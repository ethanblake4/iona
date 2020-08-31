import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'language_theme.dart';

EditorTheme testTheme = EditorTheme(
    backgroundColor: Colors.blueGrey,
    selectionColor: Colors.blueGrey[300],
    baseStyle: TextStyle(color: Colors.white, fontFamily: 'Hack', fontWeight: FontWeight.w400, fontFeatures: [
      FontFeature('liga'),
      FontFeature('clig'),
      FontFeature('dlig'),
      FontFeature('hlig'),
      FontFeature('rlig')
    ]),
    languageThemes: {
      'undef': LanguageTheme({'undef': Colors.white}),
      /*'dart': LanguageTheme({
        'string.single': Colors.lightGreenAccent[100],
        'string.double': Colors.lightGreenAccent[100],
        'string.multiline': Colors.lightGreenAccent[100],
        'operator': Colors.cyanAccent[100],
        'number': Colors.orange[200],
        'accessmod': Colors.amber,
        'keyword': Colors.pink[100],
        'paren': Colors.limeAccent[100],
        'type': Colors.yellow[100]
      }),*/
      'json': LanguageTheme({
        'source.json': Colors.white,
        'constant.language.json': Colors.pink[100],
        'constant.numeric.float.decimal.json': Colors.orange[200],
        'constant.numeric.integer.decimal.json': Colors.orangeAccent[200],
        'string.quoted.double.json': Colors.lightGreenAccent[100],
        'punctuation.definition.string': Colors.lightGreenAccent[100],
        'punctuation.section.sequence': Colors.limeAccent[100],
        'punctuation.section.mapping': Colors.limeAccent[100],
      }),
      'protobuf': LanguageTheme({
        'keyword.other': Colors.pink[100],
        'storage.modifier.proto': Colors.lightBlueAccent[100],
        'storage.type.annotation.proto': Colors.pink[100],
        'storage.type.message.proto': Colors.pink[100],
        'storage.modifier.oneof.proto': Colors.pink[100],
        'punctuation.definition.block': Colors.limeAccent[100],
        'punctuation.definition.string': Colors.lightGreenAccent[100],
        'string.quoted.double.proto': Colors.lightGreenAccent[100],
        'variable.other.field.proto': Colors.white,
        'variable.namespace.proto': Color(0xFFCCEEFF),
        'storage.type.proto variable.type.proto': Color(0xFFCCEEFF),
        'support.type.proto': Colors.lightBlueAccent[100],
        'constant.numeric.proto': Colors.deepOrange[200],
        'keyword.operator.assignment.proto': Colors.blueGrey[100],
        'entity.name': Color(0xFFCCEEFF),
      }),
      'sql': LanguageTheme({
        'keyword.other': Colors.pink[100],
        'storage.type.sql': Colors.lightBlueAccent[100],
        'constant.numeric.sql': Colors.deepOrange[200],
        'storage.modifier.sql': Color(0xFFCCEEFF),
        'constant.boolean.sql': Colors.purple[200],
        'keyword.operator.logical.sql': Colors.pink[100],
        'support.function.scalar.sql': Colors.lightBlueAccent[100],
        'punctuation.definition.string.backtick': Colors.yellow[100],
        'punctuation.definition.string': Colors.lightGreenAccent[100],
        'string.regexp.sql': Colors.lightGreenAccent[100],
        'string.quoted.single.sql': Colors.lightGreenAccent[100],
        'string.quoted.double.sql': Colors.lightGreenAccent[100],
        'entity.name.function.sql': Color(0xFFCCEEFF),
        'punctuation.section.scope': Colors.limeAccent[100],
        'variable.language.star.sql': Colors.lightBlueAccent[100],
        'string.quoted.other.backtick.sql': Colors.yellow[100],
        'constant.other': Colors.yellow[100],
        'keyword.operator.comparison.sql': Colors.orange[100]
      }),
      'dart': LanguageTheme({
        'keyword': Colors.pink[100],
        'string': Colors.lightGreenAccent[100],
        'constant': Colors.orange[200],
        'support': Colors.yellow[200],
        'entity': Color(0xFFAAE8FF),
        'storage': Colors.purple[100],
        'comment': Colors.blueGrey[100],
      }),
      'yaml': LanguageTheme({
        'keyword': Colors.pink[100],
        'string': Colors.lightGreenAccent[100],
        'constant': Colors.orange[200],
        'support': Colors.yellow[200],
        'entity': Color(0xFFAAE8FF),
        'storage': Colors.purple[100],
        'comment': Colors.blueGrey[100],
        'meta': Colors.orange[100],
        'punctuation': Colors.limeAccent[100]
      })
    });

class EditorTheme {
  EditorTheme(
      {this.backgroundColor, this.selectionColor, this.baseStyle, this.languageThemes, this.showLineNumbers = true});

  Color backgroundColor;
  Color selectionColor;
  TextStyle baseStyle;
  Map<String, LanguageTheme> languageThemes;
  bool showLineNumbers;
}
