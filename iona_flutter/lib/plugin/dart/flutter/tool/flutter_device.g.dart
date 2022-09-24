// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_device.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FlutterDevice> _$flutterDeviceSerializer =
    new _$FlutterDeviceSerializer();

class _$FlutterDeviceSerializer implements StructuredSerializer<FlutterDevice> {
  @override
  final Iterable<Type> types = const [FlutterDevice, _$FlutterDevice];
  @override
  final String wireName = 'FlutterDevice';

  @override
  Iterable<Object> serialize(Serializers serializers, FlutterDevice object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'platform',
      serializers.serialize(object.platform,
          specifiedType: const FullType(String)),
      'emulator',
      serializers.serialize(object.emulator,
          specifiedType: const FullType(bool)),
    ];
    Object value;
    value = object.category;
    if (value != null) {
      result
        ..add('category')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.platformType;
    if (value != null) {
      result
        ..add('platformType')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.ephemeral;
    if (value != null) {
      result
        ..add('ephemeral')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.emulatorId;
    if (value != null) {
      result
        ..add('emulatorId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  FlutterDevice deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FlutterDeviceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'platform':
          result.platform = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'emulator':
          result.emulator = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'platformType':
          result.platformType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'ephemeral':
          result.ephemeral = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'emulatorId':
          result.emulatorId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$FlutterDevice extends FlutterDevice {
  @override
  final String id;
  @override
  final String name;
  @override
  final String platform;
  @override
  final bool emulator;
  @override
  final String category;
  @override
  final String platformType;
  @override
  final bool ephemeral;
  @override
  final String emulatorId;

  factory _$FlutterDevice([void Function(FlutterDeviceBuilder) updates]) =>
      (new FlutterDeviceBuilder()..update(updates)).build();

  _$FlutterDevice._(
      {this.id,
      this.name,
      this.platform,
      this.emulator,
      this.category,
      this.platformType,
      this.ephemeral,
      this.emulatorId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'FlutterDevice', 'id');
    BuiltValueNullFieldError.checkNotNull(name, 'FlutterDevice', 'name');
    BuiltValueNullFieldError.checkNotNull(
        platform, 'FlutterDevice', 'platform');
    BuiltValueNullFieldError.checkNotNull(
        emulator, 'FlutterDevice', 'emulator');
  }

  @override
  FlutterDevice rebuild(void Function(FlutterDeviceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FlutterDeviceBuilder toBuilder() => new FlutterDeviceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FlutterDevice &&
        id == other.id &&
        name == other.name &&
        platform == other.platform &&
        emulator == other.emulator &&
        category == other.category &&
        platformType == other.platformType &&
        ephemeral == other.ephemeral &&
        emulatorId == other.emulatorId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, id.hashCode), name.hashCode),
                            platform.hashCode),
                        emulator.hashCode),
                    category.hashCode),
                platformType.hashCode),
            ephemeral.hashCode),
        emulatorId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FlutterDevice')
          ..add('id', id)
          ..add('name', name)
          ..add('platform', platform)
          ..add('emulator', emulator)
          ..add('category', category)
          ..add('platformType', platformType)
          ..add('ephemeral', ephemeral)
          ..add('emulatorId', emulatorId))
        .toString();
  }
}

class FlutterDeviceBuilder
    implements Builder<FlutterDevice, FlutterDeviceBuilder> {
  _$FlutterDevice _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _platform;
  String get platform => _$this._platform;
  set platform(String platform) => _$this._platform = platform;

  bool _emulator;
  bool get emulator => _$this._emulator;
  set emulator(bool emulator) => _$this._emulator = emulator;

  String _category;
  String get category => _$this._category;
  set category(String category) => _$this._category = category;

  String _platformType;
  String get platformType => _$this._platformType;
  set platformType(String platformType) => _$this._platformType = platformType;

  bool _ephemeral;
  bool get ephemeral => _$this._ephemeral;
  set ephemeral(bool ephemeral) => _$this._ephemeral = ephemeral;

  String _emulatorId;
  String get emulatorId => _$this._emulatorId;
  set emulatorId(String emulatorId) => _$this._emulatorId = emulatorId;

  FlutterDeviceBuilder();

  FlutterDeviceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _platform = $v.platform;
      _emulator = $v.emulator;
      _category = $v.category;
      _platformType = $v.platformType;
      _ephemeral = $v.ephemeral;
      _emulatorId = $v.emulatorId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FlutterDevice other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FlutterDevice;
  }

  @override
  void update(void Function(FlutterDeviceBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FlutterDevice build() {
    final _$result = _$v ??
        new _$FlutterDevice._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, 'FlutterDevice', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'FlutterDevice', 'name'),
            platform: BuiltValueNullFieldError.checkNotNull(
                platform, 'FlutterDevice', 'platform'),
            emulator: BuiltValueNullFieldError.checkNotNull(
                emulator, 'FlutterDevice', 'emulator'),
            category: category,
            platformType: platformType,
            ephemeral: ephemeral,
            emulatorId: emulatorId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
