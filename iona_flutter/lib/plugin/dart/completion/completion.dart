import 'dart:collection';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/src/services/available_declarations.dart';
import 'package:iona_flutter/plugin/dart/completion/completion_base.dart';
import 'package:iona_flutter/plugin/dart/completion/completion_core.dart';
import 'package:iona_flutter/plugin/dart/completion/completion_performance.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/completion_manager.dart';
import 'package:iona_flutter/plugin/dart/completion/domain/available_suggestions.dart';
import 'package:iona_flutter/plugin/dart/completion/filtering/fuzzy_matcher.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_generated.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_server.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_special.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis_engine.dart';
import 'package:iona_flutter/plugin/dart/dartdoc/dartdoc_directive_info.dart';
import 'package:iona_flutter/plugin/dart/lsp/constants.dart';
import 'package:iona_flutter/plugin/dart/lsp/mapping.dart';
import 'package:iona_flutter/plugin/dart/utils/handlers.dart';

final defaultSupportedCompletionKinds = HashSet<CompletionItemKind>.of([
  CompletionItemKind.Text,
  CompletionItemKind.Method,
  CompletionItemKind.Function,
  CompletionItemKind.Constructor,
  CompletionItemKind.Field,
  CompletionItemKind.Variable,
  CompletionItemKind.Class,
  CompletionItemKind.Interface,
  CompletionItemKind.Module,
  CompletionItemKind.Property,
  CompletionItemKind.Unit,
  CompletionItemKind.Value,
  CompletionItemKind.Enum,
  CompletionItemKind.Keyword,
  CompletionItemKind.Snippet,
  CompletionItemKind.Color,
  CompletionItemKind.File,
  CompletionItemKind.Reference,
  CompletionItemKind.TypeParameter
]);

class Completion {
  Future<ErrorOr<List<CompletionItem>>> complete(CompletionParams params, CancellationToken token) async {
    final clientSupportedCompletionKinds = defaultSupportedCompletionKinds;
    final includeSuggestionSets = true;
    final pos = params.position;
    final path = pathOfDoc(params.textDocument);
    final unit = await path.mapResult(DartAnalysisEngine.instance.requireResolvedUnit);

    final lineInfo = unit.map<ErrorOr<LineInfo>>(
      // If we don't have a unit, we can still try to obtain the line info for
      // plugin contributors.
      (error) => path.mapResult(getLineInfo),
      (unit) => success(unit.lineInfo),
    );
    final offset = await lineInfo.mapResult((lineInfo) => toOffset(lineInfo, pos));

    // ignore: missing_return
    return offset.mapResult((offset) async {
      // For server results we need a valid unit, but if we don't have one
      // we shouldn't consider this an error when merging with plugin results.

      final item = TextDocumentClientCapabilitiesCompletionItem(
          true, true, [MarkupKind.PlainText, MarkupKind.Markdown], true, true);
      final kind = TextDocumentClientCapabilitiesCompletionItemKind(defaultSupportedCompletionKinds.toList());
      final serverResultsFuture = unit.isError
          ? Future.value(success(const <CompletionItem>[]))
          : _getServerItems(
              TextDocumentClientCapabilitiesCompletion(true, item, kind, true),
              clientSupportedCompletionKinds,
              includeSuggestionSets,
              unit.result,
              offset,
              token,
            );

      final results = await serverResultsFuture;

      return results;

      //final pluginResultsFuture = _getPluginResults(
      //    completionCapabilities, clientSupportedCompletionKinds, lineInfo.result, path.result, offset);

      // Await both server + plugin results together to allow async/IO to
      // overlap.
      /*final serverAndPluginResults = await Future.wait([serverResultsFuture, pluginResultsFuture]);
      final serverResults = serverAndPluginResults[0];
      final pluginResults = serverAndPluginResults[1];

      if (serverResults.isError) return serverResults;
      if (pluginResults.isError) return pluginResults;

      return success(
        serverResults.result.followedBy(pluginResults.result).toList(),
      );*/
    });
  }

  Future<ErrorOr<List<CompletionItem>>> _getServerItems(
    TextDocumentClientCapabilitiesCompletion completionCapabilities,
    HashSet<CompletionItemKind> clientSupportedCompletionKinds,
    bool includeSuggestionSets,
    ResolvedUnitResult unit,
    int offset,
    CancellationToken token,
  ) async {
    final performance = CompletionPerformance();
    performance.path = unit.path;
    performance.setContentsAndOffset(unit.content, offset);
    //server.performanceStats.completion.add(performance);

    final completionRequest =
        CompletionRequestImpl(unit, offset, /*server.options.useNewRelevance*/ false, performance);
    final directiveInfo =
        /*server.getDartdocDirectiveInfoFor(completionRequest.result);*/ DartdocDirectiveInfo();
    final dartCompletionRequest = await DartCompletionRequestImpl.from(completionRequest, directiveInfo);

    Set<ElementKind> includedElementKinds;
    Set<String> includedElementNames;
    List<IncludedSuggestionRelevanceTag> includedSuggestionRelevanceTags;
    if (includeSuggestionSets) {
      includedElementKinds = <ElementKind>{};
      includedElementNames = <String>{};
      includedSuggestionRelevanceTags = <IncludedSuggestionRelevanceTag>[];
    }

    try {
      var contributor = DartCompletionManager(
        dartdocDirectiveInfo: directiveInfo,
        includedElementKinds: includedElementKinds,
        includedElementNames: includedElementNames,
        includedSuggestionRelevanceTags: includedSuggestionRelevanceTags,
      );

      final serverSuggestions = await contributor.computeSuggestions(
        completionRequest,
        enableUriContributor: true,
      );

      if (token.isCancellationRequested) {
        return cancelled();
      }

      final results = serverSuggestions
          .map(
            (item) => toCompletionItem(
              completionCapabilities,
              clientSupportedCompletionKinds,
              unit.lineInfo,
              item,
              completionRequest.replacementOffset,
              completionRequest.replacementLength,
            ),
          )
          .toList();

      // Now compute items in suggestion sets.
      var includedSuggestionSets = <IncludedSuggestionSet>[];
      if (includedElementKinds != null && unit != null) {
        computeIncludedSetList(
          DartAnalysisEngine.instance.declarationsTracker,
          unit,
          includedSuggestionSets,
          includedElementNames,
        );
      }

      // Build a fast lookup for imported symbols so that we can filter out
      // duplicates.
      final alreadyImportedSymbols = _buildLookupOfImportedSymbols(unit);

      includedSuggestionSets.forEach((includedSet) {
        final library = DartAnalysisEngine.instance.declarationsTracker.getLibrary(includedSet.id);
        if (library == null) {
          return;
        }

        // Make a fast lookup for tag relevance.
        final tagBoosts = <String, int>{};
        includedSuggestionRelevanceTags.forEach((t) => tagBoosts[t.tag] = t.relevanceBoost);

        // Only specific types of child declarations should be included.
        // This list matches what's in _protocolAvailableSuggestion in
        // the DAS implementation.
        bool shouldIncludeChild(Declaration child) =>
            child.kind == DeclarationKind.CONSTRUCTOR ||
            child.kind == DeclarationKind.ENUM_CONSTANT ||
            (child.kind == DeclarationKind.GETTER && child.isStatic) ||
            (child.kind == DeclarationKind.FIELD && child.isStatic);

        // Collect declarations and their children.
        final allDeclarations = library.declarations
            .followedBy(library.declarations.expand((decl) => decl.children.where(shouldIncludeChild)))
            .toList();

        final setResults = allDeclarations
            // Filter to only the kinds we should return.
            .where((item) => includedElementKinds.contains(protocolElementKind(item.kind)))
            .where((item) {
          // Check existing imports to ensure we don't already import
          // this element (this exact element from its declaring
          // library, not just something with the same name). If we do
          // we'll want to skip it.
          final declaringUri = item.parent != null ? item.parent.locationLibraryUri : item.locationLibraryUri;

          // For enums and named constructors, only the parent enum/class is in
          // the list of imported symbols so we use the parents name.
          final nameKey = item.kind == DeclarationKind.ENUM_CONSTANT || item.kind == DeclarationKind.CONSTRUCTOR
              ? item.parent.name
              : item.name;
          final key = _createImportedSymbolKey(nameKey, declaringUri);
          final importingUris = alreadyImportedSymbols[key];

          // Keep it only if there are either:
          // - no URIs importing it
          // - the URIs importing it include this one
          return importingUris == null || importingUris.contains('${library.uri}');
        }).map((item) => declarationToCompletionItem(
                  completionCapabilities,
                  clientSupportedCompletionKinds,
                  unit.path,
                  offset,
                  includedSet,
                  library,
                  tagBoosts,
                  unit.lineInfo,
                  item,
                  completionRequest.replacementOffset,
                  completionRequest.replacementLength,
                ));
        results.addAll(setResults);
      });

      // Perform fuzzy matching based on the identifier in front of the caret to
      // reduce the size of the payload.
      final fuzzyPattern = dartCompletionRequest.targetPrefix;
      final fuzzyMatcher = FuzzyMatcher(fuzzyPattern, matchStyle: MatchStyle.TEXT);

      final matchingResults = results.where((e) => fuzzyMatcher.score(e.label) > 0).toList();

      performance.notificationCount = 1;
      performance.suggestionCountFirst = results.length;
      performance.suggestionCountLast = results.length;
      performance.complete();

      return success(matchingResults);
    } on AbortCompletion {
      return success([]);
    }
  }

  /// Build a list of existing imports so we can filter out any suggestions
  /// that resolve to the same underlying declared symbol.
  /// Map with key "elementName/elementDeclaringLibraryUri"
  /// Value is a set of imported URIs that import that element.
  Map<String, Set<String>> _buildLookupOfImportedSymbols(ResolvedUnitResult unit) {
    final alreadyImportedSymbols = <String, Set<String>>{};
    final importElementList = unit.libraryElement.imports;
    for (var import in importElementList) {
      final importedLibrary = import.importedLibrary;
      if (importedLibrary == null) continue;

      for (var element in import.namespace.definedNames.values) {
        if (element.librarySource != null) {
          final declaringLibraryUri = element.librarySource.uri;
          final elementName = element.name;

          final key = _createImportedSymbolKey(elementName, declaringLibraryUri);
          alreadyImportedSymbols.putIfAbsent(key, () => <String>{});
          alreadyImportedSymbols[key].add('${importedLibrary.librarySource.uri}');
        }
      }
    }
    return alreadyImportedSymbols;
  }

  String _createImportedSymbolKey(String name, Uri declaringUri) => '$name/$declaringUri';

  ErrorOr<LineInfo> getLineInfo(String path) {
    final lineInfo = DartAnalysisEngine.instance.getLineInfo(path);

    if (lineInfo == null) {
      return error(ServerErrorCodes.InvalidFilePath, 'Invalid file path', path);
    } else {
      return success(lineInfo);
    }
  }
}
