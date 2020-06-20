import 'package:flutter/material.dart';
import 'package:iona_flutter/model/ide/ide_theme.dart';

class InlineWindow extends StatefulWidget {
  Widget child;
  Widget header;
  Function(RawKeyEvent) onKey;

  InlineWindow({Key key, this.child, this.header, this.onKey}) : super(key: key);

  @override
  InlineWindowState createState() => new InlineWindowState();

  static InlineWindowState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InlineWindow>()).data;
  }
}

class InlineWindowState extends State<InlineWindow> {
  final FocusNode _focusNode = FocusNode(skipTraversal: true);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  bool get hasFocus => _focusNode.hasFocus;

  /// Request focus
  void requestFocus() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return new _InlineWindow(
      data: this,
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: RawKeyboardListener(
              focusNode: _focusNode,
              onKey: widget.onKey,
              child: Column(children: [
                Row(children: <Widget>[
                  Expanded(
                    child: Material(
                        color: _focusNode.hasFocus
                            ? IdeTheme.of(context).windowHeaderActive.col
                            : IdeTheme.of(context).windowHeader.col,
                        child: widget.header),
                  ),
                ]),
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Expanded(child: widget.child),
                  ],
                ))
              ]))),
    );
  }
}

/// Only has MyInheritedState as field.
class _InlineWindow extends InheritedWidget {
  final InlineWindowState data;

  _InlineWindow({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InlineWindow old) {
    return true;
  }
}
