// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_port.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DebugPort> _$debugPortSerializer = new _$DebugPortSerializer();

class _$DebugPortSerializer implements StructuredSerializer<DebugPort> {
  @override
  final Iterable<Type> types = const [DebugPort, _$DebugPort];
  @override
  final String wireName = 'DebugPort';

  @override
  Iterable<Object> serialize(Serializers serializers, DebugPort object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'appId',
      serializers.serialize(object.appId,
          specifiedType: const FullType(String)),
      'port',
      serializers.serialize(object.port, specifiedType: const FullType(int)),
      'wsUri',
      serializers.serialize(object.wsUri,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  DebugPort deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DebugPortBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'appId':
          result.appId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'port':
          result.port = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'wsUri':
          result.wsUri = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DebugPort extends DebugPort {
  @override
  final String appId;
  @override
  final int port;
  @override
  final String wsUri;

  factory _$DebugPort([void Function(DebugPortBuilder) updates]) =>
      (new DebugPortBuilder()..update(updates)).build();

  _$DebugPort._({this.appId, this.port, this.wsUri}) : super._() {
    BuiltValueNullFieldError.checkNotNull(appId, 'DebugPort', 'appId');
    BuiltValueNullFieldError.checkNotNull(port, 'DebugPort', 'port');
    BuiltValueNullFieldError.checkNotNull(wsUri, 'DebugPort', 'wsUri');
  }

  @override
  DebugPort rebuild(void Function(DebugPortBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DebugPortBuilder toBuilder() => new DebugPortBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DebugPort &&
        appId == other.appId &&
        port == other.port &&
        wsUri == other.wsUri;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, appId.hashCode), port.hashCode), wsUri.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DebugPort')
          ..add('appId', appId)
          ..add('port', port)
          ..add('wsUri', wsUri))
        .toString();
  }
}

class DebugPortBuilder implements Builder<DebugPort, DebugPortBuilder> {
  _$DebugPort _$v;

  String _appId;
  String get appId => _$this._appId;
  set appId(String appId) => _$this._appId = appId;

  int _port;
  int get port => _$this._port;
  set port(int port) => _$this._port = port;

  String _wsUri;
  String get wsUri => _$this._wsUri;
  set wsUri(String wsUri) => _$this._wsUri = wsUri;

  DebugPortBuilder();

  DebugPortBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _appId = $v.appId;
      _port = $v.port;
      _wsUri = $v.wsUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DebugPort other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DebugPort;
  }

  @override
  void update(void Function(DebugPortBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DebugPort build() {
    final _$result = _$v ??
        new _$DebugPort._(
            appId: BuiltValueNullFieldError.checkNotNull(
                appId, 'DebugPort', 'appId'),
            port: BuiltValueNullFieldError.checkNotNull(
                port, 'DebugPort', 'port'),
            wsUri: BuiltValueNullFieldError.checkNotNull(
                wsUri, 'DebugPort', 'wsUri'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
