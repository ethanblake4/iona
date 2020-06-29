import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer/src/services/available_declarations.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as protocol;

import '../protocol/protocol_generated.dart' as protocol;

class CompletionLibrariesWorker implements SchedulerWorker {
  final DeclarationsTracker tracker;

  CompletionLibrariesWorker(this.tracker);

  @override
  AnalysisDriverPriority get workPriority {
    if (tracker.hasWork) {
      return AnalysisDriverPriority.priority;
    } else {
      return AnalysisDriverPriority.nothing;
    }
  }

  @override
  Future<void> performWork() async {
    tracker.doWork();
  }
}

protocol.ElementKind protocolElementKind(DeclarationKind kind) {
  switch (kind) {
    case DeclarationKind.CLASS:
      return protocol.ElementKind.CLASS;
    case DeclarationKind.CLASS_TYPE_ALIAS:
      return protocol.ElementKind.CLASS_TYPE_ALIAS;
    case DeclarationKind.CONSTRUCTOR:
      return protocol.ElementKind.CONSTRUCTOR;
    case DeclarationKind.ENUM:
      return protocol.ElementKind.ENUM;
    case DeclarationKind.ENUM_CONSTANT:
      return protocol.ElementKind.ENUM_CONSTANT;
    case DeclarationKind.EXTENSION:
      return protocol.ElementKind.EXTENSION;
    case DeclarationKind.FIELD:
      return protocol.ElementKind.FIELD;
    case DeclarationKind.FUNCTION:
      return protocol.ElementKind.FUNCTION;
    case DeclarationKind.FUNCTION_TYPE_ALIAS:
      return protocol.ElementKind.FUNCTION_TYPE_ALIAS;
    case DeclarationKind.GETTER:
      return protocol.ElementKind.GETTER;
    case DeclarationKind.METHOD:
      return protocol.ElementKind.METHOD;
    case DeclarationKind.MIXIN:
      return protocol.ElementKind.MIXIN;
    case DeclarationKind.SETTER:
      return protocol.ElementKind.SETTER;
    case DeclarationKind.VARIABLE:
      return protocol.ElementKind.TOP_LEVEL_VARIABLE;
  }
  return protocol.ElementKind.UNKNOWN;
}

void computeIncludedSetList(
  DeclarationsTracker tracker,
  ResolvedUnitResult resolvedUnit,
  List<protocol.IncludedSuggestionSet> includedSetList,
  Set<String> includedElementNames,
) {
  var analysisContext = resolvedUnit.session.analysisContext;
  var context = tracker.getContext(analysisContext);
  if (context == null) return;

  var librariesObject = context.getLibraries(resolvedUnit.path);

  var importedUriSet =
      resolvedUnit.libraryElement.importedLibraries.map((importedLibrary) => importedLibrary.source.uri).toSet();

  void includeLibrary(
    Library library,
    int importedRelevance,
    int deprecatedRelevance,
    int otherwiseRelevance,
  ) {
    int relevance;
    if (importedUriSet.contains(library.uri)) {
      relevance = importedRelevance;
    } else if (library.isDeprecated) {
      relevance = deprecatedRelevance;
    } else {
      relevance = otherwiseRelevance;
    }

    includedSetList.add(
      protocol.IncludedSuggestionSet(
        library.id,
        relevance,
        displayUri: _getRelativeFileUri(resolvedUnit, library.uri),
      ),
    );

    for (var declaration in library.declarations) {
      includedElementNames.add(declaration.name);
    }
  }

  for (var library in librariesObject.context) {
    includeLibrary(library, 8, 2, 5);
  }

  for (var library in librariesObject.dependencies) {
    includeLibrary(library, 7, 1, 4);
  }

  for (var library in librariesObject.sdk) {
    includeLibrary(library, 6, 0, 3);
  }
}

/// Computes the best URI to import [what] into the [unit] library.
String _getRelativeFileUri(ResolvedUnitResult unit, Uri what) {
  if (what.scheme == 'file') {
    var pathContext = unit.session.resourceProvider.pathContext;

    var libraryPath = unit.libraryElement.source.fullName;
    var libraryFolder = pathContext.dirname(libraryPath);

    var whatPath = pathContext.fromUri(what);
    var relativePath = pathContext.relative(whatPath, from: libraryFolder);
    return pathContext.split(relativePath).join('/');
  }
  return null;
}
