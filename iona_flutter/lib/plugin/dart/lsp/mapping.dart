import 'dart:collection';
import 'dart:math';

import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/src/services/available_declarations.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as server;
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_special.dart';
import 'package:iona_flutter/plugin/dart/lsp/dartdoc.dart';

import '../completion/protocol/protocol_generated.dart' as lsp;
import '../completion/protocol/protocol_generated.dart' show ResponseError;
import '../completion/protocol/protocol_server.dart' as lsp show CompletionItemKind, CompletionSuggestion;
import '../completion/protocol/protocol_special.dart' as lsp;
import 'constants.dart' as lsp;

lsp.Either2<String, lsp.MarkupContent> asStringOrMarkupContent(List<lsp.MarkupKind> preferredFormats, String content) {
  if (content == null) {
    return null;
  }

  return preferredFormats == null
      ? lsp.Either2<String, lsp.MarkupContent>.t1(content)
      : lsp.Either2<String, lsp.MarkupContent>.t2(_asMarkup(preferredFormats, content));
}

/// Returns the file system path for a TextDocumentIdentifier.
ErrorOr<String> pathOfDoc(lsp.TextDocumentIdentifier doc) => pathOfUri(Uri.tryParse(doc?.uri));

/// Returns the file system path for a TextDocumentItem.
//ErrorOr<String> pathOfDocItem(lsp.TextDocumentItem doc) =>
//    pathOfUri(Uri.tryParse(doc?.uri));

/// Returns the file system path for a file URI.
ErrorOr<String> pathOfUri(Uri uri) {
  if (uri == null) {
    return ErrorOr<String>.error(
        ResponseError(lsp.ServerErrorCodes.InvalidFilePath, 'Document URI was not supplied', null));
  }
  final isValidFileUri = (uri?.isScheme('file') ?? false);
  if (!isValidFileUri) {
    return ErrorOr<String>.error(
        ResponseError(lsp.ServerErrorCodes.InvalidFilePath, 'URI was not a valid file:// URI', uri.toString()));
  }
  try {
    return ErrorOr<String>.success(uri.toFilePath());
  } catch (e) {
    // Even if tryParse() works and file == scheme, toFilePath() can throw on
    // Windows if there are invalid characters.
    return ErrorOr<String>.error(ResponseError(
        lsp.ServerErrorCodes.InvalidFilePath, 'File URI did not contain a valid file path', uri.toString()));
  }
}

ErrorOr<int> toOffset(
  LineInfo lineInfo,
  lsp.Position pos, {
  failureIsCritial = false,
}) {
  if (pos.line > lineInfo.lineCount) {
    return ErrorOr<int>.error(lsp.ResponseError(
        failureIsCritial ? lsp.ServerErrorCodes.ClientServerInconsistentState : lsp.ServerErrorCodes.InvalidFileLineCol,
        'Invalid line number',
        pos.line.toString()));
  }
  // TODO(dantup): Is there any way to validate the character? We could ensure
  // it's less than the offset of the next line, but that would only work for
  // all lines except the last one.
  return ErrorOr<int>.success(lineInfo.getOffsetOfLine(pos.line) + pos.character);
}

lsp.CompletionItem toCompletionItem(
  lsp.TextDocumentClientCapabilitiesCompletion completionCapabilities,
  HashSet<lsp.CompletionItemKind> supportedCompletionItemKinds,
  LineInfo lineInfo,
  lsp.CompletionSuggestion suggestion,
  int replacementOffset,
  int replacementLength,
) {
  // Build display labels and text to insert. insertText and filterText may
  // differ from label (for ex. if the label includes things like (…)). If
  // either are missing then label will be used by the client.
  var label = suggestion.displayText ?? suggestion.completion;
  var insertText = suggestion.completion;
  var filterText = suggestion.completion;

  // Trim any trailing comma from the (displayed) label.
  if (label.endsWith(',')) {
    label = label.substring(0, label.length - 1);
  }

  if (suggestion.displayText == null) {
    switch (suggestion.element?.kind) {
      case server.ElementKind.CONSTRUCTOR:
      case server.ElementKind.FUNCTION:
      case server.ElementKind.METHOD:
        label += suggestion.parameterNames?.isNotEmpty ?? false ? '(…)' : '()';
        break;
    }
  }

  final useDeprecated = completionCapabilities?.completionItem?.deprecatedSupport == true;
  final formats = completionCapabilities?.completionItem?.documentationFormat;
  final supportsSnippets = completionCapabilities?.completionItem?.snippetSupport == true;

  final completionKind = suggestion.element != null
      ? elementKindToCompletionItemKind(supportedCompletionItemKinds, suggestion.element.kind)
      : suggestionKindToCompletionItemKind(supportedCompletionItemKinds, suggestion.kind, label);

  var insertTextFormat = lsp.InsertTextFormat.PlainText;
  if (supportsSnippets && suggestion.selectionOffset != 0) {
    insertTextFormat = lsp.InsertTextFormat.Snippet;
    insertText = buildSnippetStringWithSelection(
      suggestion.completion,
      suggestion.selectionOffset,
      suggestion.selectionLength,
    );
  }

  // Because we potentially send thousands of these items, we should minimise
  // the generated JSON as much as possible - for example using nulls in place
  // of empty lists/false where possible.
  return lsp.CompletionItem(
    label,
    completionKind,
    getCompletionDetail(suggestion, completionKind, useDeprecated),
    asStringOrMarkupContent(formats, cleanDartdoc(suggestion.docComplete)),
    useDeprecated && suggestion.isDeprecated ? true : null,
    null, // preselect
    // Relevance is a number, highest being best. LSP does text sort so subtract
    // from a large number so that a text sort will result in the correct order.
    // 555 -> 999455
    //  10 -> 999990
    //   1 -> 999999
    (1000000 - suggestion.relevance).toString(),
    filterText != label ? filterText : null, // filterText uses label if not set
    insertText != label ? insertText : null, // insertText uses label if not set
    insertTextFormat != lsp.InsertTextFormat.PlainText
        ? insertTextFormat
        : null, // Defaults to PlainText if not supplied
    lsp.TextEdit(
      toRange(lineInfo, replacementOffset, replacementLength),
      insertText,
    ),
    null, // additionalTextEdits, used for adding imports, etc.
    null, // commitCharacters
    null, // command
    null, // data, useful for if using lazy resolve, this comes back to us
  );
}

lsp.Range toRange(LineInfo lineInfo, int offset, int length) {
  CharacterLocation start = lineInfo.getLocation(offset);
  CharacterLocation end = lineInfo.getLocation(offset + length);

  return lsp.Range(
    toPosition(start),
    toPosition(end),
  );
}

lsp.Position toPosition(CharacterLocation location) {
  // LSP is zero-based, but analysis server is 1-based.
  return lsp.Position(location.lineNumber - 1, location.columnNumber - 1);
}

lsp.CompletionItemKind elementKindToCompletionItemKind(
  HashSet<lsp.CompletionItemKind> clientSupportedCompletionKinds,
  server.ElementKind kind,
) {
  bool isSupported(lsp.CompletionItemKind kind) => clientSupportedCompletionKinds.contains(kind);

  List<lsp.CompletionItemKind> getKindPreferences() {
    switch (kind) {
      case server.ElementKind.CLASS:
      case server.ElementKind.CLASS_TYPE_ALIAS:
        return const [lsp.CompletionItemKind.Class];
      case server.ElementKind.COMPILATION_UNIT:
        return const [lsp.CompletionItemKind.Module];
      case server.ElementKind.CONSTRUCTOR:
      case server.ElementKind.CONSTRUCTOR_INVOCATION:
        return const [lsp.CompletionItemKind.Constructor];
      case server.ElementKind.ENUM:
      case server.ElementKind.ENUM_CONSTANT:
        return const [lsp.CompletionItemKind.Enum];
      case server.ElementKind.FIELD:
        return const [lsp.CompletionItemKind.Field];
      case server.ElementKind.FILE:
        return const [lsp.CompletionItemKind.File];
      case server.ElementKind.FUNCTION:
        return const [lsp.CompletionItemKind.Function];
      case server.ElementKind.FUNCTION_TYPE_ALIAS:
        return const [lsp.CompletionItemKind.Class];
      case server.ElementKind.GETTER:
        return const [lsp.CompletionItemKind.Property];
      case server.ElementKind.LABEL:
        // There isn't really a good CompletionItemKind for labels so we'll
        // just use the Text option.
        return const [lsp.CompletionItemKind.Text];
      case server.ElementKind.LIBRARY:
        return const [lsp.CompletionItemKind.Module];
      case server.ElementKind.LOCAL_VARIABLE:
        return const [lsp.CompletionItemKind.Variable];
      case server.ElementKind.METHOD:
        return const [lsp.CompletionItemKind.Method];
      case server.ElementKind.MIXIN:
        return const [lsp.CompletionItemKind.Class];
      case server.ElementKind.PARAMETER:
      case server.ElementKind.PREFIX:
        return const [lsp.CompletionItemKind.Variable];
      case server.ElementKind.SETTER:
        return const [lsp.CompletionItemKind.Property];
      case server.ElementKind.TOP_LEVEL_VARIABLE:
        return const [lsp.CompletionItemKind.Variable];
      case server.ElementKind.TYPE_PARAMETER:
        return const [
          lsp.CompletionItemKind.TypeParameter,
          lsp.CompletionItemKind.Variable,
        ];
      case server.ElementKind.UNIT_TEST_GROUP:
      case server.ElementKind.UNIT_TEST_TEST:
        return const [lsp.CompletionItemKind.Method];
      default:
        return const [];
    }
  }

  return getKindPreferences().firstWhere(isSupported, orElse: () => null);
}

lsp.CompletionItemKind suggestionKindToCompletionItemKind(
  HashSet<lsp.CompletionItemKind> clientSupportedCompletionKinds,
  server.CompletionSuggestionKind kind,
  String label,
) {
  bool isSupported(lsp.CompletionItemKind kind) => clientSupportedCompletionKinds.contains(kind);

  List<lsp.CompletionItemKind> getKindPreferences() {
    switch (kind) {
      case server.CompletionSuggestionKind.ARGUMENT_LIST:
        return const [lsp.CompletionItemKind.Variable];
      case server.CompletionSuggestionKind.IMPORT:
        // For package/relative URIs, we can send File/Folder kinds for better icons.
        if (!label.startsWith('dart:')) {
          return label.endsWith('.dart')
              ? const [
                  lsp.CompletionItemKind.File,
                  lsp.CompletionItemKind.Module,
                ]
              : const [
                  lsp.CompletionItemKind.Folder,
                  lsp.CompletionItemKind.Module,
                ];
        }
        return const [lsp.CompletionItemKind.Module];
      case server.CompletionSuggestionKind.IDENTIFIER:
        return const [lsp.CompletionItemKind.Variable];
      case server.CompletionSuggestionKind.INVOCATION:
        return const [lsp.CompletionItemKind.Method];
      case server.CompletionSuggestionKind.KEYWORD:
        return const [lsp.CompletionItemKind.Keyword];
      case server.CompletionSuggestionKind.NAMED_ARGUMENT:
        return const [lsp.CompletionItemKind.Variable];
      case server.CompletionSuggestionKind.OPTIONAL_ARGUMENT:
        return const [lsp.CompletionItemKind.Variable];
      case server.CompletionSuggestionKind.PARAMETER:
        return const [lsp.CompletionItemKind.Value];
      default:
        return const [];
    }
  }

  return getKindPreferences().firstWhere(isSupported, orElse: () => null);
}

String getCompletionDetail(
  server.CompletionSuggestion suggestion,
  lsp.CompletionItemKind completionKind,
  bool clientSupportsDeprecated,
) {
  final hasElement = suggestion.element != null;
  final hasParameters = hasElement && suggestion.element.parameters != null && suggestion.element.parameters.isNotEmpty;
  final hasReturnType = hasElement && suggestion.element.returnType != null && suggestion.element.returnType.isNotEmpty;
  final hasParameterType = suggestion.parameterType != null && suggestion.parameterType.isNotEmpty;

  final prefix = clientSupportsDeprecated || !suggestion.isDeprecated ? '' : '(Deprecated) ';

  if (completionKind == lsp.CompletionItemKind.Property) {
    // Setters appear as methods with one arg but they also cause getters to not
    // appear in the completion list, so displaying them as setters is misleading.
    // To avoid this, always show only the return type, whether it's a getter
    // or a setter.
    return prefix +
        (suggestion.element.kind == server.ElementKind.GETTER
            ? suggestion.element.returnType
            // Don't assume setters always have parameters
            // See https://github.com/dart-lang/sdk/issues/27747
            : suggestion.element.parameters != null && suggestion.element.parameters.isNotEmpty
                // Extract the type part from '(MyType value)`
                ? suggestion.element.parameters.substring(1, suggestion.element.parameters.lastIndexOf(' '))
                : '');
  } else if (hasParameters && hasReturnType) {
    return '$prefix${suggestion.element.parameters} → ${suggestion.element.returnType}';
  } else if (hasReturnType) {
    return '$prefix${suggestion.element.returnType}';
  } else if (hasParameterType) {
    return '$prefix${suggestion.parameterType}';
  } else {
    return prefix.isNotEmpty ? prefix : null;
  }
}

/// Builds an LSP snippet string that uses a $1 tabstop to set the selected text
/// after insertion.
String buildSnippetStringWithSelection(
  String text,
  int selectionOffset,
  int selectionLength,
) {
  String escape(String input) => input.replaceAllMapped(
        RegExp(r'[$}\\]'), // Replace any of $ } \
        (c) => '\\${c[0]}', // Prefix with a backslash
      );
  // Snippets syntax is documented in the LSP spec:
  // https://microsoft.github.io/language-server-protocol/specifications/specification-3-14/#snippet-syntax
  //
  // $1, $2, etc. are used for tab stops and ${1:foo} inserts a placeholder of foo.
  // Since we only need to support a single tab stop, our string is constructed of three parts:
  // - Anything before the selection
  // - The selection (which may or may not include text, depending on selectionLength)
  // - Anything after the selection
  final prefix = escape(text.substring(0, selectionOffset));
  final selectionText = escape(text.substring(selectionOffset, selectionOffset + selectionLength));
  final selection = '\${1:$selectionText}';
  final suffix = escape(text.substring(selectionOffset + selectionLength));

  return '$prefix$selection$suffix';
}

lsp.MarkupContent _asMarkup(List<lsp.MarkupKind> preferredFormats, String content) {
  // It's not valid to call this function with a null format, as null formats
  // do not support MarkupContent. [asStringOrMarkupContent] is probably the
  // better choice.
  assert(preferredFormats != null);

  if (content == null) {
    return null;
  }

  if (preferredFormats.isEmpty) {
    preferredFormats.add(lsp.MarkupKind.Markdown);
  }

  final supportsMarkdown = preferredFormats.contains(lsp.MarkupKind.Markdown);
  final supportsPlain = preferredFormats.contains(lsp.MarkupKind.PlainText);
  // Since our PlainText version is actually just Markdown, only advertise it
  // as PlainText if the client explicitly supports PlainText and not Markdown.
  final format = supportsPlain && !supportsMarkdown ? lsp.MarkupKind.PlainText : lsp.MarkupKind.Markdown;

  return lsp.MarkupContent(format, content);
}

lsp.CompletionItem declarationToCompletionItem(
  lsp.TextDocumentClientCapabilitiesCompletion completionCapabilities,
  HashSet<lsp.CompletionItemKind> supportedCompletionItemKinds,
  String file,
  int offset,
  lsp.IncludedSuggestionSet includedSuggestionSet,
  Library library,
  Map<String, int> tagBoosts,
  LineInfo lineInfo,
  Declaration declaration,
  int replacementOffset,
  int replacementLength,
) {
  // Build display labels and text to insert. insertText and filterText may
  // differ from label (for ex. if the label includes things like (…)). If
  // either are missing then label will be used by the client.
  String label;
  String insertText;
  String filterText;
  switch (declaration.kind) {
    case DeclarationKind.ENUM_CONSTANT:
      label = '${declaration.parent.name}.${declaration.name}';
      break;
    case DeclarationKind.GETTER:
    case DeclarationKind.FIELD:
      label = declaration.parent != null && declaration.parent.name != null && declaration.parent.name.isNotEmpty
          ? '${declaration.parent.name}.${declaration.name}'
          : declaration.name;
      break;
    case DeclarationKind.CONSTRUCTOR:
      label = declaration.parent.name;
      if (declaration.name.isNotEmpty) {
        label += '.${declaration.name}';
      }
      insertText = label;
      filterText = label;
      label += declaration.parameterNames?.isNotEmpty ?? false ? '(…)' : '()';
      break;
    case DeclarationKind.FUNCTION:
      label = declaration.name;
      insertText = label;
      filterText = label;
      label += declaration.parameterNames?.isNotEmpty ?? false ? '(…)' : '()';
      break;
    default:
      label = declaration.name;
  }

  final useDeprecated = completionCapabilities?.completionItem?.deprecatedSupport == true;

  final completionKind = declarationKindToCompletionItemKind(supportedCompletionItemKinds, declaration.kind);

  var relevanceBoost = 0;
  if (declaration.relevanceTags != null) {
    declaration.relevanceTags.forEach((t) => relevanceBoost = max(relevanceBoost, tagBoosts[t] ?? 0));
  }
  final itemRelevance = includedSuggestionSet.relevance + relevanceBoost;

  // Because we potentially send thousands of these items, we should minimise
  // the generated JSON as much as possible - for example using nulls in place
  // of empty lists/false where possible.
  return lsp.CompletionItem(
    label,
    completionKind,
    getDeclarationCompletionDetail(declaration, completionKind, useDeprecated),
    null, // documentation - will be added during resolve.
    useDeprecated && declaration.isDeprecated ? true : null,
    null, // preselect
    // Relevance is a number, highest being best. LSP does text sort so subtract
    // from a large number so that a text sort will result in the correct order.
    // 555 -> 999455
    //  10 -> 999990
    //   1 -> 999999
    (1000000 - itemRelevance).toString(),
    filterText != label ? filterText : null, // filterText uses label if not set
    insertText != label ? insertText : null, // insertText uses label if not set
    null, // insertTextFormat (we always use plain text so can ommit this)
    null, // textEdit - added on during resolve
    null, // additionalTextEdits, used for adding imports, etc.
    null, // commitCharacters
    null, // command
    // data, used for completionItem/resolve.
    lsp.CompletionItemResolutionInfo(file, offset, includedSuggestionSet.id,
        includedSuggestionSet.displayUri ?? library.uri?.toString(), replacementOffset, replacementLength),
  );
}

String getDeclarationCompletionDetail(
  Declaration declaration,
  lsp.CompletionItemKind completionKind,
  bool clientSupportsDeprecated,
) {
  final hasParameters = declaration.parameters != null && declaration.parameters.isNotEmpty;
  final hasReturnType = declaration.returnType != null && declaration.returnType.isNotEmpty;

  final prefix = clientSupportsDeprecated || !declaration.isDeprecated ? '' : '(Deprecated) ';

  if (completionKind == lsp.CompletionItemKind.Property) {
    // Setters appear as methods with one arg but they also cause getters to not
    // appear in the completion list, so displaying them as setters is misleading.
    // To avoid this, always show only the return type, whether it's a getter
    // or a setter.
    var suffix = '';
    if (declaration.kind == DeclarationKind.GETTER) {
      suffix = declaration.returnType;
    } else {
      // Don't assume setters always have parameters
      // See https://github.com/dart-lang/sdk/issues/27747
      if (declaration.parameters != null && declaration.parameters.isNotEmpty) {
        // Extract the type part from `(MyType value)`, if there is a type.
        var spaceIndex = declaration.parameters.lastIndexOf(' ');
        if (spaceIndex > 0) {
          suffix = declaration.parameters.substring(1, spaceIndex);
        }
      }
    }
    return prefix + suffix;
  } else if (hasParameters && hasReturnType) {
    return '$prefix${declaration.parameters} → ${declaration.returnType}';
  } else if (hasReturnType) {
    return '$prefix${declaration.returnType}';
  } else {
    return prefix.isNotEmpty ? prefix : null;
  }
}

lsp.CompletionItemKind declarationKindToCompletionItemKind(
  HashSet<lsp.CompletionItemKind> clientSupportedCompletionKinds,
  DeclarationKind kind,
) {
  bool isSupported(lsp.CompletionItemKind kind) => clientSupportedCompletionKinds.contains(kind);

  List<lsp.CompletionItemKind> getKindPreferences() {
    switch (kind) {
      case DeclarationKind.CLASS:
      case DeclarationKind.CLASS_TYPE_ALIAS:
      case DeclarationKind.MIXIN:
        return const [lsp.CompletionItemKind.Class];
      case DeclarationKind.CONSTRUCTOR:
        return const [lsp.CompletionItemKind.Constructor];
      case DeclarationKind.ENUM:
      case DeclarationKind.ENUM_CONSTANT:
        return const [lsp.CompletionItemKind.Enum];
      case DeclarationKind.FUNCTION:
        return const [lsp.CompletionItemKind.Function];
      case DeclarationKind.FUNCTION_TYPE_ALIAS:
        return const [lsp.CompletionItemKind.Class];
      case DeclarationKind.GETTER:
        return const [lsp.CompletionItemKind.Property];
      case DeclarationKind.SETTER:
        return const [lsp.CompletionItemKind.Property];
      case DeclarationKind.VARIABLE:
        return const [lsp.CompletionItemKind.Variable];
      default:
        return const [];
    }
  }

  return getKindPreferences().firstWhere(isSupported, orElse: () => null);
}
