import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class KeyData {
  bool isKeyDown;
  int keyCode;
  String characters;

  @override
  String toString() {
    return 'KeyData{isKeyDown: $isKeyDown, keyCode: $keyCode, characters: $characters}';
  }

  KeyData(this.isKeyDown, this.keyCode, this.characters);
}

KeyData rawKeyToKeyData(RawKeyEvent event) {
  var isKeyDown = false;
  var characters = '';
  var keyCode = -1;
  switch (event.runtimeType) {
    case RawKeyDownEvent:
      isKeyDown = true;
      break;
    case RawKeyUpEvent:
      isKeyDown = false;
      break;
    default:
      throw new Exception('Unexpected runtimeType of RawKeyEvent');
  }

  switch (event.data.runtimeType) {
    case RawKeyEventDataMacOs:
      final RawKeyEventDataMacOs data = event.data;
      keyCode = data.keyCode;
      characters = data.characters;
      break;
    default:
      throw new Exception('Unsupported platform ${event.data.runtimeType}');
  }
  return KeyData(isKeyDown, keyCode, characters);
}
