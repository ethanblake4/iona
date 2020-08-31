import 'package:flutter/material.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/eval.dart';

class DartEvalTypeMainAxisAlignment<T extends MainAxisAlignment> extends DartEvalTypeObject<T> {
  const DartEvalTypeMainAxisAlignment(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'index':
        return DartEvalTypeInt(value.index);
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeMainAxisSize<T extends MainAxisSize> extends DartEvalTypeObject<T> {
  const DartEvalTypeMainAxisSize(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'index':
        return DartEvalTypeInt(value.index);
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeCrossAxisAlignment<T extends CrossAxisAlignment> extends DartEvalTypeObject<T> {
  const DartEvalTypeCrossAxisAlignment(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'index':
        return DartEvalTypeInt(value.index);
        break;
      default:
        return super.getField(name);
    }
  }
}
