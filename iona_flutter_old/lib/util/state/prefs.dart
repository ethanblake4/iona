import 'package:flutter/widgets.dart';

import '../config/config.dart';

class PreferencesModel extends InheritedModel<String> {
  PreferencesModel({this.prefs, this.repositoryChangeIndexes, Widget child}) : super(child: child);

  final Map<String, int> repositoryChangeIndexes;
  final Map<String, Map<String, ConfigOption>> prefs;

  static PreferencesModel of(BuildContext context, String aspect) {
    return InheritedModel.inheritFrom<PreferencesModel>(context, aspect: aspect);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(PreferencesModel oldWidget, Set<String> dependencies) {
    return dependencies.any((key) => repositoryChangeIndexes[key] != oldWidget.repositoryChangeIndexes[key]);
  }

  ConfigOption<T> config<T>(String scope, String id) {
    return prefs[scope][id] as ConfigOption<T>;
  }
}
