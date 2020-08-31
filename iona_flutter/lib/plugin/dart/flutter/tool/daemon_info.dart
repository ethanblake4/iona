import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daemon_info.g.dart';

abstract class DaemonInfo implements Built<DaemonInfo, DaemonInfoBuilder> {
  static Serializer<DaemonInfo> get serializer => _$daemonInfoSerializer;

  DaemonInfo._();

  String get version;
  int get pid;

  factory DaemonInfo([updates(DaemonInfoBuilder b)]) = _$DaemonInfo;
}
