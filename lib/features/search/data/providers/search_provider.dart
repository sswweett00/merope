import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/social_api.dart';
import 'package:merope_core/data/services/api_client.dart';

final nearbyUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final api = ref.read(socialApiServiceProvider);
  // Default coordinates for search/radar if no GPS available
  final result = await api.getNearbyUsers(lat: 41.0082, lon: 28.9784);
  return result.data ?? [];
});

class SuggestedNode {
  final String id;
  final String name;
  final String avatarUrl;
  final double influence;

  SuggestedNode(
      {required this.id,
      required this.name,
      this.avatarUrl = '',
      this.influence = 0.0});
}

class TrendingSignal {
  final String tag;
  final int count;

  TrendingSignal({required this.tag, required this.count});
}


final searchDiscoverProvider =
    FutureProvider<Map<String, List<dynamic>>>((ref) async {
  final api = ApiClient();
  final responses = await Future.wait<dynamic>([
    api.get<dynamic>('/search/trending'),
    api.get<dynamic>('/search/history'),
    api.get<dynamic>('/search/interests'),
  ]);

  final trendingPayload = responses[0] as dynamic;
  final historyPayload = responses[1] as dynamic;
  final interestsPayload = responses[2] as dynamic;

  final suggested = <SuggestedNode>[];
  if (trendingPayload.isSuccess && trendingPayload.data is Map) {
    final raw = (trendingPayload.data as Map)['trending'];
    if (raw is List) {
      for (final item in raw.whereType<Map>()) {
        final map = Map<String, dynamic>.from(item);
        final id = '${map['id'] ?? ''}';
        if (id.isEmpty) continue;
        suggested.add(SuggestedNode(
          id: id,
          name: '${map['title'] ?? map['subtitle'] ?? 'Merope user'}',
          avatarUrl: '',
          influence: (map['score'] as num?)?.toDouble() ?? 0.0,
        ));
      }
    }
  }

  final history = <String>[];
  if (historyPayload.isSuccess && historyPayload.data is Map) {
    final raw = (historyPayload.data as Map)['history'];
    if (raw is List) {
      history.addAll(raw.whereType<Map>().map((e) => '${e['query'] ?? ''}').where((e) => e.isNotEmpty));
    }
  }

  final interests = <String>[];
  if (interestsPayload.isSuccess && interestsPayload.data is Map) {
    final raw = (interestsPayload.data as Map)['interests'];
    if (raw is List) interests.addAll(raw.map((e) => e.toString()).where((e) => e.isNotEmpty));
  }

  return {
    'trending': const <TrendingSignal>[],
    'suggested': suggested,
    'history': history,
    'interests': interests,
  };
});

final searchHistoryProvider = FutureProvider<List<String>>((ref) async {
  final result = await ApiClient().get<dynamic>('/search/history');
  if (result.isError || result.data is! Map) return const <String>[];
  final raw = (result.data as Map)['history'];
  if (raw is! List) return const <String>[];
  return raw.whereType<Map>().map((e) => '${e['query'] ?? ''}').where((e) => e.isNotEmpty).toList(growable: false);
});

final searchInterestsProvider = FutureProvider<List<String>>((ref) async {
  final result = await ApiClient().get<dynamic>('/search/interests');
  if (result.isError || result.data is! Map) return const <String>[];
  final raw = (result.data as Map)['interests'];
  if (raw is! List) return const <String>[];
  return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList(growable: false);
});

Future<void> updateSearchInterests(List<String> interests) async {
  final cleaned = interests.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().take(50).toList(growable: false);
  final result = await ApiClient().post<dynamic>('/search/interests', data: {'interests': cleaned});
  if (result.isError) {
    throw StateError('Failed to update search interests');
  }
}
