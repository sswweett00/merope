import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import '../data/database/merope_database.dart';
import '../plugins/isolate_manager.dart';
import 'package:merope_core/sync/veritas_integrity_engine.dart';
import 'operation_log.dart';
import 'sync_telemetry.dart';
import 'sync_profile.dart';

abstract class ISyncNetworkAdapter {
  Future<bool> sendOperation(OperationLogEntry entry);
}

class SyncException implements Exception {
  final String message;
  const SyncException(this.message);

  @override
  String toString() => 'SyncException: $message';
}

enum SyncStatus { idle, syncing, error }

/// Offline-First Sync Engine
class SyncEngine {
  static const _maxPayloadSize = 5 * 1024 * 1024; // 5MB for massive content
  static const _maxRetries = 5;

  final ISyncNetworkAdapter _networkAdapter;
  final MeropeDatabase _db;
  final IsolateManager _isolateManager = IsolateManager();
  bool _isSyncing = false;
  SyncProfile _profile = SyncProfile.standard;

  final _statusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get onStatusChanged => _statusController.stream;
  SyncStatus _currentStatus = SyncStatus.idle;
  SyncStatus get currentStatus => _currentStatus;

  void _setStatus(SyncStatus status) {
    if (_currentStatus == status) return;
    _currentStatus = status;
    _statusController.add(status);
  }

  SyncProfile get profile => _profile;
  void setProfile(SyncProfile profile) {
    _profile = profile;
    _processQueue();
  }

  final StreamController<OperationLogEntry> _syncStreamController = StreamController.broadcast();
  Stream<OperationLogEntry> get onOperationSynced => _syncStreamController.stream;

  final StreamController<SyncTelemetry> _telemetryStreamController = StreamController.broadcast();
  Stream<SyncTelemetry> get onTelemetryUpdated => _telemetryStreamController.stream;

  SyncTelemetry _currentTelemetry = SyncTelemetry.initial();
  SyncTelemetry get currentTelemetry => _currentTelemetry;

  final StreamController<Exception> _errorStreamController = StreamController<Exception>.broadcast();
  Stream<Exception> get onSyncError => _errorStreamController.stream;

  SyncEngine({
    required ISyncNetworkAdapter networkAdapter,
    required MeropeDatabase database,
  })  : _networkAdapter = networkAdapter,
        _db = database;

  Future<OperationLogEntry> enqueue({
    required String entityType,
    required String entityId,
    required OperationType type,
    required Map<String, dynamic> payload,
  }) async {
    // Offload validation and encoding to Isolate
    await _isolateManager.runCompute(_validatePayloadIsolate, {
      'payload': payload,
      'maxSize': _maxPayloadSize,
    });

    // Veritas: Cryptographic Provenance Check
    final isValid = await VeritasIntegrityEngine.executeBlindP2PVerification(
      blindedSignature: payload['signature'] ?? 'unsigned',
      contentCommitment: VeritasIntegrityEngine.generateContentCommitment(
        payload['content'] ?? '',
        'sync_salt',
      ),
    );

    if (!isValid) throw const SyncException('Content integrity verification failed');

    final lastEntry = await (_db.select(_db.operationLogs)
          ..orderBy([(t) => OrderingTerm(expression: t.clientSequence, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();

    final sequence = (lastEntry?.clientSequence ?? 0) + 1;

    final entry = OperationLogEntry(
      entityType: entityType,
      entityId: entityId,
      type: type,
      payload: payload,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      clientSequence: sequence,
    );

    // Use Isolate for JSON encoding before DB insert
    final encodedPayload = await _isolateManager.runCompute(jsonEncode, entry.payload);

    await _db.into(_db.operationLogs).insert(
          OperationLogsCompanion.insert(
            id: entry.id,
            entityType: entry.entityType,
            entityId: entry.entityId,
            operation: entry.type.name,
            performedBy: 'me',
            performedAt: DateTime.fromMillisecondsSinceEpoch(entry.timestamp),
            metadata: Value(encodedPayload),
            clientSequence: Value(entry.clientSequence),
            isSynced: const Value(false),
          ),
        );

    if (_profile.immediateSync) {
      _processQueue();
    }
    return entry;
  }

  static void _validatePayloadIsolate(Map<String, dynamic> data) {
    final payload = data['payload'] as Map<String, dynamic>;
    final maxSize = data['maxSize'] as int;
    final jsonString = jsonEncode(payload);
    if (jsonString.length > maxSize) {
      throw SyncException('Payload exceeds maximum allowed size of $maxSize bytes');
    }
  }

  Future<void> _processQueue() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _setStatus(SyncStatus.syncing);

    try {
      final pendingEntries = await (_db.select(_db.operationLogs)
            ..where((t) => t.isSynced.equals(false))
            ..orderBy([
              (t) => OrderingTerm(expression: t.clientSequence),
            ]))
          .get();

      if (pendingEntries.isEmpty) {
        _updateTelemetry(_currentTelemetry.copyWith(pendingOperations: 0));
        _setStatus(SyncStatus.idle);
        return;
      }

      final pendingCount = pendingEntries.length;
      _updateTelemetry(_currentTelemetry.copyWith(pendingOperations: pendingCount));

      final batchSize = _profile.batchSize;
      for (var i = 0; i < pendingEntries.length; i += batchSize) {
        final end = (i + batchSize < pendingEntries.length) ? i + batchSize : pendingEntries.length;
        final batch = pendingEntries.sublist(i, end);

        final startTime = DateTime.now();
        final success = await _sendBatchWithRetry(batch);
        final latency = DateTime.now().difference(startTime).inMilliseconds.toDouble() / batch.length;

        if (success) {
          final ids = batch.map((e) => e.id).toList();
          await (_db.update(_db.operationLogs)..where((t) => t.id.isIn(ids)))
              .write(const OperationLogsCompanion(isSynced: Value(true)));

          _currentTelemetry = _currentTelemetry.copyWith(
            totalSynced: _currentTelemetry.totalSynced + batch.length,
            averageLatencyMs: (_currentTelemetry.averageLatencyMs == 0)
                ? latency
                : (_currentTelemetry.averageLatencyMs * 0.9 + latency * 0.1),
            lastSyncTime: DateTime.now(),
            pendingOperations: pendingCount - (i + batch.length),
          );
          _updateTelemetry(_currentTelemetry);

          for (final driftEntry in batch) {
             _syncStreamController.add(OperationLogEntry.fromJson({
                'id': driftEntry.id,
                'entityType': driftEntry.entityType,
                'entityId': driftEntry.entityId,
                'type': driftEntry.operation,
                'payload': driftEntry.metadata,
                'timestamp': driftEntry.performedAt.millisecondsSinceEpoch,
                'clientSequence': driftEntry.clientSequence,
                'isSynced': driftEntry.isSynced,
              }),);
          }
        } else {
          // If a batch fails, stop processing to preserve order
          break;
        }
      }
    } catch (e) {
      _setStatus(SyncStatus.error);
      final exception = SyncException('Error in SyncEngine: $e');
      if (!_errorStreamController.isClosed) {
        _errorStreamController.add(exception);
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _sendBatchWithRetry(List<OperationLog> batch) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      attempt++;
      try {
        bool allSuccess = true;
        for (final driftEntry in batch) {
          final decodedPayload = driftEntry.metadata != null
              ? jsonDecode(driftEntry.metadata!) as Map<String, dynamic>
              : <String, dynamic>{};

          final entry = OperationLogEntry(
            id: driftEntry.id,
            entityType: driftEntry.entityType,
            entityId: driftEntry.entityId,
            type: OperationType.values.firstWhere(
              (e) => e.name == driftEntry.operation,
              orElse: () => OperationType.create,
            ),
            payload: decodedPayload,
            timestamp: driftEntry.performedAt.millisecondsSinceEpoch,
            clientSequence: driftEntry.clientSequence ?? 0,
          );

          final success = await _networkAdapter.sendOperation(entry);
          if (!success) {
            allSuccess = false;
            break;
          }
        }
        if (allSuccess) return true;
      } catch (e) {
        if (attempt == _maxRetries) return false;
        await Future.delayed(_profile.retryDelayBase * attempt);
      }
    }
    return false;
  }

  void _updateTelemetry(SyncTelemetry telemetry) {
    if (!_telemetryStreamController.isClosed) {
      _telemetryStreamController.add(telemetry);
    }
  }

  void triggerSync() {
    _processQueue();
  }

  /// High-priority, low-resource sync for background execution
  Future<void> runBackgroundCycle() async {
    if (_isSyncing) return;

    // Switch to background profile (smaller batches, longer retries)
    final originalProfile = _profile;
    _profile = SyncProfile.efficiency;

    await _processQueue();

    _profile = originalProfile;
  }

  Future<void> dispose() async {
    await _syncStreamController.close();
    await _telemetryStreamController.close();
    await _errorStreamController.close();
  }
}
