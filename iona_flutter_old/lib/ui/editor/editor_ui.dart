import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:flutter/widgets.dart';
import 'package:iona_flutter/ui/editor/editor.dart';
import 'package:iona_flutter/util/patterns.dart';

import '../painting/util/text_layout_cache.dart';
import 'theme/editor_theme.dart';

/// An Editor UI
class EditorUi extends CustomPainter {
  /// Construct an editor UI
  EditorUi(this.scroll,
      {this.theme, this.lines, this.lineHeight, this.callback, this.cursor, this.events, this.cursorBlink}) {
    backgroundPaint = Paint()..color = theme.backgroundColor;
    cursorPaint = Paint()..color = theme.baseStyle.color;
    selectionPaint = Paint()..color = theme.selectionColor;
  }

  final Offset scroll;
  final EditorTheme theme;
  final double lineHeight;
  final List<EditorUiLine> lines;
  final Function() callback;
  final EditorCursor cursor;
  final Stream<PointerEvent> events;
  final bool cursorBlink;

  Paint backgroundPaint;
  Paint cursorPaint;
  Paint selectionPaint;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paint the background

    Editor.editorSize = size;

    final startMs = DateTime.now().millisecondsSinceEpoch;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    var offsetYPos = 5.0 + (-scroll.dy / lineHeight).floor() * lineHeight;
    var i = (-scroll.dy / lineHeight).floor();

    int firstCline, firstPos, lastCline, lastPos;
    if (cursor.line < cursor.endLine) {
      firstCline = cursor.line;
      firstPos = cursor.position;
      lastCline = cursor.endLine;
      lastPos = cursor.endPosition;
    } else if (cursor.line == cursor.endLine) {
      firstCline = cursor.line;
      firstPos = min(cursor.position, cursor.endPosition);
      lastCline = cursor.line;
      lastPos = max(cursor.position, cursor.endPosition);
    } else {
      firstCline = cursor.endLine;
      firstPos = cursor.endPosition;
      lastCline = cursor.line;
      lastPos = cursor.position;
    }
    //print(scroll.dx);

    for (var line in lines.skip((-scroll.dy / lineHeight).floor()).take((size.height / lineHeight).ceil())) {
      if (line == null) continue;
      i++;
      var offsetXPos = 45.0 + scroll.dx;

      final f = line.fragments.map((frag) => TextSpan(
          text: frag.text,
          style: theme.baseStyle.copyWith(
              color: theme.languageThemes[frag.language]?.getHighlightFor(frag.spanType) ?? theme.baseStyle.color)));

      final painter = TextLayoutCache.inst.getOrPerformLayout(TextSpan(children: f.toList()));

      if (firstCline <= i - 1 && lastCline >= i - 1 && (lastPos != firstPos || lastCline != firstCline)) {
        List<TextBox> boxes;
        if (lastCline == firstCline) {
          boxes = painter.getBoxesForSelection(TextSelection(baseOffset: firstPos, extentOffset: lastPos));
        } else if (firstCline < i - 1 && lastCline > i - 1) {
          boxes = [TextBox.fromLTRBD(0, 0, size.width - offsetXPos, lineHeight, TextDirection.ltr)];
        } else if (firstCline == i - 1) {
          final cOff = painter.getOffsetForCaret(TextPosition(offset: firstPos), Rect.fromLTWH(0, 0, 2, lineHeight));
          boxes = [TextBox.fromLTRBD(cOff.dx, 0, size.width - offsetXPos, lineHeight, TextDirection.ltr)];
        } else if (lastCline == i - 1) {
          final cOff = painter.getOffsetForCaret(TextPosition(offset: lastPos), Rect.fromLTWH(0, 0, 2, lineHeight));
          boxes = [TextBox.fromLTRBD(0, 0, cOff.dx, lineHeight, TextDirection.ltr)];
        }
        for (final box in boxes) {
          canvas.drawRect(box.toRect().shift(Offset(offsetXPos, scroll.dy + offsetYPos)), selectionPaint);
        }
      }

      painter.paint(canvas, Offset(offsetXPos, scroll.dy + offsetYPos));

      if (cursorBlink && cursor.endLine == i - 1) {
        final o =
            painter.getOffsetForCaret(TextPosition(offset: cursor.endPosition), Rect.fromLTWH(0, 0, 2, lineHeight));
        canvas.drawRect(Rect.fromLTWH(offsetXPos + o.dx, o.dy + scroll.dy + offsetYPos, 2, lineHeight), cursorPaint);
        Editor.cursorScreenPosition = Offset(offsetXPos + o.dx, o.dy + scroll.dy + offsetYPos + lineHeight);
      }

      if (theme.showLineNumbers) {
        canvas.drawRect(Rect.fromLTWH(0, scroll.dy + offsetYPos, 45, lineHeight), backgroundPaint);
        final painter = TextLayoutCache.inst.getOrPerformLayout(
            TextSpan(text: i.toString(), style: theme.baseStyle.copyWith(color: Color(0xFFCCCCCC), fontSize: 12.0)));
        painter.paint(canvas, Offset(-painter.width + 30, scroll.dy + offsetYPos + 1.0));
      }

      offsetYPos += lineHeight;
    }

    //if (Random().nextInt(100) < 5) print('time paint: ${DateTime.now().millisecondsSinceEpoch - startMs}');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorUi &&
          runtimeType == other.runtimeType &&
          scroll == other.scroll &&
          theme == other.theme &&
          lineHeight == other.lineHeight &&
          lines == other.lines;

  @override
  int get hashCode => scroll.hashCode ^ theme.hashCode ^ lineHeight.hashCode ^ lines.hashCode;
}

/// A fragment of text for display in the editor.
class EditorTextFragment with EquatableMixin {
  /// Create an EditorTextFragment
  EditorTextFragment(this.language, this.spanType, this.text);

  /// Represents a space
  static EditorTextFragment space = EditorTextFragment('undef', 'undef', ' ');

  final String language;
  final String spanType;
  final String text;

  @override
  List get props => [language, spanType, text];

  @override
  String toString() => 'EditorTextFragment{language: $language, spanType: $spanType, text: $text}';
}

/// An [EditorTextFragment] that has had its line position resolved
class ResolvedEditorTextFragment extends EditorTextFragment {
  final double startX;
  final double width;

  ResolvedEditorTextFragment(this.startX, this.width, String language, String spanType, String text)
      : super(language, spanType, text);

  ResolvedEditorTextFragment.from(EditorTextFragment frag, this.startX, this.width)
      : super(frag.language, frag.spanType, frag.text);

  @override
  String toString() => 'ResolvedETF{startX: $startX, width: $width, frag: ${super.toString()}';

  @override
  List<Object> get eqProps => [startX, width];
}

class EditorUiLine {
  EditorUiLine(this.fragments);

  final List<EditorTextFragment> fragments;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorUiLine && runtimeType == other.runtimeType && fragments == other.fragments;

  @override
  int get hashCode => fragments.hashCode;

  EditorTextFragment fragmentAtPosition(int pos) {
    var accum = 0;
    for (var frag in fragments) {
      if (accum >= pos) {
        return frag;
      }
      accum += frag.text.length;
    }
    return null;
  }

  int suggestionStart(int pos) {
    var accum = 0;
    for (final frag in fragments) {
      accum += frag.text.length;
      if (accum >= pos) {
        return accum - frag.text.trimLeft().length;
      }
    }
    return 0;
  }

  int insertEnd(int pos) {
    var accum = 0;
    for (final frag in fragments) {
      accum += frag.text.length;
      if (accum >= pos) {
        return accum;
      }
    }
    return 0;
  }

  String stringVal() {
    final sb = StringBuffer();
    for (final frag in fragments) {
      sb.write(frag.text);
    }
    return sb.toString();
  }

  int indentStart() {
    var accum = 0;
    for (final frag in fragments) {
      final trimLen = frag.text.trimLeft().length;
      if (trimLen == 0 || frag.text == '\n' || frag.text == '\r\n') {
        accum += frag.text.replaceAll(newlineChars, '').length;
      } else {
        return accum + frag.text.length - trimLen;
      }
    }
    return accum;
  }

  @override
  String toString() {
    return 'EditorUiLine{fragments: $fragments}';
  }
}

class ResolvedEditorUiLine with EquatableMixin {
  ResolvedEditorUiLine(this.startY, this.lineHeight, this.fragments);

  final double startY;
  final double lineHeight;

  final List<ResolvedEditorTextFragment> fragments;

  @override
  List get props => [startY, lineHeight, fragments];
}

class EditorCursor {
  EditorCursor(this.line, this.endLine, this.position, this.endPosition);

  final int line;
  final int endLine;
  final int position;
  final int endPosition;

  EditorCursor copyWith({int line, int endLine, int position, int endPosition}) => EditorCursor(
      line ?? this.line, endLine ?? this.endLine, position ?? this.position, endPosition ?? this.endPosition);

  EditorCursor copyWithSingle({int line, int position}) =>
      EditorCursor(line ?? this.line, line ?? this.endLine, position ?? this.position, position ?? this.endPosition);

  int get firstLine => min(line, endLine);

  int get lastLine => max(line, endLine);

  int get firstPosition {
    if (line < endLine) {
      return position;
    } else if (line == endLine) {
      return min(position, endPosition);
    } else
      return endPosition;
  }

  int get lastPosition {
    if (line > endLine) {
      return position;
    } else if (line == endLine) {
      return max(position, endPosition);
    } else
      return endPosition;
  }

  /// Whether this cursor contains a selection
  bool get isSelection => position != endPosition || line != endLine;

  @override
  String toString() {
    return 'EditorCursor{line: $line, endLine: $endLine, position: $position, endPosition: $endPosition}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorCursor &&
          runtimeType == other.runtimeType &&
          line == other.line &&
          endLine == other.endLine &&
          position == other.position &&
          endPosition == other.endPosition;

  @override
  int get hashCode => line.hashCode ^ endLine.hashCode ^ position.hashCode ^ endPosition.hashCode;
}

// ignore: avoid_classes_with_only_static_members
class EditorCursorUtil {
  static Map<int, _EditorCursorEventData> cursors = {};

  static EditorCursor calcNewCursor(PointerEvent event, List<EditorUiLine> lines, EditorTheme theme, double scrollY,
      double scrollX, double lineHeight, Offset local) {
    int calcLine(double y) => max(0, min(((-scrollY + y) / lineHeight).floor(), lines.length - 1));
    int calcPos(EditorTheme theme, EditorUiLine line, double x) {
      if (x == 0) return 0;

      final f = line.fragments.map((frag) => TextSpan(
          text: frag.text,
          style: theme.baseStyle.copyWith(
              color: theme.languageThemes[frag.language]?.getHighlightFor(frag.spanType) ?? theme.baseStyle.color)));

      final painter = TextLayoutCache.inst.getOrPerformLayout(TextSpan(children: f.toList()));

      return painter.getPositionForOffset(Offset(x, 0)).offset;
    }

    if (event is PointerDownEvent) {
      if (!cursors.containsKey(event.pointer)) {
        cursors[event.pointer] = _EditorCursorEventData(0, 0, false);
      }
      /*if (cursors[event.pointer].canDoubleClick) {
        print('double click');
      } else {*/
      final l = calcLine(local.dy);
      cursors[event.pointer] = _EditorCursorEventData(l, calcPos(theme, lines[l], max(0, local.dx - scrollX)));
      Future.delayed(const Duration(milliseconds: 500), () {
        cursors[event.pointer].canDoubleClick = false;
      });
      //}
    } else if (event is PointerUpEvent || event is PointerMoveEvent) {
      final l = calcLine(local.dy);

      final x = EditorCursor(cursors[event.pointer].lineInitial, l, cursors[event.pointer].posInitial,
          calcPos(theme, lines[l], max(0, local.dx - scrollX)));
      // print(x);
      return x;
    }

    return EditorCursor(cursors[event.pointer].lineInitial, cursors[event.pointer].lineInitial,
        cursors[event.pointer].posInitial, cursors[event.pointer].posInitial);
  }
}

class _EditorCursorEventData {
  final int lineInitial;
  final int posInitial;
  bool canDoubleClick;
  int clickState;

  _EditorCursorEventData(this.lineInitial, this.posInitial, [this.canDoubleClick = true, this.clickState = 0]);
}
