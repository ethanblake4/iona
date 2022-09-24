import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'config_option.g.dart';

/// A value class that describes a configuration option.
abstract class ConfigOption<T> implements Built<ConfigOption<T>, ConfigOptionBuilder<T>> {
  static Serializer<ConfigOption> get serializer => _$configOptionSerializer;

  ConfigOption._();

  String get scope;

  String get id;

  String get configKey => "$scope.$id";

  T get value;

  factory ConfigOption([updates(ConfigOptionBuilder<T> b)]) = _$ConfigOption<T>;
}
