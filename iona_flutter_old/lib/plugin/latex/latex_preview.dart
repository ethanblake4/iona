import 'package:catex/catex.dart';
import 'package:flutter/material.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:scoped_model/scoped_model.dart';

class LatexPreview extends StatefulWidget {
  @override
  _LatexPreviewState createState() => _LatexPreviewState();
}

class _LatexPreviewState extends State<LatexPreview> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Project>(builder: (context, child, model) {
      try {
        return InlineWindow(
            constraints: BoxConstraints.tightFor(width: 400),
            header: Text('LaTeX Preview'),
            child: Theme(
                data: ThemeData(
                    textTheme: TextTheme(
                  bodyText2: TextStyle(color: Colors.black87, fontSize: 12.0, inherit: false),
                  bodyText1: TextStyle(color: Colors.black87, fontSize: 12.0, inherit: false),
                )),
                child: Material(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          child: CaTeX(adocToString(model.activeProjectFile.document))),
                    ))));
      } catch (e) {
        return Text("Failed to render");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
