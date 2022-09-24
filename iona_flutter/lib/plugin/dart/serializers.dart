library dart_serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:iona_flutter/plugin/dart/flutter/tool/daemon_info.dart';
import 'package:iona_flutter/plugin/dart/flutter/tool/debug_port.dart';
import 'package:iona_flutter/plugin/dart/flutter/tool/flutter_device.dart';

part 'serializers.g.dart';

@SerializersFor(const [FlutterDevice, DaemonInfo, DebugPort])
final Serializers dartSerializers = _$dartSerializers;
final standardDartSerializers =
    (dartSerializers.toBuilder()..addPlugin(new StandardJsonPlugin())).build();
