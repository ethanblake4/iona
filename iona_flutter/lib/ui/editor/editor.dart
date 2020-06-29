import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart' hide Builder;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:iona_flutter/model/event/global_events.dart';
import 'package:iona_flutter/model/ide/ide_theme.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/model/syntax/syntax_definition.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_generated.dart' show CompletionItem;
import 'package:iona_flutter/plugin/dart/dart_analysis.dart';
import 'package:iona_flutter/ui/design/custom_iconbutton.dart';
import 'package:iona_flutter/ui/editor/util/compose.dart';
import 'package:iona_flutter/util/ot/atext_changeset.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yaml/yaml.dart';

import '../../util/menubar_manager.dart';
import 'editor_ui.dart';
import 'theme/editor_theme.dart';
import 'util/syntax_highlighter.dart';

/// Provides edit functionality
class Editor extends StatefulWidget {
  static Size editorSize = Size.zero;
  static Offset cursorScreenPosition = Offset.zero;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final FocusNode _focusNode = FocusNode(skipTraversal: true);
  var curFile = '';
  bool cursorBlink = false;
  bool rebuildLines = false;
  bool postponeNextBlink = false;
  bool didUpdateDoc = false;

  Map<String, Offset> scrollPositions = {};
  Map<String, EditorCursor> cursors = {};
  StreamController<PointerEvent> gestureDelegator = StreamController();
  Map<String, List<Changeset>> prevChangesets = {};
  Map<String, int> undoPosition = {};
  Map<String, List<List<int>>> prevLineLengths = {};
  Map<String, List<int>> currentChangeLineLength = {};
  bool didComplete = false;
  var hasMovedCursor = false;
  var wasBackspacing = false;
  var didUndo = false;
  var find = 0;
  var displayedDoc = '';
  var activePointerDrag = -1;
  var suggestionStartDx = 0.0;
  int completeLen = 0;

  final List<SyntaxDefinition> syntaxes = [];
  SyntaxDefinition currentSyntax;

  List<EditorUiLine> lines = [];
  StreamSubscription _changeActiveFileSubscription;

  List<CompletionItem> completions = [];

  @override
  void initState() {
    super.initState();
    final dir = Directory('./Iona/syntax');
    final sx = dir.listSync();
    for (final s in sx) {
      if (s.path.endsWith('.syntax') && s.statSync().type == FileSystemEntityType.file) {
        syntaxes.add(SyntaxDefinition.parseYaml(loadYaml(File(s.path).readAsStringSync())));
      }
    }
    _focusNode.addListener(() {
      setState(() {});
    });
    reupBlink();
    MenuBarManager()
      ..updateItem(MenuCategory.edit, 'undo', 'undo', enabled: false, action: () {
        final cur = cursors[curFile];
        final file = Project.of(context).openFiles[curFile];
        if (undoPosition[curFile] <= prevChangesets[curFile].length) {
          final inv = prevChangesets[curFile][prevChangesets[curFile].length - undoPosition[curFile] - 1].invert();
          file.lineLengths = prevLineLengths[curFile][prevLineLengths[curFile].length - undoPosition[curFile] - 1];
          final np = Position(cur.position, cur.line).transform(inv, 'right');
          cursors[curFile] = cur.copyWithSingle(line: np.line, position: np.ch);
          undoPosition[curFile]++;
          didUpdateDoc = true;
          didUndo = true;
          Project.of(context).updateFile(curFile, inv);
        }
      })
      ..updateItem(MenuCategory.edit, 'clipboard', 'paste', enabled: true, action: paste)
      ..updateItem(MenuCategory.file, 'save', 'save', enabled: false, action: saveCurrentFile)
      ..publish();
    _changeActiveFileSubscription = eventBus.on<MakeEditorFileActive>().listen((event) {
      setState(() {
        curFile = Project.of(context).openFiles[event.file].fileLocation;
        eventBus.fire(EditorFileActiveEvent(curFile));
        if (!scrollPositions.containsKey(curFile)) {
          scrollPositions[curFile] = Offset.zero;
        }
        if (!cursors.containsKey(curFile)) {
          cursors[curFile] = EditorCursor(0, 0, 0, 0);
        }
      });
    });
  }

  void saveCurrentFile() {
    Project.of(context).saveFile(curFile);
  }

  void reupBlink() => Future.delayed(const Duration(milliseconds: 550), () {
        setState(() {
          if (!postponeNextBlink) cursorBlink = !cursorBlink;
          postponeNextBlink = false;
          rebuildLines = true;
        });
        reupBlink();
      });

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Project>(builder: (context, child, model) {
      final openFiles = Project.of(context).openFiles;
      if (openFiles.isNotEmpty) {
        if (curFile == '') {
          curFile = openFiles.values.first.fileLocation;
          eventBus.fire(EditorFileActiveEvent(curFile));
          scrollPositions[curFile] = Offset.zero;
          cursors[curFile] = EditorCursor(0, 0, 0, 0);
          undoPosition[curFile] = 0;
          prevChangesets[curFile] = [];
          prevLineLengths[curFile] = [];
        }

        if (curFile != displayedDoc) {
          var doc = openFiles[curFile].document;
          final fn = openFiles[curFile].fileName;
          currentSyntax = syntaxes.first;
          for (final syntax in syntaxes) {
            if (syntax.fileExtensions.any(fn.endsWith)) {
              currentSyntax = syntax;
              break;
            }
          }
          //print(doc.last.toString());
          lines = StandardSyntaxHighlighter(currentSyntax.name, currentSyntax)
              .highlight(doc.map((it) => it['s']).toList().cast<String>());
          displayedDoc = curFile;
        }
        if (rebuildLines) {
          lines = [...lines];
          rebuildLines = false;
        }
      }
      if (!scrollPositions.containsKey(curFile)) {
        scrollPositions[curFile] = Offset.zero;
      }
      if (!cursors.containsKey(curFile)) {
        cursors[curFile] = EditorCursor(0, 0, 0, 0);
      }
      if (!undoPosition.containsKey(curFile)) {
        undoPosition[curFile] = 0;
      }
      if (!prevChangesets.containsKey(curFile)) {
        prevChangesets[curFile] = [];
      }
      if (!prevLineLengths.containsKey(curFile)) {
        prevLineLengths[curFile] = [];
      }
      if (didUpdateDoc) {
        var doc = Project.of(context).openFiles[curFile].document;
        lines = StandardSyntaxHighlighter(currentSyntax.name, currentSyntax)
            .highlight(doc.map((it) => it['s'] as String).toList());
        didUpdateDoc = false;
      }
      var i = 0;
      return GestureDetector(
        onTap: () {
          print('editor tap');
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: RawKeyboardListener(
          focusNode: _focusNode,
          onKey: onKeyEvent,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Material(
                color: _focusNode.hasFocus
                    ? IdeTheme.of(context).windowHeaderActive.col
                    : IdeTheme.of(context).windowHeader.col,
                child: Row(
                  children: openFiles.values.map((file) {
                    if (file.fileLocation == curFile) find = i;
                    i++;
                    return Material(
                      color: file.fileLocation == curFile
                          ? testTheme.backgroundColor
                          : IdeTheme.of(context).windowHeaderActive.col,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            FocusScope.of(context).requestFocus(_focusNode);
                            curFile = file.fileLocation;
                            eventBus.fire(EditorFileActiveEvent(curFile));
                            if (!scrollPositions.containsKey(curFile)) {
                              scrollPositions[curFile] = Offset.zero;
                            }
                            if (!cursors.containsKey(curFile)) {
                              cursors[curFile] = EditorCursor(0, 0, 0, 0);
                            }
                          });
                        },
                        child: IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              CustomIconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 20.0,
                                ),
                                iconSize: 20.0,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Project.of(context).closeFile(file.fileLocation);
                                  if (curFile == file.fileLocation) {
                                    curFile = openFiles.values.toList()[find - 1].fileLocation;
                                    eventBus.fire(EditorFileActiveEvent(curFile));
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 2.0, right: 3.0),
                                child: Text(
                                  file.fileName,
                                  style: TextStyle(color: testTheme.baseStyle.color),
                                ),
                              ),
                              if (openFiles[file.fileLocation].hasModified)
                                Padding(
                                  child: Icon(Icons.brightness_1, size: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                                ),
                              Padding(
                                padding: EdgeInsets.only(right: 3.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(child: LayoutBuilder(builder: (context, constraints) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.text,
                        opaque: false,
                        child: Listener(
                          behavior: HitTestBehavior.opaque,
                          onPointerDown: (evt) {
                            _handlePointerPositionEvent(context, evt);
                          },
                          onPointerSignal: (signal) {
                            if (signal is PointerScrollEvent) {
                              final file = Project.of(context).openFiles[curFile];
                              var maxLen = 0;
                              for (final len in file.lineLengths) {
                                if (len > maxLen) maxLen = len;
                              }
                              final c = Editor.editorSize.width - 45 - (maxLen * 8.2);
                              setState(() {
                                scrollPositions[curFile] += signal.scrollDelta;
                                scrollPositions[curFile] = Offset(
                                    max(0, min(-c, scrollPositions[curFile].dx)),
                                    min(max(0, scrollPositions[curFile].dy),
                                        max(0, 16.0 * lines.length - constraints.maxHeight + 10.0)));
                              });
                            }
                          },
                          onPointerMove: (evt) {
                            _handlePointerPositionEvent(context, evt);
                          },
                          child: ClipRect(
                            clipBehavior: Clip.antiAlias,
                            child: CustomPaint(
                              child: Completions(
                                completions: completions,
                                suggestionStartDx: suggestionStartDx,
                              ),
                              painter: EditorUi(-(scrollPositions[curFile] ?? Offset.zero),
                                  theme: testTheme,
                                  lines: lines,
                                  lineHeight: 16.0,
                                  callback: () {},
                                  cursor: cursors[curFile],
                                  cursorBlink: _focusNode.hasFocus && cursorBlink),
                            ),
                          ),
                        ),
                      );
                    })),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void _handlePointerPositionEvent(BuildContext context, PointerEvent event) {
    final RenderBox getBox = context.findRenderObject();
    final local = getBox.globalToLocal(event.position);
    final newCursor = EditorCursorUtil.calcNewCursor(event, lines, testTheme, -scrollPositions[curFile].dy,
        -scrollPositions[curFile].dx, 16.0, local.translate(-45, -5));
    setState(() {
      completions = [];
      cursors[curFile] = newCursor;
      hasMovedCursor = true;
      cursorBlink = true;
      postponeNextBlink = true;
      rebuildLines = true;
    });
    updateMenus(newCursor);
  }

  void updateMenus(EditorCursor newCursor) {
    if (newCursor.isSelection) {
      MenuBarManager()
        ..updateItem(MenuCategory.edit, 'clipboard', 'cut', enabled: true, action: cut)
        ..updateItem(MenuCategory.edit, 'clipboard', 'copy', enabled: true, action: copy)
        ..publish();
    } else {
      MenuBarManager()
        ..updateItem(MenuCategory.edit, 'clipboard', 'cut', enabled: false)
        ..updateItem(MenuCategory.edit, 'clipboard', 'copy', enabled: false)
        ..publish();
    }
  }

  void cut() {
    final cur = cursors[curFile];
    if (!cur.isSelection) {
      return;
    }
    copy();
    final file = Project.of(context).openFiles[curFile];
    setState(() {
      final cs = beginChange(file);
      composeDeleteSelection(file, cur, cs);
      updateDoc(finishCs(file, cs, cur));
    });
  }

  void copy() {
    final cursor = cursors[curFile];
    if (!cursor.isSelection) return;
    final data = StringBuffer();
    final doc = Project.of(context).openFiles[curFile].document;
    for (var i = cursor.firstLine; i <= cursor.lastLine; i++) {
      String line = doc[i]['s'];
      if (i == cursor.firstLine)
        line = line.substring(cursor.firstPosition, i == cursor.lastLine ? cursor.lastPosition : null);
      else if (i == cursor.lastLine) line = line.substring(0, cursor.lastPosition);
      data.write(line);
    }
    Clipboard.setData(ClipboardData(text: data.toString()));
  }

  void paste() async {
    final pasteData = (await Clipboard.getData(Clipboard.kTextPlain)).text;
    if (pasteData == null || pasteData.isEmpty) return;
    final cur = cursors[curFile];
    final file = Project.of(context).openFiles[curFile];
    cursorBlink = true;
    postponeNextBlink = true;
    setState(() {
      final cs = beginChange(file);
      if (cur.isSelection) {
        composeDeleteSelection(file, cur, cs);
      } else {
        composeStartRelativeToCursor(file, cur, cs, 0);
      }

      cs.insert(pasteData);
      final pasteLines = pasteData.split('\n');
      for (var i = 0; i < pasteLines.length; i++) {
        if (i == 0)
          file.lineLengths[cur.firstLine] += pasteLines[i].length;
        else
          file.lineLengths.insert(cur.firstLine + i, pasteLines[i].length + 1);
      }

      updateDoc(finishCs(file, cs, cur));
    });
  }

  void onKeyEvent(RawKeyEvent event) {
    bool isKeyDown;
    switch (event.runtimeType) {
      case RawKeyDownEvent:
        isKeyDown = true;
        Future.delayed(const Duration(seconds: 1), () {});
        break;
      case RawKeyUpEvent:
        isKeyDown = false;
        break;
      default:
        throw new Exception('Unexpected runtimeType of RawKeyEvent');
    }

    int keyCode;
    switch (event.data.runtimeType) {
      case RawKeyEventDataMacOs:
        final RawKeyEventDataMacOs data = event.data;
        keyCode = data.keyCode;
        if (isKeyDown)
          setState(() {
            final cur = cursors[curFile];
            final file = Project.of(context).openFiles[curFile];
            cursorBlink = true;
            postponeNextBlink = true;
            if (keyCode == 123) {
              // Left
              if (cur.position != cur.endPosition) {
                cursors[curFile] = cur.copyWith(
                    line: cur.firstLine,
                    endLine: cur.firstLine,
                    position: cur.firstPosition,
                    endPosition: cur.firstPosition);
              }
              if (cur.position == 0) {
                if (cur.line == 0) return;
                cursors[curFile] = cur.copyWithSingle(line: cur.line - 1, position: lineLength(cur.line - 1));
              } else
                cursors[curFile] = cursors[curFile].copyWithSingle(position: max(0, cur.position - 1));
              hasMovedCursor = true;
              rebuildLines = true;
            } else if (keyCode == 124) {
              // Right
              if (cur.position != cur.endPosition) {
                cursors[curFile] = cur.copyWith(
                    line: cur.lastLine,
                    endLine: cur.lastLine,
                    position: cur.lastPosition,
                    endPosition: cur.lastPosition);
              } else if (cur.position > lineLength(cur.line) - 1) {
                if (cur.line == lines.length - 1) return;
                cursors[curFile] = cur.copyWithSingle(line: cur.line + 1, position: 0);
              } else {
                cursors[curFile] = cur.copyWithSingle(position: cur.position + 1);
              }
              hasMovedCursor = true;
              rebuildLines = true;
            } else if (keyCode == 125) {
              // Down
              cursors[curFile] = cur.copyWithSingle(
                  line: min(cur.line + 1, lines.length - 1), position: min(cur.position, lineLength(cur.line + 1)));
              hasMovedCursor = true;
              rebuildLines = true;
            } else if (keyCode == 126) {
              // Up
              cursors[curFile] = cur.copyWithSingle(
                  line: max(cur.line - 1, 0), position: min(cur.position, lineLength(max(0, cur.line - 1))));
              hasMovedCursor = true;
              rebuildLines = true;
            } else {
              undoPosition[curFile] = 0;
              if (didUndo) {
                didUndo = false;
                prevLineLengths[curFile] = [];
                prevChangesets[curFile] = [];
              }
              Changeset ec;
              final cs = beginChange(file);

              var shouldComplete = false;

              if (keyCode == 51) {
                // Backspace
                if (cur.isSelection) {
                  composeDeleteSelection(file, cur, cs);
                  ec = finishCs(file, cs, cur, true);
                } else {
                  final startOfLine = cur.position == 0;
                  composeStartRelativeToCursor(file, cur, cs, -1);
                  cs.remove(1, startOfLine ? 1 : 0);
                  ec = finishCs(file, cs, cur);
                  if (startOfLine) {
                    file.lineLengths[cur.line - 1] += file.lineLengths[cur.line] - 1;
                    file.lineLengths.removeAt(cur.line);
                  } else
                    file.lineLengths[cur.line]--;
                }
              } else if (keyCode == 36) {
                // Enter
                final p = file.lineLengths[cur.line];
                composeStartRelativeToCursor(file, cur, cs, 0);
                cs.insert('\n');
                ec = finishCs(file, cs, cur);
                file.lineLengths
                  ..[cur.line] = cur.position + 1
                  ..insert(cur.line + 1, p - cur.position);
                hasMovedCursor = true;
              } else if (data.characters.isNotEmpty) {
                if (cur.isSelection) {
                  composeDeleteSelection(file, cur, cs);
                  cs.insert(data.characters);
                } else {
                  composeStartRelativeToCursor(file, cur, cs, 0);
                  cs.insert(data.characters);
                  shouldComplete = true;
                }
                file.lineLengths[cur.firstLine] += data.characters.length;
                ec = finishCs(file, cs, cur);
              }

              if (keyCode == 51) {
                if (!wasBackspacing) {
                  wasBackspacing = true;
                  hasMovedCursor = true;
                }
                completeLen--;
                if (completeLen <= 0) {
                  completions = [];
                }
              } else if (wasBackspacing) {
                wasBackspacing = false;
                hasMovedCursor = true;
              }
              if (ec != null) {
                updateDoc(ec);
              }

              if (hasMovedCursor) {
                completions = [];
              }

              if (shouldComplete && curFile.endsWith('.dart')) {
                codeComplete(data.characters);

                if (!didComplete) {
                  suggestionStartDx = Editor.cursorScreenPosition.dx;
                  completeLen = 0;
                }
                completeLen++;
                didComplete = true;
              } else if (keyCode != 51) {
                completions = [];
              }

              updateMenus(cursors[curFile]);
            }
          });
        break;
      default:
        throw new Exception('Unsupported platform ${event.data.runtimeType}');
    }
  }

  Builder beginChange(ProjectFile file) {
    currentChangeLineLength[curFile] = [...file.lineLengths];
    cursorBlink = true;
    postponeNextBlink = true;
    return Changeset.create(file.document);
  }

  Changeset finishCs(ProjectFile file, Builder cs, EditorCursor cur, [left = false]) {
    final ec = cs.finish();
    final np = Position(cur.endPosition, cur.endLine).transform(ec, left ? 'left' : 'right');
    cursors[curFile] = cur.copyWithSingle(line: np.line, position: np.ch);
    prevLineLengths[curFile].add(currentChangeLineLength[curFile]);
    return ec;
  }

  void codeComplete(String triggerChar) async {
    final _completions = await DartAnalyzer()
        .completeChar(triggerChar, curFile, cursors[curFile].firstLine, cursors[curFile].firstPosition);
    setState(() {
      completions = _completions;
    });
  }

  void updateDoc(Changeset ec) {
    Project.of(context).updateFile(curFile, ec);
    if (!hasMovedCursor && prevChangesets.isNotEmpty && prevChangesets[curFile].isNotEmpty) {
      prevChangesets[curFile].last = prevChangesets[curFile].last.compose(ec);
      prevLineLengths[curFile].removeAt(prevLineLengths[curFile].length - 1);
    } else {
      prevChangesets[curFile].add(ec);
      hasMovedCursor = false;
    }
    didUpdateDoc = true;
    MenuBarManager()
      ..updateItem(MenuCategory.edit, 'undo', 'undo', enabled: true)
      ..updateItem(MenuCategory.file, 'save', 'save', enabled: true, action: saveCurrentFile)
      ..publish();
  }

  int lineLength(int line) {
    var doc = Project.of(context).openFiles[curFile].document;
    return doc[line]['s'].length - 1;
  }

  @override
  void dispose() {
    super.dispose();
    gestureDelegator.close();
    _changeActiveFileSubscription.cancel();
  }
}

class Completions extends StatelessWidget {
  const Completions({Key key, @required this.completions, this.suggestionStartDx}) : super(key: key);

  final List<CompletionItem> completions;
  final double suggestionStartDx;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(left: max(0, suggestionStartDx - 8), top: max(0, Editor.cursorScreenPosition.dy)),
        child: Container(
            constraints: BoxConstraints.loose(Size(240, 120)),
            child: Listener(
              onPointerDown: (evt) {
                print('sugest tap');
              },
              behavior: HitTestBehavior.opaque,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                opaque: true,
                child: Material(
                  elevation: 4,
                  color: Colors.blueGrey[800],
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text(
                            completions[i].label,
                            style: testTheme.baseStyle.copyWith(color: Colors.white70, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                      );
                    },
                    itemCount: completions?.length ?? 0,
                  ),
                ),
              ),
            )),
      ),
    ]);
  }
}
