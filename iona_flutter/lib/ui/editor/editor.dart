import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:analysis_server/lsp_protocol/protocol_generated.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:iona_flutter/model/event/global_events.dart';
import 'package:iona_flutter/model/hid/key_codes.dart' as key_codes;
import 'package:iona_flutter/model/ide/ide_theme.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/model/syntax/syntax_definition.dart';
//import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_generated.dart' show CompletionItem;
import 'package:iona_flutter/plugin/dart/dart_analysis.dart';
import 'package:iona_flutter/ui/design/custom_iconbutton.dart';
import 'package:iona_flutter/ui/editor/completions.dart';
import 'package:iona_flutter/ui/editor/controller.dart';
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
  static bool cursorCapturedBySuggestions = false;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final FocusNode _focusNode = FocusNode();
  final dartFormatter = DartFormatter(pageWidth: 120);
  var _curFile = '';
  bool cursorBlink = false;
  bool rebuildLines = false;
  bool postponeNextBlink = false;
  bool didUpdateDoc = false;

  Map<String, EditorController> controllers = {};
  StreamController<PointerEvent> gestureDelegator = StreamController();
  bool didComplete = false;
  var _hasMovedCursor = false;
  var _wasBackspacing = false;
  var _displayedDoc = '';
  var _suggestionStart = 0;
  int completeLen = 0;

  final List<SyntaxDefinition> syntaxes = [];
  SyntaxDefinition currentSyntax;

  List<EditorUiLine> lines = [];
  StreamSubscription _changeActiveFileSubscription;

  List<CompletionItem> completions = [];

  Map<Type, Action<Intent>> _actionMap;
  RawKeyEventHandler _storedFocusEventHandler;

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
      if (_focusNode.hasFocus) {
        _storedFocusEventHandler = RawKeyboard.instance.keyEventHandler;
        RawKeyboard.instance.keyEventHandler = (event) {
          final handled = onKeyEvent(event);
          if (!handled && _storedFocusEventHandler != null) {
            return _storedFocusEventHandler(event);
          }
          return handled;
        };
      } else {
        if (_storedFocusEventHandler != null) {
          RawKeyboard.instance.keyEventHandler = _storedFocusEventHandler;
        }
      }
    });
    reupBlink();
    MenuBarManager()
      ..updateItem(MenuCategory.edit, 'undo', 'undo', enabled: false, action: () {
        setState(() {
          try {
            if (controller.undo()) {
              print('undo!');
              didUpdateDoc = true;
              _hasMovedCursor = true;
              updateMenus(controller.primaryCursor);
            }
          } catch (e) {
            print(e);
          }
        });
      })
      ..updateItem(MenuCategory.edit, 'clipboard', 'paste', enabled: true, action: paste)
      ..updateItem(MenuCategory.file, 'save', 'save', enabled: false, action: saveCurrentFile)
      ..publish();
    _changeActiveFileSubscription = eventBus.on<MakeEditorFileActive>().listen((event) {
      setState(() {
        FocusScope.of(context).requestFocus(_focusNode);
        changeActiveFile(Project.of(context).openFiles[event.file].fileLocation);
      });
    });
    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent: CallbackAction<NextFocusIntent>(
        onInvoke: (NextFocusIntent intent) => print('nextFocus'),
      ),
    };
  }

  EditorController get controller => controllers[_curFile];

  void saveCurrentFile() {
    Project.of(context).saveFile(_curFile);
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
      final openFiles = model.openFiles;
      if (openFiles.isNotEmpty) {
        if (_curFile == '') {
          changeActiveFile(openFiles.values.first.fileLocation);
        }

        if (_curFile != _displayedDoc) {
          final doc = openFiles[_curFile].document;
          final fn = openFiles[_curFile].fileName;
          currentSyntax = syntaxes.first;
          for (final syntax in syntaxes) {
            if (syntax.fileExtensions.any(fn.endsWith)) {
              currentSyntax = syntax;
              break;
            }
          }
          lines = StandardSyntaxHighlighter(currentSyntax.name, currentSyntax)
              .highlight(doc.map((it) => it['s']).toList().cast<String>());
          _displayedDoc = _curFile;
        }
        if (rebuildLines) {
          lines = [...lines];
          rebuildLines = false;
        }
      }
      if (!controllers.containsKey(_curFile))
        controllers[_curFile] = EditorController(model, model.openFiles[_curFile]);
      controller.makeActive();

      if (didUpdateDoc || controller.externalEdit) {
        final doc = controller.file.document;
        lines = StandardSyntaxHighlighter(currentSyntax.name, currentSyntax)
            .highlight(doc.map((it) => it['s']).toList().cast<String>());
        didUpdateDoc = false;
      }
      //var i = 0;
      return FocusableActionDetector(
        focusNode: _focusNode,
        actions: _actionMap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            EditorFilesHeader(focusNode: _focusNode, openFiles: openFiles, curFile: _curFile),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: MouseRegion(
                          cursor: SystemMouseCursors.text,
                          opaque: false,
                          child: Listener(
                            behavior: HitTestBehavior.deferToChild,
                            onPointerDown: (evt) {
                              _handlePointerPositionEvent(context, evt);
                            },
                            onPointerUp: (evt) {
                              _focusNode.requestFocus();
                            },
                            onPointerSignal: (signal) {
                              if (signal is PointerScrollEvent &&
                                  (!Editor.cursorCapturedBySuggestions || completions.isEmpty)) {
                                setState(() {
                                  controllers[_curFile].scroll(Editor.editorSize, signal.scrollDelta);
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
                                  suggestionStartDx: _findCStart(),
                                  callback: acceptSuggestion,
                                ),
                                painter: EditorUi(-(controller.scrollPosition ?? Offset.zero),
                                    theme: testTheme,
                                    lines: lines,
                                    lineHeight: 16.0,
                                    callback: () {},
                                    cursor: controller.primaryCursor,
                                    cursorBlink: _focusNode.hasFocus && cursorBlink),
                              ),
                            ),
                          ))),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  void changeActiveFile(String newActiveFile) {
    _curFile = newActiveFile;
    if (!controllers.containsKey(_curFile))
      controllers[_curFile] = EditorController(Project.of(context), Project.of(context).openFiles[newActiveFile]);
    controller.makeActive();
  }

  double _findCStart() {
    if (completions.isEmpty) return _suggestionStart * 8.2 + 45;
    for (var cc in completions) {
      if (cc.textEdit != null) {
        return cc.textEdit.range.start.character * 8.2 + 45;
      }
    }
    return _suggestionStart * 8.2 + 45;
  }

  void _handlePointerPositionEvent(BuildContext context, PointerEvent event) {
    if (Editor.cursorCapturedBySuggestions && completions.isNotEmpty) return;
    final RenderBox getBox = context.findRenderObject();
    final local = getBox.globalToLocal(event.position);
    final newCursor = EditorCursorUtil.calcNewCursor(event, lines, testTheme, -controllers[_curFile].scrollPosition.dy,
        -controllers[_curFile].scrollPosition.dx, 16.0, local.translate(-45, -30));
    setState(() {
      controller.primaryCursor = newCursor;
      completions = [];
      _hasMovedCursor = true;
      cursorBlink = true;
      postponeNextBlink = true;
      rebuildLines = true;
    });
    updateMenus(newCursor);
  }

  void updateMenus(EditorCursor newCursor) {
    MenuBarManager()
      ..updateItem(MenuCategory.edit, 'undo', 'undo', enabled: controller.canUndo)
      ..updateItem(MenuCategory.file, 'save', 'save', enabled: true, action: saveCurrentFile);

    if (newCursor.isSelection) {
      MenuBarManager()
        ..updateItem(MenuCategory.edit, 'clipboard', 'cut', enabled: true, action: cut)
        ..updateItem(MenuCategory.edit, 'clipboard', 'copy', enabled: true, action: _copy)
        ..publish();
    } else {
      MenuBarManager()
        ..updateItem(MenuCategory.edit, 'clipboard', 'cut', enabled: false)
        ..updateItem(MenuCategory.edit, 'clipboard', 'copy', enabled: false)
        ..publish();
    }
  }

  void cut() {
    _copy();
    setState(() {
      controller.deleteSelection();
    });
  }

  void _copy() {
    final data = controller.selectedText;
    if (data == null) return;
    Clipboard.setData(ClipboardData(text: data.toString()));
  }

  void paste() async {
    final pasteData = (await Clipboard.getData(Clipboard.kTextPlain)).text;
    if (pasteData == null || pasteData.isEmpty) return;

    setState(() {
      didUpdateDoc = controller.insert(pasteData);
      cursorBlink = true;
      postponeNextBlink = true;
    });
  }

  void acceptSuggestion(CompletionItem completion) {
    print('suggestion start: $_suggestionStart');
    var cur = controller.primaryCursor.copyWith(
        position: _suggestionStart - 1,
        endPosition: lines[controller.primaryCursor.line].insertEnd(_suggestionStart - 1) - 1);
    var ctext = completion.insertText;
    print('suggestion is: $ctext');
    if (completion.textEdit != null) {
      final start = completion.textEdit.range.start.character;
      final end = completion.textEdit.range.end.character;
      cur = EditorCursor(cur.line, cur.endLine, start, end);
      ctext = completion.textEdit.newText ?? completion.insertText;
    }

    ctext ??= completion.label;

    setState(() {
      didUpdateDoc = controller.insertAt(cur, ctext);
      completions = [];
      didComplete = false;
      cursorBlink = true;
      postponeNextBlink = true;
    });
  }

  void reformat() {}

  void moveCursor(EditorCursor newCursor) {
    controller.primaryCursor = newCursor;
    _hasMovedCursor = true;
    rebuildLines = true;
  }

  bool onKeyEvent(RawKeyEvent event) {
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
    var handled = true;
    switch (event.data.runtimeType) {
      case RawKeyEventDataMacOs:
        final RawKeyEventDataMacOs data = event.data;
        keyCode = data.keyCode;
        if (isKeyDown)
          setState(() {
            final cur = controller.primaryCursor;
            final file = Project.of(context).openFiles[_curFile];
            cursorBlink = true;
            postponeNextBlink = true;
            if (keyCode == key_codes.left) {
              if (data.isModifierPressed(ModifierKey.shiftModifier)) {
                final newPos = cur.endPosition == 0 && cur.endLine > 0
                    ? file.lineLengths[cur.endLine - 1] - 1
                    : max(0, cur.endPosition - 1);
                final newLine = cur.endPosition == 0 && cur.endLine > 0 ? cur.endLine - 1 : cur.endLine;

                moveCursor(cur.copyWith(endLine: newLine, endPosition: newPos));
              } else if (cur.isSelection) {
                moveCursor(cur.copyWith(
                    line: cur.firstLine,
                    endLine: cur.firstLine,
                    position: cur.firstPosition,
                    endPosition: cur.firstPosition));
              } else if (cur.position == 0) {
                if (cur.line == 0) {
                  handled = false;
                  return;
                }
                moveCursor(cur.copyWithSingle(line: cur.line - 1, position: lineLength(cur.line - 1)));
              } else
                moveCursor(controller.primaryCursor.copyWithSingle(position: max(0, cur.position - 1)));
            } else if (keyCode == key_codes.right) {
              if (data.isModifierPressed(ModifierKey.shiftModifier)) {
                final newPos =
                    cur.endPosition == file.lineLengths[cur.endLine] - 1 && cur.endLine < file.lineLengths.length - 1
                        ? 0
                        : min(file.lineLengths[cur.endLine] - 1, cur.endPosition + 1);
                final newLine =
                    cur.endPosition == file.lineLengths[cur.endLine] - 1 && cur.endLine < file.lineLengths.length - 1
                        ? cur.endLine + 1
                        : cur.endLine;
                moveCursor(cur.copyWith(line: cur.line, endLine: newLine, position: cur.position, endPosition: newPos));
                return;
              }
              if (cur.position != cur.endPosition) {
                moveCursor(cur.copyWith(
                    line: cur.lastLine,
                    endLine: cur.lastLine,
                    position: cur.lastPosition,
                    endPosition: cur.lastPosition));
              } else if (cur.position > lineLength(cur.line) - 1) {
                if (cur.line == lines.length - 1) {
                  handled = false;
                  return;
                }
                moveCursor(cur.copyWithSingle(line: cur.line + 1, position: 0));
              } else
                moveCursor(cur.copyWithSingle(position: cur.position + 1));
            } else if (keyCode == key_codes.down) {
              if (cur.line == lines.length - 1 && cur.endLine == lines.length - 1) {
                handled = false;
                return;
              }
              moveCursor(cur.copyWithSingle(
                  line: min(cur.line + 1, lines.length - 1), position: min(cur.position, lineLength(cur.line + 1))));
            } else if (keyCode == key_codes.up) {
              if (cur.line == 0 && cur.endLine == 0) {
                handled = false;
                return;
              }
              moveCursor(cur.copyWithSingle(
                  line: max(cur.line - 1, 0), position: min(cur.position, lineLength(max(0, cur.line - 1)))));
            } else {
              //Changeset ec;

              var shouldComplete = true;
              var restrictComplete = false;

              if (keyCode == key_codes.backspace) {
                if (cur.isSelection) {
                  didUpdateDoc = controller.deleteSelection(cursorLeft: true);
                } else {
                  final istart = lines[cur.line].indentStart();
                  if (cur.position > istart || cur.position == 0) {
                    didUpdateDoc = controller.removeLeft(1);
                  } else {
                    final String prevLine = controller.file.document[cur.line - 1]['s'];
                    if (prevLine.trim().isEmpty) {
                      final nc = EditorCursor(cur.line - 1, cur.line, prevLine.length - 1, istart);
                      didUpdateDoc = controller.deleteAt(nc);
                    } else {
                      final nc = EditorCursor(cur.line - 1, cur.line, prevLine.length - 1, istart);
                      didUpdateDoc = controller.deleteAt(nc);
                    }
                  }
                }
              } else if (keyCode == key_codes.enter) {
                final iStart = lines[cur.line].indentStart();
                final iData = controller.file.indentData;
                print(controller.file.document[cur.firstLine]['s']);
                final lChar = cur.firstPosition == 0
                    ? ''
                    : controller.file.document[cur.firstLine]['s'].substring(cur.firstPosition - 1, cur.firstPosition);
                print('lc $lChar');
                final indentChange = (lChar == '{' || lChar == '(' || lChar == '.' || lChar == '[') ? 1 : 0;
                print('ic $indentChange');
                final indent =
                    (iData.indent.substring(0, 1) * iStart).substring(indentChange == -1 ? iData.indent.length : 0) +
                        (indentChange == 1 ? iData.indent : '');
                didUpdateDoc = controller.insert('\n$indent');
                _hasMovedCursor = true;
              } else if (keyCode == key_codes.tab) {
                // Tab
                final idata = controller.file.indentData;
                if (data.isModifierPressed(ModifierKey.shiftModifier)) {
                  final iStart = lines[cur.firstLine].indentStart();
                  if (iStart >= controller.file.indentData.amount) {
                    final cur = controller.primaryCursor.copyWithSingle(position: iStart);
                    didUpdateDoc = controller.removeLeftAt(cur, controller.file.indentData.amount);
                  }
                } else
                  didUpdateDoc = controller.insert(idata.indent);
              } else if (data.characters.isNotEmpty) {
                didUpdateDoc = controller.insert(data.characters);
              } else
                restrictComplete = true;

              if (keyCode == key_codes.backspace) {
                if (!_wasBackspacing) {
                  _wasBackspacing = true;
                  _hasMovedCursor = true;
                }
                completeLen--;
                if (completeLen <= 0) completions = [];
              } else if (_wasBackspacing) {
                _wasBackspacing = false;
                _hasMovedCursor = true;
              }

              if (_hasMovedCursor) completions = [];

              if (shouldComplete && _curFile.endsWith('.dart')) {
                print('will attempt code complete');
                codeComplete(data.characters);

                if (!didComplete) {
                  _suggestionStart = lines[controller.primaryCursor.firstLine]
                      .suggestionStart(controller.primaryCursor.firstPosition - 1);
                  completeLen = 0;
                }
                completeLen++;
                didComplete = true;
              } else if (keyCode != 51 && !restrictComplete) {
                completions = [];
                didComplete = false;
              } else
                didComplete = false;

              updateMenus(controller.primaryCursor);
            }
          });
        break;
      default:
        throw Exception('Unsupported platform ${event.data.runtimeType}');
    }
    return handled;
  }

  void codeComplete(String triggerChar) async {
    final _completions = await DartAnalyzer().completeChar(
        triggerChar, _curFile, controller.primaryCursor.firstLine, controller.primaryCursor.firstPosition);
    if (_completions != null)
      setState(() {
        completions = _completions;
      });
  }

  int lineLength(int line) {
    final doc = Project.of(context).openFiles[_curFile].document;
    return doc[line]['s'].length - 1;
  }

  @override
  void dispose() {
    super.dispose();
    gestureDelegator.close();
    _changeActiveFileSubscription.cancel();
  }
}

class EditorFilesHeader extends StatelessWidget {
  const EditorFilesHeader({
    Key key,
    @required FocusNode focusNode,
    @required this.openFiles,
    @required String curFile,
  })  : _focusNode = focusNode,
        _curFile = curFile,
        super(key: key);

  final FocusNode _focusNode;
  final Map<String, ProjectFile> openFiles;
  final String _curFile;

  @override
  Widget build(BuildContext context) {
    var i = 0;
    var _find = 0;
    return Material(
      color: _focusNode.hasFocus ? IdeTheme.of(context).windowHeaderActive.col : IdeTheme.of(context).windowHeader.col,
      child: Row(
        children: openFiles.values.map((file) {
          if (file.fileLocation == _curFile) _find = i;
          i++;
          return Material(
            color:
                file.fileLocation == _curFile ? testTheme.backgroundColor : IdeTheme.of(context).windowHeaderActive.col,
            child: InkWell(
              focusNode: FocusNode(skipTraversal: true),
              onTap: () {
                _focusNode.requestFocus();
                eventBus.fire(MakeEditorFileActive(file.fileLocation));
              },
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 24),
                child: Row(
                  children: <Widget>[
                    CustomIconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                      ),
                      iconSize: 20.0,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Project.of(context).closeFile(file.fileLocation);
                        if (_curFile == file.fileLocation) {
                          eventBus.fire(MakeEditorFileActive(openFiles.values.toList()[_find - 1].fileLocation));
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
    );
  }
}
