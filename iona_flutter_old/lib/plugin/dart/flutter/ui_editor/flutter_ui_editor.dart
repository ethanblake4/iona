/*import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:cyclop/cyclop.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:iona_flutter/model/event/global_events.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/editor_reporting_widget.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/eval.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/widget_canvas.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types.dart';
import 'package:iona_flutter/plugin/dart/utils/strings.dart';
import 'package:iona_flutter/ui/design/desktop_dropdown.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:iona_flutter/ui/editor/controller.dart';
import 'package:iona_flutter/ui/editor/editor_ui.dart';
import 'package:iona_flutter/util/strings/single_match_text_formatter.dart';
import 'package:scoped_model/scoped_model.dart';

class FlutterUiEditor extends StatefulWidget {
  @override
  FlutterUiEditorState createState() => FlutterUiEditorState();

  static FlutterUiEditorState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_FlutterUiEditor>()).data;
  }
}

class FlutterUiEditorState extends State<FlutterUiEditor> {
  StreamSubscription _fileActiveSubscription;
  StreamSubscription _fileSaveSubscription;
  FlutterFileInfo fileInfo;
  String selectedWidget = '<no widgets>';
  ScrollController propertiesListController = ScrollController();
  var width = 400.0;
  var rint = 0;
  String enumOverride;
  String enumOverrideVal;

  final ListQueue<EditorReportingWidget> _hover = ListQueue<EditorReportingWidget>();
  EditorReportingWidget innerSelection;
  int innerSelectionId;
  Future rebuildFuture;
  bool didPointerDown = false;

  void hover(EditorReportingWidget hover) {
    if (_hover.isNotEmpty && _hover.last == hover) {
      return;
    }
    _hover.add(hover);
    rebuildFuture ??= Future.delayed(2.milliseconds, () {
      rebuildFuture = null;
      setState(() {
        // rebuild
        rint++;
      });
    });
  }

  void dehover(EditorReportingWidget dehover) {
    try {
      _hover.removeLast();
    } catch (e) {
      print('too much');
    }
    rebuildFuture ??= Future.delayed(2.milliseconds, () {
      rebuildFuture = null;
      setState(() {
        // rebuild
        rint--;
      });
    });
  }

  bool pointerDown(int id, EditorReportingWidget widget) {
    if (didPointerDown) {
      return false;
    }
    setState(() {
      if (innerSelection?.node != widget.node) {
        innerSelection = widget;
        innerSelectionId = id;
        propertiesListController.jumpTo(0);
      }
    });
    didPointerDown = true;
    Future.delayed(3.milliseconds).then((_) {
      didPointerDown = false;
    });
    return true;
  }

  bool report(int id, EditorReportingWidget widget) {
    if (id == innerSelectionId) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          innerSelection = widget;
          innerSelectionId = id;
          rint++;
          enumOverride = null;
          enumOverrideVal = null;
        });
      });
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _fileActiveSubscription = eventBus.on<EditorFileActiveEvent>().listen((event) {
      maybeReanalyze(event.file, true);
    });
    _fileSaveSubscription = eventBus.on<FileContentsChanged>().listen((event) {
      maybeReanalyze(event.file, false);
    });
  }

  void maybeReanalyze(String file, bool changeActive) {
    if (DartAnalyzer().currentRootFolder == Project.of(context).rootFolder && file.endsWith('.dart')) {
      DartAnalyzer().flutterFileInfo(file).then((_fileInfo) {
        setState(() {
          print(_fileInfo);
          if (_fileInfo == null) {
            return;
          }
          if (_fileInfo.widgets.isNotEmpty) {
            print(_fileInfo);
            fileInfo = _fileInfo;
            if (changeActive ||
                _fileInfo.widgets.firstWhere((element) => element.name == selectedWidget, orElse: () => null) == null) {
              selectedWidget = _fileInfo.widgets.first.name;
            }
          } else {
            fileInfo = null;
            selectedWidget = '<no widgets>';
          }
        });
      });
    } else {
      setState(() {
        fileInfo = null;
        selectedWidget = '<no widgets>';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Project>(builder: (context, child, model) {
      final namedW = <TableRow>[];
      var dark = true;
      if (innerSelection != null && innerSelection.node is DartInstanceCreationExpression) {
        print('reBUILD');
        final DartInstanceCreationExpression expr = innerSelection.node;

        expr.possibleNamed.forEach((k, v) {
          final control = _buildControl(expr, k, v);
          if (control == null) return;

          namedW.add(TableRow(decoration: dark ? BoxDecoration(color: Colors.blueGrey[700]) : null, children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(k),
                  ),
                  Text(
                    ConstructorPath.fromString(v.path).type,
                    style: TextStyle(fontSize: 10, color: Colors.blueGrey[200]),
                  )
                ],
              ),
            ),
            Row(children: [
              control,
              Expanded(child: Container()),
            ])
          ]));
          dark = !dark;
        });
      }
      return _FlutterUiEditor(
        data: this,
        child: InlineWindow(
          resizeLeft: true,
          constraints: BoxConstraints.tightFor(width: width),
          constraintsCallback: (delta) {
            setState(() {
              width -= delta.dx;
              width = min(600, max(width, 270));
            });
          },
          header: Text('Flutter UI Editor'),
          child: Material(
            color: Colors.blueGrey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DesktopDropdownButton<String>(
                    underline: Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blueGrey[800],
                            width: 0.0,
                          ),
                        ),
                      ),
                    ),
                    dropdownColor: Colors.blueGrey[100],
                    itemHeight: 36.0,
                    isDense: false,
                    style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[900]),
                    items: (fileInfo?.widgets?.map((w) => w.name) ?? ['<no widgets>']).map((String value) {
                      return DesktopDropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        selectedWidget = newVal;
                      });
                    },
                    value: selectedWidget,
                  ),
                ),
                Theme(
                  data: ThemeData(),
                  child: EditorWidgetCanvas(
                    fileInfo: fileInfo,
                    selectedWidget: selectedWidget,
                    hoverWidget: (_hover.isNotEmpty && _hover.last != null) ? _hover.last : null,
                    innerSelection: innerSelection,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 150, maxHeight: 200, minWidth: double.infinity, maxWidth: double.infinity),
                      child: Material(
                        color: Colors.blueGrey[600],
                        child: CupertinoScrollbar(
                          controller: propertiesListController,
                          child: ListView(
                            controller: propertiesListController,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  innerSelection != null
                                      ? innerSelection.path.type
                                      : (_hover != null && _hover.isNotEmpty
                                          ? _hover.last.path.type
                                          : 'No widget selected'),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: innerSelection == null && _hover != null && _hover.isNotEmpty
                                          ? Colors.white70
                                          : Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              DefaultTextStyle(
                                child: Table(
                                  children: namedW,
                                  columnWidths: {0: FlexColumnWidth(), 1: FlexColumnWidth(1)},
                                ),
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildControl(DartInstanceCreationExpression expression, String name, DartPossibleParameter template) {
    final path = ConstructorPath.fromString(template.path);
    if ((path.path1 == 'package:flutter/src/foundation/key.dart' && path.type == 'Key') ||
        path.type == 'List' ||
        path.type == 'Widget') {
      return null;
    }
    String isval;
    Color colval;
    dynamic val;
    var controlType = ControlType.NONE;
    if (path.path2 == 'dart:ui/painting.dart' && path.type == 'Color') {
      controlType = ControlType.COLOR;
    } else if (path.path1 == 'dart:core') {
      switch (path.type) {
        case 'bool':
          controlType = ControlType.BOOL;
          break;
        case 'double':
        case 'int':
        case 'num':
          controlType = ControlType.NUM;
          break;
        case 'String':
          controlType = ControlType.STRING;
          break;
      }
    }

    DartExpression param;
    DartNamedExpression root;

    if (expression.namedParameters.containsKey(name)) {
      root = expression.namedParameters[name];
      param = root.expression;
      try {
        if (controlType == ControlType.COLOR) {
          colval = param.eval(DartScope(null)).value;
        } else {
          val = param.eval(DartScope(null)).value;
        }
      } catch (e) {
        print('unable to evaluate $name (${e.runtimeType})');
      }
      if (param is DartPrefixedIdentifier) {
        isval = param.name;
      } else
        isval = param.offset.toString();
    } else {}

    Widget control;

    if (template.enumValues != null) {
      control = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
        child: DesktopDropdownButton<String>(
          underline: Container(),
          style: TextStyle(fontSize: 13),
          dropdownColor: Colors.blueGrey[800],
          items: [
            DesktopDropdownMenuItem(
              value: null,
              child: Text('<default>'),
            ),
            for (final enumVal in template.enumValues)
              DesktopDropdownMenuItem(
                value: enumVal.value,
                child: Text(enumVal.value),
                tooltip: '${docCommentPlaintext(enumVal.docComment)}',
              )
          ],
          onChanged: (value) {
            setState(() {
              enumOverride = name;
              enumOverrideVal = value;
            });
            final editor = EditorController.active..beginExternalEdit();

            if (param != null) {
              if (value == null) {
                // the user has set the value back to <default>
                final cur = editor.cursorFromOffset(root.offset, root.offset + root.length + 1);
                editor.deleteAt(cur);
              } else {
                final cur = editor.cursorFromOffset(param.offset + name.length + 1,
                    param.offset + name.length + 1 + (param as DartPrefixedIdentifier).name.length);
                editor.insertAt(cur, value);
              }
            } else if (value != null) {
              addParameter(editor, expression, name, '${path.type}.$value');
            }
          },
          value: enumOverride == name ? enumOverrideVal : isval,
        ),
      );
    } else if (controlType == ControlType.COLOR) {
      control = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
        child: ColorButton(
          color: colval,
          config: ColorPickerConfig(enableEyePicker: false),
          boxShape: BoxShape.rectangle,
          darkMode: true,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: colval,
            border: Border.all(width: 2, color: Colors.white),
          ),
          // default : circle
          size: 18,
          onColorChanged: (value) {
            if (value == null) return;
            final editor = EditorController.active..beginExternalEdit();
            String hx(int rep) {
              var out = rep.toRadixString(16);
              if (out.length == 1) out = '0$out';
              if (out.length > 2) out = out.substring(0, 2);
              return out;
            }

            final alpha = hx((value.opacity * 255).toInt());
            final red = hx(value.red);
            final green = hx(value.green);
            final blue = hx(value.blue);

            if (param != null) {
              final cur = editor.cursorFromOffset(param.offset, param.offset + param.length);
              editor.insertAt(cur, 'Color(0x$alpha$red$green$blue)');
            } else {
              addParameter(editor, expression, name, 'Color(0x$alpha$red$green$blue)');
            }
          },
        ),
      );
    } else if (controlType == ControlType.NUM || controlType == ControlType.STRING) {
      control = Expanded(
        child: TextField(
          inputFormatters: controlType == ControlType.NUM
              ? [
                  SingleMatchTextFormatter.allow(
                      RegExp(r'((0(x|X)[0-9a-fA-F]*)|(([0-9]+\.?[0-9]*)|(\.[0-9]*))((e|E)(\+|-)?[0-9]*)?)'))
                ]
              : [],
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              isDense: true,
              hintText: '<default>',
              floatingLabelBehavior: FloatingLabelBehavior.never),
          style: TextStyle(fontSize: 14),
          keyboardType: controlType == ControlType.NUM ? TextInputType.number : TextInputType.text,
        ),
      );
    } else {
      control = Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(isval ?? '<default>', style: isval == null ? TextStyle(color: Colors.white54) : null),
      );
    }

    return control;
  }

  void addParameter(EditorController editor, DartInstanceCreationExpression expression, String name, String value) {
    final cur = editor.cursorFromOffset(expression.offset, expression.offset + expression.length);
    final expressionLine = cur.line;
    final firstParamLine = editor
        .cursorFromOffsetSingle((expression.positionalParameters.isNotEmpty
                ? expression.positionalParameters.first
                : (expression.namedParameters.isNotEmpty
                    ? expression.namedParameters[expression.namedParameters.keys.first]
                    : expression))
            .offset)
        .line;
    final isMultiline = firstParamLine != expressionLine;
    var lastWasId = false;
    DartPrefixedIdentifier last;
    var didInsert = false;
    String lineIndent(int line) => isMultiline ? editor.lineIndent(line) : '';
    final lineEnding = isMultiline ? '\n' : ' ';
    String insert(EditorCursor cur, {bool comma = true}) =>
        '${lineIndent(cur.line)}$name: $value${comma ? ",$lineEnding" : (isMultiline ? lineEnding : '')}';
    for (final ik in expression.namedParameters.keys) {
      if (expression.namedParameters[ik].expression is DartPrefixedIdentifier) {
        lastWasId = true;
        last = expression.namedParameters[ik].expression;
      } else if ((lastWasId || ik == 'child' || ik == 'children') && last != null) {
        final cur = editor.cursorFromOffset(last.offset + last.length + 2, last.offset + last.length + 2);
        editor.insertAt(cur, insert(cur));
        didInsert = true;
      }
    }
    if (!didInsert) {
      if (expression.namedParameters.isEmpty) {
        if (expression.positionalParameters.isNotEmpty) {
          final pref = expression.positionalParameters.last;
          final sel = editor.cursorFromOffset(pref.offset, pref.offset + pref.length + 1);

          final t = editor.textAt(sel);
          final hasComma = t.endsWith(',');

          final cur =
              editor.cursorFromOffsetSingle(pref.offset + pref.length + (hasComma ? 1 : 0) + (isMultiline ? 1 : 0));
          editor.insertAt(cur, (hasComma ? '' : ', ') + insert(cur, comma: hasComma));
        } else {
          final cur = editor.cursorFromOffsetSingle(expression.offset + expression.length - 1);
          editor.insertAt(cur, insert(cur));
        }
      } else {
        final pref = expression.namedParameters[expression.namedParameters.keys.last];
        final cur = editor.cursorFromOffsetSingle(pref.offset + pref.length + (isMultiline ? 2 : 1));
        editor.insertAt(cur, '${lineIndent(isMultiline ? cur.line - 1 : cur.line)}$name: $value,$lineEnding');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fileActiveSubscription.cancel();
    _fileSaveSubscription.cancel();
  }
}

class _FlutterUiEditor extends InheritedWidget {
  final FlutterUiEditorState data;

  _FlutterUiEditor({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_FlutterUiEditor old) {
    return true;
  }
}

enum ControlType { NONE, COLOR, BOOL, NUM, STRING }
*/
