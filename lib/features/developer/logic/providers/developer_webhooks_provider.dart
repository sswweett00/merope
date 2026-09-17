import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/developer_module_providers.dart';
import '../../domain/models/webhook_model.dart';

class DeveloperWebhooks extends FamilyAsyncNotifier<List<Webhook>, String> {
  @override
  FutureOr<List<Webhook>> build(String appId) async {
    final repo = ref.watch(developerRepositoryProvider);
    return repo.getWebhooks(appId);
  }

  Future<Webhook> createWebhook(
      String appId, String name, String url, List<String> events) async {
    final repo = ref.read(developerRepositoryProvider);
    final hook = await repo.createWebhook(appId, name, url, events);
    ref.invalidateSelf();
    state = AsyncData(await future);
    return hook;
  }

  Future<Webhook> updateWebhook(Webhook webhook) async {
    final repo = ref.read(developerRepositoryProvider);
    final updated = await repo.updateWebhook(webhook);
    ref.invalidateSelf();
    state = AsyncData(await future);
    return updated;
  }

  Future<void> deleteWebhook(String webhookId) async {
    final repo = ref.read(developerRepositoryProvider);
    await repo.deleteWebhook(webhookId);
    ref.invalidateSelf();
    state = AsyncData(await future);
  }

  Future<void> toggleWebhook(String webhookId, bool isActive) async {
    final repo = ref.read(developerRepositoryProvider);
    final existing = await _findById(webhookId);
    if (existing == null) return;
    await repo.updateWebhook(existing.copyWith(isActive: isActive));
    ref.invalidateSelf();
    state = AsyncData(await future);
  }

  Future<void> testDelivery(String webhookId) async {
    final repo = ref.read(developerRepositoryProvider);
    await repo.testWebhook(webhookId);
    ref.invalidateSelf();
    state = AsyncData(await future);
  }

  Future<Webhook?> _findById(String webhookId) async {
    return await future
        .then((list) => list.firstWhere((w) => w.id == webhookId));
  }

  Future<void> refresh() => future.then((_) => null);
}

final developerWebhooksProvider =
    AsyncNotifierProviderFamily<DeveloperWebhooks, List<Webhook>, String>(
        DeveloperWebhooks.new);
