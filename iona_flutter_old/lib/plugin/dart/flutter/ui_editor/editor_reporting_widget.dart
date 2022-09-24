/*import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/flutter_ui_editor.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types.dart';
import 'package:iona_flutter/plugin/dart/utils/strings.dart';
import 'package:iona_flutter/ui/editor/controller.dart';

import 'fit_text_field.dart' as fitTextField;

// (immutability is dumb)
// ignore: must_be_immutable
class EditorReportingWidget<T extends Widget> extends StatefulWidget {
  EditorReportingWidget({this.node, this.child, this.path, this.focusNode});

  final DartInstanceCreationExpression node;
  final T child;
  final FocusNode focusNode;
  ConstructorPath path;
  RenderObject currentRenderObject;
  EditorReportingWidgetState currentState;

  @override
  EditorReportingWidgetState createState() => EditorReportingWidgetState();
}

class EditorReportingWidgetState extends State<EditorReportingWidget> {
  static int eri = 0;

  DartInstanceCreationExpression _lastSourceNode;
  Widget childReplacement;
  bool startedDoubleTap = false;
  FocusNode _focusNode;
  final TextEditingController ctrl = TextEditingController();
  String textReplacement;
  int id;

  @override
  void initState() {
    super.initState();
    id = eri++;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode
      ..attach(context)
      ..addListener(() {
        if (!_focusNode.hasFocus && childReplacement != null) {
          setState(() {
            childReplacement = null;
            ctrl.removeListener(_onTextChanged);
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastSourceNode != null && !widget.node.equalIdentifiers(_lastSourceNode)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.currentRenderObject = context.findRenderObject();
      });
      FlutterUiEditor.of(context).report(id, widget);
    }

    _lastSourceNode = widget.node;

    return MouseRegion(
      onEnter: (event) {
        widget.currentState = this;
        widget.currentRenderObject = context.findRenderObject();
        FlutterUiEditor.of(context).hover(widget);
      },
      onExit: (event) {
        FlutterUiEditor.of(context).dehover(widget);
      },
      cursor: SystemMouseCursors.click,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        child: childReplacement ?? widget.child,
        onPointerDown: _pointerDown,
        onPointerMove: (event) {},
      ),
    );
  }

  void _pointerDown(PointerDownEvent event) {
    widget.currentRenderObject = context.findRenderObject();
    if (!FlutterUiEditor.of(context).pointerDown(id, widget)) {
      return;
    }
    if (startedDoubleTap) {
      if (widget.child is Text && childReplacement == null) {
        print('issa text: ${widget.node.offset}');
        setState(() {
          final Text cc = widget.child;
          ctrl.text = cc.data;
          textReplacement = cc.data;
          final ts = DefaultTextStyle.of(context);
          final st =
              TextStyle(fontSize: 12.0, textBaseline: TextBaseline.alphabetic).merge(ts.style.copyWith(inherit: true));

          childReplacement = fitTextField.FitTextField(
            autofocus: true,
            controller: ctrl,
            focusNode: _focusNode,
            maxLines: null,
            style: st,
            cursorColor: st.color,
            onEditingComplete: () {
              setState(() {
                childReplacement = null;
              });
            },
            keyboardType: fitTextField.TextInputType.multiline,
          );

          ctrl.addListener(_onTextChanged);

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ctrl
              ..text = cc.data
              ..selection = TextSelection(baseOffset: 0, extentOffset: cc.data.length);
            FocusScope.of(context).requestFocus(_focusNode);
            Future.delayed(const Duration(milliseconds: 12))
                .then((value) => FocusScope.of(context).requestFocus(_focusNode));
          });
        });
      }
    } else {
      startedDoubleTap = true;
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        startedDoubleTap = false;
      });
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void _onTextChanged() {
    if (EditorController.active != null && textReplacement != ctrl.text) {
      //widget.node.offset

      final editor = EditorController.active..beginExternalEdit();
      final string =
          (widget.node as DartInstanceCreationExpression).positionalParameters.first as DartSimpleStringLiteral;

      final cur = editor.cursorFromOffset(string.offset + 1, string.offset + textReplacement.length + 1);
      print(cur);
      editor.insertAt(cur, ctrl.text);
    }
    textReplacement = ctrl.text;
  }
}

class EditorReportingPrefSizeWidget extends EditorReportingWidget<PreferredSizeWidget> implements PreferredSizeWidget {
  EditorReportingPrefSizeWidget({DartSourceNode node, PreferredSizeWidget child, ConstructorPath path})
      : super(node: node, child: child, path: path);

  @override
  Size get preferredSize => child.preferredSize;
}*/
