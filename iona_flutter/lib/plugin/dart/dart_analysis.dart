import 'dart:async';
import 'dart:isolate';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis_engine.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';

class DartAnalyzer {
  static DartAnalyzer _instance;

  /// Get singleton DartAnalyzer
  factory DartAnalyzer() {
    return _instance != null ? _instance : _instance = DartAnalyzer._internal();
  }

  DartAnalyzer._internal() {
    _isolate = Isolate.spawn(analysisEngine, receivePort.sendPort);
    receivePort.first.then((value) => _sendPort = value);
  }

  AnalysisContextCollection collection;
  final ResourceProvider resourceProvider = PhysicalResourceProvider.INSTANCE;
  final receivePort = ReceivePort();
  FutureOr<Isolate> _isolate;
  SendPort _sendPort;
  String currentRootFolder;

  bool maybeAnalyzeRootFolder(String path) {
    if (_sendPort != null && resourceProvider.getFolder(path).getChildAssumingFile('pubspec.yaml').exists) {
      print('analyze!');
      final response = ReceivePort();
      _sendPort.send([AnalysisMessage('setRootFolder', path), response.sendPort]);
      response.first.then((value) => {print('response: ${value.content}')});
      currentRootFolder = path;
    } else {
      print('no!');
    }
  }

  Future<FlutterFileInfo> flutterFileInfo(String path) async {
    if (_sendPort != null) {
      print('info!');
      final response = ReceivePort();
      final ts = DateTime.now().millisecondsSinceEpoch;
      _sendPort.send([AnalysisMessage('resolvedUnitInfo', path), response.sendPort]);
      final value = await response.first;
      final nts = DateTime.now().millisecondsSinceEpoch;
      print('time: ${nts - ts}');
      print('response: ${value.content}');
      // ignore: avoid_as
      return value.content as FlutterFileInfo;
    }
  }

  void analyzeFileDart(String path) {
    //print(getSdkPath());
    //print(parseFile(path: path, featureSet: FeatureSet.forTesting(sdkVersion: '2.8.0')).unit.root);
  }
}

class AnalysisComputeOptions {
  String path;

  AnalysisComputeOptions(this.path);
}
