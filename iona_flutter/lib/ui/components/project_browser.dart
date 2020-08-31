import 'dart:io';
import 'dart:math';

import 'package:devtools_app/devtools.dart' as dt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iona_flutter/model/ide/ide_theme.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/ui/components/context_menu.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:time/time.dart';

/// A project browser showing files and such
class ProjectBrowser extends StatefulWidget {
  @override
  _ProjectBrowserState createState() => _ProjectBrowserState();
}

class _ProjectBrowserState extends State<ProjectBrowser> {
  String rootFolder = '';
  var _width = 280.0;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Project>(
      builder: (context, child, model) {
        if (model.rootFolder != rootFolder) {
          rootFolder = model.rootFolder;
        }
        return InlineWindow(
          resizeRight: true,
          constraints: BoxConstraints.tightFor(width: _width),
          header: Text('Project'),
          constraintsCallback: (delta) {
            setState(() {
              _width += delta.dx;
              _width = max(160, min(_width, 500));
            });
          },
          child: Material(
            color: IdeTheme.of(context).projectBrowserBackground.col,
            child: FileTreeSelectionParent(
              child: CupertinoScrollbar(
                controller: controller,
                child: SingleChildScrollView(
                    controller: controller,
                    child: _FileTree(
                      filepath: rootFolder,
                      startsExpanded: true,
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FileTreeSelectionParent extends StatefulWidget {
  Widget child;

  FileTreeSelectionParent({this.child});

  @override
  FileTreeSelectionParentState createState() => new FileTreeSelectionParentState();

  static FileTreeSelectionParentState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_FileTreeSelectionParent>()).data;
  }
}

class FileTreeSelectionParentState extends State<FileTreeSelectionParent> {
  @override
  Widget build(BuildContext context) {
    return new _FileTreeSelectionParent(
      data: this,
      child: widget.child,
    );
  }
}

/// Only has MyInheritedState as field.
class _FileTreeSelectionParent extends InheritedWidget {
  final FileTreeSelectionParentState data;

  _FileTreeSelectionParent({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_FileTreeSelectionParent old) {
    return true;
  }
}

class _FileTree extends StatefulWidget {
  _FileTree({this.filepath, this.startsExpanded = false, this.indent = 0, this.focusNode}) : super(key: Key(filepath));

  final String filepath;
  final bool startsExpanded;
  final int indent;
  final FocusNode focusNode;

  @override
  _FileTreeState createState() => _FileTreeState();
}

class _FileTreeState extends State<_FileTree> {
  bool expanded;
  String name;
  List<FileSystemEntity> root = [];
  bool hadTap = false;
  FocusNode focusNode;
  bool showingContextMenu = false;
  Map<Type, Action<Intent>> _actionMap;

  @override
  void initState() {
    super.initState();
    expanded = widget.startsExpanded;
    name = widget.filepath.substring(widget.filepath.lastIndexOf('/') + 1);
    if (expanded) expand();

    focusNode = widget.focusNode ?? FocusNode();

    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => expandCollapse(),
      ),
    };
  }

  void expand() {
    listAndRebuild();
    expanded = true;
  }

  void listAndRebuild() async {
    var directory = Directory(widget.filepath);
    var list = await directory.list().fold<List<FileSystemEntity>>([], (list, item) => list..add(item));
    setState(() {
      root = list.where((file) => file is Directory || (file is File && !file.path.endsWith('.DS_Store'))).toList()
        ..sort((f1, f2) {
          if (f1 is Directory && f2 is File)
            return -1;
          else if (f2 is Directory && f1 is File) return 1;
          return f1.path.compareTo(f2.path);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          color: showingContextMenu ? Colors.blueGrey[600] : Colors.transparent,
          child: GestureDetector(
            onSecondaryTapDown: (event) {
              focusNode.requestFocus();
            },
            onSecondaryTapUp: (event) async {
              setState(() {
                showingContextMenu = true;
              });
              await showContextMenu<String>(
                  context,
                  event.globalPosition.translate(-4, -8) & Size(144, 22),
                  [
                    //makeSimpleContextItem('cut', 'Cut', icon: Icon(Icons.content_cut, size: 18), onTap: () {}),
                    //makeSimpleContextItem('copy', 'Copy', icon: Icon(Icons.content_copy, size: 18), onTap: () {}),
                    //makeSimpleContextItem('rename', 'Rename', icon: Icon(Icons.text_format, size: 18), onTap: () {}),
                    //makeSimpleContextItem('delete', 'Delete', icon: Icon(Icons.delete, size: 18), onTap: () {}),
                    makeSimpleContextItem('copy', 'Copy Path', onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.filepath));
                    }),
                    if (Platform.isMacOS)
                      makeSimpleContextItem('reveal', 'Reveal in Finder', icon: Icon(Icons.remove_red_eye, size: 18),
                          onTap: () {
                        if (Platform.isMacOS) {
                          Process.run('/usr/bin/open', ['-R', widget.filepath]);
                        }
                      }),
                  ],
                  dropdownColor: Colors.blueGrey[900],
                  style: TextStyle(fontSize: 13, color: Colors.blueGrey[100]));
              setState(() {
                showingContextMenu = false;
              });
            },
            child: InkWell(
              focusNode: FocusNode(skipTraversal: true),
              onTap: () {
                focusNode.requestFocus();
                if (!hadTap) {
                  hadTap = true;
                  Future.delayed(0.5.seconds, () {
                    hadTap = false;
                  });
                } else
                  expandCollapse();
              },
              child: FocusableActionDetector(
                actions: _actionMap,
                focusNode: focusNode,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0 + widget.indent * 12.0, top: 4.0, bottom: 4.0, right: 2.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.folder,
                        size: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                      ),
                      Text(
                        name,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ...root.map((e) {
          if (e is Directory)
            return _FileTree(
              filepath: e.path,
              indent: widget.indent + 1,
            );
          if (e is File) {
            return _File(
              filepath: e.path,
              indent: widget.indent + 1,
            );
          }
          return null;
        }).where((e) => e != null),
      ],
    );
  }

  void showRenameDialog() {
    final dir = Directory(widget.filepath);
    if (!dir.existsSync()) {
      dt.Notifications.of(context).push('Could not rename: directory does not exist');
    } else {
      print('can rename');
      var curText = name;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Rename "$name"'),
                content: TextField(
                  controller: TextEditingController(text: name),
                  onChanged: (c) => curText = c,
                  decoration: InputDecoration(hintText: 'Enter new name'),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (!dir.existsSync()) {
                        dt.Notifications.of(context).push('Could not rename: directory does not exist');
                      }
                      final np = widget.filepath.substring(0, widget.filepath.lastIndexOf('/') + 1) + curText;
                      print(np);
                      dt.Notifications.of(context).push('ERROR: Rename is not supported');
                      /*try {
                                          dir.renameSync(newPath)
                                        } {

                                        }*/
                    },
                  ),
                ],
              ));
    }
  }

  void expandCollapse() {
    if (!expanded)
      expand();
    else
      setState(() {
        root = [];
        expanded = false;
      });
  }
}

final iconMap = {'dart': 'dart.png'};

class _File extends StatefulWidget {
  _File({this.filepath, this.indent = 0, this.focusNode}) : super(key: Key(filepath));

  final String filepath;
  final int indent;
  final FocusNode focusNode;

  @override
  _FileState createState() => _FileState();
}

class _FileState extends State<_File> {
  String name;
  String icon;
  Icon builtInIcon;
  bool hadTap = false;
  FocusNode focusNode;
  bool showingContextMenu = false;

  Map<Type, Action<Intent>> _actionMap;

  @override
  void initState() {
    super.initState();
    name = widget.filepath.substring(widget.filepath.lastIndexOf('/') + 1);
    icon = name.substring(name.lastIndexOf('.') + 1);
    icon = iconMap.containsKey(icon) ? iconMap[icon] : null;
    focusNode = widget.focusNode ?? FocusNode();

    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => Project.of(context).openFile(widget.filepath),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onSecondaryTapDown: (event) {
          focusNode.requestFocus();
        },
        onSecondaryTapUp: (event) async {
          setState(() {
            showingContextMenu = true;
          });
          await showContextMenu<String>(
              context,
              event.globalPosition.translate(-4, -8) & Size(144, 22),
              [
                //makeSimpleContextItem('cut', 'Cut', icon: Icon(Icons.content_cut, size: 18), onTap: () {}),
                //makeSimpleContextItem('copy', 'Copy', icon: Icon(Icons.content_copy, size: 18), onTap: () {}),
                //makeSimpleContextItem('rename', 'Rename', icon: Icon(Icons.text_format, size: 18), onTap: () {}),
                //makeSimpleContextItem('delete', 'Delete', icon: Icon(Icons.delete, size: 18), onTap: () {}),
                makeSimpleContextItem('copy', 'Copy Path', onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.filepath));
                }),
                if (Platform.isMacOS)
                  makeSimpleContextItem('reveal', 'Reveal in Finder', icon: Icon(Icons.remove_red_eye, size: 18),
                      onTap: () {
                    if (Platform.isMacOS) {
                      Process.run('/usr/bin/open', ['-R', widget.filepath]);
                    }
                  }),
              ],
              dropdownColor: Colors.blueGrey[900],
              style: TextStyle(fontSize: 13, color: Colors.blueGrey[100]));
          setState(() {
            showingContextMenu = false;
          });
        },
        child: InkWell(
          focusNode: FocusNode(skipTraversal: true),
          onTap: () {
            focusNode.requestFocus();
            if (!hadTap) {
              hadTap = true;
              Future.delayed(0.5.seconds, () {
                hadTap = false;
              });
            } else {
              print('opening ${widget.filepath}');
              Project.of(context).openFile(widget.filepath);
            }
          },
          child: FocusableActionDetector(
            actions: _actionMap,
            focusNode: focusNode,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0 + widget.indent * 12.0, top: 4.0, bottom: 4.0, right: 4.0),
              child: Row(
                children: <Widget>[
                  icon == null
                      ? Icon(
                          Icons.insert_drive_file,
                          size: 20.0,
                        )
                      : Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Image.asset(
                            'assets/icons/$icon',
                            width: 16.0,
                            height: 16.0,
                          )),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                  ),
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
