import 'dart:isolate';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/src/context/builder.dart' as cb;
import 'package:analyzer/src/dart/analysis/byte_store.dart';
import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';
import 'package:analyzer/src/dart/analysis/file_byte_store.dart' show EvictingFileByteStore;
import 'package:analyzer/src/services/available_declarations.dart';
import 'package:iona_flutter/plugin/dart/completion/completion.dart';
import 'package:iona_flutter/plugin/dart/completion/domain/available_suggestions.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_generated.dart';
import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_special.dart';
import 'package:iona_flutter/plugin/dart/lsp/constants.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:iona_flutter/plugin/dart/model/flutter_names.dart';
import 'package:iona_flutter/plugin/dart/parse.dart';
import 'package:iona_flutter/plugin/dart/utils/handlers.dart';

analysisEngine(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  final port = ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);

  await for (final msg in port) {
    AnalysisMessage data = msg[0];
    SendPort replyTo = msg[1];
    final result = await DartAnalysisEngine().handleMessage(data);
    replyTo.send(result);
  }
}

class DartAnalysisEngine {
  static const String SUFFIX_DART = "dart";

  static DartAnalysisEngine instance;

  DartAnalysisEngine._internal() {
    byteStore = createByteStore(resourceProvider);
    declarationsTracker = DeclarationsTracker(byteStore, resourceProvider);

    cb.ContextBuilder.onCreateAnalysisDriver = (driver, AnalysisDriverScheduler analysisDriverScheduler, performanceLog,
        resourceProvider, byteStore, fileContentOverlay, path, sf, options) {
      print('oncreateanalysisdriver');
      analysisDriverScheduler.outOfBandWorker = CompletionLibrariesWorker(declarationsTracker);
    };
  }

  factory DartAnalysisEngine() {
    return instance != null ? instance : instance = DartAnalysisEngine._internal();
  }

  final OverlayResourceProvider resourceProvider = OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);
  DeclarationsTracker declarationsTracker;
  AnalysisContextCollection collection;
  ByteStore byteStore;
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
      case 'complete':
        final res = await complete(message.content as CompletionParams);
        print(res?.result?.length);
        return AnalysisMessage('complete.result', res);
        break;
      case 'overlay':
        final overlay = message.content as FileOverlay;
        if (!isDartFileName(overlay.path)) return AnalysisMessage('overlay.result', false);
        resourceProvider.setOverlay(overlay.path,
            content: overlay.content, modificationStamp: DateTime.now().millisecondsSinceEpoch);
        (collection.contextFor(overlay.path) as DriverBasedAnalysisContext).driver.changeFile(overlay.path);
        declarationsTracker.changeFile(overlay.path);
        return AnalysisMessage('overlay.result', true);
        break;
    }
  }

  Future<ErrorOr<List<CompletionItem>>> complete(CompletionParams params) {
    return Completion().complete(params, CancelableToken());
  }

  Future<int> setRootFolder(String folder) async {
    declarationsTracker.discardContexts();
    collection = AnalysisContextCollection(includedPaths: [folder], resourceProvider: resourceProvider);
    rootFolder = folder;
    final context = collection.contextFor('$folder/lib/main.dart') as DriverBasedAnalysisContext;
    final result = await context.currentSession.getResolvedUnit('$folder/lib/main.dart');

    collection.contexts.forEach((element) {
      declarationsTracker.addContext(element);
    });

    return result.state == ResultState.VALID ? 1 : 0;
  }

  ResolvedUnitResult rs;
  AnalysisSession ss;

  Future<ErrorOr<ResolvedUnitResult>> requireResolvedUnit(String path) async {
    final result = await collection.contextFor(path).currentSession.getResolvedUnit(path);
    if (result?.state != ResultState.VALID) {
      return error(ServerErrorCodes.InvalidFilePath, 'Invalid file path', path);
    }
    return success(result);
  }

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

  /// Return `true` if the given [fileName] is assumed to contain Dart source
  /// code.
  static bool isDartFileName(String fileName) {
    if (fileName == null) {
      return false;
    }
    String extension = FileNameUtilities.getExtension(fileName).toLowerCase();
    return extension == SUFFIX_DART;
  }

  /// Return the LineInfo for the file with the given [path]. The file is
  /// analyzed in one of the analysis drivers to which the file was added,
  /// otherwise in the first driver, otherwise `null` is returned.
  LineInfo getLineInfo(String path) {
    return getAnalysisDriver(path)?.getFileSync(path)?.lineInfo;
  }

  AnalysisDriver getAnalysisDriver(String path) {
    return (collection.contextFor(path) as DriverBasedAnalysisContext).driver;
  }

  ByteStore createByteStore(ResourceProvider resourceProvider) {
    const M = 1024 * 1024 /*1 MiB*/;
    const G = 1024 * 1024 * 1024 /*1 GiB*/;

    const memoryCacheSize = 128 * M;

    if (resourceProvider is OverlayResourceProvider) {
      OverlayResourceProvider overlay = resourceProvider;
      resourceProvider = overlay.baseProvider;
    }
    if (resourceProvider is PhysicalResourceProvider) {
      var stateLocation = resourceProvider.getStateLocation('.analysis-driver');
      if (stateLocation != null) {
        return MemoryCachingByteStore(EvictingFileByteStore(stateLocation.path, G), memoryCacheSize);
      }
    }

    return MemoryCachingByteStore(NullByteStore(), memoryCacheSize);
  }
}

class FileNameUtilities {
  static String getExtension(String fileName) {
    if (fileName == null) {
      return "";
    }
    int index = fileName.lastIndexOf('.');
    if (index >= 0) {
      return fileName.substring(index + 1);
    }
    return "";
  }
}