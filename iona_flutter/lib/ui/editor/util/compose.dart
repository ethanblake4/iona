import 'package:iona_flutter/model/ide/project.dart';
import 'package:iona_flutter/ui/editor/editor_ui.dart';
import 'package:iona_flutter/util/ot/atext_changeset.dart';

/// Start the compose operation at the location of [cur]
void composeStartRelativeToCursor(ProjectFile file, EditorCursor cur, Builder cs, int offset) {
  final firstPos = cur.firstPosition;
  final startLine = cur.firstLine;
  final less1 = (firstPos + offset) < 0;
  print(less1);
  final lcl = file.lineLengths.take(startLine - (less1 ? 1 : 0)).fold(0, (n, x) => n + x);

  cs..keep(lcl, startLine - (less1 ? 1 : 0))..keep((less1 ? file.lineLengths[startLine - 1] : firstPos) + offset, 0);
}

/// Delete the currently selected text
void composeDeleteSelection(ProjectFile file, EditorCursor cur, Builder cs) {
  final lcl = file.lineLengths.take(cur.firstLine).fold(0, (n, x) => n + x);

  final lcd = cur.lastLine == cur.firstLine
      ? 0
      : file.lineLengths.skip(cur.firstLine).take(cur.lastLine - cur.firstLine).fold(0, (n, x) => n + x);
  cs
    ..keep(lcl, cur.firstLine)
    ..keep(cur.firstPosition, 0)
    ..remove(cur.lastPosition - cur.firstPosition + lcd, cur.lastLine - cur.firstLine);

  if (cur.lastLine != cur.firstLine) {
    final lastL = file.lineLengths[cur.lastLine];
    file.lineLengths[cur.firstLine] = cur.firstPosition + lastL - cur.lastPosition;
    for (var i = cur.firstLine; i < cur.lastLine; i++) {
      file.lineLengths.removeAt(cur.firstLine + 1);
    }
  } else
    file.lineLengths[cur.line] -= cur.lastPosition - cur.firstPosition;
}
