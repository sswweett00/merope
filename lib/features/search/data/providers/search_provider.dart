import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/social_api.dart';

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
  // Mock data for discover tab
  return {
    'trending': [
      TrendingSignal(tag: '#MeropeOS', count: 1200),
      TrendingSignal(tag: '#NeuralSync', count: 850),
      TrendingSignal(tag: '#PulsePay', count: 640),
    ],
    'suggested': [
      SuggestedNode(id: '1', name: 'Dr. Quantum', influence: 0.95),
      SuggestedNode(id: '2', name: 'Aether Labs', influence: 0.88),
      SuggestedNode(id: '3', name: 'Cyber Nomad', influence: 0.76),
    ],
  };
});
