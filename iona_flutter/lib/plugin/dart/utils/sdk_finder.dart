import 'dart:io';

import 'package:iona_flutter/util/file_utils.dart';
import 'package:iona_flutter/util/io/env.dart';
import 'package:iona_flutter/util/io/is.dart';
import 'package:iona_flutter/util/io/which.dart';
import 'package:path/path.dart';

String findDartSdk(String /*?*/ fuchsiaRoot, String _binSuffix) {
  final sdkPlatformName = Platform.isWindows
      ? 'win'
      : (Platform.isMacOS
          ? 'mac'
          : exists('/dev/.cros_milestone')
              ? 'chromeos'
              : 'linux');

  var exePath = which('dart').path;

  if (exePath == null && fuchsiaRoot != null) {
    final searchPaths = [
      join(fuchsiaRoot, 'topaz/tools/prebuilt-dart-sdk', '$sdkPlatformName-x64'),
      join(fuchsiaRoot, 'third_party/dart/tools/sdks/dart-sdk'),
      join(fuchsiaRoot, 'third_party/dart/tools/sdks', sdkPlatformName, 'dart-sdk'),
      join(fuchsiaRoot, 'dart/tools/sdks', sdkPlatformName, 'dart-sdk')
    ];

    try {
      exePath = searchPaths.firstWhere((path) => isFile(join(path, 'dart$_binSuffix')));
    } on StateError catch (_) {
      // ignore
    }
  }

  if (exePath == null) {
    return null;
  }

  return dirname(dirname(exePath));
}

String findFlutterSdk(String /*?*/ fuchsiaRoot, String _binSuffix) {
  var exePath = which('flutter').path;

  if (exePath == null) {
    final searchPaths = [
      if (fuchsiaRoot != null) ...[
        join(fuchsiaRoot, 'lib', 'flutter'),
        join(fuchsiaRoot, 'third_party', 'dart-pkg', 'git', 'flutter')
      ],
      env['FLUTTER_ROOT'],
      if (Platform.isLinux) '~/snap/flutter/common/flutter',
      "~/flutter-sdk",
      "~/.flutter-sdk",
    ];

    try {
      exePath = searchPaths.firstWhere((path) => isFile(join(path, 'bin', 'flutter$_binSuffix')));
    } on StateError catch (_) {
      // ignore
    }
  }

  if (exePath == null) {
    return null;
  }

  return dirname(dirname(exePath));
}

String findFuchsiaRoot(String projectDir) => findRootContainingSync(projectDir, '.jiri_root');
