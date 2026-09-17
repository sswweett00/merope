import '../datasources/developer_local_datasource.dart';
import '../datasources/developer_remote_datasource.dart';
import '../../domain/models/api_key_model.dart';
import '../../domain/models/bot_model.dart';
import '../../domain/models/developer_app_model.dart';
import '../../domain/models/developer_metrics_model.dart';
import '../../domain/models/test_suite_result_model.dart';
import '../../domain/models/webhook_model.dart';
import 'developer_repository.dart';

class DeveloperRepositoryImpl implements IDeveloperRepository {
  final DeveloperRemoteDataSource remote;
  final DeveloperLocalDataSource local;

  DeveloperRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<DeveloperApp>> getApps(String ownerId) async {
    try {
      final apps = await remote.getApps(ownerId);
      await local.cacheApps(ownerId, apps);
      return apps;
    } catch (e) {
      final cached = await local.getApps(ownerId);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<DeveloperApp?> getApp(String appId) async {
    try {
      final app = await remote.getApp(appId);
      if (app != null) await local.cacheApp(app);
      return app;
    } catch (e) {
      return await local.getApp(appId);
    }
  }

  @override
  Future<DeveloperApp> createApp(
      String ownerId, String name, String? description) async {
    final app = await remote.createApp(ownerId, name, description);
    await local.cacheApp(app);
    return app;
  }

  @override
  Future<DeveloperApp> updateApp(DeveloperApp app) async {
    final updated = await remote.updateApp(app);
    await local.cacheApp(updated);
    return updated;
  }

  @override
  Future<void> deleteApp(String appId) async {
    await remote.deleteApp(appId);
    await local.removeApp(appId);
  }

  @override
  Future<void> verifyApp(String appId) => remote.verifyApp(appId);

  @override
  Future<List<ApiKey>> getApiKeys(String appId) async {
    try {
      final keys = await remote.getApiKeys(appId);
      await local.cacheApiKeys(appId, keys);
      return keys;
    } catch (e) {
      final cached = await local.getApiKeys(appId);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<ApiKey?> getApiKey(String keyId) async {
    try {
      final key = await remote.getApiKey(keyId);
      if (key != null) await local.cacheApiKey(key);
      return key;
    } catch (e) {
      return await local.getApiKey(keyId);
    }
  }

  @override
  Future<ApiKey> createApiKey(String appId, String name, String? description,
      List<String> scopes, int ttlDays) async {
    final key =
        await remote.createApiKey(appId, name, description, scopes, ttlDays);
    await local.cacheApiKey(key);
    return key;
  }

  @override
  Future<ApiKey> updateApiKey(ApiKey key) async {
    final updated = await remote.updateApiKey(key);
    await local.cacheApiKey(updated);
    return updated;
  }

  @override
  Future<void> revokeApiKey(String keyId) async {
    await remote.revokeApiKey(keyId);
    await local.removeApiKey(keyId);
  }

  @override
  Future<List<Webhook>> getWebhooks(String appId) async {
    try {
      final hooks = await remote.getWebhooks(appId);
      await local.cacheWebhooks(appId, hooks);
      return hooks;
    } catch (e) {
      final cached = await local.getWebhooks(appId);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<Webhook?> getWebhook(String webhookId) async {
    try {
      final hook = await remote.getWebhook(webhookId);
      if (hook != null) await local.cacheWebhook(hook);
      return hook;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Webhook> createWebhook(
      String appId, String name, String url, List<String> events) async {
    final hook = await remote.createWebhook(appId, name, url, events);
    await local.cacheWebhook(hook);
    return hook;
  }

  @override
  Future<Webhook> updateWebhook(Webhook webhook) async {
    final updated = await remote.updateWebhook(webhook);
    await local.cacheWebhook(updated);
    return updated;
  }

  @override
  Future<void> deleteWebhook(String webhookId) async {
    await remote.deleteWebhook(webhookId);
    await local.removeWebhook(webhookId);
  }

  @override
  Future<void> testWebhook(String webhookId) => remote.testWebhook(webhookId);

  @override
  Future<List<Bot>> getBots(String appId) async {
    try {
      final bots = await remote.getBots(appId);
      await local.cacheBots(appId, bots);
      return bots;
    } catch (e) {
      final cached = await local.getBots(appId);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<Bot?> getBot(String botId) async {
    try {
      final bot = await remote.getBot(botId);
      if (bot != null) await local.cacheBot(bot);
      return bot;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Bot> createBot(String appId, String name, String? description) async {
    final bot = await remote.createBot(appId, name, description);
    await local.cacheBot(bot);
    return bot;
  }

  @override
  Future<Bot> updateBot(Bot bot) async {
    final updated = await remote.updateBot(bot);
    await local.cacheBot(updated);
    return updated;
  }

  @override
  Future<void> deleteBot(String botId) async {
    await remote.deleteBot(botId);
    await local.removeBot(botId);
  }

  @override
  Future<DeveloperMetrics> getMetrics(String appId, String period) async {
    try {
      final metrics = await remote.getMetrics(appId, period);
      await local.cacheMetrics(metrics);
      return metrics;
    } catch (e) {
      final cached = await local.getMetrics(appId, period);
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Stream<DeveloperMetrics> watchMetrics(String appId, String period) {
    return local.watchMetrics(appId, period).map((points) => DeveloperMetrics(
          appId: appId,
          period: period,
          dataPoints: points,
        ));
  }

  @override
  Future<TestSuiteResult> runTestSuite(String appId) async {
    try {
      final result = await remote.runTestSuite(appId);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
