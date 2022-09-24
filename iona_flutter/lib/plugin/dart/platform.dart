import 'dart:io';

import 'package:iona_flutter/plugin/dart/utils/sdk_finder.dart';
import 'package:path/path.dart';

class DartPlatformConfig {
  DartPlatformConfig(String projectDir, this.isFlutter) {
    fuchsiaRoot = findFuchsiaRoot(projectDir);
    if (isFlutter) {
      flutterSdkRoot = findFlutterSdk(fuchsiaRoot, _binSuffix);
    } else {
      _dartSdkRoot = findDartSdk(fuchsiaRoot, _binSuffix);
    }
  }

  static get _binSuffix => Platform.isWindows ? '.bat' : '';

  bool isFlutter;

  String fuchsiaRoot;

  String flutterSdkRoot;
  String get flutterBinaryPath => join(flutterSdkRoot, 'bin', 'flutter$_binSuffix');

  String _dartSdkRoot;
  String get dartSdkRoot => isFlutter ? join(flutterSdkRoot, 'bin', 'cache', 'dart-sdk') : _dartSdkRoot;
  String get dartBinaryPath => join(dartSdkRoot, 'bin', 'dart$_binSuffix');
}
