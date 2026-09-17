import '../../domain/models/api_key_model.dart';
import '../../domain/models/bot_model.dart';
import '../../domain/models/developer_app_model.dart';
import '../../domain/models/developer_metrics_model.dart';
import '../../domain/models/test_suite_result_model.dart';
import '../../domain/models/webhook_model.dart';

abstract class IDeveloperRepository {
  Future<List<DeveloperApp>> getApps(String ownerId);
  Future<DeveloperApp?> getApp(String appId);
  Future<DeveloperApp> createApp(
      String ownerId, String name, String? description);
  Future<DeveloperApp> updateApp(DeveloperApp app);
  Future<void> deleteApp(String appId);
  Future<void> verifyApp(String appId);

  Future<List<ApiKey>> getApiKeys(String appId);
  Future<ApiKey?> getApiKey(String keyId);
  Future<ApiKey> createApiKey(String appId, String name, String? description,
      List<String> scopes, int ttlDays);
  Future<ApiKey> updateApiKey(ApiKey key);
  Future<void> revokeApiKey(String keyId);

  Future<List<Webhook>> getWebhooks(String appId);
  Future<Webhook?> getWebhook(String webhookId);
  Future<Webhook> createWebhook(
      String appId, String name, String url, List<String> events);
  Future<Webhook> updateWebhook(Webhook webhook);
  Future<void> deleteWebhook(String webhookId);
  Future<void> testWebhook(String webhookId);

  Future<List<Bot>> getBots(String appId);
  Future<Bot?> getBot(String botId);
  Future<Bot> createBot(String appId, String name, String? description);
  Future<Bot> updateBot(Bot bot);
  Future<void> deleteBot(String botId);

  Future<DeveloperMetrics> getMetrics(String appId, String period);
  Stream<DeveloperMetrics> watchMetrics(String appId, String period);
  Future<TestSuiteResult> runTestSuite(String appId);
}
