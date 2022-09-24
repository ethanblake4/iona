// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ConfigOption<Object>> _$configOptionSerializer =
    new _$ConfigOptionSerializer();

class _$ConfigOptionSerializer
    implements StructuredSerializer<ConfigOption<Object>> {
  @override
  final Iterable<Type> types = const [ConfigOption, _$ConfigOption];
  @override
  final String wireName = 'ConfigOption';

  @override
  Iterable<Object> serialize(
      Serializers serializers, ConfigOption<Object> object,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = <Object>[
      'scope',
      serializers.serialize(object.scope,
          specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'value',
      serializers.serialize(object.value, specifiedType: parameterT),
    ];

    return result;
  }

  @override
  ConfigOption<Object> deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT =
        isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = isUnderspecified
        ? new ConfigOptionBuilder<Object>()
        : serializers.newBuilder(specifiedType) as ConfigOptionBuilder;

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'scope':
          result.scope = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'value':
          result.value =
              serializers.deserialize(value, specifiedType: parameterT);
          break;
      }
    }

    return result.build();
  }
}

class _$ConfigOption<T> extends ConfigOption<T> {
  @override
  final String scope;
  @override
  final String id;
  @override
  final T value;

  factory _$ConfigOption([void Function(ConfigOptionBuilder<T>) updates]) =>
      (new ConfigOptionBuilder<T>()..update(updates)).build();

  _$ConfigOption._({this.scope, this.id, this.value}) : super._() {
    if (scope == null) {
      throw new BuiltValueNullFieldError('ConfigOption', 'scope');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('ConfigOption', 'id');
    }
    if (value == null) {
      throw new BuiltValueNullFieldError('ConfigOption', 'value');
    }
    if (T == dynamic) {
      throw new BuiltValueMissingGenericsError('ConfigOption', 'T');
    }
  }

  @override
  ConfigOption<T> rebuild(void Function(ConfigOptionBuilder<T>) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConfigOptionBuilder<T> toBuilder() =>
      new ConfigOptionBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConfigOption &&
        scope == other.scope &&
        id == other.id &&
        value == other.value;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, scope.hashCode), id.hashCode), value.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ConfigOption')
          ..add('scope', scope)
          ..add('id', id)
          ..add('value', value))
        .toString();
  }
}

class ConfigOptionBuilder<T>
    implements Builder<ConfigOption<T>, ConfigOptionBuilder<T>> {
  _$ConfigOption<T> _$v;

  String _scope;
  String get scope => _$this._scope;
  set scope(String scope) => _$this._scope = scope;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  T _value;
  T get value => _$this._value;
  set value(T value) => _$this._value = value;

  ConfigOptionBuilder();

  ConfigOptionBuilder<T> get _$this {
    if (_$v != null) {
      _scope = _$v.scope;
      _id = _$v.id;
      _value = _$v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConfigOption<T> other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ConfigOption<T>;
  }

  @override
  void update(void Function(ConfigOptionBuilder<T>) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ConfigOption<T> build() {
    final _$result =
        _$v ?? new _$ConfigOption<T>._(scope: scope, id: id, value: value);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
