import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

/// Keeps track of running tasks in the IDE
class RunConfigurations extends Model {
  /// Get a reference to the nearest [Tasks] in the widget tree
  static RunConfigurations of(BuildContext context) => ScopedModel.of<RunConfigurations>(context);

  /// A map of domains to maps of task IDs to tasks
  final Map<String, RunTarget> _targets = {};

  Map<String, RunTarget> get targets => _targets;
  RunTarget _activeRunTarget = RunTarget.none;

  RunTarget get activeRunTarget => _activeRunTarget;

  set activeRunTarget(RunTarget target) {
    _activeRunTarget = target;
    notifyListeners();
  }

  /// Add or update a task
  void addTarget(RunTarget target) {
    _targets[target.id] = target;
    if (_activeRunTarget == RunTarget.none) {
      _activeRunTarget = target;
    }
    notifyListeners();
  }
}

class RunTarget {
  final String id;
  String name;
  Widget icon;

  RunTarget(this.id, this.name, this.icon);

  static final RunTarget none = RunTarget(
      '',
      'No devices',
      Icon(
        Icons.do_not_disturb_on,
        size: 18,
      ));

  @override
  bool operator ==(Object other) => identical(this, other) || other is RunTarget && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class RunConfig {}
