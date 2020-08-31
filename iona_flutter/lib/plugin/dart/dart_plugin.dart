import 'package:flutter/material.dart';
import 'package:iona_flutter/model/ide/run_configs.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis.dart';
import 'package:iona_flutter/plugin/dart/flutter/tool/flutter_tool.dart';

class DartPlugin {
  static void onNewRootFolder(BuildContext context, String path) async {
    DartAnalyzer().maybeAnalyzeRootFolder(context, path);
    final flutterTool = await FlutterTool.getInstance(path);
    flutterTool.onDeviceAddedListener = (device) {
      RunConfigurations.of(context).addTarget(RunTarget(device.id,
          '${device.name} (${device.platformType ?? device.platform})', _platformTypeIcon(device.platformType)));
    };
  }

  static Widget _platformTypeIcon(String platformType) {
    switch (platformType) {
      case 'web':
        return Icon(Icons.language, size: 18);
        break;
      case 'macos':
        return Icon(Icons.computer, size: 18);
        break;
      default:
        return Icon(Icons.phone_android, size: 18);
    }
  }
}
