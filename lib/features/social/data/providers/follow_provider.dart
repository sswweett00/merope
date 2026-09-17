import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowList
    extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
  @override
  FutureOr<List<Map<String, dynamic>>> build(String arg) async {
    // Simulated API fetch
    await Future.delayed(const Duration(milliseconds: 600));
    final List<Map<String, dynamic>> users = [];
    for (var i = 1; i <= 10; i++) {
      users.add({
        'id': 'u$i',
        'username': 'explorer_$i',
        'displayName': 'Explorer $i',
        'isSyncing': i % 3 == 0,
      });
    }
    return users;
  }

  Future<void> toggleSync(String userId) async {
    final previousState = state.value ?? [];
    final newState = previousState.map((u) {
      if (u['id'] == userId) {
        return {...u, 'isSyncing': !(u['isSyncing'] as bool)};
      }
      return u;
    }).toList();
    state = AsyncValue.data(newState);
  }
}

final followListProvider =
    AsyncNotifierProviderFamily<FollowList, List<Map<String, dynamic>>, String>(
        FollowList.new);
