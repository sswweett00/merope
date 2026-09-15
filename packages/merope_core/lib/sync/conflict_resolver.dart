import 'operation_log.dart';

class ConflictResolver {
  /// Last-Write-Wins (LWW) with Vector Clock tie-breaking
  static OperationLogEntry resolveConflict(OperationLogEntry local, OperationLogEntry remote) {
    if (remote.timestamp > local.timestamp) {
      return remote;
    } else if (local.timestamp > remote.timestamp) {
      return local;
    } else {
      // Tie-break using client sequence or ID lexicographical comparison
      return remote.clientSequence > local.clientSequence ? remote : local;
    }
  }

  static List<OperationLogEntry> batchResolve(List<OperationLogEntry> localQueue, List<OperationLogEntry> remoteQueue) {
    final Map<String, OperationLogEntry> resolvedMap = {};

    for (final entry in localQueue) {
      resolvedMap['${entry.entityType}:${entry.entityId}'] = entry;
    }

    for (final remote in remoteQueue) {
      final key = '${remote.entityType}:${remote.entityId}';
      if (resolvedMap.containsKey(key)) {
        resolvedMap[key] = resolveConflict(resolvedMap[key]!, remote);
      } else {
        resolvedMap[key] = remote;
      }
    }

    return resolvedMap.values.toList();
  }
}
