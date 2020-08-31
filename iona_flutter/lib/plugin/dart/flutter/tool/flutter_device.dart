import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'flutter_device.g.dart';

abstract class FlutterDevice implements Built<FlutterDevice, FlutterDeviceBuilder> {
  static Serializer<FlutterDevice> get serializer => _$flutterDeviceSerializer;

  FlutterDevice._();

  /// ID of the device, e.g. 702ABC1F-5EA5-4F83-84AB-6380CA91D39A
  String get id;

  /// Name of the device, e.g. iPhone 6
  String get name;

  /// Platform of the device, e.g. ios_x64
  String get platform;

  /// Whether or not the device is available for use
  bool get emulator;

  @nullable
  String get category;

  @nullable
  String get platformType;

  @nullable
  bool get ephemeral;

  @nullable
  String get emulatorId;

  factory FlutterDevice([updates(FlutterDeviceBuilder b)]) = _$FlutterDevice;
}
