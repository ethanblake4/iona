import 'dart:collection';
import 'dart:isolate';

import 'package:iona_flutter/plugin/dart/completion/completion_performance.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/completion_dart.dart';
import 'package:iona_flutter/plugin/dart/completion/dart/completion_ranking_internal.dart';

/// Number of lookback tokens.
const int _LOOKBACK = 100;

class PerformanceMetrics {
  static const int _maxResultBuffer = 50;

  final Queue<PredictionResult> _predictionResults = Queue();
  int _predictionRequestCount = 0;
  final List<Duration> _isolateInitTimes = [];

  PerformanceMetrics._();

  List<Duration> get isolateInitTimes => _isolateInitTimes;

  /// The total prediction requests to ML Complete.
  int get predictionRequestCount => _predictionRequestCount;

  /// An iterable of the last `n` prediction results;
  Iterable<PredictionResult> get predictionResults => _predictionResults;

  void _addPredictionResult(PredictionResult request) {
    _predictionResults.addFirst(request);
    if (_predictionResults.length > _maxResultBuffer) {
      _predictionResults.removeLast();
    }
  }

  void _incrementPredictionRequestCount() {
    _predictionRequestCount++;
  }
}

class PredictionResult {
  final Map<String, double> results;
  final Duration elapsedTime;
  final String sourcePath;
  final String snippet;

  PredictionResult(this.results, this.elapsedTime, this.sourcePath, this.snippet);
}

class CompletionRanking {
  /// Singleton instance.
  static CompletionRanking instance;

  /// Filesystem location of model files.
  final String _directory;

  /// Ports to communicate from main to model isolates.
  List<SendPort> _writes;

  /// Pointer for round robin load balancing over isolates.
  int _index;

  /// General performance metrics around ML completion.
  final PerformanceMetrics performanceMetrics = PerformanceMetrics._();

  CompletionRanking(this._directory);

  /// Send an RPC to the isolate worker requesting that it load the model and
  /// wait for it to respond.
  Future<Map<String, Map<String, double>>> makeLoadRequest(SendPort sendPort, List<String> args) async {
    final receivePort = ReceivePort();
    sendPort.send({
      'method': 'load',
      'args': args,
      'port': receivePort.sendPort,
    });
    return await receivePort.first;
  }

  /// Send an RPC to the isolate worker requesting that it make a prediction and
  /// wait for it to respond.
  Future<Map<String, Map<String, double>>> makePredictRequest(List<String> args) async {
    final receivePort = ReceivePort();
    _writes[_index].send({
      'method': 'predict',
      'args': args,
      'port': receivePort.sendPort,
    });
    _index = (_index + 1) % _writes.length;
    return await receivePort.first;
  }

  /// Return a next-token prediction starting at the completion request cursor
  /// and walking back to find previous input tokens, or `null` if the
  /// prediction isolates are not running.
  Future<Map<String, double>> predict(DartCompletionRequest request) async {
    if (_writes == null || _writes.isEmpty) {
      // The field `_writes` is initialized in `start`, but the code that
      // invokes `start` doesn't wait for it complete. That means that it's
      // possible for this method to be invoked before `_writes` is initialized.
      // In those cases we return `null`
      return null;
    }
    final query = constructQuery(request, _LOOKBACK);
    if (query == null) {
      return Future.value();
    }

    request.checkAborted();

    performanceMetrics._incrementPredictionRequestCount();

    var timer = Stopwatch()..start();
    var response = await makePredictRequest(query);
    timer.stop();

    var result = response['data'];

    performanceMetrics._addPredictionResult(PredictionResult(
      result,
      timer.elapsed,
      request.source.fullName,
      computeCompletionSnippet(request.sourceContents, request.offset),
    ));

    return result;
  }
}
