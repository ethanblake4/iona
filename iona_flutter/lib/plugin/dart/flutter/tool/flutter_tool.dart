import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:iona_flutter/plugin/dart/flutter/tool/daemon_info.dart';
import 'package:iona_flutter/plugin/dart/flutter/tool/debug_port.dart';
import 'package:iona_flutter/plugin/dart/flutter/tool/flutter_device.dart';
import 'package:iona_flutter/plugin/dart/serializers.dart';
import 'package:pedantic/pedantic.dart';

typedef OnDeviceAddedListener = void Function(FlutterDevice device);
typedef DebugPortListener = void Function(DebugPort port);

class FlutterTool {
  /// Create a Shell interface
  FlutterTool._(this.startMode, this._sink, this._err, this._stream, this._kill,
      this._processCompleter) {
    init();
  }

  static final Map<String, FlutterTool> _instance = {};

  static FutureOr<FlutterTool> getInstance(String workingDirectory,
      {String path}) async {
    if (_instance.containsKey(workingDirectory))
      return _instance[workingDirectory];
    final tool = await create(path: path, workingDirectory: workingDirectory);
    return _instance[workingDirectory] = tool;
  }

  final FlutterToolStartMode startMode;
  final IOSink _sink;
  final Stream<String> _stream;
  final Stream<String> _err;
  final Function _kill;

  StreamSubscription _streamSubscription;
  StreamSubscription _errSubscription;

  final Completer<int> _processCompleter;

  int _messageId = 1;
  final Map<int, Completer<String>> _messageResponders = {};

  DaemonInfo connectionInfo;

  OnDeviceAddedListener _onDeviceAddedListener;
  DebugPortListener _debugPortListener;

  // ignore: avoid_setters_without_getters
  set onDeviceAddedListener(OnDeviceAddedListener listener) {
    _onDeviceAddedListener = listener;
    if (connectionInfo != null) {
      enableDevicePolling();
    }
  }

  set debugPortListener(DebugPortListener listener) {
    _debugPortListener = listener;
  }

  /// Create a default shell
  static Future<FlutterTool> create(
      {String path,
      String workingDirectory,
      String deviceId,
      FlutterToolStartMode startMode = FlutterToolStartMode.daemon}) async {
    final startArgs = startMode == FlutterToolStartMode.daemon
        ? ['daemon']
        : [
            if (startMode == FlutterToolStartMode.run) ...[
              'run',
              '-d',
              deviceId
            ] else
              'attach',
            '--machine'
          ];
    final process = await Process.start(path, startArgs,
        workingDirectory: workingDirectory, mode: ProcessStartMode.normal);

    final processCompleter = Completer<int>();
    print('Flutter tool: connection created');
    unawaited(process.exitCode.then(processCompleter.complete));
    final inStream =
        process.stdout.transform(utf8.decoder).transform(const LineSplitter());

    return FlutterTool._(
        startMode,
        process.stdin,
        process.stderr.transform(utf8.decoder).transform(const LineSplitter()),
        inStream,
        process.kill,
        processCompleter);
  }

  void init() {
    _streamSubscription = _stream.listen((messageStr) {
      if (!messageStr.startsWith('[') || !messageStr.endsWith(']')) {
        print('Flutter tool: Invalid message format: $messageStr');
        return;
      }
      try {
        final message =
            json.decode(messageStr.substring(1, messageStr.length - 1));
        if (message.containsKey('event')) {
          _handleEvent(message);
        }
      } catch (e) {
        print('Flutter tool: Failed to decode JSON: $messageStr');
        print(e);
      }
    });
    _errSubscription = _err.listen((errorString) {
      print('Flutter tool: stderr: $errorString');
    });
    _processCompleter.future.then((exitCode) {
      print('Flutter tool: process exited with code $exitCode');
      close();
    });
  }

  void _handleEvent(Map eventMessage) {
    switch (eventMessage['event']) {
      case 'device.added':
        final device = standardDartSerializers.deserializeWith(
            FlutterDevice.serializer, eventMessage['params']);
        if (_onDeviceAddedListener != null) {
          _onDeviceAddedListener(device);
        }
        break;
      case 'daemon.connected':
        connectionInfo = standardDartSerializers.deserializeWith(
            DaemonInfo.serializer, eventMessage['params']);
        print(connectionInfo);
        if (_onDeviceAddedListener != null) {
          enableDevicePolling();
        }
        break;
      case 'app.debugPort':
        final debugPort = standardDartSerializers.deserializeWith(
            DebugPort.serializer, eventMessage['params']);
        if (_debugPortListener != null) {
          _debugPortListener(debugPort);
        }
        break;
    }
  }

  Future<Null> enableDevicePolling() =>
      _internalSendMessage('device.enable').then((_) {});

  Future<String> _internalSendMessage(String method,
      [String serializedParams]) {
    final completer = Completer<String>();
    final id = _messageId++;
    _messageResponders[id] = completer;
    final paramsField =
        serializedParams == null ? '' : '"params":$serializedParams,';
    final message = '[{"method":"$method",$paramsField"id":$id}]';
    print(message);
    _sink.writeln(message);
    return completer.future;
  }

  void close() async {
    await _sink.close();
    await _streamSubscription.cancel();
    await _errSubscription.cancel();
    _kill();
  }
}

enum FlutterToolStartMode { daemon, run, attach }
