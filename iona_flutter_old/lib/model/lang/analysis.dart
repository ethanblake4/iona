import 'dart:async';

/// An interface that provides analysis (syntax highlighting, refactoring, etc.)
/// for a specified filetype. Usually defined per-language.
abstract class AnalysisProvider {
  bool willHandle(String fileExtension);
  FutureOr<FileAnalysisProvider> analysisForFilepath(String filepath);
  void endAnalysisFor(String filepath) {

  }
}

abstract class FileAnalysisProvider {
  String get filepath;

  // ANALYSIS
  Stream<List<SyntaxHighlight>> get highlighting;
}

class SyntaxHighlight {

  const SyntaxHighlight(this.language, this.type, this.offset, this.length);

  final String language;
  final String type;
  final int offset;
  final int length;
}
