import 'dart:io';

import 'package:file_chooser/file_chooser.dart' as file_chooser;
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/ide/ide_theme.dart';
import 'model/ide/project.dart';
import 'ui/components/output_area.dart';
import 'ui/components/project_browser.dart';
import 'ui/editor/editor.dart';
import 'util/menubar_manager.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  var dir = Directory('./Iona');
  if (!dir.existsSync()) {
    dir.createSync();
    File('./Iona/welcome.txt')
      ..createSync()
      ..writeAsStringSync('Welcome to Iona!\n\nTo get started, choose File > Open from the menu.\n');
  }
  runApp(IonaApp());
}

/// The top level app
class IonaApp extends StatefulWidget {
  @override
  _IonaAppState createState() => _IonaAppState();
}

class _IonaAppState extends State<IonaApp> {
  final _projectModel = Project();
  final _themeModel = IdeTheme();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: _projectModel,
        child: ScopedModel(
          model: _themeModel,
          child: ScopedModelDescendant<IdeTheme>(builder: (context, widget, model) {
            return MaterialApp(
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  iconTheme: IconThemeData(color: IdeTheme.of(context).text.col),
                  fontFamily: 'Roboto',
                  textTheme: TextTheme(
                    body1: TextStyle(color: IdeTheme.of(context).text.col, fontSize: 12.0),
                    body2: TextStyle(color: IdeTheme.of(context).textActive.col, fontSize: 12.0),
                  )),
              home: IonaHome(title: 'Iona'),
              shortcuts: const {/* ...WidgetsApp.defaultShortcuts */},
            );
          }),
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
  double termExtentY = 230.0;

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
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: constraints.maxHeight - termExtentY),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: browserExtentX),
                  child: ProjectBrowser(),
                ),
                Expanded(
                  child: ConstrainedBox(
                    child: Editor(),
                    constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: OutputArea())
        ]);
      },
    );
  }

  void _setupBaseMenus() {
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
          }, shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN)))
      ..setItem(
          MenuCategory.file,
          'open',
          MenuActionOrSubmenu('open', 'Open', action: () {
            file_chooser
                .showOpenPanel(canSelectDirectories: true, allowedFileTypes: [], confirmButtonText: 'Open')
                .then((res) {
              if (!res.canceled && res.paths.isNotEmpty) Project.of(context).rootFolder = res.paths.first;
            });
          }, shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyO)))
      ..setItem(
          MenuCategory.file,
          'save',
          MenuActionOrSubmenu('save', 'Save',
              action: () {}, shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS), enabled: false))
      ..setItem(
          MenuCategory.edit,
          'undo',
          MenuActionOrSubmenu('undo', 'Undo',
              enabled: false, action: () {}, shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ)))
      ..setItem(
          MenuCategory.edit,
          'undo',
          MenuActionOrSubmenu('redo', 'Redo',
              action: () {},
              enabled: false,
              shortcut: LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ)))
      ..setItem(
          MenuCategory.edit,
          'find',
          MenuActionOrSubmenu('find', 'Find',
              action: () {}, shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyF)))
      ..setItem(
          MenuCategory.edit,
          'find',
          MenuActionOrSubmenu('replace', 'Replace',
              action: () {}, shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyR)))
      ..publish();
  }
}
