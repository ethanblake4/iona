import 'package:devtools_app/devtools.dart';
import 'package:flutter/material.dart';
import 'package:iona_flutter/model/ide/tasks.dart';
import 'package:iona_flutter/ui/components/terminal.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:scoped_model/scoped_model.dart';

/// The bottom of the screen area
class OutputArea extends StatefulWidget {
  @override
  _OutputAreaState createState() => _OutputAreaState();
}

class _OutputAreaState extends State<OutputArea> {
  int tab = 0;
  PreferencesController prefs;

  @override
  void initState() {
    super.initState();
    initDevTools().then((_p) {
      setState(() {
        prefs = _p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedW = tab == 0
        ? Terminal(
            active: false,
          )
        : (tab == 1
            ? InlineWindow(
                constraints: BoxConstraints.tightFor(height: 230),
                child: Container(
                  color: Colors.blueGrey[800],
                ),
                header: Text('Dart Analysis'),
              )
            : (prefs != null
                ? InlineWindow(
                    constraints: BoxConstraints.tightFor(height: 230),
                    header: Text("Dart DevTools"),
                    child: DevToolsApp(defaultScreens, prefs, RouteSettings(name: '/')))
                : Container()));

    return Column(
      children: [
        displayedW,
        Row(children: [
          Expanded(
            child: Material(
              color: Colors.blueGrey[900],
              child: ScopedModelDescendant<Tasks>(
                builder: (ctx, _, model) => Row(
                  children: [
                    _buildTab(tab == 0, 'Terminal', Icons.code, () {
                      setState(() {
                        tab = 0;
                      });
                    }),
                    _buildTab(tab == 1, 'Dart Analysis', Icons.outlined_flag, () {
                      setState(() {
                        tab = 1;
                      });
                    }),
                    _buildTab(tab == 2, 'Dart DevTools', Icons.pie_chart, () {
                      setState(() {
                        tab = 2;
                      });
                    }),
                    Expanded(
                      child: Container(),
                    ),
                    if (model.isRunning('dart', 'analyze')) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(height: 12.0, width: 12.0),
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
              ),
            ),
          )
        ])
      ],
    );
    //return Container(color: Color(0xFF47586B));
  }

  Widget _buildTab(bool selected, String name, IconData icon, GestureTapCallback onTap) {
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
              Text('  $name', style: selected ? TextStyle(color: Colors.blueGrey[900]) : null),
            ],
          ),
        ),
      ),
    );
  }
}
