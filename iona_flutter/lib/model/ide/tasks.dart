import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

/// Keeps track of running tasks in the IDE
class Tasks extends Model {
  /// Get a reference to the nearest [Tasks] in the widget tree
  static Tasks of(BuildContext context) => ScopedModel.of<Tasks>(context);

  /// A map of domains to maps of task IDs to tasks
  Map<String, Map<String, Task>> taskDomains = {};

  /// Add or update a task
  void setTask(Task task) {
    print('setTask');
    if (taskDomains.containsKey(task.domain)) {
      taskDomains[task.domain][task.name] = task;
    } else {
      taskDomains[task.domain] = <String, Task>{};
      taskDomains[task.domain][task.name] = task;
    }
    print(taskDomains);
    notifyListeners();
  }

  /// Check if task with given [domain] and [name] is running
  bool isRunning(String domain, String name) {
    print('isRunning');
    print(taskDomains);
    if (!taskDomains.containsKey(domain)) return false;
    return taskDomains[domain][name]?.isRunning ?? false;
  }
}

abstract class Task {
  String get domain;
  String get name;
  bool get isRunning;
}
