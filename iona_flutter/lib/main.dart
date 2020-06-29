import 'dart:io';

import 'package:devtools_app/devtools.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iona_flutter/model/ide/tasks.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis.dart';
import 'package:iona_flutter/plugin/dart/flutter_ui_editor.dart';
import 'package:iona_flutter/ui/components/action_bar.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/ide/ide_theme.dart';
import 'model/ide/project.dart';
import 'ui/components/output_area.dart';
import 'ui/components/project_browser.dart';
import 'ui/editor/editor.dart';
import 'util/menubar_manager.dart';

String claps = "no";

void main() {
  print(claps);
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  var dir = Directory('./Iona');
  if (!dir.existsSync()) {
    dir.createSync();
    File('./Iona/welcome.txt')
      ..createSync()
      ..writeAsStringSync('Welcome to Iona!\n\nTo get started, choose File > Open from the menu.\n');
  }

  runApp(IonaApp());
  DartAnalyzer();
}

/// The top level app
class IonaApp extends StatefulWidget {
  @override
  _IonaAppState createState() => _IonaAppState();
}

class _IonaAppState extends State<IonaApp> {
  final _projectModel = Project();
  final _themeModel = IdeTheme();
  final _tasksModel = Tasks();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: _projectModel,
        child: ScopedModel(
          model: _tasksModel,
          child: ScopedModel(
            model: _themeModel,
            child: ScopedModelDescendant<IdeTheme>(builder: (context, widget, model) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    colorScheme: ColorScheme.dark(surface: Colors.blueGrey, background: Colors.blueGrey),
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: Color(0xFF37434F),
                    primarySwatch: Colors.blue,
                    iconTheme: IconThemeData(color: IdeTheme.of(context).text.col),
                    fontFamily: 'Roboto',
                    textTheme: TextTheme(
                      bodyText2: TextStyle(color: IdeTheme.of(context).text.col, fontSize: 12.0),
                      bodyText1: TextStyle(color: IdeTheme.of(context).textActive.col, fontSize: 12.0),
                    )),
                builder: (context, child) => Notifications(
                  child: child,
                ),
                home: IonaHome(title: 'Iona'),
                shortcuts: const {
                  /* ...WidgetsApp.defaultShortcuts */
                },
              );
            }),
          ),
        ));
  }
}

/// The base widget of the app UI
class IonaHome extends StatefulWidget {
  /// Create with title
  IonaHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IonaHomeState createState() => _IonaHomeState();
}

class _IonaHomeState extends State<IonaHome> {
  double browserExtentX = 280.0;
  double termExtentY = 256.0;

  @override
  void initState() {
    super.initState();
    _setupBaseMenus();
    if (Project.of(context).openFiles.isEmpty) {
      Project.of(context).rootFolder = './Iona';
      Project.of(context).openFile('./Iona/welcome.txt');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(children: [
          ActionBar(),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: constraints.maxHeight - termExtentY - 26),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ProjectBrowser(),
                Expanded(
                  child: ConstrainedBox(
                    child: Editor(),
                    constraints: BoxConstraints.tightFor(height: constraints.maxHeight - termExtentY - 26),
                  ),
                ),
                FlutterUiEditor(),
              ],
            ),
          ),
          Expanded(child: OutputArea())
        ]);
      },
    );
  }

  void _setupBaseMenus() {
    final opKey = Platform.isWindows ? LogicalKeyboardKey.control : LogicalKeyboardKey.meta;
    MenuBarManager()
      ..setItem(
          MenuCategory.file,
          'open',
          MenuActionOrSubmenu('new_project', 'New Project', action: () {
            file_chooser
                .showOpenPanel(canSelectDirectories: true, allowedFileTypes: [], confirmButtonText: 'Open')
                .then((res) {
              print(res.paths);
            });
          }, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN)))
      ..setItem(
          MenuCategory.edit,
          'analyze',
          MenuActionOrSubmenu('analyze', 'Analyze', action: () {
            DartAnalyzer().flutterFileInfo('${Project.of(context).rootFolder}/lib/main.dart').then(print);
          }, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyP)))
      ..setItem(
          MenuCategory.file,
          'open',
          MenuActionOrSubmenu('open', 'Open', action: () {
            file_chooser
                .showOpenPanel(canSelectDirectories: true, allowedFileTypes: [], confirmButtonText: 'Open')
                .then((res) {
              if (!res.canceled && res.paths.isNotEmpty) Project.of(context).rootFolder = res.paths.first;
              if (DartAnalyzer().maybeAnalyzeRootFolder(context, res.paths.first)) ;
            });
          }, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyO)))
      ..setItem(
          MenuCategory.file,
          'save',
          MenuActionOrSubmenu('save', 'Save',
              action: () {}, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyS), enabled: false))
      ..setItem(
          MenuCategory.edit,
          'undo',
          MenuActionOrSubmenu('undo', 'Undo',
              enabled: false, action: () {}, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyZ)))
      ..setItem(
          MenuCategory.edit,
          'undo',
          MenuActionOrSubmenu('redo', 'Redo',
              action: () {},
              enabled: false,
              shortcut: LogicalKeySet(LogicalKeyboardKey.shift, opKey, LogicalKeyboardKey.keyZ)))
      ..setItem(
          MenuCategory.edit,
          'clipboard',
          MenuActionOrSubmenu('cut', 'Cut',
              enabled: false, action: () {}, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyX)))
      ..setItem(
          MenuCategory.edit,
          'clipboard',
          MenuActionOrSubmenu('copy', 'Copy',
              enabled: false, action: () {}, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyC)))
      ..setItem(
          MenuCategory.edit,
          'clipboard',
          MenuActionOrSubmenu('paste', 'Paste',
              enabled: false, action: () {}, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyV)))
      ..setItem(
          MenuCategory.edit,
          'find',
          MenuActionOrSubmenu('find', 'Find',
              enabled: false, action: () {}, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyF)))
      ..setItem(
          MenuCategory.edit,
          'find',
          MenuActionOrSubmenu('replace', 'Replace',
              action: () {}, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyR)))
      ..publish();
  }
}
