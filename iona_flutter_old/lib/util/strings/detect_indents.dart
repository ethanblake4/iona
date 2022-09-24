import 'package:iona_flutter/util/patterns.dart';

enum IndentType { SPACES, TABS }

class _IndentTypeAndAmount {
  IndentType type;
  int amount;

  _IndentTypeAndAmount(this.type, this.amount);
}

class IndentData {
  IndentType type;
  int amount;
  String indent;

  IndentData(this.type, this.amount, this.indent);
}

Map<String, List<int>> _makeIndentsMap(String string) {
  final indents = <String, List<int>>{};

  // Remember the size of previous line's indentation
  var previousSize = 0;
  IndentType previousIndentType;

  // Indents key (ident type + size of the indents/unindents)
  var key;

  for (final line in string.split('\n')) {
    if (line.isEmpty) {
      // Ignore empty lines
      continue;
    }

    var indent = 0;
    IndentType indentType;
    var weight = 0;
    List<int> entry;
    final matches = indentRegex.firstMatch(line);

    if (matches == null) {
      previousSize = 0;
      previousIndentType = null;
    } else {
      indent = matches.group(0).length;

      if ((matches.group(1)?.length ?? 0) != 0) {
        indentType = IndentType.SPACES;
      } else {
        indentType = IndentType.TABS;
      }

      if (indentType != previousIndentType) {
        previousSize = 0;
      }

      previousIndentType = indentType;

      weight = 0;

      final indentDifference = indent - previousSize;
      previousSize = indent;

      // Previous line have same indent?
      if (indentDifference == 0) {
        weight++;
        // We use the key from previous loop
      } else {
        final absoluteIndentDifference = indentDifference > 0 ? indentDifference : -indentDifference;
        key = _encodeIndentsKey(indentType, absoluteIndentDifference);
      }

      // Update the stats
      entry = indents[key];

      if (entry == null) {
        entry = [1, 0]; // Init
      } else {
        entry = [++entry[0], entry[1] + weight];
      }

      indents[key] = entry;
    }
  }

  return indents;
}

// Return the key (e.g. 's4') from the indents Map that represents the most common indent,
// or return undefined if there are no indents.
String _getMostUsedKey(Map<String, List<int>> indents) {
  String result = null;
  var maxUsed = 0;
  var maxWeight = 0;

  indents.forEach((key, value) {
    if (value[0] > maxUsed || (value[0] == maxUsed && value[1] > maxWeight)) {
      maxUsed = value[0];
      maxWeight = value[1];
      result = key;
    }
  });

  return result;
}

String _encodeIndentsKey(IndentType indentType, int indentAmount) {
  final typeCharacter = indentType == IndentType.SPACES ? 's' : 't';
  return typeCharacter + indentAmount.toString();
}

// Extract the indent type and amount from a key of the indents Map.
_IndentTypeAndAmount _decodeIndentsKey(String indentsKey) {
  final keyHasTypeSpace = indentsKey.startsWith('s');
  final type = keyHasTypeSpace ? IndentType.SPACES : IndentType.TABS;

  final amount = int.parse(indentsKey.substring(1));

  return _IndentTypeAndAmount(type, amount);
}

IndentData detectIndents(String file) {
  final indents = _makeIndentsMap(file);
  final mostUsedKey = _getMostUsedKey(indents);

  if (mostUsedKey == null) return IndentData(IndentType.SPACES, 2, '  ');
  final decoded = _decodeIndentsKey(mostUsedKey);
  final idString = (decoded.type == IndentType.TABS ? '\t' : ' ') * decoded.amount;
  return IndentData(decoded.type, decoded.amount, idString);
}
