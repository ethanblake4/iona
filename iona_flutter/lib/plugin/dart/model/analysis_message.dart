import 'package:dart_eval/dart_eval.dart';

class AnalysisMessage {
  final String type;
  final dynamic content;

  AnalysisMessage(this.type, this.content);
}

class FileOverlay {
  String path;
  String content;

  FileOverlay(this.path, this.content);
}

class FlutterFileInfo {
  ScopeWrapper topLevelScope;
  List<String> widgets;

  FlutterFileInfo(this.widgets);

  @override
  String toString() {
    return 'FlutterFileInfo{widgets: $widgets}';
  }
}
/*
class FlutterWidgetInfo {
  String name;
  DartClass widgetClass;

  @override
  String toString() {
    return 'FlutterWidgetInfo{name: $name, class: $widgetClass}';
  }
}

class FlutterStatefulWidgetInfo extends FlutterWidgetInfo {
  DartClass stateClass;
}*/
