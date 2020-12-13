import 'package:flutter/material.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/eval.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/model/flutter_types/flutter_types.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types.dart';

class AstWidget extends StatefulWidget {
  const AstWidget(this.file, this.astRoot);

  final FlutterFileInfo file;
  final FlutterWidgetInfo astRoot;

  @override
  _AstWidgetState createState() => _AstWidgetState();
}

class _AstWidgetState extends State<AstWidget> {
  @override
  Widget build(BuildContext context) {
    final scope = DartScope(null);

    if (widget.file == null) {
      return Text('No file');
    }

    for (final element in widget.file.widgets) {
      final Map<String, DartEvalType> fields = {};
      final Map<String, DartEvalCallable> methods = {};
      for (final clsEl in element.widgetClass.classElements) {
        if (clsEl is DartFieldDeclaration) {
          for (final field in clsEl.fieldList) {
            fields[field.name] = field.initializer.eval(scope);
          }
        } else if (clsEl is DartMethodDeclaration) {
          final params = <DartParameter>[];
          final namedParams = <String, DartParameter>{};
          for (final pr in clsEl.params) {
            if (!pr.isNamed) {
              params.add(pr);
            } else {
              namedParams[pr.paramName] = pr;
            }
          }
          methods[clsEl.name] = DartEvalCallableImpl(null, clsEl.body.child, params: params, namedParams: namedParams);
        }
      }
      scope.set(element.name, DartEvalTypeGeneric(null, fields: fields, methods: methods));
    }

    if (widget.astRoot == null) {
      return Text('No widget');
    }

    for (final cle in widget.astRoot.widgetClass.classElements) {
      //cle.eval(scope);
    }

    final build = scope.lookup('build');

    if (build is DartEvalCallable) {
      final wid =
          build.call(scope, [DartInjectedExpression(0, 0, inject: (scope) => DartEvalTypeBuildContext(context))]);
      //print(wid);

      if (wid is DartEvalTypeWidget) {
        return wid.value;
      } else {
        print(wid);
        return Text('render fail');
      }
    } else {
      print(build);
      return Text('not callable');
    }
  }
}
