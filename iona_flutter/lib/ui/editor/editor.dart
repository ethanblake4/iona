import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart' hide Builder;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:iona_flutter/model/ide/ide_theme.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/model/syntax/syntax_definition.dart';
import 'package:iona_flutter/ui/design/custom_iconbutton.dart';
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
  var hasMovedCursor = false;
  var wasBackspacing = false;
  var didUndo = false;
  var find = 0;
  var displayedDoc = '';
  var activePointerDrag = -1;

  final List<SyntaxDefinition> syntaxes = [];
  SyntaxDefinition currentSyntax;

  List<EditorUiLine> lines = [];

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
      ..updateItem(MenuCategory.file, 'save', 'save', enabled: true, action: () {
        Project.of(context).saveFile(curFile);
      })
      ..publish();
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
          scrollPositions[curFile] = Offset.zero;
          cursors[curFile] = EditorCursor(0, 0, 0, 0);
          undoPosition[curFile] = 0;
          prevChangesets[curFile] = [];
          prevLineLengths[curFile] = [];
        }

        MenuBarManager().setItem(
            MenuCategory.file,
            'save',
            MenuActionOrSubmenu('save', 'Save', action: () {
              Project.of(context).saveFile(curFile);
            }, shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS), enabled: false));

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

          print(doc.last.toString());
          lines = StandardSyntaxHighlighter(currentSyntax.name, currentSyntax)
              .highlight(doc.map((it) => it['s'] as String).toList());
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
        /*lines = doc

            .map((line) =>
                EditorUiLine([EditorTextFragment('undef', 'undef', (line['s']).substring(0, line['s'].length - 1))]))
            .toList();*/
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
                  children: Project.of(context).openFiles.values.map((file) {
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
                                    curFile = Project.of(context).openFiles.values.toList()[find - 1].fileLocation;
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
                              if (Project.of(context).openFiles[file.fileLocation].hasModified)
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
                      return Listener(
                        onPointerDown: (evt) {
                          final RenderBox getBox = context.findRenderObject();
                          final local = getBox.globalToLocal(evt.position);
                          setState(() {
                            cursors[curFile] = EditorCursorUtil.calcNewCursor(
                                evt,
                                lines,
                                testTheme,
                                -scrollPositions[curFile].dy,
                                -scrollPositions[curFile].dx,
                                16.0,
                                local.translate(-45, -5));
                            hasMovedCursor = true;
                            cursorBlink = true;
                            postponeNextBlink = true;
                            rebuildLines = true;
                          });
                        },
                        onPointerSignal: (signal) {
                          if (signal is PointerScrollEvent) {
                            final file = Project.of(context).openFiles[curFile];
                            var maxLen = 0;
                            for (final len in file.lineLengths) {
                              if (len > maxLen) maxLen = len;
                            }
                            final c = Editor.editorSize.width - (maxLen * 8.6);
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
                          final RenderBox getBox = context.findRenderObject();
                          final local = getBox.globalToLocal(evt.position);
                          setState(() {
                            cursors[curFile] = EditorCursorUtil.calcNewCursor(
                                evt,
                                lines,
                                testTheme,
                                -scrollPositions[curFile].dy,
                                -scrollPositions[curFile].dx,
                                16.0,
                                local.translate(-45, -5));
                            hasMovedCursor = true;
                            cursorBlink = true;
                            postponeNextBlink = true;
                            rebuildLines = true;
                          });
                        },
                        child: ClipRect(
                          clipBehavior: Clip.antiAlias,
                          child: CustomPaint(
                            child: ListView(),
                            painter: EditorUi(-(scrollPositions[curFile] ?? Offset.zero),
                                theme: testTheme,
                                lines: lines,
                                lineHeight: 16.0,
                                callback: () {},
                                cursor: cursors[curFile],
                                cursorBlink: _focusNode.hasFocus && cursorBlink),
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

  @override
  void dispose() {
    super.dispose();
    gestureDelegator.close();
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
              // Leading lines character count
              final _ll = file.lineLengths;
              final lc = _ll.take(cur.line).fold(0, (n, x) => n + x);
              print('keep ${lc}, ${cur.line}, ${cur.position}');
              final cs = Changeset.create(file.document);
              Changeset ec;

              void finishCs(Builder nc, [left = false]) {
                ec = cs.finish();
                final np = Position(cur.endPosition, cur.endLine).transform(ec, left ? 'left' : 'right');
                cursors[curFile] = cur.copyWithSingle(line: np.line, position: np.ch);
                prevLineLengths[curFile].add([...file.lineLengths]);
              }

              if (keyCode == 51) {
                // Backspace
                print('bspace ${cur.position} ${cur.endPosition}');
                if (cur.endPosition == 0 && cur.position == 0 && cur.endLine == cur.line) {
                  print(lc - file.lineLengths[cur.line - 1]);
                  print(cur.line - 1);
                  print(file.lineLengths[cur.line - 1] - 1);
                  cs
                    ..keep(lc - file.lineLengths[cur.line - 1], cur.line - 1)
                    ..keep(file.lineLengths[cur.line - 1] - 1, 0)
                    ..remove(1, 1);
                  print(cs);
                  finishCs(cs);
                  file.lineLengths[cur.line - 1] += file.lineLengths[cur.line] - 1;
                  file.lineLengths.removeAt(cur.line);
                } else if (cur.endPosition != cur.position || cur.endLine != cur.line) {
                  final lcl = _ll.take(cur.firstLine).fold(0, (n, x) => n + x);

                  final lcd = cur.lastLine == cur.firstLine
                      ? 0
                      : _ll.skip(cur.firstLine).take(cur.lastLine - cur.firstLine).fold(0, (n, x) => n + x);
                  cs
                    ..keep(lcl, cur.firstLine)
                    ..keep(cur.firstPosition, 0)
                    ..remove(cur.lastPosition - cur.firstPosition + lcd, cur.lastLine - cur.firstLine);
                  finishCs(cs, true);

                  if (cur.lastLine != cur.firstLine) {
                    final lastL = file.lineLengths[cur.lastLine];
                    file.lineLengths[cur.firstLine] = cur.firstPosition + lastL - cur.lastPosition;
                    for (var i = cur.firstLine; i < cur.lastLine; i++) {
                      file.lineLengths.removeAt(cur.firstLine + 1);
                    }
                  } else
                    file.lineLengths[cur.line] -= cur.lastPosition - cur.firstPosition;
                } else {
                  cs
                    ..keep(lc, cur.line)
                    ..keep(cur.position - 1, 0)
                    ..remove(1, 0);
                  finishCs(cs);
                  file.lineLengths[cur.line]--;
                }
              } else if (keyCode == 36) {
                // Enter
                final p = file.lineLengths[cur.line];
                // print('llen');
                // print(p);
                cs
                  ..keep(lc, cur.line)
                  ..keep(cur.position, 0)
                  ..insert('\n');
                finishCs(cs);
                file.lineLengths
                  ..[cur.line] = cur.position + 1
                  ..insert(cur.line + 1, p - cur.position);
                hasMovedCursor = true;
              } else {
                print(file.lineLengths[cur.line]);
                if (cur.endPosition != cur.position) {
                  cs
                    ..keep(lc, cur.firstLine)
                    ..keep(cur.firstPosition, 0)
                    ..remove(cur.lastPosition - cur.firstPosition, 0)
                    ..insert(data.characters);
                  finishCs(cs);
                  file.lineLengths[cur.line] -= cur.lastPosition - cur.firstPosition;
                  file.lineLengths[cur.line]++;
                } else {
                  cs
                    ..keep(lc, cur.line)
                    ..keep(cur.position, 0)
                    ..insert(data.characters);
                  finishCs(cs);
                  file.lineLengths[cur.line] += data.characters.length;
                }
                print(file.lineLengths[cur.line]);
              }

              if (keyCode == 51) {
                if (!wasBackspacing) {
                  wasBackspacing = true;
                  hasMovedCursor = true;
                }
              } else if (wasBackspacing) {
                wasBackspacing = false;
                hasMovedCursor = true;
              }

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
                ..publish();
            }
          });
        break;
      default:
        throw new Exception('Unsupported platform ${event.data.runtimeType}');
    }
  }

  int lineLength(int line) {
    var doc = Project.of(context).openFiles[curFile].document;
    return doc[line]['s'].length - 1;
  }
}
