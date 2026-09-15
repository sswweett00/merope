import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/database/merope_database.dart';
import 'package:merope_core/data/database/database_provider.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_core/utils/enterprise_logger.dart';

/// Chronos: Merope's High-Performance Background Sync Engine
/// Handles delta updates and ensures offline-first consistency
class ChronosSyncService {
  final MeropeDatabase _db;
  final ApiClient _api = ApiClient();
  Timer? _syncTimer;
  bool _isSyncing = false;

  ChronosSyncService(this._db) {
    _startSyncLoop();
  }

  void _startSyncLoop() {
    // Regular heartbeat sync
    _syncTimer = Timer.periodic(const Duration(seconds: 15), (_) => syncPendingOperations());
  }

  Future<void> syncPendingOperations() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      // Fetch unsynced operations in strict chronological order
      final pendingOps = await (_db.select(_db.operationLogs)
            ..where((t) => t.isSynced.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.performedAt)]))
          .get();

      if (pendingOps.isEmpty) {
        _isSyncing = false;
        return;
      }

      MeropeLogger.info('Chronos: Syncing ${pendingOps.length} pending operations');

      for (final op in pendingOps) {
        final success = await _processOperation(op);
        if (success) {
          // Mark as synced locally
          await (_db.update(_db.operationLogs)..where((t) => t.id.equals(op.id)))
              .write(const OperationLogsCompanion(isSynced: Value(true)));
        } else {
          // Pause sync on failure to preserve causality (happens on connectivity loss)
          MeropeLogger.warn('Chronos: Sync paused due to operation failure: ${op.id}');
          break;
        }
      }
    } catch (e) {
      MeropeLogger.error('Chronos: Sync engine internal error', error: e);
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _processOperation(OperationLog op) async {
    try {
      final payload = op.metadata != null ? jsonDecode(op.metadata!) as Map<String, dynamic> : <String, dynamic>{};

      late ApiResult result;
      switch (op.entityType) {
        case 'message':
          result = await _handleMessageOp(op.operation, op.entityId, payload);
          break;
        case 'community':
          result = await _handleCommunityOp(op.operation, op.entityId, payload);
          break;
        default:
          MeropeLogger.warn('Chronos: Unknown entity type ${op.entityType}');
          return true; // Skip unknown to avoid blocking the queue
      }
      return result.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResult> _handleMessageOp(String operation, String entityId, Map<String, dynamic> payload) async {
    switch (operation) {
      case 'create':
        return await _api.post('/messages/${payload['channel_id']}', data: payload);
      case 'update':
        return await _api.put('/messages/$entityId', data: payload);
      case 'delete':
        return await _api.delete('/messages/$entityId');
      default:
        return const ApiResult.success(null);
    }
  }

  Future<ApiResult> _handleCommunityOp(String operation, String entityId, Map<String, dynamic> payload) async {
    // Community sync implementation placeholder
    return const ApiResult.success(null);
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}

final chronosSyncProvider = Provider<ChronosSyncService>((ref) {
  final db = ref.watch(meropeDatabaseProvider);
  return ChronosSyncService(db);
});
