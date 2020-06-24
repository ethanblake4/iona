import 'dart:isolate';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/model/flutter_names.dart';
import 'package:iona_flutter/plugin/dart/parse.dart';

analysisEngine(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  final port = ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);

  await for (final msg in port) {
    AnalysisMessage data = msg[0];
    SendPort replyTo = msg[1];
    final result = await _DartAnalysisEngine().handleMessage(data);
    replyTo.send(result);
  }
}

class _DartAnalysisEngine {
  static _DartAnalysisEngine instance;

  _DartAnalysisEngine._internal();

  factory _DartAnalysisEngine() {
    return instance != null ? instance : instance = _DartAnalysisEngine._internal();
  }

  final ResourceProvider resourceProvider = PhysicalResourceProvider.INSTANCE;
  AnalysisContextCollection collection;
  String rootFolder;

  Future<AnalysisMessage> handleMessage(AnalysisMessage message) async {
    switch (message.type) {
      case 'setRootFolder':
        final res = await setRootFolder(message.content);
        return AnalysisMessage('setRootFolder.result', res);
        break;
      case 'resolvedUnitInfo':
        final res = await resolvedUnitInfo(message.content as String);
        return AnalysisMessage('resolvedUnitInfo.result', res);
        break;
    }
  }

  Future<int> setRootFolder(String folder) async {
    collection = AnalysisContextCollection(includedPaths: [folder]);
    rootFolder = folder;
    final result =
        await collection.contextFor('$folder/lib/main.dart').currentSession.getResolvedUnit('$folder/lib/main.dart');

    return result.state == ResultState.VALID ? 1 : 0;
  }

  ResolvedUnitResult rs;
  AnalysisSession ss;

  Future<FlutterFileInfo> resolvedUnitInfo(String file) async {
    if (rootFolder == null) return null;

    (collection.contextFor(file) as DriverBasedAnalysisContext).driver.changeFile(file);

    final result = await collection.contextFor(file).currentSession.getResolvedUnit(file);

    //final libraryContext =
    //    (collection.contextFor('$rootFolder/lib/main.dart') as DriverBasedAnalysisContext).driver.getLibraryContext();

    final unit = result.unit;
    final element = unit.declaredElement;
    final stful = Map<String, String>();
    List<FlutterWidgetInfo> widgets = [];

    for (final declaration in unit.declarations) {
      if (declaration is ClassDeclaration) {
        final clsDef = element.getType(declaration.name.name);
        if (clsDef == null) continue;
        final supertypeEl = findWidgetSupertype(clsDef.supertype);
        if (supertypeEl == null) continue;
        final superName = supertypeEl.element.name;

        if (superName == FLUTTER_STATEFUL_WIDGET) {
          final createState = declaration.members.firstWhere(
              (element) => element is MethodDeclaration && element.name.name == FLUTTER_STATEFUL_CREATESTATE,
              orElse: () => null);
          if (createState == null || createState.declaredElement == null) continue;

          stful[createState.childEntities.toList()[1].toString()] = clsDef.name;
        } else if (superName == FLUTTER_STATE) {
          FlutterWidgetInfo w = FlutterWidgetInfo();
          w.type = FlutterWidgetType.STATEFUL;
          final build = declaration.members.firstWhere(
              (element) => element is MethodDeclaration && element.name.name == FLUTTER_BUILD,
              orElse: () => null);
          w.build = parseBuild(build);
          if (stful.containsKey(clsDef.name)) {
            w.name = stful[clsDef.name];
            widgets.add(w);
          }
        }
      }
    }
    return FlutterFileInfo(widgets);
  }

  InterfaceType findWidgetSupertype(InterfaceType type) {
    final element = type.element;
    if ((element.name == 'State' || element.name == 'StatefulWidget' || element.name == 'StatelessWidget') &&
        element.library.location.toString() == 'package:flutter/src/widgets/framework.dart') {
      return type;
    } else {
      return element.supertype == null ? null : findWidgetSupertype(element.supertype);
    }
  }
}
