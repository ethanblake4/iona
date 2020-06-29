import 'dart:convert';

import 'package:analyzer_plugin/src/protocol/protocol_internal.dart' show JsonDecoder, HasToJson;
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_server.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_special.dart';
import 'package:iona_flutter/plugin/dart/utils/utilities_general.dart';

/// IncludedSuggestionRelevanceTag
///
/// {
///   "tag": AvailableSuggestionRelevanceTag
///   "relevanceBoost": int
/// }
///
/// Clients may not extend, implement or mix-in this class.
class IncludedSuggestionRelevanceTag implements HasToJson {
  String _tag;

  int _relevanceBoost;

  /// The opaque value of the tag.
  String get tag => _tag;

  /// The opaque value of the tag.
  set tag(String value) {
    assert(value != null);
    _tag = value;
  }

  /// The boost to the relevance of the completion suggestions that match this
  /// tag, which is added to the relevance of the containing
  /// IncludedSuggestionSet.
  int get relevanceBoost => _relevanceBoost;

  /// The boost to the relevance of the completion suggestions that match this
  /// tag, which is added to the relevance of the containing
  /// IncludedSuggestionSet.
  set relevanceBoost(int value) {
    assert(value != null);
    _relevanceBoost = value;
  }

  IncludedSuggestionRelevanceTag(String tag, int relevanceBoost) {
    this.tag = tag;
    this.relevanceBoost = relevanceBoost;
  }

  factory IncludedSuggestionRelevanceTag.fromJson(JsonDecoder jsonDecoder, String jsonPath, Object json) {
    json ??= {};
    if (json is Map) {
      String tag;
      if (json.containsKey('tag')) {
        tag = jsonDecoder.decodeString(jsonPath + '.tag', json['tag']);
      } else {
        throw jsonDecoder.mismatch(jsonPath, 'tag');
      }
      int relevanceBoost;
      if (json.containsKey('relevanceBoost')) {
        relevanceBoost = jsonDecoder.decodeInt(jsonPath + '.relevanceBoost', json['relevanceBoost']);
      } else {
        throw jsonDecoder.mismatch(jsonPath, 'relevanceBoost');
      }
      return IncludedSuggestionRelevanceTag(tag, relevanceBoost);
    } else {
      throw jsonDecoder.mismatch(jsonPath, 'IncludedSuggestionRelevanceTag', json);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var result = <String, dynamic>{};
    result['tag'] = tag;
    result['relevanceBoost'] = relevanceBoost;
    return result;
  }

  @override
  String toString() => json.encode(toJson());

  @override
  bool operator ==(other) {
    if (other is IncludedSuggestionRelevanceTag) {
      return tag == other.tag && relevanceBoost == other.relevanceBoost;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, tag.hashCode);
    hash = JenkinsSmiHash.combine(hash, relevanceBoost.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class CompletionItem {
  CompletionItem(
      this.label,
      this.kind,
      this.detail,
      this.documentation,
      this.deprecated,
      this.preselect,
      this.sortText,
      this.filterText,
      this.insertText,
      this.insertTextFormat,
      this.textEdit,
      this.additionalTextEdits,
      this.commitCharacters,
      this.command,
      this.data) {
    if (label == null) {
      throw 'label is required but was not provided';
    }
  }

  /// An optional array of additional text edits that are applied when selecting
  /// this completion. Edits must not overlap (including the same insert
  /// position) with the main edit nor with themselves.
  ///
  /// Additional text edits should be used to change text unrelated to the
  /// current cursor position (for example adding an import statement at the top
  /// of the file if the completion item will insert an unqualified type).
  final List<TextEdit> additionalTextEdits;

  /// An optional command that is executed *after* inserting this completion.
  /// *Note* that additional modifications to the current document should be
  /// described with the additionalTextEdits-property.
  final Command command;

  /// An optional set of characters that when pressed while this completion is
  /// active will accept it first and then type that character. *Note* that all
  /// commit characters should have `length=1` and that superfluous characters
  /// will be ignored.
  final List<String> commitCharacters;

  /// A data entry field that is preserved on a completion item between a
  /// completion and a completion resolve request.
  final CompletionItemResolutionInfo data;

  /// Indicates if this item is deprecated.
  final bool deprecated;

  /// A human-readable string with additional information about this item, like
  /// type or symbol information.
  final String detail;

  /// A human-readable string that represents a doc-comment.
  final Either2<String, MarkupContent> documentation;

  /// A string that should be used when filtering a set of completion items.
  /// When `falsy` the label is used.
  final String filterText;

  /// A string that should be inserted into a document when selecting this
  /// completion. When `falsy` the label is used.
  ///
  /// The `insertText` is subject to interpretation by the client side. Some
  /// tools might not take the string literally. For example VS Code when code
  /// complete is requested in this example `con<cursor position>` and a
  /// completion item with an `insertText` of `console` is provided it will only
  /// insert `sole`. Therefore it is recommended to use `textEdit` instead since
  /// it avoids additional client side interpretation.
  final String insertText;

  /// The format of the insert text. The format applies to both the `insertText`
  /// property and the `newText` property of a provided `textEdit`. If ommitted
  /// defaults to `InsertTextFormat.PlainText`.
  final InsertTextFormat insertTextFormat;

  /// The kind of this completion item. Based of the kind an icon is chosen by
  /// the editor. The standardized set of available values is defined in
  /// `CompletionItemKind`.
  final CompletionItemKind kind;

  /// The label of this completion item. By default also the text that is
  /// inserted when selecting this completion.
  final String label;

  /// Select this item when showing.
  ///
  /// *Note* that only one completion item can be selected and that the tool /
  /// client decides which item that is. The rule is that the *first* item of
  /// those that match best is selected.
  final bool preselect;

  /// A string that should be used when comparing this item with other items.
  /// When `falsy` the label is used.
  final String sortText;

  /// An edit which is applied to a document when selecting this completion.
  /// When an edit is provided the value of `insertText` is ignored.
  ///
  /// *Note:* The range of the edit must be a single line range and it must
  /// contain the position at which completion has been requested.
  final TextEdit textEdit;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['label'] = label ?? (throw 'label is required but was not set');
    if (kind != null) {
      __result['kind'] = kind;
    }
    if (detail != null) {
      __result['detail'] = detail;
    }
    if (documentation != null) {
      __result['documentation'] = documentation;
    }
    if (deprecated != null) {
      __result['deprecated'] = deprecated;
    }
    if (preselect != null) {
      __result['preselect'] = preselect;
    }
    if (sortText != null) {
      __result['sortText'] = sortText;
    }
    if (filterText != null) {
      __result['filterText'] = filterText;
    }
    if (insertText != null) {
      __result['insertText'] = insertText;
    }
    if (insertTextFormat != null) {
      __result['insertTextFormat'] = insertTextFormat;
    }
    if (textEdit != null) {
      __result['textEdit'] = textEdit;
    }
    if (additionalTextEdits != null) {
      __result['additionalTextEdits'] = additionalTextEdits;
    }
    if (commitCharacters != null) {
      __result['commitCharacters'] = commitCharacters;
    }
    if (command != null) {
      __result['command'] = command;
    }
    if (data != null) {
      __result['data'] = data;
    }
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is CompletionItem && other.runtimeType == CompletionItem) {
      return label == other.label &&
          kind == other.kind &&
          detail == other.detail &&
          documentation == other.documentation &&
          deprecated == other.deprecated &&
          preselect == other.preselect &&
          sortText == other.sortText &&
          filterText == other.filterText &&
          insertText == other.insertText &&
          insertTextFormat == other.insertTextFormat &&
          textEdit == other.textEdit &&
          listEqual(additionalTextEdits, other.additionalTextEdits, (TextEdit a, TextEdit b) => a == b) &&
          listEqual(commitCharacters, other.commitCharacters, (String a, String b) => a == b) &&
          command == other.command &&
          data == other.data &&
          true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, label.hashCode);
    hash = JenkinsSmiHash.combine(hash, kind.hashCode);
    hash = JenkinsSmiHash.combine(hash, detail.hashCode);
    hash = JenkinsSmiHash.combine(hash, documentation.hashCode);
    hash = JenkinsSmiHash.combine(hash, deprecated.hashCode);
    hash = JenkinsSmiHash.combine(hash, preselect.hashCode);
    hash = JenkinsSmiHash.combine(hash, sortText.hashCode);
    hash = JenkinsSmiHash.combine(hash, filterText.hashCode);
    hash = JenkinsSmiHash.combine(hash, insertText.hashCode);
    hash = JenkinsSmiHash.combine(hash, insertTextFormat.hashCode);
    hash = JenkinsSmiHash.combine(hash, textEdit.hashCode);
    hash = JenkinsSmiHash.combine(hash, lspHashCode(additionalTextEdits));
    hash = JenkinsSmiHash.combine(hash, lspHashCode(commitCharacters));
    hash = JenkinsSmiHash.combine(hash, command.hashCode);
    hash = JenkinsSmiHash.combine(hash, data.hashCode);
    return JenkinsSmiHash.finish(hash);
  }

  @override
  String toString() {
    return 'CompletionItem{additionalTextEdits: $additionalTextEdits, command: $command, commitCharacters: $commitCharacters, data: $data, deprecated: $deprecated, detail: $detail, documentation: $documentation, filterText: $filterText, insertText: $insertText, insertTextFormat: $insertTextFormat, kind: $kind, label: $label, preselect: $preselect, sortText: $sortText, textEdit: $textEdit}';
  }
}

/// Defines whether the insert text in a completion item should be interpreted
/// as plain text or a snippet.
class InsertTextFormat {
  const InsertTextFormat._(this._value);
  const InsertTextFormat.fromJson(this._value);

  final num _value;

  /// The primary text to be inserted is treated as a plain string.
  static const PlainText = InsertTextFormat._(1);

  /// The primary text to be inserted is treated as a snippet.
  ///
  /// A snippet can define tab stops and placeholders with `$1`, `$2` and
  /// `${3:foo}`. `$0` defines the final tab stop, it defaults to the end of the
  /// snippet. Placeholders with equal identifiers are linked, that is typing in
  /// one will update others too.
  static const Snippet = InsertTextFormat._(2);

  Object toJson() => _value;

  @override
  String toString() => _value.toString();

  @override
  int get hashCode => _value.hashCode;

  bool operator ==(Object o) => o is InsertTextFormat && o._value == _value;
}

/// A `MarkupContent` literal represents a string value which content is
/// interpreted base on its kind flag. Currently the protocol supports
/// `plaintext` and `markdown` as markup kinds.
///
/// If the kind is `markdown` then the value can contain fenced code blocks like
/// in GitHub issues. See
/// https://help.github.com/articles/creating-and-highlighting-code-blocks/#syntax-highlighting
///
/// Here is an example how such a string can be constructed using JavaScript /
/// TypeScript: ```typescript let markdown: MarkdownContent = {
///
/// kind: MarkupKind.Markdown,
/// 	value: [
/// 		'# Header',
/// 		'Some text',
/// 		'```typescript',
/// 		'someCode();',
/// 		'```'
/// 	].join('\n') }; ```
///
/// *Please Note* that clients might sanitize the return markdown. A client
/// could decide to remove HTML from the markdown to avoid script execution.
class MarkupContent {
  MarkupContent(this.kind, this.value) {
    if (kind == null) {
      throw 'kind is required but was not provided';
    }
    if (value == null) {
      throw 'value is required but was not provided';
    }
  }

  /// The type of the Markup
  final MarkupKind kind;

  /// The content itself
  final String value;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['kind'] = kind ?? (throw 'kind is required but was not set');
    __result['value'] = value ?? (throw 'value is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is MarkupContent && other.runtimeType == MarkupContent) {
      return kind == other.kind && value == other.value && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, kind.hashCode);
    hash = JenkinsSmiHash.combine(hash, value.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

/// Describes the content type that a client supports in various result literals
/// like `Hover`, `ParameterInfo` or `CompletionItem`.
///
/// Please note that `MarkupKinds` must not start with a `$`. This kinds are
/// reserved for internal usage.
class MarkupKind {
  const MarkupKind._(this._value);

  final String _value;

  /// Plain text is supported as a content format
  static const PlainText = MarkupKind._(r'plaintext');

  /// Markdown is supported as a content format
  static const Markdown = MarkupKind._(r'markdown');

  @override
  String toString() => _value.toString();

  @override
  int get hashCode => _value.hashCode;

  bool operator ==(Object o) => o is MarkupKind && o._value == _value;
}

class CompletionItemResolutionInfo {
  CompletionItemResolutionInfo(this.file, this.offset, this.libId, this.displayUri, this.rOffset, this.rLength) {
    if (file == null) {
      throw 'file is required but was not provided';
    }
    if (offset == null) {
      throw 'offset is required but was not provided';
    }
    if (libId == null) {
      throw 'libId is required but was not provided';
    }
    if (displayUri == null) {
      throw 'displayUri is required but was not provided';
    }
    if (rOffset == null) {
      throw 'rOffset is required but was not provided';
    }
    if (rLength == null) {
      throw 'rLength is required but was not provided';
    }
  }
  static CompletionItemResolutionInfo fromJson(Map<String, dynamic> json) {
    final file = json['file'];
    final offset = json['offset'];
    final libId = json['libId'];
    final displayUri = json['displayUri'];
    final rOffset = json['rOffset'];
    final rLength = json['rLength'];
    return CompletionItemResolutionInfo(file, offset, libId, displayUri, rOffset, rLength);
  }

  final String displayUri;
  final String file;
  final num libId;
  final num offset;
  final num rLength;
  final num rOffset;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['file'] = file ?? (throw 'file is required but was not set');
    __result['offset'] = offset ?? (throw 'offset is required but was not set');
    __result['libId'] = libId ?? (throw 'libId is required but was not set');
    __result['displayUri'] = displayUri ?? (throw 'displayUri is required but was not set');
    __result['rOffset'] = rOffset ?? (throw 'rOffset is required but was not set');
    __result['rLength'] = rLength ?? (throw 'rLength is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is CompletionItemResolutionInfo && other.runtimeType == CompletionItemResolutionInfo) {
      return file == other.file &&
          offset == other.offset &&
          libId == other.libId &&
          displayUri == other.displayUri &&
          rOffset == other.rOffset &&
          rLength == other.rLength &&
          true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, file.hashCode);
    hash = JenkinsSmiHash.combine(hash, offset.hashCode);
    hash = JenkinsSmiHash.combine(hash, libId.hashCode);
    hash = JenkinsSmiHash.combine(hash, displayUri.hashCode);
    hash = JenkinsSmiHash.combine(hash, rOffset.hashCode);
    hash = JenkinsSmiHash.combine(hash, rLength.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class Command {
  Command(this.title, this.command, this.arguments) {
    if (title == null) {
      throw 'title is required but was not provided';
    }
    if (command == null) {
      throw 'command is required but was not provided';
    }
  }

  /// Arguments that the command handler should be invoked with.
  final List<dynamic> arguments;

  /// The identifier of the actual command handler.
  final String command;

  /// Title of the command, like `save`.
  final String title;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['title'] = title ?? (throw 'title is required but was not set');
    __result['command'] = command ?? (throw 'command is required but was not set');
    if (arguments != null) {
      __result['arguments'] = arguments;
    }
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is Command && other.runtimeType == Command) {
      return title == other.title &&
          command == other.command &&
          listEqual(arguments, other.arguments, (dynamic a, dynamic b) => a == b) &&
          true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, title.hashCode);
    hash = JenkinsSmiHash.combine(hash, command.hashCode);
    hash = JenkinsSmiHash.combine(hash, lspHashCode(arguments));
    return JenkinsSmiHash.finish(hash);
  }
}

class TextEdit {
  TextEdit(this.range, this.newText) {
    if (range == null) {
      throw 'range is required but was not provided';
    }
    if (newText == null) {
      throw 'newText is required but was not provided';
    }
  }

  /// The string to be inserted. For delete operations use an empty string.
  final String newText;

  /// The range of the text document to be manipulated. To insert text into a
  /// document create a range where start === end.
  final Range range;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['range'] = range ?? (throw 'range is required but was not set');
    __result['newText'] = newText ?? (throw 'newText is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is TextEdit && other.runtimeType == TextEdit) {
      return range == other.range && newText == other.newText && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, range.hashCode);
    hash = JenkinsSmiHash.combine(hash, newText.hashCode);
    return JenkinsSmiHash.finish(hash);
  }

  @override
  String toString() {
    return 'TextEdit{newText: $newText, range: $range}';
  }
}

class TextDocumentPositionParams {
  TextDocumentPositionParams(this.textDocument, this.position) {
    if (textDocument == null) {
      throw 'textDocument is required but was not provided';
    }
    if (position == null) {
      throw 'position is required but was not provided';
    }
  }

  /// The position inside the text document.
  final Position position;

  /// The text document.
  final TextDocumentIdentifier textDocument;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['textDocument'] = textDocument ?? (throw 'textDocument is required but was not set');
    __result['position'] = position ?? (throw 'position is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is TextDocumentPositionParams && other.runtimeType == TextDocumentPositionParams) {
      return textDocument == other.textDocument && position == other.position && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, textDocument.hashCode);
    hash = JenkinsSmiHash.combine(hash, position.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class CompletionParams implements TextDocumentPositionParams {
  CompletionParams(this.context, this.textDocument, this.position) {
    if (textDocument == null) {
      throw 'textDocument is required but was not provided';
    }
    if (position == null) {
      throw 'position is required but was not provided';
    }
  }

  /// The completion context. This is only available if the client specifies to
  /// send this using `ClientCapabilities.textDocument.completion.contextSupport
  /// === true`
  final CompletionContext context;

  /// The position inside the text document.
  final Position position;

  /// The text document.
  final TextDocumentIdentifier textDocument;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    if (context != null) {
      __result['context'] = context;
    }
    __result['textDocument'] = textDocument ?? (throw 'textDocument is required but was not set');
    __result['position'] = position ?? (throw 'position is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is CompletionParams && other.runtimeType == CompletionParams) {
      return context == other.context && textDocument == other.textDocument && position == other.position && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, context.hashCode);
    hash = JenkinsSmiHash.combine(hash, textDocument.hashCode);
    hash = JenkinsSmiHash.combine(hash, position.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

/// Contains additional information about the context in which a completion
/// request is triggered.
class CompletionContext {
  CompletionContext(this.triggerKind, this.triggerCharacter) {
    if (triggerKind == null) {
      throw 'triggerKind is required but was not provided';
    }
  }

  /// The trigger character (a single character) that has trigger code complete.
  /// Is undefined if `triggerKind !== CompletionTriggerKind.TriggerCharacter`
  final String triggerCharacter;

  /// How the completion was triggered.
  final CompletionTriggerKind triggerKind;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['triggerKind'] = triggerKind ?? (throw 'triggerKind is required but was not set');
    if (triggerCharacter != null) {
      __result['triggerCharacter'] = triggerCharacter;
    }
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is CompletionContext && other.runtimeType == CompletionContext) {
      return triggerKind == other.triggerKind && triggerCharacter == other.triggerCharacter && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, triggerKind.hashCode);
    hash = JenkinsSmiHash.combine(hash, triggerCharacter.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class TextDocumentClientCapabilitiesCompletion {
  TextDocumentClientCapabilitiesCompletion(
      this.dynamicRegistration, this.completionItem, this.completionItemKind, this.contextSupport);

  /// The client supports the following `CompletionItem` specific capabilities.
  final TextDocumentClientCapabilitiesCompletionItem completionItem;
  final TextDocumentClientCapabilitiesCompletionItemKind completionItemKind;

  /// The client supports to send additional context information for a
  /// `textDocument/completion` request.
  final bool contextSupport;

  /// Whether completion supports dynamic registration.
  final bool dynamicRegistration;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    if (dynamicRegistration != null) {
      __result['dynamicRegistration'] = dynamicRegistration;
    }
    if (completionItem != null) {
      __result['completionItem'] = completionItem;
    }
    if (completionItemKind != null) {
      __result['completionItemKind'] = completionItemKind;
    }
    if (contextSupport != null) {
      __result['contextSupport'] = contextSupport;
    }
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is TextDocumentClientCapabilitiesCompletion &&
        other.runtimeType == TextDocumentClientCapabilitiesCompletion) {
      return dynamicRegistration == other.dynamicRegistration &&
          completionItem == other.completionItem &&
          completionItemKind == other.completionItemKind &&
          contextSupport == other.contextSupport &&
          true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, dynamicRegistration.hashCode);
    hash = JenkinsSmiHash.combine(hash, completionItem.hashCode);
    hash = JenkinsSmiHash.combine(hash, completionItemKind.hashCode);
    hash = JenkinsSmiHash.combine(hash, contextSupport.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class IncludedSuggestionSet implements HasToJson {
  int _id;

  int _relevance;

  String _displayUri;

  /// Clients should use it to access the set of precomputed completions to be
  /// displayed to the user.
  int get id => _id;

  /// Clients should use it to access the set of precomputed completions to be
  /// displayed to the user.
  set id(int value) {
    assert(value != null);
    _id = value;
  }

  /// The relevance of completion suggestions from this library where a higher
  /// number indicates a higher relevance.
  int get relevance => _relevance;

  /// The relevance of completion suggestions from this library where a higher
  /// number indicates a higher relevance.
  set relevance(int value) {
    assert(value != null);
    _relevance = value;
  }

  /// The optional string that should be displayed instead of the uri of the
  /// referenced AvailableSuggestionSet.
  ///
  /// For example libraries in the "test" directory of a package have only
  /// "file://" URIs, so are usually long, and don't look nice, but actual
  /// import directives will use relative URIs, which are short, so we probably
  /// want to display such relative URIs to the user.
  String get displayUri => _displayUri;

  /// The optional string that should be displayed instead of the uri of the
  /// referenced AvailableSuggestionSet.
  ///
  /// For example libraries in the "test" directory of a package have only
  /// "file://" URIs, so are usually long, and don't look nice, but actual
  /// import directives will use relative URIs, which are short, so we probably
  /// want to display such relative URIs to the user.
  set displayUri(String value) {
    _displayUri = value;
  }

  IncludedSuggestionSet(int id, int relevance, {String displayUri}) {
    this.id = id;
    this.relevance = relevance;
    this.displayUri = displayUri;
  }

  factory IncludedSuggestionSet.fromJson(JsonDecoder jsonDecoder, String jsonPath, Object json) {
    json ??= {};
    if (json is Map) {
      int id;
      if (json.containsKey('id')) {
        id = jsonDecoder.decodeInt(jsonPath + '.id', json['id']);
      } else {
        throw jsonDecoder.mismatch(jsonPath, 'id');
      }
      int relevance;
      if (json.containsKey('relevance')) {
        relevance = jsonDecoder.decodeInt(jsonPath + '.relevance', json['relevance']);
      } else {
        throw jsonDecoder.mismatch(jsonPath, 'relevance');
      }
      String displayUri;
      if (json.containsKey('displayUri')) {
        displayUri = jsonDecoder.decodeString(jsonPath + '.displayUri', json['displayUri']);
      }
      return IncludedSuggestionSet(id, relevance, displayUri: displayUri);
    } else {
      throw jsonDecoder.mismatch(jsonPath, 'IncludedSuggestionSet', json);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var result = <String, dynamic>{};
    result['id'] = id;
    result['relevance'] = relevance;
    if (displayUri != null) {
      result['displayUri'] = displayUri;
    }
    return result;
  }

  @override
  String toString() => json.encode(toJson());

  @override
  bool operator ==(other) {
    if (other is IncludedSuggestionSet) {
      return id == other.id && relevance == other.relevance && displayUri == other.displayUri;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, id.hashCode);
    hash = JenkinsSmiHash.combine(hash, relevance.hashCode);
    hash = JenkinsSmiHash.combine(hash, displayUri.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class Range {
  Range(this.start, this.end) {
    if (start == null) {
      throw 'start is required but was not provided';
    }
    if (end == null) {
      throw 'end is required but was not provided';
    }
  }
  static Range fromJson(Map<String, dynamic> json) {
    final start = json['start'] != null ? Position.fromJson(json['start']) : null;
    final end = json['end'] != null ? Position.fromJson(json['end']) : null;
    return Range(start, end);
  }

  /// The range's end position.
  final Position end;

  /// The range's start position.
  final Position start;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['start'] = start ?? (throw 'start is required but was not set');
    __result['end'] = end ?? (throw 'end is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is Range && other.runtimeType == Range) {
      return start == other.start && end == other.end && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, start.hashCode);
    hash = JenkinsSmiHash.combine(hash, end.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class TextDocumentClientCapabilitiesCompletionItem {
  TextDocumentClientCapabilitiesCompletionItem(this.snippetSupport, this.commitCharactersSupport,
      this.documentationFormat, this.deprecatedSupport, this.preselectSupport);

  /// The client supports commit characters on a completion item.
  final bool commitCharactersSupport;

  /// The client supports the deprecated property on a completion item.
  final bool deprecatedSupport;

  /// The client supports the following content formats for the documentation
  /// property. The order describes the preferred format of the client.
  final List<MarkupKind> documentationFormat;

  /// The client supports the preselect property on a completion item.
  final bool preselectSupport;

  /// The client supports snippets as insert text.
  ///
  /// A snippet can define tab stops and placeholders with `$1`, `$2` and
  /// `${3:foo}`. `$0` defines the final tab stop, it defaults to the end of the
  /// snippet. Placeholders with equal identifiers are linked, that is typing in
  /// one will update others too.
  final bool snippetSupport;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    if (snippetSupport != null) {
      __result['snippetSupport'] = snippetSupport;
    }
    if (commitCharactersSupport != null) {
      __result['commitCharactersSupport'] = commitCharactersSupport;
    }
    if (documentationFormat != null) {
      __result['documentationFormat'] = documentationFormat;
    }
    if (deprecatedSupport != null) {
      __result['deprecatedSupport'] = deprecatedSupport;
    }
    if (preselectSupport != null) {
      __result['preselectSupport'] = preselectSupport;
    }
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is TextDocumentClientCapabilitiesCompletionItem &&
        other.runtimeType == TextDocumentClientCapabilitiesCompletionItem) {
      return snippetSupport == other.snippetSupport &&
          commitCharactersSupport == other.commitCharactersSupport &&
          listEqual(documentationFormat, other.documentationFormat, (MarkupKind a, MarkupKind b) => a == b) &&
          deprecatedSupport == other.deprecatedSupport &&
          preselectSupport == other.preselectSupport &&
          true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, snippetSupport.hashCode);
    hash = JenkinsSmiHash.combine(hash, commitCharactersSupport.hashCode);
    hash = JenkinsSmiHash.combine(hash, lspHashCode(documentationFormat));
    hash = JenkinsSmiHash.combine(hash, deprecatedSupport.hashCode);
    hash = JenkinsSmiHash.combine(hash, preselectSupport.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class TextDocumentClientCapabilitiesCompletionItemKind {
  TextDocumentClientCapabilitiesCompletionItemKind(this.valueSet);
  static TextDocumentClientCapabilitiesCompletionItemKind fromJson(Map<String, dynamic> json) {
    final valueSet = json['valueSet']
        ?.map((item) => item != null ? CompletionItemKind.fromJson(item) : null)
        ?.cast<CompletionItemKind>()
        ?.toList();
    return TextDocumentClientCapabilitiesCompletionItemKind(valueSet);
  }

  /// The completion item kind values the client supports. When this property
  /// exists the client also guarantees that it will handle values outside its
  /// set gracefully and falls back to a default value when unknown.
  ///
  /// If this property is not present the client only supports the completion
  /// items kinds from `Text` to `Reference` as defined in the initial version
  /// of the protocol.
  final List<CompletionItemKind> valueSet;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    if (valueSet != null) {
      __result['valueSet'] = valueSet;
    }
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is TextDocumentClientCapabilitiesCompletionItemKind &&
        other.runtimeType == TextDocumentClientCapabilitiesCompletionItemKind) {
      return listEqual(valueSet, other.valueSet, (CompletionItemKind a, CompletionItemKind b) => a == b) && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, lspHashCode(valueSet));
    return JenkinsSmiHash.finish(hash);
  }
}

/// How a completion was triggered
class CompletionTriggerKind {
  const CompletionTriggerKind._(this._value);
  const CompletionTriggerKind.fromJson(this._value);

  final num _value;

  /// Completion was triggered by typing an identifier (24x7 code complete),
  /// manual invocation (e.g Ctrl+Space) or via API.
  static const Invoked = CompletionTriggerKind._(1);

  /// Completion was triggered by a trigger character specified by the
  /// `triggerCharacters` properties of the `CompletionRegistrationOptions`.
  static const TriggerCharacter = CompletionTriggerKind._(2);

  /// Completion was re-triggered as the current completion list is incomplete.
  static const TriggerForIncompleteCompletions = CompletionTriggerKind._(3);

  Object toJson() => _value;

  @override
  String toString() => _value.toString();

  @override
  int get hashCode => _value.hashCode;

  bool operator ==(Object o) => o is CompletionTriggerKind && o._value == _value;
}

class TextDocumentIdentifier {
  TextDocumentIdentifier(this.uri) {
    if (uri == null) {
      throw 'uri is required but was not provided';
    }
  }

  /// The text document's URI.
  final String uri;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['uri'] = uri ?? (throw 'uri is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is TextDocumentIdentifier && other.runtimeType == TextDocumentIdentifier) {
      return uri == other.uri && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, uri.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class VersionedTextDocumentIdentifier implements TextDocumentIdentifier {
  VersionedTextDocumentIdentifier(this.version, this.uri) {
    if (uri == null) {
      throw 'uri is required but was not provided';
    }
  }
  static VersionedTextDocumentIdentifier fromJson(Map<String, dynamic> json) {
    final version = json['version'];
    final uri = json['uri'];
    return VersionedTextDocumentIdentifier(version, uri);
  }

  /// The text document's URI.
  final String uri;

  /// The version number of this document. If a versioned text document
  /// identifier is sent from the server to the client and the file is not open
  /// in the editor (the server has not received an open notification before)
  /// the server can send `null` to indicate that the version is known and the
  /// content on disk is the truth (as speced with document content ownership).
  ///
  /// The version number of a document will increase after each change,
  /// including undo/redo. The number doesn't need to be consecutive.
  final num version;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['version'] = version;
    __result['uri'] = uri ?? (throw 'uri is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is VersionedTextDocumentIdentifier && other.runtimeType == VersionedTextDocumentIdentifier) {
      return version == other.version && uri == other.uri && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, version.hashCode);
    hash = JenkinsSmiHash.combine(hash, uri.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class Position {
  Position(this.line, this.character) {
    if (line == null) {
      throw 'line is required but was not provided';
    }
    if (character == null) {
      throw 'character is required but was not provided';
    }
  }
  static Position fromJson(Map<String, dynamic> json) {
    final line = json['line'];
    final character = json['character'];
    return Position(line, character);
  }

  /// Character offset on a line in a document (zero-based). Assuming that the
  /// line is represented as a string, the `character` value represents the gap
  /// between the `character` and `character + 1`.
  ///
  /// If the character value is greater than the line length it defaults back to
  /// the line length.
  final num character;

  /// Line position in a document (zero-based).
  final num line;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['line'] = line ?? (throw 'line is required but was not set');
    __result['character'] = character ?? (throw 'character is required but was not set');
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is Position && other.runtimeType == Position) {
      return line == other.line && character == other.character && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, line.hashCode);
    hash = JenkinsSmiHash.combine(hash, character.hashCode);
    return JenkinsSmiHash.finish(hash);
  }

  //@override
  //String toString() => jsonEncoder.convert(toJson());
}

class ResponseError<D> {
  ResponseError(this.code, this.message, this.data) {
    if (code == null) {
      throw 'code is required but was not provided';
    }
    if (message == null) {
      throw 'message is required but was not provided';
    }
  }

  /// A number indicating the error type that occurred.
  final ErrorCodes code;

  /// A string that contains additional information about the error. Can be
  /// omitted.
  final String data;

  /// A string providing a short description of the error.
  final String message;

  Map<String, dynamic> toJson() {
    var __result = <String, dynamic>{};
    __result['code'] = code ?? (throw 'code is required but was not set');
    __result['message'] = message ?? (throw 'message is required but was not set');
    if (data != null) {
      __result['data'] = data;
    }
    return __result;
  }

  @override
  bool operator ==(Object other) {
    if (other is ResponseError && other.runtimeType == ResponseError) {
      return code == other.code && message == other.message && data == other.data && true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, code.hashCode);
    hash = JenkinsSmiHash.combine(hash, message.hashCode);
    hash = JenkinsSmiHash.combine(hash, data.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}

class ErrorCodes {
  const ErrorCodes(this._value);
  const ErrorCodes.fromJson(this._value);

  final num _value;

  /// Defined by JSON RPC
  static const ParseError = ErrorCodes(-32700);
  static const InvalidRequest = ErrorCodes(-32600);
  static const MethodNotFound = ErrorCodes(-32601);
  static const InvalidParams = ErrorCodes(-32602);
  static const InternalError = ErrorCodes(-32603);
  static const serverErrorStart = ErrorCodes(-32099);
  static const serverErrorEnd = ErrorCodes(-32000);
  static const ServerNotInitialized = ErrorCodes(-32002);
  static const UnknownErrorCode = ErrorCodes(-32001);

  /// Defined by the protocol.
  static const RequestCancelled = ErrorCodes(-32800);
  static const ContentModified = ErrorCodes(-32801);

  Object toJson() => _value;

  @override
  String toString() => _value.toString();

  @override
  int get hashCode => _value.hashCode;

  bool operator ==(Object o) => o is ErrorCodes && o._value == _value;
}

/// HoverInformation
///
/// {
///   "offset": int
///   "length": int
///   "containingLibraryPath": optional String
///   "containingLibraryName": optional String
///   "containingClassDescription": optional String
///   "dartdoc": optional String
///   "elementDescription": optional String
///   "elementKind": optional String
///   "isDeprecated": optional bool
///   "parameter": optional String
///   "propagatedType": optional String
///   "staticType": optional String
/// }
///
/// Clients may not extend, implement or mix-in this class.
class HoverInformation implements HasToJson {
  int _offset;

  int _length;

  String _containingLibraryPath;

  String _containingLibraryName;

  String _containingClassDescription;

  String _dartdoc;

  String _elementDescription;

  String _elementKind;

  bool _isDeprecated;

  String _parameter;

  String _propagatedType;

  String _staticType;

  /// The offset of the range of characters that encompasses the cursor
  /// position and has the same hover information as the cursor position.
  int get offset => _offset;

  /// The offset of the range of characters that encompasses the cursor
  /// position and has the same hover information as the cursor position.
  set offset(int value) {
    assert(value != null);
    _offset = value;
  }

  /// The length of the range of characters that encompasses the cursor
  /// position and has the same hover information as the cursor position.
  int get length => _length;

  /// The length of the range of characters that encompasses the cursor
  /// position and has the same hover information as the cursor position.
  set length(int value) {
    assert(value != null);
    _length = value;
  }

  /// The path to the defining compilation unit of the library in which the
  /// referenced element is declared. This data is omitted if there is no
  /// referenced element, or if the element is declared inside an HTML file.
  String get containingLibraryPath => _containingLibraryPath;

  /// The path to the defining compilation unit of the library in which the
  /// referenced element is declared. This data is omitted if there is no
  /// referenced element, or if the element is declared inside an HTML file.
  set containingLibraryPath(String value) {
    _containingLibraryPath = value;
  }

  /// The URI of the containing library, examples here include "dart:core",
  /// "package:.." and file uris represented by the path on disk, "/..". The
  /// data is omitted if the element is declared inside an HTML file.
  String get containingLibraryName => _containingLibraryName;

  /// The URI of the containing library, examples here include "dart:core",
  /// "package:.." and file uris represented by the path on disk, "/..". The
  /// data is omitted if the element is declared inside an HTML file.
  set containingLibraryName(String value) {
    _containingLibraryName = value;
  }

  /// A human-readable description of the class declaring the element being
  /// referenced. This data is omitted if there is no referenced element, or if
  /// the element is not a class member.
  String get containingClassDescription => _containingClassDescription;

  /// A human-readable description of the class declaring the element being
  /// referenced. This data is omitted if there is no referenced element, or if
  /// the element is not a class member.
  set containingClassDescription(String value) {
    _containingClassDescription = value;
  }

  /// The dartdoc associated with the referenced element. Other than the
  /// removal of the comment delimiters, including leading asterisks in the
  /// case of a block comment, the dartdoc is unprocessed markdown. This data
  /// is omitted if there is no referenced element, or if the element has no
  /// dartdoc.
  String get dartdoc => _dartdoc;

  /// The dartdoc associated with the referenced element. Other than the
  /// removal of the comment delimiters, including leading asterisks in the
  /// case of a block comment, the dartdoc is unprocessed markdown. This data
  /// is omitted if there is no referenced element, or if the element has no
  /// dartdoc.
  set dartdoc(String value) {
    _dartdoc = value;
  }

  /// A human-readable description of the element being referenced. This data
  /// is omitted if there is no referenced element.
  String get elementDescription => _elementDescription;

  /// A human-readable description of the element being referenced. This data
  /// is omitted if there is no referenced element.
  set elementDescription(String value) {
    _elementDescription = value;
  }

  /// A human-readable description of the kind of element being referenced
  /// (such as "class" or "function type alias"). This data is omitted if there
  /// is no referenced element.
  String get elementKind => _elementKind;

  /// A human-readable description of the kind of element being referenced
  /// (such as "class" or "function type alias"). This data is omitted if there
  /// is no referenced element.
  set elementKind(String value) {
    _elementKind = value;
  }

  /// True if the referenced element is deprecated.
  bool get isDeprecated => _isDeprecated;

  /// True if the referenced element is deprecated.
  set isDeprecated(bool value) {
    _isDeprecated = value;
  }

  /// A human-readable description of the parameter corresponding to the
  /// expression being hovered over. This data is omitted if the location is
  /// not in an argument to a function.
  String get parameter => _parameter;

  /// A human-readable description of the parameter corresponding to the
  /// expression being hovered over. This data is omitted if the location is
  /// not in an argument to a function.
  set parameter(String value) {
    _parameter = value;
  }

  /// The name of the propagated type of the expression. This data is omitted
  /// if the location does not correspond to an expression or if there is no
  /// propagated type information.
  String get propagatedType => _propagatedType;

  /// The name of the propagated type of the expression. This data is omitted
  /// if the location does not correspond to an expression or if there is no
  /// propagated type information.
  set propagatedType(String value) {
    _propagatedType = value;
  }

  /// The name of the static type of the expression. This data is omitted if
  /// the location does not correspond to an expression.
  String get staticType => _staticType;

  /// The name of the static type of the expression. This data is omitted if
  /// the location does not correspond to an expression.
  set staticType(String value) {
    _staticType = value;
  }

  HoverInformation(int offset, int length,
      {String containingLibraryPath,
      String containingLibraryName,
      String containingClassDescription,
      String dartdoc,
      String elementDescription,
      String elementKind,
      bool isDeprecated,
      String parameter,
      String propagatedType,
      String staticType}) {
    this.offset = offset;
    this.length = length;
    this.containingLibraryPath = containingLibraryPath;
    this.containingLibraryName = containingLibraryName;
    this.containingClassDescription = containingClassDescription;
    this.dartdoc = dartdoc;
    this.elementDescription = elementDescription;
    this.elementKind = elementKind;
    this.isDeprecated = isDeprecated;
    this.parameter = parameter;
    this.propagatedType = propagatedType;
    this.staticType = staticType;
  }

  factory HoverInformation.fromJson(JsonDecoder jsonDecoder, String jsonPath, Object json) {
    json ??= {};
    if (json is Map) {
      int offset;
      if (json.containsKey('offset')) {
        offset = jsonDecoder.decodeInt(jsonPath + '.offset', json['offset']);
      } else {
        throw jsonDecoder.mismatch(jsonPath, 'offset');
      }
      int length;
      if (json.containsKey('length')) {
        length = jsonDecoder.decodeInt(jsonPath + '.length', json['length']);
      } else {
        throw jsonDecoder.mismatch(jsonPath, 'length');
      }
      String containingLibraryPath;
      if (json.containsKey('containingLibraryPath')) {
        containingLibraryPath =
            jsonDecoder.decodeString(jsonPath + '.containingLibraryPath', json['containingLibraryPath']);
      }
      String containingLibraryName;
      if (json.containsKey('containingLibraryName')) {
        containingLibraryName =
            jsonDecoder.decodeString(jsonPath + '.containingLibraryName', json['containingLibraryName']);
      }
      String containingClassDescription;
      if (json.containsKey('containingClassDescription')) {
        containingClassDescription =
            jsonDecoder.decodeString(jsonPath + '.containingClassDescription', json['containingClassDescription']);
      }
      String dartdoc;
      if (json.containsKey('dartdoc')) {
        dartdoc = jsonDecoder.decodeString(jsonPath + '.dartdoc', json['dartdoc']);
      }
      String elementDescription;
      if (json.containsKey('elementDescription')) {
        elementDescription = jsonDecoder.decodeString(jsonPath + '.elementDescription', json['elementDescription']);
      }
      String elementKind;
      if (json.containsKey('elementKind')) {
        elementKind = jsonDecoder.decodeString(jsonPath + '.elementKind', json['elementKind']);
      }
      bool isDeprecated;
      if (json.containsKey('isDeprecated')) {
        isDeprecated = jsonDecoder.decodeBool(jsonPath + '.isDeprecated', json['isDeprecated']);
      }
      String parameter;
      if (json.containsKey('parameter')) {
        parameter = jsonDecoder.decodeString(jsonPath + '.parameter', json['parameter']);
      }
      String propagatedType;
      if (json.containsKey('propagatedType')) {
        propagatedType = jsonDecoder.decodeString(jsonPath + '.propagatedType', json['propagatedType']);
      }
      String staticType;
      if (json.containsKey('staticType')) {
        staticType = jsonDecoder.decodeString(jsonPath + '.staticType', json['staticType']);
      }
      return HoverInformation(offset, length,
          containingLibraryPath: containingLibraryPath,
          containingLibraryName: containingLibraryName,
          containingClassDescription: containingClassDescription,
          dartdoc: dartdoc,
          elementDescription: elementDescription,
          elementKind: elementKind,
          isDeprecated: isDeprecated,
          parameter: parameter,
          propagatedType: propagatedType,
          staticType: staticType);
    } else {
      throw jsonDecoder.mismatch(jsonPath, 'HoverInformation', json);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var result = <String, dynamic>{};
    result['offset'] = offset;
    result['length'] = length;
    if (containingLibraryPath != null) {
      result['containingLibraryPath'] = containingLibraryPath;
    }
    if (containingLibraryName != null) {
      result['containingLibraryName'] = containingLibraryName;
    }
    if (containingClassDescription != null) {
      result['containingClassDescription'] = containingClassDescription;
    }
    if (dartdoc != null) {
      result['dartdoc'] = dartdoc;
    }
    if (elementDescription != null) {
      result['elementDescription'] = elementDescription;
    }
    if (elementKind != null) {
      result['elementKind'] = elementKind;
    }
    if (isDeprecated != null) {
      result['isDeprecated'] = isDeprecated;
    }
    if (parameter != null) {
      result['parameter'] = parameter;
    }
    if (propagatedType != null) {
      result['propagatedType'] = propagatedType;
    }
    if (staticType != null) {
      result['staticType'] = staticType;
    }
    return result;
  }

  @override
  String toString() => json.encode(toJson());

  @override
  bool operator ==(other) {
    if (other is HoverInformation) {
      return offset == other.offset &&
          length == other.length &&
          containingLibraryPath == other.containingLibraryPath &&
          containingLibraryName == other.containingLibraryName &&
          containingClassDescription == other.containingClassDescription &&
          dartdoc == other.dartdoc &&
          elementDescription == other.elementDescription &&
          elementKind == other.elementKind &&
          isDeprecated == other.isDeprecated &&
          parameter == other.parameter &&
          propagatedType == other.propagatedType &&
          staticType == other.staticType;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = JenkinsSmiHash.combine(hash, offset.hashCode);
    hash = JenkinsSmiHash.combine(hash, length.hashCode);
    hash = JenkinsSmiHash.combine(hash, containingLibraryPath.hashCode);
    hash = JenkinsSmiHash.combine(hash, containingLibraryName.hashCode);
    hash = JenkinsSmiHash.combine(hash, containingClassDescription.hashCode);
    hash = JenkinsSmiHash.combine(hash, dartdoc.hashCode);
    hash = JenkinsSmiHash.combine(hash, elementDescription.hashCode);
    hash = JenkinsSmiHash.combine(hash, elementKind.hashCode);
    hash = JenkinsSmiHash.combine(hash, isDeprecated.hashCode);
    hash = JenkinsSmiHash.combine(hash, parameter.hashCode);
    hash = JenkinsSmiHash.combine(hash, propagatedType.hashCode);
    hash = JenkinsSmiHash.combine(hash, staticType.hashCode);
    return JenkinsSmiHash.finish(hash);
  }
}
