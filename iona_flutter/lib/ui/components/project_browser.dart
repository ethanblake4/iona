import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iona_flutter/model/ide/ide_theme.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:scoped_model/scoped_model.dart';

/// A project browser showing files and such
class ProjectBrowser extends StatefulWidget {
  @override
  _ProjectBrowserState createState() => _ProjectBrowserState();
}

class _ProjectBrowserState extends State<ProjectBrowser> {
  String rootFolder = '';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Project>(
      builder: (context, child, model) {
        if (model.rootFolder != rootFolder) {
          rootFolder = model.rootFolder;
        }
        return InlineWindow(
          constraints: BoxConstraints.tightFor(width: 280),
          header: Text('Project'),
          child: Material(
            color: IdeTheme.of(context).projectBrowserBackground.col,
            child: FileTreeSelectionParent(
              child: ListView(
                children: <Widget>[
                  _FileTree(
                    filepath: rootFolder,
                    startsExpanded: true,
                  )
                ],
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
    return (context.inheritFromWidgetOfExactType(_FileTreeSelectionParent) as _FileTreeSelectionParent).data;
  }
}

class FileTreeSelectionParentState extends State<FileTreeSelectionParent> {
  String _selectedFile;

  // only expose a getter to prevent bad usage
  String get selectedFile => _selectedFile;

  void selectFile(String newFile) {
    setState(() {
      _selectedFile = newFile;
    });
  }

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
  _FileTree({this.filepath, this.startsExpanded = false, this.indent = 0}) : super(key: Key(filepath));

  final String filepath;
  final bool startsExpanded;
  final int indent;

  @override
  _FileTreeState createState() => _FileTreeState();
}

class _FileTreeState extends State<_FileTree> {
  bool expanded;
  String name;
  List<FileSystemEntity> root = [];
  bool hadTap = false;

  @override
  void initState() {
    super.initState();
    expanded = widget.startsExpanded;
    name = widget.filepath.substring(widget.filepath.lastIndexOf('/') + 1);
    if (expanded) expand();
  }

  void expand() {
    listAndRebuild();
    expanded = true;
  }

  void listAndRebuild() async {
    var directory = Directory(widget.filepath);
    var list = await directory.list().fold<List<FileSystemEntity>>([], (list, item) => list..add(item));
    setState(() {
      root = list
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
          color: FileTreeSelectionParent.of(context).selectedFile == widget.filepath
              ? IdeTheme.of(context).fileTreeSelectedFile.col
              : Colors.transparent,
          child: InkWell(
            onTap: () {
              InlineWindow.of(context).requestFocus();
              FileTreeSelectionParent.of(context).selectFile(widget.filepath);
              if (!hadTap) {
                hadTap = true;
                Future.delayed(const Duration(milliseconds: 500), () {
                  hadTap = false;
                });
              } else {
                if (!expanded)
                  expand();
                else
                  setState(() {
                    root = [];
                    expanded = false;
                  });
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: 8.0 + widget.indent * 12.0, top: 2.0, bottom: 2.0, right: 2.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.folder,
                    size: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                  ),
                  Text(name),
                ],
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
}

final iconMap = {'dart': 'dart.png'};

class _File extends StatefulWidget {
  _File({this.filepath, this.indent = 0}) : super(key: Key(filepath));

  final String filepath;
  final int indent;

  @override
  _FileState createState() => _FileState();
}

class _FileState extends State<_File> {
  String name;
  String icon;
  Icon builtInIcon;
  bool hadTap = false;

  @override
  void initState() {
    super.initState();
    name = widget.filepath.substring(widget.filepath.lastIndexOf('/') + 1);
    icon = name.substring(name.lastIndexOf('.') + 1);
    icon = iconMap.containsKey(icon) ? iconMap[icon] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FileTreeSelectionParent.of(context).selectedFile == widget.filepath
          ? IdeTheme.of(context).fileTreeSelectedFile.col
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          InlineWindow.of(context).requestFocus();
          FileTreeSelectionParent.of(context).selectFile(widget.filepath);
          if (!hadTap) {
            hadTap = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              hadTap = false;
            });
          } else {
            print('opening ${widget.filepath}');
            Project.of(context).openFile(widget.filepath);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 8.0 + widget.indent * 12.0, top: 2.0, bottom: 2.0, right: 4.0),
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
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
