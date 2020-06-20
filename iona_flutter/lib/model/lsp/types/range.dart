import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'position.dart';

part 'range.g.dart';

abstract class Range implements Built<Range, RangeBuilder> {
  static Serializer<Range> get serializer => _$rangeSerializer;

  Range._();

  Position get start;
  Position get end;

  factory Range([updates(RangeBuilder b)]) = _$Range;
}
