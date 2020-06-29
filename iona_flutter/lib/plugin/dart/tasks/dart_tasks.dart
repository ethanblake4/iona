import 'package:iona_flutter/model/ide/tasks.dart';

/// A task representing Dart analysis
class DartAnalyzeTask extends Task {
  @override
  String get domain => 'dart';

  @override
  String get name => 'analyze';

  @override
  bool isRunning;

  DartAnalyzeTask(this.isRunning);

  @override
  String toString() {
    return 'DartAnalyzeTask{isRunning: $isRunning}';
  }
}
