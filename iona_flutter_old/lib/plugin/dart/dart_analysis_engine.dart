import 'dart:isolate';

import 'package:analysis_server/lsp_protocol/protocol_generated.dart';
import 'package:analysis_server/lsp_protocol/protocol_special.dart';
import 'package:analysis_server/src/lsp/handlers/handler_completion.dart';
import 'package:analysis_server/src/lsp/handlers/handlers.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/src/dart/analysis/byte_store.dart';
import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';
import 'package:analyzer/src/dart/analysis/file_byte_store.dart'
    show EvictingFileByteStore;
import 'package:analyzer/src/services/available_declarations.dart';
import 'package:iona_flutter/plugin/dart/model/analysis_message.dart';
import 'package:pedantic/pedantic.dart';

void analysisEngine(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  final port = ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);

  await for (final msg in port) {
    AnalysisMessage data = msg[0];
    SendPort replyTo = msg[1];
    unawaited(DartAnalysisEngine()
        .handleMessage(data)
        .then((value) => replyTo.send(value)));
  }
}

class DartAnalysisEngine {
  static const String SUFFIX_DART = "dart";

  static DartAnalysisEngine instance;

  DartAnalysisEngine._internal() {
    byteStore = createByteStore(resourceProvider);
    declarationsTracker = DeclarationsTracker(byteStore, resourceProvider);
    final cik = CompletionClientCapabilitiesCompletionItemKind(valueSet: [
      CompletionItemKind.Text,
      CompletionItemKind.Method,
      CompletionItemKind.Function,
      CompletionItemKind.Constructor,
      CompletionItemKind.Field,
      CompletionItemKind.Variable,
      CompletionItemKind.Class,
      CompletionItemKind.Interface,
      CompletionItemKind.Module,
      CompletionItemKind.Property,
      CompletionItemKind.Unit,
      CompletionItemKind.Value,
      CompletionItemKind.Enum,
      CompletionItemKind.Keyword,
      CompletionItemKind.Snippet,
      CompletionItemKind.Color,
      CompletionItemKind.File,
      CompletionItemKind.Reference,
    ]);

    final ci = CompletionClientCapabilitiesCompletionItem(
        snippetSupport: false,
        commitCharactersSupport: true,
        documentationFormat: [MarkupKind.Markdown, MarkupKind.PlainText],
        deprecatedSupport: true,
        preselectSupport: true);

    final completionCapabilities = CompletionClientCapabilities(
        completionItemKind: cik, completionItem: ci);
    final textCapabilites =
        TextDocumentClientCapabilities(completion: completionCapabilities);
    capabilities = ClientCapabilities(textDocument: textCapabilites);

    /*cb.ContextBuilder.onCreateAnalysisDriver = (AnalysisDriver driver,
        AnalysisDriverScheduler analysisDriverScheduler,
        performanceLog,
        resourceProvider,
        byteStore,
        fileContentOverlay,
        path,
        sf,
        options) {
      print('oncreateanalysisdriver');
      analysisDriverScheduler.outOfBandWorker =
          CompletionLibrariesWorker(declarationsTracker);
    };*/
  }

  factory DartAnalysisEngine() {
    return instance != null
        ? instance
        : instance = DartAnalysisEngine._internal();
  }

  final OverlayResourceProvider resourceProvider =
      OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);
  DeclarationsTracker declarationsTracker;
  AnalysisContextCollection collection;
  ByteStore byteStore;
  String rootFolder;
  CancelableToken completeToken;
  ClientCapabilities capabilities;

  Future<AnalysisMessage> handleMessage(AnalysisMessage message) async {
    switch (message.type) {
      case 'setRootFolder':
        print('root: ${message.content}');
        final res = await setRootFolder(message.content);
        return AnalysisMessage('setRootFolder.result', res);
        break;
      case 'complete':
        final res = await complete(message.content as CompletionParams);
        return AnalysisMessage('complete.result', res);
        break;
      case 'overlay':
        final overlay = message.content as FileOverlay;
        if (!isDartFileName(overlay.path))
          return AnalysisMessage('overlay.result', false);
        resourceProvider.setOverlay(overlay.path,
            content: overlay.content,
            modificationStamp: DateTime.now().millisecondsSinceEpoch);
        (collection.contextFor(overlay.path) as DriverBasedAnalysisContext)
            .driver
            .changeFile(overlay.path);
        //declarationsTracker.changeFile(overlay.path);
        return AnalysisMessage('overlay.result', true);
        break;
    }
  }

  Future<ErrorOr<List<CompletionItem>>> complete(
      CompletionParams params) async {
    completeToken?.cancel();
    completeToken = CancelableToken();
    try {
      return await CompletionHandler(null, true).handle(params, completeToken);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print((e as NoSuchMethodError).stackTrace);
      return ErrorOr.error(ResponseError(
          code: ErrorCodes.InternalError,
          message: 'Code completion failed',
          data: 'complete'));
    }
  }

  Future<int> setRootFolder(String folder) async {
    declarationsTracker.discardContexts();
    collection = AnalysisContextCollectionImpl(
        includedPaths: [folder],
        resourceProvider: resourceProvider,
        sdkPath: '/Users/ethanelshyeb/fluttersdk/flutter/bin/cache/dart-sdk');
    rootFolder = folder;
    final context = collection.contextFor('$folder/lib/main.dart')
        as DriverBasedAnalysisContext;
    final result =
        await context.currentSession.getResolvedUnit2('$folder/lib/main.dart');

    for (var element in collection.contexts) {
      declarationsTracker.addContext(element);
    }

    if (result is ResolvedUnitResult) {
      return result.state == ResultState.VALID ? 1 : 0;
    }

    return 0;
  }

  ResolvedUnitResult rs;
  AnalysisSession ss;

  Future<ErrorOr<ResolvedUnitResult>> requireResolvedUnit(String path) async {
    final result =
        await collection.contextFor(path).currentSession.getResolvedUnit2(path);

    if (result is ResolvedUnitResult) {
      if (result.state != ResultState.VALID) {
        return error(ErrorCodes.InvalidParams, 'Invalid file path', path);
      }

      return success(result);
    }

    return error(ErrorCodes.InvalidParams, 'Invalid file path', path);
  }

  InterfaceType findWidgetSupertype(InterfaceType type) {
    final element = type.element;
    if ((element.name == 'State' ||
            element.name == 'StatefulWidget' ||
            element.name == 'StatelessWidget') &&
        element.library.location.toString() ==
            'package:flutter/src/widgets/framework.dart') {
      return type;
    } else {
      return element.supertype == null
          ? null
          : findWidgetSupertype(element.supertype);
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
        return MemoryCachingByteStore(
            EvictingFileByteStore(stateLocation.path, G), memoryCacheSize);
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
