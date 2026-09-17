import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/developer_module_providers.dart';
import '../../domain/models/api_key_model.dart';

class DeveloperApiKeys extends FamilyAsyncNotifier<List<ApiKey>, String> {
  @override
  FutureOr<List<ApiKey>> build(String appId) async {
    final repo = ref.watch(developerRepositoryProvider);
    return repo.getApiKeys(appId);
  }

  Future<ApiKey> createApiKey(String appId, String name, String? description,
      List<String> scopes, int ttlDays) async {
    final repo = ref.read(developerRepositoryProvider);
    final key =
        await repo.createApiKey(appId, name, description, scopes, ttlDays);
    ref.invalidateSelf();
    state = AsyncData(await future);
    return key;
  }

  Future<ApiKey> updateApiKey(ApiKey key) async {
    final repo = ref.read(developerRepositoryProvider);
    final updated = await repo.updateApiKey(key);
    ref.invalidateSelf();
    state = AsyncData(await future);
    return updated;
  }

  Future<void> revokeApiKey(String keyId) async {
    final repo = ref.read(developerRepositoryProvider);
    await repo.revokeApiKey(keyId);
    ref.invalidateSelf();
    state = AsyncData(await future);
  }

  Future<void> refresh() => future.then((_) => null);
}

final developerApiKeysProvider =
    AsyncNotifierProviderFamily<DeveloperApiKeys, List<ApiKey>, String>(
        DeveloperApiKeys.new);
