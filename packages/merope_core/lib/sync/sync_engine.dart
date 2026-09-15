import 'dart:async';

/// Server-authoritative lifecycle coordinator.
///
/// This is intentionally not an offline-first sync engine. It exposes the
/// legacy lifecycle hooks used by the UI while all durable state remains
/// authoritative on the server.
class SyncEngine {
  bool _running = false;

  Future<void> triggerSync() async {
    _running = true;
    try {
      await Future<void>.delayed(Duration.zero);
    } finally {
      _running = false;
    }
  }

  Future<void> runBackgroundCycle() => triggerSync();

  bool get isRunning => _running;
}
