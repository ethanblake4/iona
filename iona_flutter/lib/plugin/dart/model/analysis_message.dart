import 'package:iona_flutter/plugin/dart/model/lang_types.dart';

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
  List<FlutterWidgetInfo> widgets;

  FlutterFileInfo(this.widgets);

  @override
  String toString() {
    return 'FlutterFileInfo{widgets: $widgets}';
  }
}

enum FlutterWidgetType { STATEFUL, STATELESS }

class FlutterWidgetInfo {
  String name;
  FlutterWidgetType type;
  DartFunction build;

  @override
  String toString() {
    return 'FlutterWidgetInfo{name: $name, type: $type, build: $build}';
  }
}
