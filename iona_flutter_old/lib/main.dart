import 'dart:io';

import 'package:devtools_app/devtools.dart' as dt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iona_flutter/model/ide/run_configs.dart';
import 'package:iona_flutter/model/ide/tasks.dart';
import 'package:iona_flutter/ui/components/action_bar.dart';
import 'package:iona_flutter/ui/components/output_area.dart';
import 'package:iona_flutter/ui/components/project_browser.dart';
import 'package:iona_flutter/ui/editor/editor.dart';
import 'package:iona_flutter/util/base_menus.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/ide/ide_theme.dart';
import 'model/ide/project.dart';

void main() {
  var dir = Directory('./Iona');
  if (!dir.existsSync()) {
    dir.createSync();
    File('./Iona/welcome.txt')
      ..createSync()
      ..writeAsStringSync(
          'Welcome to Iona!\n\nTo get started, choose File > Open from the menu.\n');
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
  final _tasksModel = Tasks();
  final _runconfigsModel = RunConfigurations();

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
            model: _runconfigsModel,
            child: ScopedModel(
              model: _themeModel,
              child: ScopedModelDescendant<IdeTheme>(
                  builder: (context, widget, model) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      colorScheme: ColorScheme.dark(
                          surface: Colors.blueGrey,
                          background: Colors.blueGrey),
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Color(0xFF37434F),
                      primarySwatch: Colors.blue,
                      iconTheme:
                          IconThemeData(color: IdeTheme.of(context).text.col),
                      fontFamily: 'Roboto',
                      textButtonTheme: TextButtonThemeData(
                          style: ButtonStyle(
                              visualDensity:
                                  VisualDensity.adaptivePlatformDensity,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize:
                                  ButtonStyleButton.allOrNull(Size(0, 0)),
                              padding: ButtonStyleButton.allOrNull(
                                  EdgeInsets.all(2)),
                              textStyle: ButtonStyleButton.allOrNull(
                                  TextStyle(fontWeight: FontWeight.normal)),
                              foregroundColor:
                                  ButtonStyleButton.allOrNull(Colors.white))),
                      textTheme: TextTheme(
                        bodyText2: TextStyle(
                            color: IdeTheme.of(context).text.col,
                            fontSize: 12.0),
                        bodyText1: TextStyle(
                            color: IdeTheme.of(context).textActive.col,
                            fontSize: 12.0),
                      )),
                  builder: (context, child) => MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(viewPadding: EdgeInsets.only(top: 80)),
                      child: dt.Notifications(
                        child: child,
                      )),
                  home: IonaHome(title: 'Iona'),
                  shortcuts: {...WidgetsApp.defaultShortcuts},
                );
              }),
            ),
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

    setupBaseMenus(context);
    if (Project.of(context).openFiles.isEmpty) {
      Project.of(context).rootFolder = './Iona';
      Project.of(context).openFile('./Iona/welcome.txt');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(640, 480),
        orientation: Orientation.landscape);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(children: [
          ActionBar(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ProjectBrowser(),
                Expanded(
                  child: Editor(),
                ),
                //FlutterUiEditor(),
              ],
            ),
          ),
          OutputArea()
        ]);
      },
    );
  }
}
