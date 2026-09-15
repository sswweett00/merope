import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/secure_network_service.dart';
import 'package:merope_core/utils/isolate_worker.dart';

/// Enterprise Realtime Repository handling WebSocket & gRPC streams
/// with background Isolate parsing and Riverpod state integration.
class RealtimeRepository {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  RealtimeRepository();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  /// Simulates receiving binary payload from WebSocket/gRPC stream
  /// and dispatching it to an Isolate worker to maintain 120 FPS.
  Future<void> handleIncomingBinaryData(Uint8List rawBytes) async {
    try {
      // Offload heavy parsing/decryption to background isolate
      final parsedData = await IsolateWorker.parseLargePayload(rawBytes);
      _controller.add(parsedData);
    } catch (e) {
      _controller.addError(e);
    }
  }

  void dispose() {
    _controller.close();
  }
}

// Riverpod Provider for Enterprise Realtime Repository
final secureNetworkServiceProvider = Provider((ref) => SecureNetworkService());

final realtimeRepositoryProvider = Provider((ref) {
  return RealtimeRepository();
});

final realtimeStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final repo = ref.watch(realtimeRepositoryProvider);
  return repo.stream;
});
