import 'realtime_client.dart';

abstract class IPresenceRepository {
  Future<void> updatePresence({required String userId, required bool isOnline});
  Future<void> updateLastSeen({required String userId});
  Stream<Map<String, String>> getPresenceStream();
}

class PresenceService implements IPresenceRepository {
  final RealtimeClient _realtime;
  final Map<String, String> _presenceCache = {};

  PresenceService(this._realtime);

  @override
  Future<void> updatePresence(
      {required String userId, required bool isOnline}) async {
    _presenceCache[userId] = isOnline ? 'online' : 'offline';
    if (_realtime.isConnected) {
      _realtime.sendEvent(
        'PRESENCE',
        {'user_id': userId, 'status': isOnline ? 'online' : 'offline'},
      );
    }
  }

  @override
  Future<void> updateLastSeen({required String userId}) async {
    _presenceCache[userId] = 'away';
  }

  @override
  Stream<Map<String, String>> getPresenceStream() {
    return _realtime.onPresence;
  }

  Map<String, String> get cachedPresence => Map.unmodifiable(_presenceCache);
}
