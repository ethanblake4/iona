import 'dart:async';

import 'analysis.dart';

/// An [AnalysisProvider] for files of unknown type
class BasicAnalysisProvider implements AnalysisProvider {
  @override
  bool willHandle(String fileExtension) => true;

  @override
  FutureOr<FileAnalysisProvider> analysisForFilepath(String filepath) =>
      BasicFileAnalysisProvider(filepath);

  @override
  void endAnalysisFor(String filepath) {
    // TODO: implement endAnalysisFor
  }
}

/// A [FileAnalysisProvider] for an unknown file
class BasicFileAnalysisProvider implements FileAnalysisProvider {
  final String _filepath;
  final Stream<List<SyntaxHighlight>> _highlightStream = Stream.empty();

  BasicFileAnalysisProvider(this._filepath);

  @override
  String get filepath => _filepath;

  @override
  Stream<List<SyntaxHighlight>> get highlighting => _highlightStream;
}
