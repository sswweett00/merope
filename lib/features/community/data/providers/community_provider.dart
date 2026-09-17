import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/security/session_storage.dart';

import '../../domain/models/community_model.dart';
import '../../repository/community_repository.dart';
import '../repositories/community_remote_repository.dart';

final communityRepositoryProvider = Provider<ICommunityRepository>((ref) {
  return ApiCommunityRepository(sessionStorage: SessionStorage());
});

class CollectiveList extends AsyncNotifier<List<Collective>> {
  @override
  FutureOr<List<Collective>> build() async {
    final repo = ref.watch(communityRepositoryProvider);
    return repo.getCollectives();
  }
}

final collectiveListProvider =
    AsyncNotifierProvider<CollectiveList, List<Collective>>(CollectiveList.new);
