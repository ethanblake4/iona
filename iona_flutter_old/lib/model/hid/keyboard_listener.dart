import 'package:flutter/widgets.dart';
abstract class KeyboardListener {
  bool maybeHandle(RawKeyEvent ev);
}