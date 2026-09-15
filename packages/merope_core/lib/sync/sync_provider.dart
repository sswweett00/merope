import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_engine.dart';
import 'sync_telemetry.dart';
import 'operation_log.dart';
import '../data/database/database_provider.dart';

// Placeholder Adapter
class _NoopAdapter implements ISyncNetworkAdapter {
  @override
  Future<bool> sendOperation(OperationLogEntry entry) async => true;
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(meropeDatabaseProvider);
  final engine = SyncEngine(networkAdapter: _NoopAdapter(), database: db);

  // Ensure stream controllers are disposed when the provider is disposed
  ref.onDispose(() => engine.dispose());

  return engine;
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final engine = ref.watch(syncEngineProvider);
  // Keep the provider alive while the engine is in use
  ref.keepAlive();
  return engine.onStatusChanged;
});

final syncTelemetryControllerProvider = StreamProvider<SyncTelemetry>((ref) {
  // In a real app, this would be injected via a provider that holds the SyncEngine instance
  // For now, we simulate the stream
  return Stream.periodic(const Duration(seconds: 2), (i) {
    return SyncTelemetry(
      pendingOperations: 10 - i % 5,
      totalSynced: 120 + i * 2,
      averageLatencyMs: 45.0 + (i % 3) * 5,
      retryCount: i % 2,
      lastSyncTime: DateTime.now(),
    );
  });
});
