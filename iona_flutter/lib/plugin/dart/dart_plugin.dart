import 'package:devtools_app/devtools.dart' as devtools;
import 'package:flutter/material.dart';
import 'package:iona_flutter/model/ide/run_configs.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis.dart';
import 'package:iona_flutter/plugin/dart/flutter/tool/flutter_tool.dart';
import 'package:iona_flutter/plugin/dart/platform.dart';
import 'package:pubspec/pubspec.dart';

import '../plugin.dart';
import 'model/dart_project.dart';

class DartPlugin extends PluginBase {
  @override
  String get id => 'iona.lang.dart';

  @override
  String get name => 'Dart';

  @override
  String get shortDescription => 'Provides support for the Dart language and Flutter framework.';

  DartProject _project;
  DartPlatformConfig _platformConfig;
  FlutterTool currentFlutterTool;

  void init() {}

  @override
  void onNewRootFolder(PluginInterface interface) async {
    if (currentFlutterTool != null) {
      currentFlutterTool.close();
    }

    final pubSpecFile = interface.projectFilesystem.file('pubspec.yaml');

    if (!pubSpecFile.existsSync()) {
      return;
    }

    _project = DartProject(PubSpec.fromYamlString(pubSpecFile.readAsStringSync()));

    _platformConfig = DartPlatformConfig(interface.project.rootFolder, _project.isFlutterProject);

    print('Dart SDK at ${_platformConfig.dartSdkRoot}');

    if (DartAnalyzer().analyzeRootFolder(interface, _platformConfig.dartSdkRoot)) {
      if (_project.isFlutterProject) {
        currentFlutterTool =
            await FlutterTool.getInstance(interface.project.rootFolder, path: _platformConfig.flutterBinaryPath);

        currentFlutterTool.onDeviceAddedListener = (device) {
          interface.runConfigurations.addTarget(RunTarget(device.id,
              '${device.name} (${device.platformType ?? device.platform})', _platformTypeIcon(device.platformType)));
        };

        if (interface.projectFilesystem.directory('lib').childFile('main.dart').existsSync()) {
          interface.runConfigurations.addConfig(RunConfig(this.id, 'lib/main.dart', 'flutter', props: {}));
        }
        ;
      }
    }
  }

  @override
  void launchProgram(PluginInterface interface, RunConfig config, RunTarget target, LaunchMode mode) async {
    if (config.type == 'flutter') {
      final runTool = await FlutterTool.create(
          path: _platformConfig.flutterBinaryPath,
          workingDirectory: interface.project.rootFolder,
          deviceId: target.id,
          startMode: FlutterToolStartMode.run);

      runTool.debugPortListener = (debugPort) {
        devtools.frameworkController.notifyConnectToVmEvent(Uri.parse(debugPort.wsUri), notify: true);
      };
    }
  }

  static Widget _platformTypeIcon(String platformType) {
    switch (platformType) {
      case 'web':
        return Icon(Icons.language, size: 18);
        break;
      case 'macos':
      case 'windows':
      case 'linux':
        return Icon(Icons.computer, size: 18);
        break;
      default:
        return Icon(Icons.phone_android, size: 18);
    }
  }
}
