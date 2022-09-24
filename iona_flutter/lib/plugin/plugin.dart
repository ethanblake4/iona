import 'dart:async';

import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/cupertino.dart';
import 'package:iona_flutter/model/ide/ide_theme.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/model/ide/run_configs.dart';
import 'package:iona_flutter/model/ide/tasks.dart';
import 'package:iona_flutter/plugin/dart/dart_plugin.dart';

abstract class Plugin {
  static List<Plugin> allPlugins = [DartPlugin()];

  static Plugin byId(String id) => allPlugins.firstWhere((plugin) => plugin.id == id);

  String get id;

  String get name;

  String get shortDescription;

  FutureOr init();

  void onNewRootFolder(PluginInterface interface);

  void closeProject(PluginInterface interface);

  void launchProgram(PluginInterface interface, RunConfig config, RunTarget target, LaunchMode mode);
}

abstract class PluginBase implements Plugin {
  @override
  FutureOr init() {
    // Stub
  }

  @override
  void onNewRootFolder(PluginInterface interface) {
    // Stub
  }

  @override
  void closeProject(PluginInterface interface) {
    // Stub
  }

  @override
  void launchProgram(PluginInterface interface, RunConfig config, RunTarget target, LaunchMode mode) {
    // Stub
  }
}

class PluginInterface {
  PluginInterface(this._context);

  BuildContext _context;

  Tasks get tasks => Tasks.of(_context);

  IdeTheme get theme => IdeTheme.of(_context);

  RunConfigurations get runConfigurations => RunConfigurations.of(_context);

  Project get project => Project.of(_context);

  ResourceProvider get resourceProvider => PhysicalResourceProvider.INSTANCE;

  FileSystem get projectFilesystem => LocalFileSystem()..currentDirectory = project.rootFolder;
}

enum LaunchMode { RUN, DEBUG, WATCH, SERVE, HOT_RELOAD, ATTACH, ATTACH_DEBUG }
