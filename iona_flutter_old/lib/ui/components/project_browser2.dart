import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iona_flutter/model/ide/ide_theme.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/ui/design/inline_window.dart';
import 'package:scoped_model/scoped_model.dart';

/// A project browser showing files and such
class ProjectBrowser2 extends StatefulWidget {
  @override
  _ProjectBrowser2State createState() => _ProjectBrowser2State();
}

class UiFile {
  UiFile(this.filepath, {this.indent = 0});

  final String filepath;
  int indent;
}

class UiDirectory extends UiFile {
  UiDirectory(String filepath, {this.children = const [], int indent = 0, this.open = false})
      : super(filepath, indent: indent);

  bool open;
  List<UiFile> children;
}

class _ProjectBrowser2State extends State<ProjectBrowser2> {
  var _width = 280.0;

  UiDirectory dirRoot;
  List<UiFile> inorder = [];

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Project>(
      builder: (context, child, model) {
        if (model.rootFolder != dirRoot?.filepath) {
          dirRoot = UiDirectory(model.rootFolder);
          expandCollapse(dirRoot);
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
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 18.0),
              child: ListView.builder(
                itemBuilder: _itemBuilder,
                itemCount: inorder.length,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int i) {
    final UiFile f = inorder[i];
    if (f is UiDirectory) {
      return _Directory(
        filepath: f.filepath,
        indent: f.indent,
        onOpenClose: () {
          expandCollapse(f);
        },
      );
    } else {
      return _File(filepath: f.filepath, indent: f.indent);
    }
  }

  void expandCollapse(UiDirectory dir) async {
    if (!dir.open) {
      var directory = Directory(dir.filepath);
      var list = await directory.list().fold<List<FileSystemEntity>>([], (list, item) => list..add(item));
      list.sort((f1, f2) {
        if (f1 is Directory && f2 is File)
          return -1;
        else if (f2 is Directory && f1 is File) return 1;
        return f1.path.compareTo(f2.path);
      });
      dir
        ..children = list.map((f) {
          if (f is File) {
            return UiFile(f.path);
          } else if (f is Directory) {
            return UiDirectory(f.path);
          }
        }).toList()
        ..open = true;
    } else {
      dir.open = false;
    }

    setState(() {
      inorder = walkTree();
    });
  }

  List<UiFile> walkTree() {
    final newInorder = <UiFile>[];
    _walkTreeInternal(newInorder, [dirRoot], 0);
    return newInorder;
  }

  void _walkTreeInternal(List newInorder, List<UiFile> files, int indent) {
    for (final file in files) {
      newInorder.add(file..indent = indent);
      if (file is UiDirectory && file.open) {
        _walkTreeInternal(newInorder, file.children, indent + 1);
      }
    }
  }
}

final iconMap = {'dart': 'dart.png'};

// ignore: must_be_immutable
class _Directory extends StatelessWidget {
  _Directory({this.filepath, this.indent = 0, this.focusNode, this.onOpenClose}) : super(key: Key(filepath)) {
    name = filepath.substring(filepath.lastIndexOf('/') + 1);
    focusNode ??= FocusNode();
    _actionMap ??= <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => onOpenClose(),
      ),
    };
  }

  final String filepath;
  final int indent;
  final VoidCallback onOpenClose;

  FocusNode focusNode;

  String name;
  bool hadTap = false;

  Map<Type, Action<Intent>> _actionMap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onFocusChange: (fcn) {},
        onHighlightChanged: (hc) {
          if (hc) {
            focusNode.requestFocus();
          }
        },
        onTap: () {
          //focusNode.requestFocus();
          if (!hadTap) {
            hadTap = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              hadTap = false;
            });
          } else {
            onOpenClose();
          }
        },
        child: FocusableActionDetector(
          actions: _actionMap,
          focusNode: focusNode,
          onShowFocusHighlight: (sd) {
            print('sfh $sd');
          },
          onFocusChange: (g) {
            print('nnn $g');
          },
          child: Padding(
            padding: EdgeInsets.only(left: 8.0 + indent * 12.0, top: 4.0, bottom: 4.0, right: 4.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.folder,
                  size: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                ),
                Flexible(
                  child: Text(
                    name,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _File extends StatelessWidget {
  _File({this.filepath, this.indent = 0, this.focusNode}) : super(key: Key(filepath)) {
    name = filepath.substring(filepath.lastIndexOf('/') + 1);
    icon = name.substring(name.lastIndexOf('.') + 1);
    icon = iconMap.containsKey(icon) ? iconMap[icon] : null;
    focusNode ??= FocusNode();
  }

  final String filepath;
  final int indent;
  FocusNode focusNode;

  String name;
  String icon;
  Icon builtInIcon;
  bool hadTap = false;

  Map<Type, Action<Intent>> _actionMap;

  @override
  Widget build(BuildContext context) {
    _actionMap ??= <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => Project.of(context).openFile(filepath),
      ),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        focusNode: FocusNode(skipTraversal: true),
        onTap: () {
          focusNode.requestFocus();
          if (!hadTap) {
            hadTap = true;
            /*Future.delayed(const Duration(milliseconds: 500), () {
              hadTap = false;
            });*/
          } else {
            print('opening $filepath');
            Project.of(context).openFile(filepath);
          }
        },
        child: FocusableActionDetector(
          actions: _actionMap,
          focusNode: focusNode,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0 + indent * 12.0, top: 4.0, bottom: 4.0, right: 4.0),
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
                    overflow: TextOverflow.visible,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
