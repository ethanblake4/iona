import 'package:flutter/material.dart';
import 'package:iona_flutter/plugin/dart/model/eval.dart';

const FL_SRC = 'package:flutter/src';
const FL_WIDGETS = '$FL_SRC/widgets';
const FL_BASIC = '$FL_WIDGETS/basic.dart;$FL_WIDGETS/basic.dart';

dynamic rn(Map<String, dynamic> resolvedNamedArgs, String name, [dynamic defaultValue]) {
  if (resolvedNamedArgs.containsKey(name)) {
    return resolvedNamedArgs[name];
  }
  return defaultValue;
}

Map<String, KnownFunction> knownTypeMap;

void buildTypeMap() {
  knownTypeMap = <String, KnownFunction>{
    '$FL_BASIC;Flex;': (_, r) => DartEvalTypeGeneric(Flex(
          key: rn(r, 'key'),
          direction: rn(r, 'direction'),
          mainAxisAlignment: rn(r, 'mainAxisAlignment', MainAxisAlignment.start),
          mainAxisSize: rn(r, 'mainAxisSize', MainAxisSize.max),
          crossAxisAlignment: rn(r, 'crossAxisAlignment', CrossAxisAlignment.center),
          textDirection: rn(r, 'textDirection'),
          verticalDirection: rn(r, 'verticalDirection', VerticalDirection.down),
          textBaseline: rn(r, 'textBaseline'),
          children: (rn(r, 'children', const <Widget>[])).cast<Widget>(),
        )),
    '$FL_BASIC;Column;': (p, r) => knownTypeMap['$FL_BASIC;Flex;'](p, {...r, 'direction': Axis.vertical}),
    '$FL_BASIC;Row;': (p, r) => knownTypeMap['$FL_BASIC;Flex;'](p, {...r, 'direction': Axis.horizontal}),
    '$FL_WIDGETS/text.dart;$FL_WIDGETS/text.dart;Text;': (p, r) => DartEvalTypeGeneric(Text(p[0], key: rn(r, 'key')))
  };
}
