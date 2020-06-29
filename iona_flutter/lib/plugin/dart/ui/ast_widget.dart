import 'package:flutter/material.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/model/eval.dart';

class AstWidget extends StatefulWidget {
  const AstWidget(this.astRoot);

  final FlutterWidgetInfo astRoot;
  @override
  _AstWidgetState createState() => _AstWidgetState();
}

class _AstWidgetState extends State<AstWidget> {
  @override
  Widget build(BuildContext context) {
    final scope = DartScope(null);
    if (widget.astRoot == null) {
      return Text("No widget");
    }
    try {
      final wid = widget.astRoot.build.body.child.eval(scope);
      if (wid is DartEvalTypeGeneric && wid.value is Widget) {
        return wid.value;
      } else {
        print(wid);
        return Text("Render fail");
      }
    } catch (e) {
      return Text("Render error");
    }
  }
}
