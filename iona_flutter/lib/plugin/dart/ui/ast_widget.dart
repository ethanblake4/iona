import 'package:dart_eval/dart_eval.dart';
import 'package:flutter/material.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/model/flutter_types/flutter_types.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types.dart';

class AstWidget extends StatefulWidget {
  const AstWidget(this.file, this.selectedWidget);

  final FlutterFileInfo file;
  final String selectedWidget;

  @override
  _AstWidgetState createState() => _AstWidgetState();
}

class _AstWidgetState extends State<AstWidget> {
  @override
  Widget build(BuildContext context) {
    //final scope = DartScope(null);

    if (widget.file == null) {
      return Text('No file');
    }

    final cls = widget.file.topLevelScope.scope.lookup(widget.selectedWidget) as EvalClass;

    // ignore: cascade_invocations
    final wid = cls.call(widget.file.topLevelScope.scope, EvalScope.empty, [], []);

    final build = wid.getField('build');

    if (build is EvalFunction) {
      build.call(EvalScope.empty, EvalScope.empty, [], [args]);
    }

    /*for (final element in widget.file.widgets) {
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
    }*/

    final w = scope.lookup(widget.selectedWidget);

    final b = w.getMethod('build');
    if (b != null) {
      if (b is DartEvalCallable) {
        final wid =
            b.call(scope, [DartInjectedExpression(-1, -1, inject: (scope) => DartEvalTypeBuildContext(context))]);

        if (wid is DartEvalTypeWidget) {
          return wid.value;
        } else {
          print(wid);
          return Text('Render failure');
        }
      }
    }
    return Text('No widget found');
  }
}
