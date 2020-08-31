import 'package:event_bus/event_bus.dart';

EventBus _bus;

/// The global event bus
EventBus get eventBus => _bus ??= EventBus();

enum WindowIdentifier { left, main, right, bottom }

class WindowResizeEvent {
  /// The type of window we are attempting to resize
  final List<WindowIdentifier> selector;
  final int size;

  WindowResizeEvent(this.selector, this.size);
}

class MakeEditorFileActive {
  final String file;

  MakeEditorFileActive(this.file);
}

class SaveFile {
  final String file;
  final bool activeFile;

  SaveFile(this.file, this.activeFile);
}

class FileContentsChanged {
  final String file;
  final bool activeFile;

  FileContentsChanged(this.file, this.activeFile);
}

class EditorFileActiveEvent {
  final String file;

  EditorFileActiveEvent(this.file);

  @override
  String toString() {
    return 'EditorFileActiveEvent{file: $file}';
  }
}
