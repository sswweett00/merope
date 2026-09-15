class SyncTelemetry {
  final int pendingOperations;
  final int totalSynced;
  final double averageLatencyMs;
  final int retryCount;
  final DateTime lastSyncTime;

  const SyncTelemetry({
    required this.pendingOperations,
    required this.totalSynced,
    required this.averageLatencyMs,
    required this.retryCount,
    required this.lastSyncTime,
  });

  SyncTelemetry copyWith({
    int? pendingOperations,
    int? totalSynced,
    double? averageLatencyMs,
    int? retryCount,
    DateTime? lastSyncTime,
  }) {
    return SyncTelemetry(
      pendingOperations: pendingOperations ?? this.pendingOperations,
      totalSynced: totalSynced ?? this.totalSynced,
      averageLatencyMs: averageLatencyMs ?? this.averageLatencyMs,
      retryCount: retryCount ?? this.retryCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  factory SyncTelemetry.initial() {
    return SyncTelemetry(
      pendingOperations: 0,
      totalSynced: 0,
      averageLatencyMs: 0.0,
      retryCount: 0,
      lastSyncTime: DateTime.now(),
    );
  }
}
