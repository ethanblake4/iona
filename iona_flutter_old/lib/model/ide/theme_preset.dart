import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'theme_preset.g.dart';

abstract class ThemePreset implements Built<ThemePreset, ThemePresetBuilder> {
  ThemePreset._();

  static ThemePreset get DEFAULT => new ThemePreset((builder) => builder
    ..projectBrowserBackground = '#37474F'
    ..textActive = '#eeffff'
    ..termBackground = '#47586B'
    ..windowHeader = '304050'
    ..windowHeaderActive = '405666'
    ..fileTreeSelectedFile = '455666'
    ..text = '#acbccf');

  String get projectBrowserBackground;

  String get termBackground;

  String get text;

  String get textActive;

  String get windowHeader;

  String get windowHeaderActive;

  String get fileTreeSelectedFile;

  static Serializer<ThemePreset> get serializer => _$themePresetSerializer;

  factory ThemePreset([updates(ThemePresetBuilder b)]) = _$ThemePreset;
}
