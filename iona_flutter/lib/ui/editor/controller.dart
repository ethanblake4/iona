import 'dart:math';
import 'dart:ui';

import 'package:iona_flutter/model/event/global_events.dart';
import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/ui/editor/editor_ui.dart';
import 'package:iona_flutter/ui/editor/util/compose.dart';
import 'package:iona_flutter/util/ot/atext_changeset.dart';
import 'package:iona_flutter/util/patterns.dart';

class EditorController {
  EditorController(this.project, this.file);

  static EditorController active;

  /// The [Project] this EditorController will apply changes to
  final Project project;

  /// A [ProjectFile] this EditorController is editing
  final ProjectFile file;

  /// Rendering info from the most recently rendered frame of the [EditorUi]
  EditorRenderingInfo renderingInfo = EditorRenderingInfo.initial;

  /// The screen scroll position of the Editor
  Offset scrollPosition = Offset.zero;

  /// How many undos have been performed since the most recent non-undo edit
  int undoPosition = 0;
  bool _didUndo = false;
  bool _propagate = true;

  List<Changeset> _prevChangesets = [];
  List<List<int>> _prevLineLengths = [];
  final List<VoidCallback> _fileChangedListeners = [];
  List<int> _currentChangeLineLength;
  EditorCursor _primaryCursor = EditorCursor(0, 0, 0, 0);
  bool _canCompose = false;

  EditOpType lastEdit;

  bool _externalEdit = false;

  bool get externalEdit {
    final ee = _externalEdit;
    _externalEdit = false;
    return ee;
  }

  /// Whether or not undoing is possible
  bool get canUndo =>
      undoPosition < _prevChangesets.length && _prevChangesets.isNotEmpty && _prevLineLengths.isNotEmpty;

  /// The number of lines present in this file
  int get lineCount => file.lineLengths.length;

  /// The maximum line length (in characters) present in this file
  int get maxLineLength {
    int maxLen = 0;
    for (final len in file.lineLengths) {
      if (len > maxLen) maxLen = len;
    }
    return maxLen;
  }

  /// The text that is currently selected by the [primaryCursor], as a string
  String get selectedText {
    if (!primaryCursor.isSelection) return null;
    final data = StringBuffer();
    for (var i = _primaryCursor.firstLine; i <= _primaryCursor.lastLine; i++) {
      String line = file.document[i]['s'];
      if (i == _primaryCursor.firstLine)
        line = line.substring(
            _primaryCursor.firstPosition, i == _primaryCursor.lastLine ? _primaryCursor.lastPosition : null);
      else if (i == _primaryCursor.lastLine) line = line.substring(0, _primaryCursor.lastPosition);
      data.write(line);
    }
    return data.toString();
  }

  /// The primary controllable [EditorCursor] for this controller
  EditorCursor get primaryCursor => _primaryCursor;

  set primaryCursor(EditorCursor newPrimaryCursor) {
    if (newPrimaryCursor != _primaryCursor) _canCompose = false;
    _primaryCursor = newPrimaryCursor;
  }

  /// Make this [EditorController] the active editor
  void makeActive() {
    EditorController.active = this;
    if (file != null && project.activeFile != file.fileLocation) {
      project.activeFile = file.fileLocation;
      eventBus.fire(EditorFileActiveEvent(file.fileLocation));
    }
  }

  /// Add a listener that will be notified when this [EditorController]'s contents change
  void addOnChangeListener(VoidCallback listener) {
    _fileChangedListeners.add(listener);
  }

  /// Change the scroll position based on a [scrollDelta], limited by [screenArea]
  void scroll(Size screenArea, Offset scrollDelta) {
    final scrollW = screenArea.width - (maxLineLength * renderingInfo.characterSize.width);
    scrollPosition += scrollDelta;
    scrollPosition = Offset(
        max(0, min(-scrollW, scrollPosition.dx)),
        min(max(0, scrollPosition.dy),
            max(0, renderingInfo.characterSize.height * lineCount - screenArea.height + 10.0)));
  }

  bool removeLeft(int deleteSize) => removeLeftAt(primaryCursor, deleteSize);

  bool removeLeftAt(EditorCursor cursor, int deleteSize) {
    assert(!cursor.isSelection, 'Cursor cannot be a selection in removeLeft()');
    if (cursor.line == 0 && cursor.position == 0) return false;
    final cs = _beginChange();
    final startOfLine = cursor.position == 0;
    assert(!startOfLine || deleteSize == 1, 'Cannot delete more than 1 character at start of line with removeLeft()');
    composeStartRelativeToCursor(file, cursor, cs, -deleteSize);
    cs.remove(deleteSize, startOfLine ? 1 : 0);
    if (startOfLine) {
      file.lineLengths[cursor.line - 1] += file.lineLengths[cursor.line] - 1;
      file.lineLengths.removeAt(cursor.line);
    } else
      file.lineLengths[cursor.line] -= deleteSize;
    _updateDoc(_finishChange(cs, primaryCursor, true), EditOpType.removeLeft);
    return true;
  }

  bool deleteAt(EditorCursor selection, {bool cursorLeft = false}) {
    if (!selection.isSelection) return false;
    final cs = _beginChange();
    composeDeleteSelection(file, selection, cs);
    _updateDoc(_finishChange(cs, selection, cursorLeft), EditOpType.delete);
    return true;
  }

  bool deleteSelection({bool cursorLeft = false}) {
    return deleteAt(primaryCursor, cursorLeft: cursorLeft);
  }

  /// Insert a string of text at the [primaryCursor]'s position
  /// See [insertAt] for more info
  bool insert(String text) {
    return insertAt(primaryCursor, text);
  }

  EditorCursor cursorFromOffsetSingle(int pos) => cursorFromOffset(pos, pos);

  EditorCursor cursorFromOffset(int start, int end) {
    var len = 0;
    var i = 0;
    int startLine, endLine, startPos, endPos, lastLen;
    for (final line in file.document) {
      if (start < len) {
        startLine = i - 1;
        startPos = lastLen - (len - start);
      }
      if (end < len) {
        endLine = i - 1;
        endPos = lastLen - (len - end);
        if (startLine != null) {
          break;
        }
      }
      lastLen = line['s'].length;
      len += line['s'].length;
      i++;
    }
    return EditorCursor(startLine, endLine, startPos, endPos);
  }

  String lineIndent(int line) {
    final String lineStr = file.document[line]['s'];
    return lineStr.substring(0, lineStr.length - lineStr.trimLeft().length).replaceAll(newlineChars, '');
  }

  String lineText(int line, {bool includeIndent = true}) {
    final String lineStr = file.document[line]['s'];
    if (includeIndent) return lineStr;
    return lineStr.substring(lineStr.length - lineStr.trimLeft().length);
  }

  String textAt(EditorCursor cur) {
    if (!cur.isSelection) return '';
    final sb = StringBuffer();
    for (var i = cur.firstLine; i < cur.lastLine + 1; i++) {
      final String lineStr = file.document[i]['s'];
      if (i == cur.firstLine) {
        if (i == cur.lastLine) {
          sb.write(lineStr.substring(cur.firstPosition, cur.lastPosition));
        } else {
          sb.write(lineStr.substring(cur.firstPosition));
        }
      } else if (i == cur.lastLine) {
        sb.write(lineStr.substring(0, cur.lastPosition));
      } else {
        sb.write(lineStr);
      }
    }
    return sb.toString();
  }

  /// Insert a string of text at the given [cursor] position
  /// If the cursor is a selection, this will overwrite the selected text
  bool insertAt(EditorCursor cursor, String text) {
    final cs = _beginChange();
    if (cursor.isSelection) {
      composeDeleteSelection(file, cursor, cs);
    } else {
      composeStartRelativeToCursor(file, cursor, cs, 0);
    }

    cs.insert(text);

    final lines = text.split('\n');
    final l1len = file.lineLengths[cursor.firstLine];
    for (var i = 0; i < lines.length; i++) {
      if (i == 0) {
        if (lines.length > 1) {
          file.lineLengths[cursor.firstLine] = cursor.firstPosition + lines[i].length + 1;
        } else
          file.lineLengths[cursor.firstLine] += lines[i].length;
      } else if (i == 1) {
        file.lineLengths.insert(cursor.firstLine + i, l1len - cursor.firstPosition + lines[i].length);
      } else
        file.lineLengths.insert(cursor.firstLine + i, lines[i].length + 1);
    }
    _updateDoc(_finishChange(cs, cursor), lines.length > 1 ? EditOpType.insertWithNewlines : EditOpType.insert);
    return true;
  }

  /// Attempt to undo the previous change. Return whether or not the undo was successful
  bool undo() {
    if (!canUndo) return false;

    final inv = _prevChangesets[_prevChangesets.length - undoPosition - 1].invert();
    file.lineLengths = _prevLineLengths[_prevLineLengths.length - undoPosition - 1];
    final np = Position(_primaryCursor.position, _primaryCursor.line).transform(inv, 'right');
    _primaryCursor = _primaryCursor.copyWithSingle(line: np.line, position: np.ch);
    undoPosition++;

    _didUndo = true;
    _canCompose = false;

    project.updateFile(file.fileLocation, inv);
    _notifyChangedListeners();
    return true;
  }

  void beginExternalEdit({bool propagate = true}) {
    _propagate = propagate;
    _externalEdit = true;
  }

  void _notifyChangedListeners() {
    if (!_propagate) return;
    eventBus.fire(FileContentsChanged(file.fileLocation, EditorController.active == this));
    for (final listener in _fileChangedListeners) {
      listener();
    }
  }

  Builder _beginChange() {
    _currentChangeLineLength = [...file.lineLengths];
    return Changeset.create(file.document);
  }

  // ignore: avoid_positional_boolean_parameters
  Changeset _finishChange(Builder cs, EditorCursor cur, [bool left = false]) {
    if (_didUndo) {
      _didUndo = false;
      undoPosition = 0;
      _prevChangesets = [];
      _prevLineLengths = [];
    }
    final ec = cs.finish();
    final np = Position(cur.endPosition, cur.endLine).transform(ec, left ? 'left' : 'right');
    _primaryCursor = cur.copyWithSingle(line: np.line, position: np.ch);
    _prevLineLengths.add(_currentChangeLineLength);
    return ec;
  }

  void _updateDoc(Changeset ec, EditOpType opType) {
    project.updateFile(file.fileLocation, ec);
    if (_canCompose && opType == lastEdit && _prevChangesets.isNotEmpty) {
      _prevChangesets.last = _prevChangesets.last.compose(ec);
      _prevLineLengths.removeAt(_prevLineLengths.length - 1);
    } else {
      _prevChangesets.add(ec);
      _canCompose = true;
    }
    _notifyChangedListeners();
    lastEdit = opType;
    _propagate = true;
  }
}

enum EditOpType { delete, removeLeft, insert, insertWithNewlines }

class EditorRenderingInfo {
  const EditorRenderingInfo(this.characterSize);

  static EditorRenderingInfo initial = EditorRenderingInfo(Size(8.2, 16));

  final Size characterSize;
}
