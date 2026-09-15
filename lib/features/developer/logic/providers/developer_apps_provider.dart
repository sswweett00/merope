import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/developer_module_providers.dart';
import '../../domain/models/developer_app_model.dart';

final developerOwnerIdProvider = Provider<String>((ref) {
  return 'me';
});

class DeveloperApps extends FamilyAsyncNotifier<List<DeveloperApp>, String> {
  @override
  FutureOr<List<DeveloperApp>> build(String ownerId) async {
    final repo = ref.watch(developerRepositoryProvider);
    return repo.getApps(ownerId);
  }

  Future<DeveloperApp> createApp(String name, String? description) async {
    final repo = ref.read(developerRepositoryProvider);
    final app = await repo.createApp(arg, name, description);
    ref.invalidateSelf();
    state = AsyncData(await future);
    return app;
  }

  Future<DeveloperApp> updateApp(DeveloperApp app) async {
    final repo = ref.read(developerRepositoryProvider);
    final updated = await repo.updateApp(app);
    ref.invalidateSelf();
    state = AsyncData(await future);
    return updated;
  }

  Future<void> deleteApp(String appId) async {
    final repo = ref.read(developerRepositoryProvider);
    await repo.deleteApp(appId);
    ref.invalidateSelf();
    state = AsyncData(await future);
  }

  Future<void> verifyApp(String appId) async {
    final repo = ref.read(developerRepositoryProvider);
    await repo.verifyApp(appId);
  }

  Future<void> refresh() => future.then((_) => null);
}

final developerAppsProvider = AsyncNotifierProviderFamily<DeveloperApps, List<DeveloperApp>, String>(DeveloperApps.new);
