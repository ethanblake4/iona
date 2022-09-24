import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'position.g.dart';

abstract class Position implements Built<Position, PositionBuilder> {
  static Serializer<Position> get serializer => _$positionSerializer;

  Position._();

  int get line;
  int get character;

  factory Position([updates(PositionBuilder b)]) = _$Position;
}
