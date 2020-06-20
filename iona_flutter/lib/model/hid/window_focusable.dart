import 'package:flutter/widgets.dart';

class WindowFocusable extends InheritedWidget {
  WindowFocusable(this.controller, {Key key, Widget child}) : super(key: key, child: child);

  /// Inherit this widget
  static WindowFocusable of(BuildContext context) => context.inheritFromWidgetOfExactType(WindowFocusable);

  final _WindowFocusableControllerState controller;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class WindowFocusableController extends StatefulWidget {
  WindowFocusableController({Key key, this.child}) : super(key: key);

  Widget child;

  @override
  _WindowFocusableControllerState createState() => _WindowFocusableControllerState();
}

class _WindowFocusableControllerState extends State<WindowFocusableController> {
  final FocusNode _globalKeyFocus = FocusNode();

  List<String> ids = [];
  Map<String, Function(RawKeyEvent)> listenerMap = {};

  @override
  Widget build(BuildContext context) {
    return WindowFocusable(
      this,
      child: widget.child,
    );
  }

  void requestFocus(String id) {
    setState(() {
      ids.add(id);
    });
  }

  void removeFocus(String id) {
    if (ids.isNotEmpty && ids.last == id) {
      ids.removeLast();
    }
  }

  void listen(String id, Function(RawKeyEvent) onKey) {
    listenerMap[id] = onKey;
  }
}
