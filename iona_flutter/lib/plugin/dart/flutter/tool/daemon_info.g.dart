// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daemon_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DaemonInfo> _$daemonInfoSerializer = new _$DaemonInfoSerializer();

class _$DaemonInfoSerializer implements StructuredSerializer<DaemonInfo> {
  @override
  final Iterable<Type> types = const [DaemonInfo, _$DaemonInfo];
  @override
  final String wireName = 'DaemonInfo';

  @override
  Iterable<Object> serialize(Serializers serializers, DaemonInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'version',
      serializers.serialize(object.version,
          specifiedType: const FullType(String)),
      'pid',
      serializers.serialize(object.pid, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  DaemonInfo deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DaemonInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'version':
          result.version = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'pid':
          result.pid = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$DaemonInfo extends DaemonInfo {
  @override
  final String version;
  @override
  final int pid;

  factory _$DaemonInfo([void Function(DaemonInfoBuilder) updates]) =>
      (new DaemonInfoBuilder()..update(updates)).build();

  _$DaemonInfo._({this.version, this.pid}) : super._() {
    BuiltValueNullFieldError.checkNotNull(version, 'DaemonInfo', 'version');
    BuiltValueNullFieldError.checkNotNull(pid, 'DaemonInfo', 'pid');
  }

  @override
  DaemonInfo rebuild(void Function(DaemonInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DaemonInfoBuilder toBuilder() => new DaemonInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DaemonInfo && version == other.version && pid == other.pid;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, version.hashCode), pid.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DaemonInfo')
          ..add('version', version)
          ..add('pid', pid))
        .toString();
  }
}

class DaemonInfoBuilder implements Builder<DaemonInfo, DaemonInfoBuilder> {
  _$DaemonInfo _$v;

  String _version;
  String get version => _$this._version;
  set version(String version) => _$this._version = version;

  int _pid;
  int get pid => _$this._pid;
  set pid(int pid) => _$this._pid = pid;

  DaemonInfoBuilder();

  DaemonInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _pid = $v.pid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DaemonInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DaemonInfo;
  }

  @override
  void update(void Function(DaemonInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DaemonInfo build() {
    final _$result = _$v ??
        new _$DaemonInfo._(
            version: BuiltValueNullFieldError.checkNotNull(
                version, 'DaemonInfo', 'version'),
            pid: BuiltValueNullFieldError.checkNotNull(
                pid, 'DaemonInfo', 'pid'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
