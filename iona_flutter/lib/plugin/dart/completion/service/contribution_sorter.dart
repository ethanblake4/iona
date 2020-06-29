import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/completion_dart.dart';

/// The abstract class [DartContributionSorter] defines the behavior of objects
/// that are used to adjust the relevance of an existing list of suggestions.
/// This is a long-lived object that should not maintain state between
/// calls to it's [sort] method.
abstract class DartContributionSorter {
  /// After [CompletionSuggestion]s have been computed,
  /// this method is called to adjust the relevance of those suggestions.
  /// Return a [Future] that completes when the suggestions have been updated.
  Future sort(DartCompletionRequest request, Iterable<CompletionSuggestion> suggestions);
}
