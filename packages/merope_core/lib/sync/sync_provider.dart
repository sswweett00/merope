import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_engine.dart';

enum SyncStatus { idle, syncing, error }

class SyncTelemetry {
  const SyncTelemetry({this.pendingOperations = 0});
  final int pendingOperations;
}

final syncEngineProvider = Provider<SyncEngine>((ref) => SyncEngine());

final syncStatusProvider = FutureProvider<SyncStatus>((ref) async {
  final engine = ref.watch(syncEngineProvider);
  return engine.isRunning ? SyncStatus.syncing : SyncStatus.idle;
});

final syncTelemetryControllerProvider = FutureProvider<SyncTelemetry>((ref) async {
  // Durable pending work is intentionally not kept client-side. The server is
  // authoritative, so this compatibility telemetry reports no local queue.
  return const SyncTelemetry();
});
