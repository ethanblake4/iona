import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iona_flutter/model/event/global_events.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/model/ide/run_configs.dart';
import 'package:iona_flutter/ui/design/custom_iconbutton.dart';
import 'package:iona_flutter/ui/design/desktop_dropdown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:window_size/window_size.dart';

import 'license_dialog.dart' as ld;

class ActionBar extends StatefulWidget {
  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  StreamSubscription _fileActiveSubscription;
  String openFile = '';
  var pointerId = 0;
  var tapState = 0;
  Rect savedRect;

  @override
  void initState() {
    super.initState();
    _fileActiveSubscription = eventBus.on<EditorFileActiveEvent>().listen((event) {
      final root = Project.of(context).rootFolder;
      print(root);
      setState(() {
        openFile = event.file.startsWith(root) ? event.file.substring(root.length) : event.file;
      });
    });
    getWindowInfo().then((value) => savedRect = value.frame);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (tapState == 1) {
            final size = await getWindowMaxSize();
            final win = await getWindowInfo();
            final screen = win.screen;
            if (savedRect != null && win.frame.width == screen.visibleFrame.width) {
              setWindowFrame(savedRect);
            } else {
              savedRect = win.frame;
              setWindowFrame(Rect.fromLTWH(0, 0, screen.visibleFrame.width, size.height));
            }
            tapState = 0;
          } else {
            tapState = 1;
            await Future.delayed(Duration(milliseconds: 400));
            tapState = 0;
          }
        },
        child: Material(
          color: Colors.blueGrey[900],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: ScopedModelDescendant<RunConfigurations>(builder: (context, child, configs) {
                  return Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3, left: 80),
                        child: Text(openFile),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: DesktopDropdownButton<RunTarget>(
                            dropdownColor: Colors.blueGrey[900],
                            itemHeight: 36.0,
                            isDense: false,
                            style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[100]),
                            items: (configs.targets.isEmpty ? [RunTarget.none] : configs.targets.values)
                                .map((RunTarget target) {
                              return DesktopDropdownMenuItem<RunTarget>(
                                value: target,
                                child: Row(
                                  children: [
                                    Padding(
                                      child: target.icon,
                                      padding: EdgeInsets.only(right: 4),
                                    ),
                                    Text(target.name)
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newTarget) {
                              setState(() {
                                RunConfigurations.of(context).activeRunTarget = newTarget;
                              });
                            },
                            value: configs.targets.isEmpty ? RunTarget.none : configs.activeRunTarget //selectedWidget,
                            ),
                      ),
                      CustomIconButton(
                        //visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        icon: Icon(
                          Icons.play_arrow,
                          color: configs.activeRunTarget != RunTarget.none
                              ? Colors.lightGreenAccent[200]
                              : Colors.grey[500],
                        ),
                        onPressed: () {},
                        iconSize: 24,
                      ),
                      CustomIconButton(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        icon: Icon(
                          Icons.bug_report,
                          color: configs.activeRunTarget != RunTarget.none ? Colors.red[300] : Colors.grey[500],
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                      CustomIconButton(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        icon: Icon(
                          Icons.settings,
                          color: Colors.grey[100],
                          size: 20,
                        ),
                        onPressed: () {
                          print('qqqq');
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return Dialog(
                                    child: ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(900, 700)),
                                  child: ld.LicensePage(
                                    applicationName: 'Iona',
                                    applicationVersion: '0.0.1',
                                    applicationLegalese: '\u00a9 2020 Ethan Elshyeb',
                                  ),
                                ));
                              });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _fileActiveSubscription.cancel();
  }
}

extension on double {
  bool isCloseTo(double other) => this + 0.001 > other + 0.001 && this - 0.001 < other - 0.001;
}

extension on Offset {
  bool isCloseTo(Offset other) => dx.isCloseTo(other.dx) && dy.isCloseTo(other.dy);
}
