class AnalysisMessage {
  final String type;
  final dynamic content;

  AnalysisMessage(this.type, this.content);

  static const String setRootFolder = 'setRootFolder';
  static const String complete = 'complete';
  static const String overlay = 'overlay';
}

class SetRootFolderParams {
  SetRootFolderParams(this.sdkPath, this.rootFolder);

  String sdkPath;
  String rootFolder;
}

class FileOverlay {
  String path;
  String content;

  FileOverlay(this.path, this.content);
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
