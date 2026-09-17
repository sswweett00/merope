import '../../domain/models/community_model.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/database/merope_database.dart' as db;
import '../../repository/community_repository.dart';

final communityRepositoryProvider = Provider<ICommunityRepository>((ref) {
  final database = db.MeropeDatabase();
  return DriftCommunityRepository(database, userId: 'user_1');
});

class CollectiveList extends AsyncNotifier<List<Collective>> {
  @override
  FutureOr<List<Collective>> build() async {
    final repo = ref.watch(communityRepositoryProvider);
    final collectives = await repo.getCollectives();

    if (collectives.isEmpty) {
      // Seed some initial data if empty for demo
      return [
        Collective(
          id: 'c1',
          name: 'Neural Explorers',
          description: 'Deep dive into decentralized systems.',
          icon: 'hub',
          slug: 'neural-explorers',
          memberCount: 1240,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          stats: const CollectiveStats(),
        ),
        Collective(
          id: 'c2',
          name: 'Wave Builders',
          description: 'Building the next generation of resonance protocols.',
          icon: 'build',
          slug: 'wave-builders',
          memberCount: 850,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          stats: const CollectiveStats(),
        ),
      ];
    }
    return collectives;
  }
}

final collectiveListProvider =
    AsyncNotifierProvider<CollectiveList, List<Collective>>(CollectiveList.new);
