import 'dart:math';

import 'package:devtools_app/devtools.dart' as dt;
import 'package:flutter/material.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/model/ide/tasks.dart';
import 'package:iona_flutter/ui/components/devtools.dart';
import 'package:iona_flutter/ui/components/terminal.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:iona_flutter/util/strings/detect_indents.dart';
import 'package:scoped_model/scoped_model.dart';

/// The bottom of the screen area
class OutputArea extends StatefulWidget {
  @override
  _OutputAreaState createState() => _OutputAreaState();
}

class _OutputAreaState extends State<OutputArea> {
  int tab = 0;
  dt.PreferencesController prefs;
  var height = 230.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      final dtIdeTheme = dt.IdeTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          embed: true);

      dt.initDevTools(dtIdeTheme).then((_p) {
        setState(() {
          prefs = _p;
        });
      });
    }

    final displayedW = tab == -1
        ? null
        : (tab == 0
            ? Terminal(
                active: true,
                height: height,
                constraintsCallback: (delta) {
                  setState(() {
                    height -= delta.dy;
                    height = max(height, 190.0);
                  });
                },
                onCollapse: () {
                  setState(() {
                    tab = -1;
                  });
                },
              )
            : (tab == 1
                ? InlineWindow(
                    constraints: BoxConstraints.tightFor(height: height),
                    child: Container(
                      color: Colors.blueGrey[800],
                    ),
                    header: Text('Dart Analysis'),
                    resizeTop: true,
                    constraintsCallback: (delta) {
                      setState(() {
                        height -= delta.dy;
                        height = max(height, 190.0);
                      });
                    },
                    onCollapse: () {
                      setState(() {
                        tab = -1;
                      });
                    },
                  )
                : Devtools(
                    height: height,
                    constraintsCallback: (delta) {
                      setState(() {
                        height -= delta.dy;
                        height = max(height, 190.0);
                      });
                    },
                    onCollapse: () {
                      setState(() {
                        tab = -1;
                      });
                    },
                  )));

    final tabBar = Row(children: [
      Expanded(
        child: Material(
          color: Colors.blueGrey[900],
          child: ScopedModelDescendant<Project>(builder: (_, __, project) {
            return ScopedModelDescendant<Tasks>(
              builder: (ctx, _, model) => Row(
                children: [
                  OutputTab(
                      selected: tab == 0,
                      name: 'Terminal',
                      icon: Icons.code,
                      onTap: () {
                        setState(() {
                          if (tab == 0)
                            tab = -1;
                          else
                            tab = 0;
                        });
                      }),
                  OutputTab(
                      selected: tab == 1,
                      name: 'Dart Analysis',
                      icon: Icons.outlined_flag,
                      onTap: () {
                        setState(() {
                          if (tab == 1)
                            tab = -1;
                          else
                            tab = 1;
                        });
                      }),
                  OutputTab(
                      selected: tab == 2,
                      name: 'Dart DevTools',
                      icon: Icons.pie_chart,
                      onTap: () {
                        setState(() {
                          if (tab == 2)
                            tab = -1;
                          else
                            tab = 2;
                        });
                      }),
                  Expanded(
                    child: Container(),
                  ),
                  if (project.activeProjectFile != null)
                    Text((project.activeProjectFile.lineTerminatorFormat ==
                                LineTerminatorFormat.CRLF
                            ? 'CRLF'
                            : 'LF') +
                        '   ' +
                        (project.activeProjectFile.indentData.type ==
                                IndentType.TABS
                            ? 'Tabs'
                            : '${project.activeProjectFile.indentData.amount} spaces')),
                  if (model.isRunning('dart', 'analyze')) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(height: 12.0, width: 12.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                    Text('Running Dart analysis...')
                  ],
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                  )
                ],
              ),
            );
          }),
        ),
      )
    ]);

    if (tab == -1) {
      return tabBar;
    }
    return Column(
      children: [displayedW, tabBar],
    );
    //return Container(color: Color(0xFF47586B));
  }
}

class OutputTab extends StatelessWidget {
  const OutputTab({
    Key key,
    @required this.selected,
    @required this.name,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);

  final bool selected;
  final String name;
  final IconData icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.blueGrey[300] : Colors.blueGrey[900],
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.blueGrey[900] : null,
              ),
              Text('  $name',
                  style:
                      selected ? TextStyle(color: Colors.blueGrey[900]) : null),
            ],
          ),
        ),
      ),
    );
  }
}
