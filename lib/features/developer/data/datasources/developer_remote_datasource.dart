import 'package:dio/dio.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_core/data/services/exceptions.dart';
import '../../domain/models/api_key_model.dart';
import '../../domain/models/bot_model.dart';
import '../../domain/models/developer_app_model.dart';
import '../../domain/models/developer_metrics_model.dart';
import '../../domain/models/test_suite_result_model.dart';
import '../../domain/models/webhook_model.dart';

abstract class DeveloperRemoteDataSource {
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
  Stream<DeveloperMetrics> streamMetrics(String appId);
  Future<TestSuiteResult> runTestSuite(String appId);
}

class DeveloperRemoteDataSourceImpl implements DeveloperRemoteDataSource {
  final Dio _dio;
  final ApiClient _apiClient;

  DeveloperRemoteDataSourceImpl({Dio? dio, ApiClient? apiClient})
      : _dio = dio ?? ApiClient().dio,
        _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<DeveloperApp>> getApps(String ownerId) async {
    final result = await _apiClient.get<List<dynamic>>('/developer/apps',
        queryParameters: {'owner_id': ownerId});
    return result.fold(
      (data) => (data ?? [])
          .map((e) => DeveloperApp.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<DeveloperApp?> getApp(String appId) async {
    final result =
        await _apiClient.get<Map<String, dynamic>>('/developer/apps/$appId');
    return result.fold(
      (data) => data != null ? DeveloperApp.fromJson(data) : null,
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<DeveloperApp> createApp(
      String ownerId, String name, String? description) async {
    final result =
        await _apiClient.post<Map<String, dynamic>>('/developer/apps', data: {
      'owner_id': ownerId,
      'name': name,
      if (description != null) 'description': description,
    });
    return result.fold(
      (data) => DeveloperApp.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<DeveloperApp> updateApp(DeveloperApp app) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
        '/developer/apps/${app.id}',
        data: app.toJson());
    return result.fold(
      (data) => DeveloperApp.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<void> deleteApp(String appId) async {
    final result = await _apiClient.delete<void>('/developer/apps/$appId');
    result.fold(
      (_) {},
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<void> verifyApp(String appId) async {
    final result = await _apiClient.post<void>('/developer/apps/$appId/verify');
    result.fold(
      (_) {},
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<List<ApiKey>> getApiKeys(String appId) async {
    final result = await _apiClient
        .get<Map<String, dynamic>>('/developer/apps/$appId/api-keys');
    return result.fold(
      (data) => (data?['keys'] as List<dynamic>? ?? [])
          .map((e) => ApiKey.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<ApiKey?> getApiKey(String keyId) async {
    final result = await _apiClient
        .get<Map<String, dynamic>>('/developer/api-keys/$keyId');
    return result.fold(
      (data) => data != null ? ApiKey.fromJson(data) : null,
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<ApiKey> createApiKey(String appId, String name, String? description,
      List<String> scopes, int ttlDays) async {
    final result = await _apiClient
        .post<Map<String, dynamic>>('/developer/apps/$appId/api-keys', data: {
      'name': name,
      if (description != null) 'description': description,
      'scopes': scopes,
      'ttl_days': ttlDays,
    });
    return result.fold(
      (data) => ApiKey.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<ApiKey> updateApiKey(ApiKey key) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
        '/developer/api-keys/${key.id}',
        data: key.toJson());
    return result.fold(
      (data) => ApiKey.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<void> revokeApiKey(String keyId) async {
    final result = await _apiClient.delete<void>('/developer/api-keys/$keyId');
    result.fold(
      (_) {},
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<List<Webhook>> getWebhooks(String appId) async {
    final result = await _apiClient
        .get<Map<String, dynamic>>('/developer/apps/$appId/webhooks');
    return result.fold(
      (data) => (data?['webhooks'] as List<dynamic>? ?? [])
          .map((e) => Webhook.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<Webhook?> getWebhook(String webhookId) async {
    final result = await _apiClient
        .get<Map<String, dynamic>>('/developer/webhooks/$webhookId');
    return result.fold(
      (data) => data != null ? Webhook.fromJson(data) : null,
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<Webhook> createWebhook(
      String appId, String name, String url, List<String> events) async {
    final result = await _apiClient
        .post<Map<String, dynamic>>('/developer/apps/$appId/webhooks', data: {
      'name': name,
      'url': url,
      'events': events,
    });
    return result.fold(
      (data) => Webhook.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<Webhook> updateWebhook(Webhook webhook) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
        '/developer/webhooks/${webhook.id}',
        data: webhook.toJson());
    return result.fold(
      (data) => Webhook.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<void> deleteWebhook(String webhookId) async {
    final result =
        await _apiClient.delete<void>('/developer/webhooks/$webhookId');
    result.fold(
      (_) {},
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<void> testWebhook(String webhookId) async {
    final result = await _apiClient
        .post<void>('/developer/webhooks/$webhookId/test', data: {});
    result.fold(
      (_) {},
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<List<Bot>> getBots(String appId) async {
    final result =
        await _apiClient.get<List<dynamic>>('/developer/apps/$appId/bots');
    return result.fold(
      (data) => (data ?? [])
          .map((e) => Bot.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<Bot?> getBot(String botId) async {
    final result =
        await _apiClient.get<Map<String, dynamic>>('/developer/bots/$botId');
    return result.fold(
      (data) => data != null ? Bot.fromJson(data) : null,
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<Bot> createBot(String appId, String name, String? description) async {
    final result = await _apiClient
        .post<Map<String, dynamic>>('/developer/apps/$appId/bots', data: {
      'name': name,
      if (description != null) 'description': description,
    });
    return result.fold(
      (data) => Bot.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<Bot> updateBot(Bot bot) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
        '/developer/bots/${bot.id}',
        data: bot.toJson());
    return result.fold(
      (data) => Bot.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<void> deleteBot(String botId) async {
    final result = await _apiClient.delete<void>('/developer/bots/$botId');
    result.fold(
      (_) {},
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Future<DeveloperMetrics> getMetrics(String appId, String period) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
        '/developer/apps/$appId/metrics',
        queryParameters: {'period': period});
    return result.fold(
      (data) => DeveloperMetrics.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }

  @override
  Stream<DeveloperMetrics> streamMetrics(String appId) async* {
    yield await getMetrics(appId, 'realtime');
  }

  @override
  Future<TestSuiteResult> runTestSuite(String appId) async {
    final result = await _apiClient
        .post<Map<String, dynamic>>('/developer/apps/$appId/test-suite');
    return result.fold(
      (data) => TestSuiteResult.fromJson(data!),
      (error) => throw MeropeAPIException.fromDioError(error),
    );
  }
}
