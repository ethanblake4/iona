import 'dart:io' show Platform;

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:menubar/menubar.dart';

/// The root submenu categories
enum MenuCategory {
  /// For file and project related actions
  file,

  /// For edit related actions
  edit,

  /// For presentation and view related actions
  //view,

  /// For run and build related actions
  run,

  /// For windowing related actions
  //window,

  /// For help related actions
  help
}

/// The manager
class MenuBarManager {
  /// Returns the current instance of [MenuBarManager]
  factory MenuBarManager() {
    return _singleton;
  }

  MenuBarManager._internal();

  Map<MenuCategory, Map<String, List<MenuActionOrSubmenu>>> rootMenus = Map.fromEntries(MenuCategory.values.map((v) {
    return MapEntry(v, <String, List<MenuActionOrSubmenu>>{});
  }));

  /// Singleton
  static final MenuBarManager _singleton = MenuBarManager._internal();

  void setItem(MenuCategory category, String group, MenuActionOrSubmenu item) {
    if (!rootMenus[category].containsKey(group)) {
      rootMenus[category][group] = <MenuActionOrSubmenu>[];
    }
    var ind = rootMenus[category][group].indexOf(item);
    if (ind == -1)
      rootMenus[category][group].add(item);
    else
      rootMenus[category][group][ind] = item;

    if (!_firstPublish) {
      _publish();
    }
  }

  bool updateItem(MenuCategory category, String group, String id,
      {String title,
      MenuSelectedCallback action,
      bool enabled,
      List<MenuActionOrSubmenu> submenu,
      LogicalKeySet shortcut}) {
    if (!rootMenus[category].containsKey(group)) return false;
    final ind = rootMenus[category][group].firstWhere((element) => element._id == id, orElse: () => null);
    if (ind == null) return false;
    ind
      ..action = action ?? ind.action
      ..enabled = enabled ?? ind.enabled
      ..shortcut = shortcut ?? ind.shortcut
      ..submenu = submenu ?? ind.submenu
      ..title = title ?? ind.title;

    if (!_firstPublish) {
      _publish();
    }

    return true;
  }

  bool _firstPublish = false;

  /// Forcefully publish the menu.
  void publish() {
    _publish();
    _firstPublish = true;
  }

  void _publish() {
    if (!Platform.isMacOS && !Platform.isLinux) {
      return;
    }

    setApplicationMenu(rootMenus
        .map((name, menu) => MapEntry<MenuCategory, Submenu>(
            name,
            Submenu(
                label: name.toString().substring(13, 14).toUpperCase() + name.toString().substring(14),
                children:
                    menu.entries.expand((item) => [...item.value.map((l) => l.toApiMenu()), MenuDivider()]).toList())))
        .values
        .toList());
  }
}

/// A menu item that can either contain an action or a submenu.
class MenuActionOrSubmenu with EquatableMixin {
  /// Create a new MenuActionOrSubmenu
  MenuActionOrSubmenu(this._id, this.title, {this.enabled = true, this.action, this.submenu, this.shortcut})
      : assert(action == null || submenu == null);

  String _id;
  String title;
  MenuSelectedCallback action;
  bool enabled;
  List<MenuActionOrSubmenu> submenu;
  LogicalKeySet shortcut;

  /// Convert to an API menu
  AbstractMenuItem toApiMenu() {
    if (action != null) {
      return MenuItem(label: title, enabled: enabled, onClicked: action, shortcut: shortcut);
    } else if (submenu != null) {
      return Submenu(label: title, children: submenu.map((item) => item.toApiMenu()));
    }
    throw new Exception('No action or submenu $title $_id $action $submenu $shortcut');
  }

  @override
  List get props => [_id];
}
