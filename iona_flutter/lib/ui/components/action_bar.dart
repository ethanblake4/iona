import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iona_flutter/model/event/global_events.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/ui/design/custom_iconbutton.dart';

class ActionBar extends StatefulWidget {
  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  StreamSubscription _fileActiveSubscription;
  String openFile = '';

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
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                  child: Text(openFile),
                ),
                Expanded(
                  child: Container(),
                ),
                CustomIconButton(
                  //visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.lightGreen[300],
                  ),
                  onPressed: () {},
                  iconSize: 24,
                ),
                CustomIconButton(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  icon: Icon(
                    Icons.bug_report,
                    color: Colors.redAccent[100],
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
                  onPressed: () {},
                ),
                Padding(
                  padding: EdgeInsets.only(right: 4),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _fileActiveSubscription.cancel();
  }
}
