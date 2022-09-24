// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Position> _$positionSerializer = new _$PositionSerializer();

class _$PositionSerializer implements StructuredSerializer<Position> {
  @override
  final Iterable<Type> types = const [Position, _$Position];
  @override
  final String wireName = 'Position';

  @override
  Iterable<Object> serialize(Serializers serializers, Position object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'line',
      serializers.serialize(object.line, specifiedType: const FullType(int)),
      'character',
      serializers.serialize(object.character,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  Position deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PositionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'line':
          result.line = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'character':
          result.character = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Position extends Position {
  @override
  final int line;
  @override
  final int character;

  factory _$Position([void Function(PositionBuilder) updates]) =>
      (new PositionBuilder()..update(updates)).build();

  _$Position._({this.line, this.character}) : super._() {
    BuiltValueNullFieldError.checkNotNull(line, 'Position', 'line');
    BuiltValueNullFieldError.checkNotNull(character, 'Position', 'character');
  }

  @override
  Position rebuild(void Function(PositionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PositionBuilder toBuilder() => new PositionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Position &&
        line == other.line &&
        character == other.character;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, line.hashCode), character.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Position')
          ..add('line', line)
          ..add('character', character))
        .toString();
  }
}

class PositionBuilder implements Builder<Position, PositionBuilder> {
  _$Position _$v;

  int _line;
  int get line => _$this._line;
  set line(int line) => _$this._line = line;

  int _character;
  int get character => _$this._character;
  set character(int character) => _$this._character = character;

  PositionBuilder();

  PositionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _line = $v.line;
      _character = $v.character;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Position other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Position;
  }

  @override
  void update(void Function(PositionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Position build() {
    final _$result = _$v ??
        new _$Position._(
            line:
                BuiltValueNullFieldError.checkNotNull(line, 'Position', 'line'),
            character: BuiltValueNullFieldError.checkNotNull(
                character, 'Position', 'character'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
