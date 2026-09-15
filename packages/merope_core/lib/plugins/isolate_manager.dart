import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';

/// IsolateManager handles offloading heavy computations to background isolates
/// to keep the main UI thread at 120 FPS.
class IsolateManager {
  static final IsolateManager _instance = IsolateManager._internal();
  factory IsolateManager() => _instance;
  IsolateManager._internal();

  /// Runs a high-priority task using Flutter's compute function
  Future<R> runCompute<Q, R>(ComputeCallback<Q, R> callback, Q message) {
    return compute(callback, message);
  }

  /// Specialized method for heavy JSON parsing
  Future<dynamic> parseJson(String jsonString) {
    return compute(_decodeJson, jsonString);
  }

  static dynamic _decodeJson(String source) {
    return jsonDecode(source);
  }

  /// Persistent Isolate for background synchronization or encryption tasks
  Isolate? _persistentIsolate;
  SendPort? _sendPort;
  final _pendingRequests = <int, Completer<dynamic>>{};
  int _requestIdCounter = 0;

  final _broadcastController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get broadcastStream => _broadcastController.stream;

  Future<void> initPersistentIsolate() async {
    if (_persistentIsolate != null) return;

    final receivePort = ReceivePort();
    _persistentIsolate = await Isolate.spawn(_persistentEntry, receivePort.sendPort);

    receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is _IsolateResponse) {
        final completer = _pendingRequests.remove(message.id);
        completer?.complete(message.result);
      } else {
        // Broad multiplexing: non-request messages are broadcast globally
        _broadcastController.add(message);
      }
    });
  }

  static void _persistentEntry(SendPort mainSendPort) {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message is _IsolateRequest) {
        try {
          final result = message.task();
          mainSendPort.send(_IsolateResponse(message.id, result));
        } catch (e) {
          mainSendPort.send(_IsolateResponse(message.id, e, isError: true));
        }
      }
    });
  }

  /// Executes a task in the persistent isolate and returns the result.
  Future<R> runInPersistentIsolate<R>(FutureOr<R> Function() task) async {
    if (_persistentIsolate == null) {
      await initPersistentIsolate();
    }

    while (_sendPort == null) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    final id = _requestIdCounter++;
    final completer = Completer<R>();
    _pendingRequests[id] = completer;

    _sendPort!.send(_IsolateRequest(id, task));
    return completer.future;
  }

  /// Zenith: Spawn a non-terminating daemon isolate for Desktop background tasks
  Future<void> spawnDaemonIsolate(void Function() daemonTask) async {
    if (kIsWeb) return;
    await Isolate.spawn((_) => daemonTask(), null);
  }
}

class _IsolateRequest {
  final int id;
  final Function task;
  _IsolateRequest(this.id, this.task);
}

class _IsolateResponse {
  final int id;
  final dynamic result;
  final bool isError;
  _IsolateResponse(this.id, this.result, {this.isError = false});
}
