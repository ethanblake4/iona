import 'dart:async';
import 'dart:isolate';

import 'package:analysis_server/lsp_protocol/protocol_generated.dart';
import 'package:analysis_server/lsp_protocol/protocol_special.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis_engine.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/tasks/dart_tasks.dart';
import 'package:iona_flutter/plugin/plugin.dart';

class DartAnalyzer {
  static DartAnalyzer _instance;

  /// Get singleton DartAnalyzer
  factory DartAnalyzer() {
    return _instance != null ? _instance : _instance = DartAnalyzer._internal();
  }

  factory DartAnalyzer.respawn(String sdkRoot) {
    return _instance = DartAnalyzer._internal();
  }

  DartAnalyzer._internal() {
    _isolate = Isolate.spawn(analysisEngine, receivePort.sendPort);
    receivePort.first.then((value) {
      _sendPort = value;
      _onSendPortAvailable.forEach((fn) => fn(_sendPort));
      _onSendPortAvailable = [];
    });
  }

  AnalysisContextCollection collection;
  ResourceProvider resourceProvider;
  final receivePort = ReceivePort();
  FutureOr<Isolate> _isolate;

  List<Function(SendPort)> _onSendPortAvailable = [];

  SendPort _sendPort;
  String currentRootFolder;

  bool analyzeRootFolder(PluginInterface interface, String sdkPath) {
    resourceProvider = interface.resourceProvider;

    _runWithIsolate((sendPort) {
      interface.tasks.setTask(DartAnalyzeTask(true));
      final response = ReceivePort();
      sendPort.send([
        AnalysisMessage(AnalysisMessage.setRootFolder, SetRootFolderParams(sdkPath, interface.project.rootFolder)),
        response.sendPort
      ]);
      response.first.then((value) => {interface.tasks.setTask(DartAnalyzeTask(false))});
      currentRootFolder = interface.project.rootFolder;
    });

    return true;
  }

  void _runWithIsolate(Function(SendPort) fn) {
    if (_sendPort != null) {
      fn(_sendPort);
    } else {
      _onSendPortAvailable.add(fn);
    }
  }

  Future<bool> editFile(String path, String content) async {
    if (_sendPort != null) {
      final response = ReceivePort();
      _sendPort.send([AnalysisMessage('overlay', FileOverlay(path, content)), response.sendPort]);
      final value = (((await response.first) as AnalysisMessage).content as bool);
      if (value == true) return true;
    }
    return false;
  }

  Future<List<CompletionItem>> completeChar(String char, String file, int line, int offset) async {
    if (!DartAnalysisEngine.isDartFileName(file)) return null;
    final ctx = CompletionContext(triggerKind: CompletionTriggerKind.TriggerCharacter, triggerCharacter: char);
    final doc = TextDocumentIdentifier(uri: Uri.file(file).toString());
    final p = CompletionParams(context: ctx, textDocument: doc, position: Position(line: line, character: offset));
    if (_sendPort != null) {
      final response = ReceivePort();
      _sendPort.send([AnalysisMessage(AnalysisMessage.complete, p), response.sendPort]);
      final value = ((await response.first) as AnalysisMessage).content as ErrorOr<List<CompletionItem>>;
      if (value.isError) {
        print(value.error);
        return null;
      } else {
        return value.result;
      }
    }
    return null;
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
