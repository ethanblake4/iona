import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as protocol;
import 'package:analyzer_plugin/src/utilities/completion/completion_target.dart';
import 'package:analyzer_plugin/src/utilities/completion/optype.dart';
import 'package:analyzer_plugin/utilities/completion/relevance.dart';
import 'package:iona_flutter/plugin/dart/completion/completion_base.dart';
import 'package:iona_flutter/plugin/dart/completion/completion_core.dart';
import 'package:iona_flutter/plugin/dart/completion/completion_performance.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/completion_dart.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/completion_ranking.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/arglist_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/combinator_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/extension_member_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/field_formal_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/imported_reference_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/keyword_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/label_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/library_member_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/library_prefix_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/local_library_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/local_reference_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/override_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/static_member_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/type_member_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/uri_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/contributor/variable_name_contributor.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/suggestion_builder.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_generated.dart';
import 'package:iona_flutter/plugin/dart/completion/service/common_usage_sorter.dart';
import 'package:iona_flutter/plugin/dart/completion/service/feature_computer.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis_engine.dart';
import 'package:iona_flutter/plugin/dart/dartdoc/dartdoc_directive_info.dart';
import 'package:meta/meta.dart';

import '../protocol/protocol_server.dart' show CompletionSuggestion;
import '../service/contribution_sorter.dart';
import 'contributor/named_constructor_contributor.dart';

/// [DartCompletionManager] determines if a completion request is Dart specific
/// and forwards those requests to all [DartCompletionContributor]s.
class DartCompletionManager implements CompletionContributor {
  /// The [contributionSorter] is a long-lived object that isn't allowed
  /// to maintain state between calls to [DartContributionSorter#sort(...)].
  static DartContributionSorter contributionSorter = CommonUsageSorter();

  /// The object used to resolve macros in Dartdoc comments.
  final DartdocDirectiveInfo dartdocDirectiveInfo;

  /// If not `null`, then instead of using [ImportedReferenceContributor],
  /// fill this set with kinds of elements that are applicable at the
  /// completion location, so should be suggested from available suggestion
  /// sets.
  final Set<protocol.ElementKind> includedElementKinds;

  /// If [includedElementKinds] is not null, must be also not `null`, and
  /// will be filled with names of all top-level declarations from all
  /// included suggestion sets.
  final Set<String> includedElementNames;

  /// If [includedElementKinds] is not null, must be also not `null`, and
  /// will be filled with tags for suggestions that should be given higher
  /// relevance than other included suggestions.
  final List<IncludedSuggestionRelevanceTag> includedSuggestionRelevanceTags;

  /// The listener to be notified at certain points in the process of building
  /// suggestions, or `null` if no notification should occur.
  final SuggestionListener listener;

  /// Initialize a newly created completion manager. The parameters
  /// [includedElementKinds], [includedElementNames], and
  /// [includedSuggestionRelevanceTags] must either all be `null` or must all be
  /// non-`null`.
  DartCompletionManager(
      {this.dartdocDirectiveInfo,
      this.includedElementKinds,
      this.includedElementNames,
      this.includedSuggestionRelevanceTags,
      this.listener})
      : assert((includedElementKinds != null &&
                includedElementNames != null &&
                includedSuggestionRelevanceTags != null) ||
            (includedElementKinds == null && includedElementNames == null && includedSuggestionRelevanceTags == null));

  @override
  Future<List<protocol.CompletionSuggestion>> computeSuggestions(
    CompletionRequest request, {
    @required bool enableUriContributor,
  }) async {
    request.checkAborted();
    if (!DartAnalysisEngine.isDartFileName(request.result.path)) {
      return const <CompletionSuggestion>[];
    }

    var performance = (request as CompletionRequestImpl).performance;
    DartCompletionRequestImpl dartRequest = await DartCompletionRequestImpl.from(request, dartdocDirectiveInfo);

    // Don't suggest in comments.
    if (dartRequest.target.isCommentText) {
      return const <CompletionSuggestion>[];
    }

    final ranking = CompletionRanking.instance;
    var probabilityFuture = ranking != null ? ranking.predict(dartRequest) : Future.value(null);

    var range = dartRequest.target.computeReplacementRange(dartRequest.offset);
    (request as CompletionRequestImpl)
      ..replacementOffset = range.offset
      ..replacementLength = range.length;

    // Request Dart specific completions from each contributor
    var builder = SuggestionBuilder(dartRequest, listener: listener);
    var contributors = <DartCompletionContributor>[
      ArgListContributor(),
      CombinatorContributor(),
      ExtensionMemberContributor(),
      FieldFormalContributor(),
      KeywordContributor(),
      LabelContributor(),
      LibraryMemberContributor(),
      LibraryPrefixContributor(),
      LocalLibraryContributor(),
      LocalReferenceContributor(),
      NamedConstructorContributor(),
      OverrideContributor(),
      StaticMemberContributor(),
      TypeMemberContributor(),
      if (enableUriContributor) UriContributor(),
      VariableNameContributor()
    ];

    if (includedElementKinds != null) {
      _addIncludedElementKinds(dartRequest);
      _addIncludedSuggestionRelevanceTags(dartRequest);
    } else {
      contributors.add(ImportedReferenceContributor());
    }

    try {
      for (var contributor in contributors) {
        var contributorTag = 'DartCompletionManager - ${contributor.runtimeType}';
        performance.logStartTime(contributorTag);
        await contributor.computeSuggestions(dartRequest, builder);
        performance.logElapseTime(contributorTag);
        request.checkAborted();
      }
    } on InconsistentAnalysisException {
      // The state of the code being analyzed has changed, so results are likely
      // to be inconsistent. Just abort the operation.
      throw AbortCompletion();
    }

    // Adjust suggestion relevance before returning
    var suggestions = builder.suggestions.toList();
    const SORT_TAG = 'DartCompletionManager - sort';
    performance.logStartTime(SORT_TAG);
    if (ranking != null) {
      request.checkAborted();
      // MACHINE LEARNING AI SORT RESORT RANKING SUGGESTIONS
      /*try {
        suggestions = await ranking.rerank(probabilityFuture, suggestions, includedElementNames,
            includedSuggestionRelevanceTags, dartRequest, request.result.unit.featureSet);
      } catch (exception, stackTrace) {
        // TODO(brianwilkerson) Shutdown the isolates that have already been
        //  started.
        // Disable smart ranking if prediction fails.
        CompletionRanking.instance = null;
        AnalysisEngine.instance.instrumentationService.logException(
            CaughtException.withMessage('Failed to rerank completion suggestions', exception, stackTrace));
        await contributionSorter.sort(dartRequest, suggestions);
      }*/
    } else if (!request.useNewRelevance) {
      await contributionSorter.sort(dartRequest, suggestions);
    }
    performance.logElapseTime(SORT_TAG);
    request.checkAborted();
    return suggestions;
  }

  void _addIncludedElementKinds(DartCompletionRequestImpl request) {
    var opType = request.opType;

    if (!opType.includeIdentifiers) return;

    var kinds = includedElementKinds;
    if (kinds != null) {
      if (opType.includeConstructorSuggestions) {
        kinds.add(protocol.ElementKind.CONSTRUCTOR);
      }
      if (opType.includeTypeNameSuggestions) {
        kinds.add(protocol.ElementKind.CLASS);
        kinds.add(protocol.ElementKind.CLASS_TYPE_ALIAS);
        kinds.add(protocol.ElementKind.ENUM);
        kinds.add(protocol.ElementKind.FUNCTION_TYPE_ALIAS);
        kinds.add(protocol.ElementKind.MIXIN);
      }
      if (opType.includeReturnValueSuggestions) {
        kinds.add(protocol.ElementKind.CONSTRUCTOR);
        kinds.add(protocol.ElementKind.ENUM_CONSTANT);
        kinds.add(protocol.ElementKind.EXTENSION);
        // Static fields.
        kinds.add(protocol.ElementKind.FIELD);
        kinds.add(protocol.ElementKind.FUNCTION);
        // Static and top-level properties.
        kinds.add(protocol.ElementKind.GETTER);
        kinds.add(protocol.ElementKind.SETTER);
        kinds.add(protocol.ElementKind.TOP_LEVEL_VARIABLE);
      }
    }
  }

  void _addIncludedSuggestionRelevanceTags(DartCompletionRequestImpl request) {
    if (request.inConstantContext && request.useNewRelevance) {
      includedSuggestionRelevanceTags
          .add(IncludedSuggestionRelevanceTag('isConst', /* ml RelevanceBoost.constInConstantContext*/ 1));
    }

    var type = request.contextType;
    if (type is InterfaceType) {
      var element = type.element;
      var tag = '${element.librarySource.uri}::${element.name}';
      if (element.isEnum) {
        var relevance =
            /*ml request.useNewRelevance ? RelevanceBoost.availableEnumConstant :*/ DART_RELEVANCE_BOOST_AVAILABLE_ENUM;
        includedSuggestionRelevanceTags.add(
          IncludedSuggestionRelevanceTag(
            tag,
            relevance,
          ),
        );
      } else {
        var relevance =
            /*ml request.useNewRelevance ? RelevanceBoost.availableDeclaration :*/ DART_RELEVANCE_BOOST_AVAILABLE_DECLARATION;
        includedSuggestionRelevanceTags.add(
          IncludedSuggestionRelevanceTag(
            tag,
            relevance,
          ),
        );
      }
    }
  }
}

/// The information about a requested list of completions within a Dart file.
class DartCompletionRequestImpl implements DartCompletionRequest {
  @override
  final ResolvedUnitResult result;

  @override
  final ResourceProvider resourceProvider;

  @override
  final InterfaceType objectType;

  @override
  final Source source;

  @override
  final int offset;

  @override
  Expression dotTarget;

  @override
  final Source librarySource;

  @override
  CompletionTarget target;

  OpType _opType;

  @override
  final FeatureComputer featureComputer;

  @override
  final DartdocDirectiveInfo dartdocDirectiveInfo;

  /// A flag indicating whether the [_contextType] has been computed.
  bool _hasComputedContextType = false;

  /// The context type associated with the target's `containingNode`.
  DartType _contextType;

  final CompletionRequest _originalRequest;

  final CompletionPerformance performance;

  DartCompletionRequestImpl._(this.result, this.resourceProvider, this.objectType, this.librarySource, this.source,
      this.offset, CompilationUnit unit, this.dartdocDirectiveInfo, this._originalRequest, this.performance)
      : featureComputer = FeatureComputer(result.typeSystem, result.typeProvider) {
    _updateTargets(unit);
  }

  @override
  DartType get contextType {
    if (!_hasComputedContextType) {
      _contextType = featureComputer.computeContextType(target.containingNode, target.offset);
      _hasComputedContextType = true;
    }
    return _contextType;
  }

  @override
  FeatureSet get featureSet => result.session.analysisContext.analysisOptions.contextFeatures;

  @override
  bool get includeIdentifiers {
    return opType.includeIdentifiers;
  }

  @override
  bool get inConstantContext {
    var entity = target.entity;
    return entity is ExpressionImpl && entity.inConstantContext;
  }

  @override
  LibraryElement get libraryElement => result.libraryElement;

  @override
  OpType get opType {
    _opType ??= OpType.forCompletion(target, offset);
    return _opType;
  }

  @override
  String get sourceContents => result.content;

  @override
  SourceFactory get sourceFactory {
    DriverBasedAnalysisContext context = result.session.analysisContext;
    return context.driver.sourceFactory;
  }

  @override
  String get targetPrefix {
    var entity = target.entity;
    while (entity is AstNode) {
      if (entity is SimpleIdentifier) {
        var identifier = entity.name;
        if (offset >= entity.offset && offset - entity.offset < identifier.length) {
          return identifier.substring(0, offset - entity.offset);
        }
        return identifier;
      }
      var children = (entity as AstNode).childEntities;
      entity = children.isEmpty ? null : children.first;
    }
    return '';
  }

  @override
  bool get useNewRelevance => _originalRequest.useNewRelevance;

  /// Throw [AbortCompletion] if the completion request has been aborted.
  @override
  void checkAborted() {
    _originalRequest.checkAborted();
  }

  /// Update the completion [target] and [dotTarget] based on the given [unit].
  void _updateTargets(CompilationUnit unit) {
    _opType = null;
    dotTarget = null;
    target = CompletionTarget.forOffset(unit, offset);
    var node = target.containingNode;
    if (node is MethodInvocation) {
      if (identical(node.methodName, target.entity)) {
        dotTarget = node.realTarget;
      } else if (node.isCascaded && node.operator.offset + 1 == target.offset) {
        dotTarget = node.realTarget;
      }
    }
    if (node is PropertyAccess) {
      if (identical(node.propertyName, target.entity)) {
        dotTarget = node.realTarget;
      } else if (node.isCascaded && node.operator.offset + 1 == target.offset) {
        dotTarget = node.realTarget;
      }
    }
    if (node is PrefixedIdentifier) {
      if (identical(node.identifier, target.entity)) {
        dotTarget = node.prefix;
      }
    }
  }

  /// Return a [Future] that completes with a newly created completion request
  /// based on the given [request]. This method will throw [AbortCompletion]
  /// if the completion request has been aborted.
  static Future<DartCompletionRequest> from(
      CompletionRequest request, DartdocDirectiveInfo dartdocDirectiveInfo) async {
    request.checkAborted();
    var performance = (request as CompletionRequestImpl).performance;
    const BUILD_REQUEST_TAG = 'build DartCompletionRequest';
    performance.logStartTime(BUILD_REQUEST_TAG);

    var unit = request.result.unit;
    var libSource = unit.declaredElement.library.source;
    var objectType = request.result.typeProvider.objectType;

    var dartRequest = DartCompletionRequestImpl._(request.result, request.resourceProvider, objectType, libSource,
        request.source, request.offset, unit, dartdocDirectiveInfo, request, performance);

    performance.logElapseTime(BUILD_REQUEST_TAG);
    return dartRequest;
  }
}
