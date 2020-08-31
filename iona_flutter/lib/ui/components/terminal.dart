import 'dart:async';
import 'dart:io';

import 'package:ffi_terminal/ffi_terminal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iona_flutter/model/hid/key_codes.dart' as key_codes;
import 'package:iona_flutter/model/ide/ide_theme.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:iona_flutter/util/key_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:piecemeal/piecemeal.dart';

/// A terminal using ffi_terminal
class Terminal extends StatefulWidget {
  const Terminal({this.active = true, this.height = 230, this.constraintsCallback, this.onCollapse});

  final bool active;
  final double height;
  final ModifyConstraintsCallback constraintsCallback;
  final VoidCallback onCollapse;

  @override
  _TerminalState createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> {
  static VTerm vterm;
  double fmax = 0;
  bool hsf = false;
  int width = 110;
  int height = 15;
  Array2D chars;
  static List<List<VTIScreenCell>> sbFrames;
  static bool isVisible = false;
  bool rd = false;

  StreamSubscription<String> data;
  StreamSubscription<String> err;
  static ScrollController controller = ScrollController();
  static int maxRow = 0;
  static int frameOffsetX = 0;
  static int frameOffsetY = 0;
  static bool firstInit = true;

  @override
  void initState() {
    super.initState();
    chars = Array2D<String>(width, height);
    isVisible = true;
    if (sbFrames == null) {
      print('sbFrames null :(');
      sbFrames = <List<VTIScreenCell>>[]..length = height;
      for (var i = 0; i < height; i++) {
        sbFrames[i] = <VTIScreenCell>[]..length = width;
      }
    }
    if (widget.active) init();
    if (firstInit) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        firstInit = false;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller.jumpTo(gse());
      });
      WidgetsBinding.instance.scheduleFrame();
    }
  }

  void init() async {
    final docsDir = (await getApplicationDocumentsDirectory()).path;

    final mainLib = File('$docsDir/libvterm.dylib');
    if (!mainLib.existsSync()) {
      await _copyFile('nativeLibs/libvterm.dylib', '$docsDir/libvterm.dylib');
      await _copyFile('nativeLibs/libvterm.0.dylib', '$docsDir/libvterm.0.dylib');
      await _copyFile('nativeLibs/libvterm.a', '$docsDir/libvterm.a');
      await _copyFile('nativeLibs/libvterm.lai', '$docsDir/libvterm.lai');
    }

    if (vterm == null) {
      vterm = VTerm(height, width, '$docsDir/');
      unawaited(read(600, true));
    }
    vterm.callbacks.onReplaceCell = (row, col, cell) {
      while (sbFrames.length < row + frameOffsetY) {
        sbFrames.add(<VTIScreenCell>[]..length = width);
      }

      if (isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            if (maxRow < row + 1) maxRow = row + 1;
            //chars.set((col + frameOffsetX) % width, (row + frameOffsetY) % height, cell.content);
            sbFrames[row + frameOffsetY][col] = cell;
          });
        });
        WidgetsBinding.instance.scheduleFrame();
      } else {
        if (maxRow < row + 1) maxRow = row + 1;
        //chars.set((col + frameOffsetX) % width, (row + frameOffsetY) % height, cell.content);
        sbFrames[row + frameOffsetY][col] = cell;
      }
    };
    vterm.callbacks.onMoveRect = (dest, src) {
      if (isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            if (controller.offset > controller.position.maxScrollExtent - 2) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.jumpTo(gse());
              });
            }
          });
        });
        WidgetsBinding.instance.scheduleFrame();
      }
    };
    vterm.callbacks.onPushScrollbackLine = (cells) {
      if (isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            sbFrames.add(<VTIScreenCell>[]..length = width);
            frameOffsetY++;
          });
        });
        WidgetsBinding.instance.scheduleFrame();
      } else {
        sbFrames.add(<VTIScreenCell>[]..length = width);
        frameOffsetY++;
      }
    };
  }

  double gse() {
    return controller.position.maxScrollExtent;
  }

  // ignore: avoid_positional_boolean_parameters
  Future read(int ms, bool rp) async {
    await Future.delayed(Duration(milliseconds: ms));
    try {
      vterm.masterRead();
    } catch (e) {
      print(e);
    }

    if (rp) {
      unawaited(read(80, true));
    }
  }

  Future<void> _copyFile(asset, file) async {
    //read and write
    final bytes = await rootBundle.load(asset);
    print('copyFile $asset');
    print(bytes.lengthInBytes);
    await writeToFile(bytes, file);
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  @override
  void dispose() {
    super.dispose();
    isVisible = false;

    if (data != null) data.cancel();
    if (err != null) err.cancel();
  }

  String _getLineText(int line) {
    final txt = StringBuffer('');
    for (var i = 0; i < width; i++) {
      if (sbFrames.length > line && sbFrames[line].length > i) {
        txt.write(sbFrames[line][i] == null ? ' ' : sbFrames[line][i].content);
      } else
        txt.write(' ');
    }
    return txt.toString();
  }

  @override
  Widget build(BuildContext context) {
    return InlineWindow(
        requestFocus: !firstInit,
        constraints: BoxConstraints.tightFor(height: widget.height),
        constraintsCallback: widget.constraintsCallback,
        onCollapse: widget.onCollapse,
        resizeTop: true,
        onKey: (k) {
          final d = rawKeyToKeyData(k);
          var mods = VTERM_MOD_NONE;
          if (k.isControlPressed) {
            mods |= VTERM_MOD_CTRL;
          }
          if (k.isAltPressed) {
            mods |= VTERM_MOD_ALT;
          }
          if (k.isShiftPressed) {
            mods |= VTERM_MOD_SHIFT;
          }
          if (d.isKeyDown) {
            switch (d.keyCode) {
              case key_codes.backspace:
                vterm.writeKey(VTERM_KEY_BACKSPACE, modifier: mods);
                break;
              case key_codes.enter:
                vterm.writeKey(VTERM_KEY_ENTER, modifier: mods);
                break;
              case key_codes.tab:
                vterm.writeKey(VTERM_KEY_TAB, modifier: mods);
                break;
              case key_codes.escape:
                vterm.writeKey(VTERM_KEY_ESCAPE, modifier: mods);
                break;
              case key_codes.up:
                vterm.writeKey(VTERM_KEY_UP, modifier: mods);
                break;
              case key_codes.right:
                vterm.writeKey(VTERM_KEY_RIGHT, modifier: mods);
                break;
              case key_codes.left:
                vterm.writeKey(VTERM_KEY_LEFT, modifier: mods);
                break;
              case key_codes.down:
                vterm.writeKey(VTERM_KEY_DOWN, modifier: mods);
                break;
              default:
                vterm.writeChar(k.logicalKey.keyLabel.codeUnitAt(0), modifier: mods);
                break;
            }
            vterm.flushBuf();
            controller.jumpTo(controller.position.maxScrollExtent);
            // vterm.writeMaster(d.characters);
          }
          //vterm.writeChar(d.keyCode);
          read(0, false);
        },
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Text('Terminal'),
        ),
        child: Listener(
          onPointerMove: (move) {
            //vterm
            //  ..mouseMove(move.localPosition.dy ~/ 12, move.localPosition.dx ~/ 12)
            //  ..flushBuf();
          },
          onPointerSignal: (signal) {
            if (signal is PointerScrollEvent) {
              //vterm
              //  ..mouseButton(signal.scrollDelta.dy > 0 ? 5 : 4, true)
              //  ..flushBuf();
            }
          },
          child: Material(
              color: IdeTheme.of(context).termBackground.col,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CupertinoScrollbar(
                  controller: controller,
                  child: ListView.builder(
                      controller: controller,
                      itemBuilder: (context, i) {
                        return SelectableText(_getLineText(i),
                            style: TextStyle(fontFamily: 'Hack', color: IdeTheme.of(context).textActive.col));
                      },
                      itemCount: maxRow + frameOffsetY),
                ),
              )),
        ));
  }
}
