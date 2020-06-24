import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iona_flutter/model/event/global_events.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/ui/ast_widget.dart';
import 'package:iona_flutter/ui/design/desktop_dropdown.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:scoped_model/scoped_model.dart';

class FlutterUiEditor extends StatefulWidget {
  @override
  _FlutterUiEditorState createState() => _FlutterUiEditorState();
}

class _FlutterUiEditorState extends State<FlutterUiEditor> {
  StreamSubscription _fileActiveSubscription;
  StreamSubscription _fileSaveSubscription;
  FlutterFileInfo fileInfo;
  String selectedWidget = '<no widgets>';

  @override
  void initState() {
    super.initState();
    _fileActiveSubscription = eventBus.on<EditorFileActiveEvent>().listen((event) {
      maybeReanalyze(event.file, true);
    });
    _fileSaveSubscription = eventBus.on<SaveFile>().listen((event) {
      maybeReanalyze(event.file, false);
    });
  }

  void maybeReanalyze(String file, bool changeActive) {
    if (DartAnalyzer().currentRootFolder == Project.of(context).rootFolder && file.endsWith('.dart')) {
      DartAnalyzer().flutterFileInfo(file).then((_fileInfo) {
        setState(() {
          if (_fileInfo.widgets.length > 0) {
            fileInfo = _fileInfo;
            if (changeActive || _fileInfo.widgets.firstWhere((element) => element.name == selectedWidget) == null) {
              selectedWidget = _fileInfo.widgets.first.name;
            }
          } else {
            fileInfo = null;
            selectedWidget = '<no widgets>';
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Project>(builder: (context, child, model) {
      return InlineWindow(
        constraints: BoxConstraints.tightFor(width: 400),
        header: Text('Flutter UI Editor'),
        child: Theme(
          data: ThemeData(
              textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.black87, fontSize: 12.0, inherit: false),
            bodyText1: TextStyle(color: Colors.black87, fontSize: 12.0, inherit: false),
          )),
          child: Material(
              color: Colors.blueGrey[300],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DesktopDropdownButton<String>(
                      underline: Container(
                        height: 1.0,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blueGrey[800],
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
                      dropdownColor: Colors.blueGrey[100],
                      itemHeight: 36.0,
                      isDense: false,
                      style: TextStyle(fontSize: 12.0, color: Colors.blueGrey[900]),
                      items: (fileInfo?.widgets?.map((w) => w.name) ?? ['<no widgets>']).map((String value) {
                        return DesktopDropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedWidget = newVal;
                        });
                      },
                      value: selectedWidget,
                    ),
                    Expanded(
                      child: Center(
                          child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(width: 200, height: 200),
                              child: Card(
                                child: AstWidget(
                                    fileInfo?.widgets?.firstWhere((element) => element.name == selectedWidget)),
                                elevation: 2.0,
                                shape: Border.all(color: Colors.blueGrey[600]),
                              ))),
                    ),
                  ],
                ),
              )),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _fileActiveSubscription.cancel();
    _fileSaveSubscription.cancel();
  }
}
