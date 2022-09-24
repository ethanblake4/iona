import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'debug_port.g.dart';

abstract class DebugPort implements Built<DebugPort, DebugPortBuilder> {
  static Serializer<DebugPort> get serializer => _$debugPortSerializer;

  DebugPort._();

  String get appId;
  int get port;
  String get wsUri;

  factory DebugPort([updates(DebugPortBuilder b)]) = _$DebugPort;
}
