enum SyncProfile {
  /// Optimizes for battery and data. Batches heavily and delays sync.
  eco,

  /// Balanced performance. Standard batching and retry logic.
  standard,

  /// Ultra-low latency. Immediate sync and smaller batches.
  realtime,

  /// Optimized for background tasks.
  efficiency;

  int get batchSize {
    switch (this) {
      case SyncProfile.eco: return 20;
      case SyncProfile.standard: return 10;
      case SyncProfile.realtime: return 5;
      case SyncProfile.efficiency: return 15;
    }
  }

  Duration get retryDelayBase {
    switch (this) {
      case SyncProfile.eco: return const Duration(seconds: 5);
      case SyncProfile.standard: return const Duration(milliseconds: 500);
      case SyncProfile.realtime: return const Duration(milliseconds: 100);
      case SyncProfile.efficiency: return const Duration(seconds: 2);
    }
  }

  bool get immediateSync {
    switch (this) {
      case SyncProfile.eco:
      case SyncProfile.efficiency:
        return false;
      default: return true;
    }
  }
}
