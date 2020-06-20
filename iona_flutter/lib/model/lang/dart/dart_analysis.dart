import 'dart:async';

import 'package:analysis_server_lib/analysis_server_lib.dart' as da;

import '../analysis.dart';

/// A Dart analysis provider, using the Dart Analysis Server
class DartAnalysis implements AnalysisProvider {
  da.AnalysisServer _analyzer;
  Map<String, _DartFileAnalysisProvider> _providers;

  @override
  bool willHandle(String fileExtension) {
    return fileExtension.endsWith('dart');
  }

  @override
  FutureOr<FileAnalysisProvider> analysisForFilepath(String filepath) {
    if (_analyzer == null) _initAnalysis();
    if (_providers.containsKey(filepath)) return _providers[filepath];
    return _providers[filepath] = _DartFileAnalysisProvider(filepath);
  }

  @override
  void endAnalysisFor(String filepath) {
    if (_providers.containsKey(filepath)) {
      _providers[filepath].dispose();
      _providers.remove(filepath);
    }
  }

  void _initAnalysis() async {
    _analyzer = await da.AnalysisServer.create();

    final connected = await _analyzer.server.onConnected.first;
    print('Server version: ${connected.version}');

    _analyzer.analysis.onHighlights.listen((msg) {
      if (!_providers.containsKey(msg.file)) return;
      _providers[msg.file]
          ._highlightUpdates
          .add(msg.regions.map((region) => SyntaxHighlight('dart', region.type, region.offset, region.length)));
    });
  }
}

class _DartFileAnalysisProvider implements FileAnalysisProvider {
  /// Create a [_DartFileAnalysisProvider]
  _DartFileAnalysisProvider(this._filepath);

  final String _filepath;
  final _highlightUpdates = StreamController<List<SyntaxHighlight>>();

  @override
  String get filepath => _filepath;

  @override
  Stream<List<SyntaxHighlight>> get highlighting => _highlightUpdates.stream;

  void dispose() {
    _highlightUpdates.close();
  }
}
