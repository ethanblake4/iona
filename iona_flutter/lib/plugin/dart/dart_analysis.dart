import 'dart:async';
import 'dart:isolate';

import 'package:analysis_server/lsp_protocol/protocol_generated.dart';
import 'package:analysis_server/lsp_protocol/protocol_special.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:iona_flutter/model/ide/tasks.dart';
import 'package:iona_flutter/plugin/dart/dart_analysis_engine.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/tasks/dart_tasks.dart';

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

  bool maybeAnalyzeRootFolder(BuildContext context, String path) {
    if (_sendPort != null && resourceProvider.getFolder(path).getChildAssumingFile('pubspec.yaml').exists) {
      Tasks.of(context).setTask(DartAnalyzeTask(true));
      final response = ReceivePort();
      _sendPort.send([AnalysisMessage('setRootFolder', path), response.sendPort]);
      response.first.then((value) => {Tasks.of(context).setTask(DartAnalyzeTask(false))});
      currentRootFolder = path;
      return true;
    }
    return false;
  }

  Future<FlutterFileInfo> flutterFileInfo(String path) async {
    if (_sendPort != null) {
      final response = ReceivePort();
      final ts = DateTime.now().millisecondsSinceEpoch;
      _sendPort.send([AnalysisMessage('resolvedUnitInfo', path), response.sendPort]);
      final value = await response.first;
      final nts = DateTime.now().millisecondsSinceEpoch;
      print('flutter file info (time=${nts - ts}ms)');
      //print('response: ${value.content}');

      // ignore: avoid_as
      return value.content as FlutterFileInfo;
    }
  }

  Future<bool> editFile(String path, String content) async {
    if (_sendPort != null) {
      final response = ReceivePort();
      _sendPort.send([AnalysisMessage('overlay', FileOverlay(path, content)), response.sendPort]);
      final value = (((await response.first) as AnalysisMessage).content as bool);
      if (value == true) return true;
      return false;
    }
  }

  Future<List<CompletionItem>> completeChar(String char, String file, int line, int offset) async {
    print('cp');
    if (!DartAnalysisEngine.isDartFileName(file)) return null;
    final ctx = CompletionContext(triggerKind: CompletionTriggerKind.TriggerCharacter, triggerCharacter: char);
    final doc = TextDocumentIdentifier(uri: Uri.file(file).toString());
    final p = CompletionParams(context: ctx, textDocument: doc, position: Position(line: line, character: offset));
    //final params = CompletionParams(CompletionContext(CompletionTriggerKind.TriggerCharacter, char),
    //    TextDocumentIdentifier(Uri.file(file).toString()), Position(line, offset));
    if (_sendPort != null) {
      final response = ReceivePort();
      print('send cp');
      _sendPort.send([AnalysisMessage('complete', p), response.sendPort]);
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
