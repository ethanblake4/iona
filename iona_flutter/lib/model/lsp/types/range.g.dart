// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Range> _$rangeSerializer = new _$RangeSerializer();

class _$RangeSerializer implements StructuredSerializer<Range> {
  @override
  final Iterable<Type> types = const [Range, _$Range];
  @override
  final String wireName = 'Range';

  @override
  Iterable serialize(Serializers serializers, Range object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'start',
      serializers.serialize(object.start,
          specifiedType: const FullType(Position)),
      'end',
      serializers.serialize(object.end,
          specifiedType: const FullType(Position)),
    ];

    return result;
  }

  @override
  Range deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RangeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'start':
          result.start.replace(serializers.deserialize(value,
              specifiedType: const FullType(Position)) as Position);
          break;
        case 'end':
          result.end.replace(serializers.deserialize(value,
              specifiedType: const FullType(Position)) as Position);
          break;
      }
    }

    return result.build();
  }
}

class _$Range extends Range {
  @override
  final Position start;
  @override
  final Position end;

  factory _$Range([void Function(RangeBuilder) updates]) =>
      (new RangeBuilder()..update(updates)).build();

  _$Range._({this.start, this.end}) : super._() {
    if (start == null) {
      throw new BuiltValueNullFieldError('Range', 'start');
    }
    if (end == null) {
      throw new BuiltValueNullFieldError('Range', 'end');
    }
  }

  @override
  Range rebuild(void Function(RangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RangeBuilder toBuilder() => new RangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Range && start == other.start && end == other.end;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, start.hashCode), end.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Range')
          ..add('start', start)
          ..add('end', end))
        .toString();
  }
}

class RangeBuilder implements Builder<Range, RangeBuilder> {
  _$Range _$v;

  PositionBuilder _start;
  PositionBuilder get start => _$this._start ??= new PositionBuilder();
  set start(PositionBuilder start) => _$this._start = start;

  PositionBuilder _end;
  PositionBuilder get end => _$this._end ??= new PositionBuilder();
  set end(PositionBuilder end) => _$this._end = end;

  RangeBuilder();

  RangeBuilder get _$this {
    if (_$v != null) {
      _start = _$v.start?.toBuilder();
      _end = _$v.end?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Range other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Range;
  }

  @override
  void update(void Function(RangeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Range build() {
    _$Range _$result;
    try {
      _$result = _$v ?? new _$Range._(start: start.build(), end: end.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'start';
        start.build();
        _$failedField = 'end';
        end.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Range', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
