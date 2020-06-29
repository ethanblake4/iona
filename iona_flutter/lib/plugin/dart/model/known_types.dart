import 'package:flutter/material.dart';
import 'package:iona_flutter/plugin/dart/model/eval.dart';
import 'package:iona_flutter/plugin/dart/model/static/indexed_colors.dart';
import 'package:iona_flutter/plugin/dart/model/static/indexed_icons.dart';
import 'package:iona_flutter/ui/design/custom_iconbutton.dart';

const flSrc = 'package:flutter/src';
const flWidgets = '$flSrc/widgets';
const flBasic = '$flWidgets/basic.dart;$flWidgets/basic.dart';
const flMatLib = '$flSrc/material';
const flMaterial = '$flMatLib/material.dart;$flMatLib/material.dart';
const flPainting = '$flSrc/painting';

T rn<T>(Map<String, dynamic> resolvedNamedArgs, String name, [T defaultValue]) {
  if (resolvedNamedArgs.containsKey(name)) {
    return resolvedNamedArgs[name];
  }
  return defaultValue;
}

List<T> rnList<T>(Map<String, dynamic> resolvedNamedArgs, String name, [List<T> defaultValue]) {
  if (resolvedNamedArgs.containsKey(name)) {
    return resolvedNamedArgs[name].cast<T>();
  }
  return defaultValue;
}

Map<String, KnownFunction> knownTypeMap;
Map<String, DartEvalType> knownStaticTypeMap;

void buildTypeMap() {
  knownTypeMap = <String, KnownFunction>{
    '$flBasic;Flex;': (_, r) => DartEvalTypeGeneric(Flex(
          key: rn<Key>(r, 'key'),
          direction: rn<Axis>(r, 'direction'),
          mainAxisAlignment: rn(r, 'mainAxisAlignment', MainAxisAlignment.start),
          mainAxisSize: rn(r, 'mainAxisSize', MainAxisSize.max),
          crossAxisAlignment: rn(r, 'crossAxisAlignment', CrossAxisAlignment.center),
          textDirection: rn<TextDirection>(r, 'textDirection'),
          verticalDirection: rn(r, 'verticalDirection', VerticalDirection.down),
          textBaseline: rn<TextBaseline>(r, 'textBaseline'),
          children: rnList<Widget>(r, 'children', const <Widget>[]),
        )),
    '$flBasic;Padding;': (_, r) => DartEvalTypeGeneric(Padding(
          key: rn<Key>(r, 'key'),
          padding: rn<EdgeInsets>(r, 'padding'),
          child: rn<Widget>(r, 'child'),
        )),
    '$flBasic;Expanded;': (_, r) => DartEvalTypeGeneric(Expanded(
          key: rn<Key>(r, 'key'),
          flex: rn<int>(r, 'flex', 1),
          child: rn<Widget>(r, 'child'),
        )),
    '$flBasic;Column;': (p, r) => knownTypeMap['$flBasic;Flex;'](p, {...r, 'direction': Axis.vertical}),
    '$flBasic;Row;': (p, r) => knownTypeMap['$flBasic;Flex;'](p, {...r, 'direction': Axis.horizontal}),
    '$flWidgets/text.dart;$flWidgets/text.dart;Text;': (p, r) => DartEvalTypeGeneric(Text(p[0], key: rn(r, 'key'))),
    '$flMaterial;Material;': (_, r) => DartEvalTypeGeneric(Material(
          key: rn<Key>(r, 'key'),
          type: rn(r, 'type', MaterialType.canvas),
          elevation: rn(r, 'elevation', 0.0),
          color: rn<Color>(r, 'color'),
          shadowColor: rn(r, 'shadowColor', const Color(0xFF000000)),
          textStyle: rn<TextStyle>(r, 'textStyle'),
          borderRadius: rn<BorderRadiusGeometry>(r, 'borderRadius'),
          shape: rn<ShapeBorder>(r, 'shape'),
          borderOnForeground: rn(r, 'borderOnForeground', true),
          clipBehavior: rn<Clip>(r, 'clipBehavior', Clip.none),
          animationDuration: rn(r, 'animationDuration', kThemeAnimationDuration),
          child: rn<Widget>(r, 'child'),
        )),
    '$flPainting/edge_insets.dart;$flPainting/edge_insets.dart;EdgeInsets;only': (_, r) => DartEvalTypeGeneric(
        EdgeInsets.only(
            left: rn<num>(r, 'left', 0)?.toDouble(),
            top: rn<num>(r, 'top', 0)?.toDouble(),
            right: rn<num>(r, 'right', 0)?.toDouble(),
            bottom: rn<num>(r, 'bottom', 0)?.toDouble())),
    '$flPainting/edge_insets.dart;$flPainting/edge_insets.dart;EdgeInsets;symmetric': (_, r) => DartEvalTypeGeneric(
        EdgeInsets.symmetric(
            horizontal: rn<num>(r, 'horizontal', 0)?.toDouble(), vertical: rn<num>(r, 'vertical', 0)?.toDouble())),
    '$flPainting/edge_insets.dart;$flPainting/edge_insets.dart;EdgeInsets;all': (p, _) =>
        DartEvalTypeGeneric(EdgeInsets.all(p[0])),
    '$flWidgets/icon.dart;$flWidgets/icon.dart;Icon;': (p, r) => DartEvalTypeGeneric(Icon(
          p[0],
          key: rn<Key>(r, 'key'),
          size: rn<num>(r, 'size')?.toDouble(),
          color: rn<Color>(r, 'color'),
          semanticLabel: rn<String>(r, 'semanticLabel'),
          textDirection: rn<TextDirection>(r, 'textDirection'),
        )),
    '$flWidgets/container.dart;$flWidgets/container.dart;Container;': (_, r) => DartEvalTypeGeneric(Container(
          key: rn<Key>(r, 'key'),
          alignment: rn<Alignment>(r, 'alignment'),
          color: rn<Color>(r, 'color'),
          width: rn<num>(r, 'width')?.toDouble(),
          height: rn<num>(r, 'height')?.toDouble(),
          padding: rn<EdgeInsets>(r, 'padding'),
          child: rn<Widget>(r, 'child'),
        )),
    'package:iona_flutter/ui/design/custom_iconbutton.dart;package:iona_flutter/ui/design/custom_iconbutton.dart;CustomIconButton;':
        (_, r) => DartEvalTypeGeneric(CustomIconButton(
              icon: rn<Widget>(r, 'icon'),
              onPressed: rn<Function>(r, 'onPressed'),
            ))
  };
  knownStaticTypeMap = <String, DartEvalType>{
    '$flMatLib/icons.dart;$flMatLib/icons.dart;Icons': DartEvalKnownMap(indexedIcons),
    '$flMatLib/colors.dart;$flMatLib/colors.dart;Colors': DartEvalKnownMap(indexedColors),
    'package:iona_flutter/ui/components/action_bar.dart;package:iona_flutter/ui/components/action_bar.dart;_ActionBarState;openFile?':
        DartEvalTypeString('heyyy')
  };
}
