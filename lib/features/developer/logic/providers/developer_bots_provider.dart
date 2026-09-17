import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/developer_module_providers.dart';
import '../../domain/models/bot_model.dart';

class DeveloperBots extends FamilyAsyncNotifier<List<Bot>, String> {
  @override
  FutureOr<List<Bot>> build(String appId) async {
    final repo = ref.watch(developerRepositoryProvider);
    return repo.getBots(appId);
  }

  Future<Bot> createBot(String appId, String name, String? description) async {
    final repo = ref.read(developerRepositoryProvider);
    final bot = await repo.createBot(appId, name, description);
    ref.invalidateSelf();
    state = AsyncData(await future);
    return bot;
  }

  Future<Bot> updateBot(Bot bot) async {
    final repo = ref.read(developerRepositoryProvider);
    final updated = await repo.updateBot(bot);
    ref.invalidateSelf();
    state = AsyncData(await future);
    return updated;
  }

  Future<void> deleteBot(String botId) async {
    final repo = ref.read(developerRepositoryProvider);
    await repo.deleteBot(botId);
    ref.invalidateSelf();
    state = AsyncData(await future);
  }

  Future<void> toggleBot(String botId, bool isActive) async {
    final repo = ref.read(developerRepositoryProvider);
    final bot = await repo.getBot(botId);
    if (bot == null) return;
    await repo.updateBot(bot.copyWith(isActive: isActive));
    ref.invalidateSelf();
    state = AsyncData(await future);
  }

  Future<void> bulkToggle(List<String> botIds, bool isActive) async {
    final repo = ref.read(developerRepositoryProvider);
    for (final id in botIds) {
      final bot = await repo.getBot(id);
      if (bot != null) {
        await repo.updateBot(bot.copyWith(isActive: isActive));
      }
    }
    ref.invalidateSelf();
    state = AsyncData(await future);
  }

  Future<void> refresh() => future.then((_) => null);
}

final developerBotsProvider =
    AsyncNotifierProviderFamily<DeveloperBots, List<Bot>, String>(
        DeveloperBots.new);
