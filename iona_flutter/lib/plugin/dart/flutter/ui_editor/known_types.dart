import 'package:flutter/material.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/editor_reporting_widget.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/eval.dart';
import 'package:iona_flutter/plugin/dart/model/flutter_types/flex.dart';
import 'package:iona_flutter/plugin/dart/model/flutter_types/flutter_types.dart';
import 'package:iona_flutter/plugin/dart/model/flutter_types/material.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types.dart';
import 'package:iona_flutter/plugin/dart/model/static/indexed_colors.dart';
import 'package:iona_flutter/plugin/dart/model/static/indexed_icons.dart';
import 'package:iona_flutter/plugin/dart/utils/strings.dart';
import 'package:iona_flutter/ui/design/custom_iconbutton.dart';

import 'known_paths.dart';

T rn<T>(Map<String, dynamic> resolvedNamedArgs, String name, [T defaultValue]) {
  if (resolvedNamedArgs.containsKey(name)) {
    return resolvedNamedArgs[name];
  }
  return defaultValue;
}

List<T> rnList<T>(Map<String, dynamic> resolvedNamedArgs, String name, [List<T> defaultValue]) {
  if (resolvedNamedArgs.containsKey(name)) {
    return resolvedNamedArgs[name].map((v) => v.value).toList().cast<T>();
  }
  return defaultValue;
}

Map<String, KnownFunction> knownTypeMap;
Map<String, DartEvalType> knownStaticTypeMap;

KnownFunction changePath(KnownFunction fnIn, String path) {
  return (n, p, r) {
    final v = fnIn(n, p, r);
    if (v is DartEvalTypeWidget && v.value is EditorReportingWidget) {
      final EditorReportingWidget w = v.value;
      // ignore: cascade_invocations
      w.path = ConstructorPath.fromString(path);
    }
    return v;
  };
}

Map<String, dynamic> removeKey(Map<String, dynamic> inMap, String key) {
  if (!inMap.containsKey(key)) return inMap;
  final nm = <String, dynamic>{};
  inMap.forEach((k, v) {
    if (key == k) return;
    nm[k] = v;
  });
  return nm;
}

void buildTypeMap() {
  knownTypeMap = <String, KnownFunction>{
    '$flwFlex;': (n, _, r) => _wrapWidget(
        n,
        Flex(
          key: rn<Key>(r, 'key'),
          direction: rn<Axis>(r, 'direction'),
          mainAxisAlignment: rn(r, 'mainAxisAlignment', MainAxisAlignment.start),
          mainAxisSize: rn(r, 'mainAxisSize', MainAxisSize.max),
          crossAxisAlignment: rn(r, 'crossAxisAlignment', CrossAxisAlignment.center),
          textDirection: rn<TextDirection>(r, 'textDirection'),
          verticalDirection: rn(r, 'verticalDirection', VerticalDirection.down),
          textBaseline: rn<TextBaseline>(r, 'textBaseline'),
          children: rnList<Widget>(r, 'children', const <Widget>[]),
        ),
        '$flBasic;Flex;'),
    '$flwPadding;': (n, _, r) => _wrapWidget(
        n,
        Padding(
          key: rn<Key>(r, 'key'),
          padding: rn<EdgeInsets>(r, 'padding'),
          child: rn<Widget>(r, 'child'),
        ),
        '$flBasic;Padding;'),
    '$flwExpanded;': (n, _, r) => _wrapWidget(
        n,
        Expanded(
          key: rn<Key>(r, 'key'),
          flex: rn<int>(r, 'flex', 1),
          child: rn<Widget>(r, 'child'),
        ),
        '$flBasic;Expanded;'),
    '$flwColumn;': changePath(
        (n, p, r) => knownTypeMap['$flBasic;Flex;'](n, p, {...r, 'direction': Axis.vertical}), '$flBasic;Column;'),
    '$flwRow;': changePath(
        (n, p, r) => knownTypeMap['$flBasic;Flex;'](n, p, {...r, 'direction': Axis.horizontal}), '$flBasic;Row;'),
    '$flBasic;Align;': (n, p, r) => _wrapWidget(
        n,
        Align(
          key: rn<Key>(r, 'key'),
          alignment: rn<AlignmentGeometry>(r, 'alignment', Alignment.center),
          widthFactor: rn<num>(r, 'widthFactor')?.toDouble(),
          heightFactor: rn<num>(r, 'heightFactor')?.toDouble(),
          child: rn<Widget>(r, 'child'),
        ),
        '$flBasic;Align;'),
    '$flBasic;Center;':
        changePath((n, p, r) => knownTypeMap['$flBasic;Align;'](n, p, removeKey(r, 'alignment')), '$flBasic;Center;'),
    '$flwText;': (n, p, r) => _wrapWidget(
        n,
        Text(
          p[0],
          key: rn<Key>(r, 'key'),
          style: rn<TextStyle>(r, 'style'),
        ),
        '${"$flWidgets/text.dart;" * 2}Text;'),
    '$flMaterial;Material;': (n, _, r) => _wrapWidget(
        n,
        Material(
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
        ),
        '$flMaterial;Material;'),
    '$flPainting/edge_insets.dart;$flPainting/edge_insets.dart;EdgeInsets;only': (n, _, r) => DartEvalTypeGeneric(
        EdgeInsets.only(
            left: rn<num>(r, 'left', 0)?.toDouble(),
            top: rn<num>(r, 'top', 0)?.toDouble(),
            right: rn<num>(r, 'right', 0)?.toDouble(),
            bottom: rn<num>(r, 'bottom', 0)?.toDouble())),
    '$flPainting/edge_insets.dart;$flPainting/edge_insets.dart;EdgeInsets;symmetric': (n, _, r) => DartEvalTypeGeneric(
        EdgeInsets.symmetric(
            horizontal: rn<num>(r, 'horizontal', 0)?.toDouble(), vertical: rn<num>(r, 'vertical', 0)?.toDouble())),
    '$flPainting/edge_insets.dart;$flPainting/edge_insets.dart;EdgeInsets;all': (n, p, _) =>
        DartEvalTypeGeneric(EdgeInsets.all(p[0]?.toDouble())),
    '$flWidgets/icon.dart;$flWidgets/icon.dart;Icon;': (n, p, r) => _wrapWidget(
        n,
        Icon(
          p[0],
          key: rn<Key>(r, 'key'),
          size: rn<num>(r, 'size')?.toDouble(),
          color: rn<Color>(r, 'color'),
          semanticLabel: rn<String>(r, 'semanticLabel'),
          textDirection: rn<TextDirection>(r, 'textDirection'),
        ),
        '$flWidgets/icon.dart;$flWidgets/icon.dart;Icon;'),
    '$flWidgets/container.dart;$flWidgets/container.dart;Container;': (n, _, r) => _wrapWidget(
        n,
        Container(
          key: rn<Key>(r, 'key'),
          alignment: rn<Alignment>(r, 'alignment'),
          color: rn<Color>(r, 'color'),
          width: rn<num>(r, 'width')?.toDouble(),
          height: rn<num>(r, 'height')?.toDouble(),
          padding: rn<EdgeInsets>(r, 'padding'),
          child: rn<Widget>(r, 'child'),
        ),
        '$flWidgets/container.dart;$flWidgets/container.dart;Container;'),
    '$flMatLib/scaffold.dart;$flMatLib/scaffold.dart;Scaffold;': (n, _, r) => _wrapWidget(
        n,
        Scaffold(
          body: rn<Widget>(r, 'body'),
          appBar: rn<PreferredSizeWidget>(r, 'appBar'),
          floatingActionButton: rn<Widget>(r, 'floatingActionButton'),
          backgroundColor: rn<Color>(r, 'backgroundColor'),
          floatingActionButtonLocation: rn<FloatingActionButtonLocation>(r, 'floatingActionButtonLocation'),
          floatingActionButtonAnimator: rn<FloatingActionButtonAnimator>(r, 'floatingActionButtonAnimator'),
          persistentFooterButtons: rnList<Widget>(r, 'persistentFooterButtons'),
          drawer: rn<Widget>(r, 'drawer'),
          endDrawer: rn<Widget>(r, 'endDrawer'),
        ),
        '$flMatLib/scaffold.dart;$flMatLib/scaffold.dart;Scaffold;'),
    '${"$flMatLib/floating_action_button.dart;" * 2}FloatingActionButton;': (n, _, r) => _wrapWidget(
        n,
        FloatingActionButton(
          key: rn<Key>(r, 'key'),
          child: rn<Widget>(r, 'child'),
          tooltip: rn<String>(r, 'tooltip'),
          foregroundColor: rn<Color>(r, 'foregroundColor'),
          backgroundColor: rn<Color>(r, 'backgroundColor'),
          focusColor: rn<Color>(r, 'focusColor'),
          onPressed: () {},
        ),
        '${"$flMatLib/floating_action_button.dart;" * 2}FloatingActionButton;'),
    '$flMatLib/app_bar.dart;$flMatLib/app_bar.dart;AppBar;': (n, _, r) => _wrapWidget(
        n,
        AppBar(
          key: rn<Key>(r, 'key'),
          leading: rn<Widget>(r, 'leading'),
          automaticallyImplyLeading: rn<bool>(r, 'automaticallyImplyLeading', true),
          title: rn<Widget>(r, 'title'),
          actions: rnList<Widget>(r, 'actions'),
          flexibleSpace: rn<Widget>(r, 'flexibleSpace'),
          bottom: rn<Widget>(r, 'bottom'),
          elevation: rn<num>(r, 'elevation')?.toDouble(),
          shadowColor: rn<Color>(r, 'shadowColor'),
          shape: rn<ShapeBorder>(r, 'shape'),
          backgroundColor: rn<Color>(r, 'backgroundColor'),
          brightness: rn<Brightness>(r, 'brightness'),
          iconTheme: rn<IconThemeData>(r, 'iconTheme'),
          actionsIconTheme: rn<IconThemeData>(r, 'actionsIconTheme'),
          textTheme: rn<TextTheme>(r, 'textTheme'),
          primary: rn<bool>(r, 'primary', true),
          centerTitle: rn<bool>(r, 'centerTitle'),
        ),
        '$flMatLib/app_bar.dart;$flMatLib/app_bar.dart;AppBar;'),
    '$flmMaterialApp;': (n, _, r) => _wrapWidget(
        n,
        MaterialApp(
            key: rn<Key>(r, 'key'),
            navigatorKey: rn<GlobalKey<NavigatorState>>(r, 'navigatorKey'),
            home: rn<Widget>(r, 'home'),
            initialRoute: rn<String>(r, 'initialRoute'),
            title: rn<String>(r, 'title'),
            theme: rn<ThemeData>(r, 'theme')),
        '$flmMaterialApp;',
        wrapper: (w) => DartEvalTypeMaterialApp(w)),
    'package:iona_flutter/ui/design/custom_iconbutton.dart;package:iona_flutter/ui/design/custom_iconbutton.dart;CustomIconButton;':
        (n, _, r) => _wrapWidget(
            n,
            CustomIconButton(
              icon: rn<Widget>(r, 'icon'),
              onPressed: rn<Function>(r, 'onPressed'),
            ),
            'package:iona_flutter/ui/design/custom_iconbutton.dart;package:iona_flutter/ui/design/custom_iconbutton.dart;CustomIconButton;'),
    '$fluiColor;': (n, p, r) => DartEvalTypeColor(Color(p[0])),
    '$fluiColor;fromARGB': (n, p, r) => DartEvalTypeColor(Color.fromARGB(p[0], p[1], p[2], p[3])),
    '$fluiColor;fromRGBO': (n, p, r) => DartEvalTypeColor(Color.fromRGBO(p[0], p[1], p[2], p[3]?.toDouble())),
    '$flmVisualDensity;': (n, p, r) => DartEvalTypeVisualDensity(VisualDensity(
          horizontal: rn<num>(r, 'horizontal')?.toDouble(),
          vertical: rn<num>(r, 'vertical')?.toDouble(),
        )),
    '$flmThemeData;': (n, p, r) => DartEvalTypeThemeData(ThemeData(
        primarySwatch: rn<MaterialColor>(r, 'primarySwatch'),
        brightness: rn<Brightness>(r, 'brightness'),
        visualDensity: rn<VisualDensity>(r, 'visualDensity')))
  };
  knownStaticTypeMap = <String, DartEvalType>{
    '$flMatLib/icons.dart;$flMatLib/icons.dart;Icons':
        DartEvalTypeStaticMap<IconData>(Icons, fields: indexedIcons, wrapper: (v) => DartEvalTypeIconData(v)),
    '$flMatLib/colors.dart;$flMatLib/colors.dart;Colors':
        DartEvalTypeStaticMap<Color>(Colors, fields: indexedColors, wrapper: (v) => DartEvalTypeColor(v)),
    '$flFlex;MainAxisAlignment': DartEvalTypeEnum<MainAxisAlignment>(MainAxisAlignment,
        fields: {
          'start': MainAxisAlignment.start,
          'end': MainAxisAlignment.end,
          'center': MainAxisAlignment.center,
          'spaceBetween': MainAxisAlignment.spaceBetween,
          'spaceAround': MainAxisAlignment.spaceAround,
          'spaceEvenly': MainAxisAlignment.spaceEvenly,
        },
        wrapper: (v) => DartEvalTypeMainAxisAlignment(v)),
    '$flFlex;MainAxisSize': DartEvalTypeEnum<MainAxisSize>(MainAxisSize,
        fields: {
          'max': MainAxisSize.max,
          'min': MainAxisSize.min,
        },
        wrapper: (v) => DartEvalTypeMainAxisSize(v)),
    '$flFlex;CrossAxisAlignment': DartEvalTypeEnum<CrossAxisAlignment>(CrossAxisAlignment,
        fields: {
          'start': CrossAxisAlignment.start,
          'stretch': CrossAxisAlignment.stretch,
          'baseline': CrossAxisAlignment.baseline,
          'center': CrossAxisAlignment.center,
          'end': CrossAxisAlignment.end,
        },
        wrapper: (v) => DartEvalTypeCrossAxisAlignment(v)),
    flmTheme: DartEvalTypeGeneric<Type>(Theme, methods: <String, DartEvalCallable<Function>>{
      'of': DartInternalCallable(Theme.of, (p, n) => DartEvalTypeThemeData(Theme.of(p[0].value)))
    }),
    flmVisualDensity: DartEvalTypeGeneric<Type>(VisualDensity, fields: <String, DartEvalType>{
      'standard': DartEvalTypeVisualDensity(VisualDensity.standard),
      'compact': DartEvalTypeVisualDensity(VisualDensity.compact),
      'comfortable': DartEvalTypeVisualDensity(VisualDensity.comfortable),
      'minimumDensity': DartEvalTypeDouble(VisualDensity.minimumDensity),
      'maximumDensity': DartEvalTypeDouble(VisualDensity.maximumDensity),
      'adaptivePlatformDensity': DartEvalTypeVisualDensity(VisualDensity.adaptivePlatformDensity),
    }),
    'dart:ui;dart:ui/text.dart;TextDirection': DartEvalTypeEnum<TextDirection>(TextDirection,
        fields: <String, TextDirection>{'ltr': TextDirection.ltr, 'rtl': TextDirection.rtl},
        wrapper: (v) => DartEvalTypeTextDirection(v)),
    'package:iona_flutter/ui/components/action_bar.dart;package:iona_flutter/ui/components/action_bar.dart;_ActionBarState;openFile?':
        DartEvalTypeString('heyyy')
  };
}

DartEvalType _wrapWidget(DartSourceNode node, Widget widget, String path,
    {DartEvalType Function(Widget child) wrapper}) {
  final _wrapper = wrapper ?? _wrapDefault;
  if (widget is PreferredSizeWidget) {
    return DartEvalTypeEditorReportingWidget(
        EditorReportingPrefSizeWidget(node: node, child: widget, path: ConstructorPath.fromString(path)),
        proxy: _wrapper(widget));
  }
  return DartEvalTypeEditorReportingWidget(
      EditorReportingWidget<Widget>(node: node, child: widget, path: ConstructorPath.fromString(path)),
      proxy: _wrapper(widget));
}

DartEvalTypeWidget _wrapDefault(Widget w) => DartEvalTypeWidget(w);
