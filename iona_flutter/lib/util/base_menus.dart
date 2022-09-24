import 'dart:io';

import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/plugin/plugin.dart';
import 'package:iona_flutter/util/menubar_manager.dart';

void setupBaseMenus(BuildContext context) {
  final opKey =
      Platform.isWindows ? LogicalKeyboardKey.control : LogicalKeyboardKey.meta;
  MenuBarManager()
    ..setItem(
        MenuCategory.file,
        'open',
        MenuActionOrSubmenu('new_project', 'New Project', action: () {
          file_selector.getDirectoryPath(confirmButtonText: 'Open').then(print);
        },
            shortcut: LogicalKeySet(
                opKey, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN)))
    ..setItem(
        MenuCategory.edit,
        'analyze',
        MenuActionOrSubmenu('analyze', 'Analyze', action: () {
          // DartAnalyzer().flutterFileInfo('${Project.of(context).rootFolder}/lib/main.dart').then(print);
        }, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyP)))
    ..setItem(
        MenuCategory.file,
        'open',
        MenuActionOrSubmenu('open', 'Open', action: () {
          file_selector.getDirectoryPath(confirmButtonText: 'Open').then((res) {
            if (res != null) {
              Project.of(context).rootFolder = res;

              final interface = PluginInterface(context);
              for (final plugin in Plugin.allPlugins) {
                plugin.onNewRootFolder(interface);
              }
            }
          });
        }, shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyO)))
    ..setItem(
        MenuCategory.file,
        'save',
        MenuActionOrSubmenu('save', 'Save',
            action: () {},
            shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyS),
            enabled: false))
    ..setItem(
        MenuCategory.edit,
        'undo',
        MenuActionOrSubmenu('undo', 'Undo',
            enabled: false,
            action: () {},
            shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyZ)))
    ..setItem(
        MenuCategory.edit,
        'undo',
        MenuActionOrSubmenu('redo', 'Redo',
            action: () {},
            enabled: false,
            shortcut: LogicalKeySet(
                LogicalKeyboardKey.shift, opKey, LogicalKeyboardKey.keyZ)))
    ..setItem(
        MenuCategory.edit,
        'clipboard',
        MenuActionOrSubmenu('cut', 'Cut',
            enabled: false,
            action: () {},
            shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyX)))
    ..setItem(
        MenuCategory.edit,
        'clipboard',
        MenuActionOrSubmenu('copy', 'Copy',
            enabled: false,
            action: () {},
            shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyC)))
    ..setItem(
        MenuCategory.edit,
        'clipboard',
        MenuActionOrSubmenu('paste', 'Paste',
            enabled: false,
            action: () {},
            shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyV)))
    ..setItem(
        MenuCategory.edit,
        'format',
        MenuActionOrSubmenu('reformat', 'Reformat Code',
            enabled: false,
            action: () {},
            shortcut: LogicalKeySet(
                opKey, LogicalKeyboardKey.alt, LogicalKeyboardKey.keyL)))
    ..setItem(
        MenuCategory.edit,
        'find',
        MenuActionOrSubmenu('find', 'Find',
            enabled: false,
            action: () {},
            shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyF)))
    ..setItem(
        MenuCategory.edit,
        'find',
        MenuActionOrSubmenu('replace', 'Replace',
            action: () {},
            shortcut: LogicalKeySet(opKey, LogicalKeyboardKey.keyR)))
    ..publish();
}
