import 'package:_fe_analyzer_shared/src/scanner/scanner.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/completion_dart.dart';

/// Finds the previous n tokens occurring before the cursor.
List<String> constructQuery(DartCompletionRequest request, int n) {
  var token = getCursorToken(request);
  if (request.offset == null) {
    return null;
  }

  while (!isStopToken(token, request.offset)) {
    token = token.previous;
  }

  if (token?.offset == null || token?.type == null) {
    return null;
  }

  final result = <String>[];
  for (var size = 0; size < n && token != null && !token.isEof; token = token.previous) {
    if (!token.isSynthetic && token is! ErrorToken) {
      // Omit the optional new keyword as we remove it at training time to
      // prevent model from suggesting it.
      if (token.lexeme == 'new') {
        continue;
      }

      result.add(token.lexeme);
      size += 1;
    }
  }

  return result.reversed.toList(growable: false);
}

bool isNotWhitespace(String lexeme) {
  return lexeme.replaceAll("'", '').split('').any((String chr) => !RegExp(r'\s').hasMatch(chr));
}

/// Step to previous token until we are at the first token before where the
/// cursor is located.
bool isStopToken(Token token, int cursorOffset) {
  if (token == null) {
    return true;
  }
  if (token.isSynthetic && !token.isEof) {
    return false;
  }
  final position = token.offset + token.length;
  if (position == cursorOffset) {
    // If we are at the end of some token, step to previous only if the
    // token is NOT an identifier, keyword, or literal. The rationale is that
    // we want to keep moving if we have a situation like
    // FooBar foo^ since foo is not a previous token to pass to the model.
    return !token.lexeme[token.lexeme.length - 1].contains(RegExp(r'[0-9A-Za-z_]'));
  }
  // Stop if the token's location is strictly before the cursor, continue
  // if the token's location is strictly after.
  return position < cursorOffset;
}

/// Maps included relevance tags formatted as
/// '${element.librarySource.uri}::${element.name}' to element.name.
String elementNameFromRelevanceTag(String tag) {
  final index = tag.lastIndexOf('::');
  if (index == -1) {
    return null;
  }

  return tag.substring(index + 2);
}

Token getCurrentToken(DartCompletionRequest request) {
  var token = getCursorToken(request);
  while (!isStopToken(token.previous, request.offset)) {
    token = token.previous;
  }
  return token;
}

/// Finds the token at which completion was requested.
Token getCursorToken(DartCompletionRequest request) {
  final entity = request.target.entity;
  if (entity is AstNode) {
    return entity.endToken;
  }
  return entity is Token ? entity : null;
}

bool isLiteral(String lexeme) {
  if (lexeme == null || lexeme.isEmpty) {
    return false;
  }
  if (RegExp(r'^[0-9]+$').hasMatch(lexeme)) {
    // Check for number lexeme.
    return true;
  }
  return isStringLiteral(lexeme);
}

bool isStringLiteral(String lexeme) {
  if (lexeme == null || lexeme.isEmpty) {
    return false;
  }
  return (lexeme.length > 1 && lexeme[0] == "'") || (lexeme.length > 2 && lexeme[0] == 'r' && lexeme[1] == "'");
}

bool isTokenDot(Token token) {
  return token != null && !token.isSynthetic && token.lexeme.endsWith('.');
}

/// Filters the entries list down to only those which represent string literals
/// and then strips quotes.
List<MapEntry<String, double>> selectStringLiterals(List<MapEntry> entries) {
  return entries
      .where((MapEntry entry) => isStringLiteral(entry.key) && isNotWhitespace(entry.key))
      .map<MapEntry<String, double>>((MapEntry entry) => MapEntry(trimQuotes(entry.key), entry.value))
      .toList();
}

bool testFollowingDot(DartCompletionRequest request) {
  final token = getCurrentToken(request);
  return isTokenDot(token) || isTokenDot(token.previous);
}

bool testInsideQuotes(DartCompletionRequest request) {
  final token = getCurrentToken(request);
  if (token == null || token.isSynthetic) {
    return false;
  }

  final cursorOffset = request.offset;
  if (cursorOffset == token.offset || cursorOffset == token.offset + token.length) {
    // We are not inside the current token, quoted or otherwise.
    return false;
  }

  final lexeme = token.lexeme;
  if (lexeme.length > 2 && lexeme[0] == 'r') {
    return lexeme[1] == "'" || lexeme[1] == '"';
  }

  return lexeme.length > 1 && (lexeme[0] == "'" || lexeme[0] == '"');
}

/// Tests whether all completion suggestions are for named arguments.
bool testNamedArgument(List<CompletionSuggestion> suggestions) {
  if (suggestions == null) {
    return false;
  }

  return suggestions
      .any((CompletionSuggestion suggestion) => suggestion.kind == CompletionSuggestionKind.NAMED_ARGUMENT);
}

String trimQuotes(String input) {
  final result = input[0] == '\'' ? input.substring(1) : input;
  return result[result.length - 1] == '\'' ? result.substring(0, result.length - 1) : result;
}
