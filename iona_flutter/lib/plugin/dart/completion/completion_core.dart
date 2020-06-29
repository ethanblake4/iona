import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:iona_flutter/plugin/dart/completion/completion_base.dart';
import 'package:iona_flutter/plugin/dart/completion/completion_performance.dart';

/// The information about a requested list of completions.
class CompletionRequestImpl implements CompletionRequest {
  @override
  final ResolvedUnitResult result;

  @override
  final int offset;

  @override
  bool useNewRelevance;

  /// The offset of the start of the text to be replaced.
  /// This will be different than the [offset] used to request the completion
  /// suggestions if there was a portion of an identifier before the original
  /// [offset]. In particular, the [replacementOffset] will be the offset of the
  /// beginning of said identifier.
  int replacementOffset;

  /// The length of the text to be replaced if the remainder of the identifier
  /// containing the cursor is to be replaced when the suggestion is applied
  /// (that is, the number of characters in the existing identifier).
  /// This will be different than the [replacementOffset] - [offset]
  /// if the [offset] is in the middle of an existing identifier.
  int replacementLength;

  bool _aborted = false;

  final CompletionPerformance performance;

  /// Initialize a newly created completion request based on the given
  /// arguments.
  CompletionRequestImpl(this.result, int offset, this.useNewRelevance, this.performance)
      : offset = offset,
        replacementOffset = offset,
        replacementLength = 0;

  @override
  ResourceProvider get resourceProvider => result.session.resourceProvider;

  @override
  Source get source => result.unit.declaredElement.source;

  @override
  String get sourceContents => result?.content;

  /// Abort the current completion request.
  void abort() {
    _aborted = true;
  }

  @override
  void checkAborted() {
    if (_aborted) {
      throw AbortCompletion();
    }
  }
}
