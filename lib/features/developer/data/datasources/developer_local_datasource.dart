import 'dart:convert';
import 'package:drift/drift.dart';
import '../developer_database.dart'
    hide
        ApiKey,
        Bot,
        DeveloperApp,
        MetricDataPoint,
        Webhook,
        WebhookDeliveryLog;
import '../../domain/models/api_key_model.dart';
import '../../domain/models/bot_model.dart';
import '../../domain/models/developer_app_model.dart';
import '../../domain/models/developer_metrics_model.dart';
import '../../domain/models/webhook_model.dart';

abstract class DeveloperLocalDataSource {
  Future<void> cacheApps(String ownerId, List<DeveloperApp> apps);
  Future<List<DeveloperApp>> getApps(String ownerId);
  Future<void> cacheApp(DeveloperApp app);
  Future<DeveloperApp?> getApp(String appId);
  Future<void> removeApp(String appId);
  Future<void> clearApps();

  Future<void> cacheApiKeys(String appId, List<ApiKey> keys);
  Future<List<ApiKey>> getApiKeys(String appId);
  Future<void> cacheApiKey(ApiKey key);
  Future<ApiKey?> getApiKey(String keyId);
  Future<void> removeApiKey(String keyId);

  Future<void> cacheWebhooks(String appId, List<Webhook> webhooks);
  Future<List<Webhook>> getWebhooks(String appId);
  Future<void> cacheWebhook(Webhook webhook);
  Future<void> removeWebhook(String webhookId);

  Future<void> cacheBots(String appId, List<Bot> bots);
  Future<List<Bot>> getBots(String appId);
  Future<void> cacheBot(Bot bot);
  Future<void> removeBot(String botId);

  Future<void> cacheMetrics(DeveloperMetrics metrics);
  Future<DeveloperMetrics?> getMetrics(String appId, String period);
  Future<void> appendMetricDataPoint(
      String appId, String period, MetricDataPoint point);
  Stream<List<MetricDataPoint>> watchMetrics(String appId, String period);

  Future<void> clearAll();
}

class DriftDeveloperLocalDataSource implements DeveloperLocalDataSource {
  final DeveloperDatabase _db;

  DriftDeveloperLocalDataSource(this._db);

  @override
  Future<void> cacheApps(String ownerId, List<DeveloperApp> apps) async {
    final now = DateTime.now();
    for (final app in apps) {
      await _db.into(_db.developerApps).insert(
            DeveloperAppsCompanion(
              id: Value(app.id),
              ownerId: Value(app.ownerId),
              name: Value(app.name),
              description: Value(app.description),
              clientId: Value(app.clientId),
              clientIdNormalized: Value(app.clientId.toLowerCase()),
              data: Value(jsonEncode(app.toJson())),
              createdAt: Value(app.createdAt),
              updatedAt: Value(app.updatedAt),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  @override
  Future<List<DeveloperApp>> getApps(String ownerId) async {
    final rows = await (_db.select(_db.developerApps)
          ..where((t) => t.ownerId.equals(ownerId)))
        .get();
    return rows
        .map((row) =>
            DeveloperApp.fromJson(jsonDecode(row.data) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheApp(DeveloperApp app) async {
    await _db.into(_db.developerApps).insert(
          DeveloperAppsCompanion(
            id: Value(app.id),
            ownerId: Value(app.ownerId),
            name: Value(app.name),
            description: Value(app.description),
            clientId: Value(app.clientId),
            clientIdNormalized: Value(app.clientId.toLowerCase()),
            data: Value(jsonEncode(app.toJson())),
            createdAt: Value(app.createdAt),
            updatedAt: Value(app.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<DeveloperApp?> getApp(String appId) async {
    final row = await (_db.select(_db.developerApps)
          ..where((t) => t.id.equals(appId)))
        .getSingleOrNull();
    if (row == null) return null;
    return DeveloperApp.fromJson(jsonDecode(row.data) as Map<String, dynamic>);
  }

  @override
  Future<void> removeApp(String appId) async {
    await (_db.delete(_db.developerApps)..where((t) => t.id.equals(appId)))
        .go();
    await (_db.delete(_db.apiKeys)..where((t) => t.appId.equals(appId))).go();
    await (_db.delete(_db.webhooks)..where((t) => t.appId.equals(appId))).go();
    await (_db.delete(_db.bots)..where((t) => t.appId.equals(appId))).go();
    await (_db.delete(_db.metricDataPoints)
          ..where((t) => t.appId.equals(appId)))
        .go();
  }

  @override
  Future<void> clearApps() => _db.delete(_db.developerApps).go();

  @override
  Future<void> cacheApiKeys(String appId, List<ApiKey> keys) async {
    for (final key in keys) {
      await _cacheApiKeyInternal(key);
    }
  }

  @override
  Future<List<ApiKey>> getApiKeys(String appId) async {
    final rows = await (_db.select(_db.apiKeys)
          ..where((t) => t.appId.equals(appId) & t.isActive.equals(true)))
        .get();
    return rows
        .map((row) =>
            ApiKey.fromJson(jsonDecode(row.data) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheApiKey(ApiKey key) => _cacheApiKeyInternal(key);

  Future<void> _cacheApiKeyInternal(ApiKey key) async {
    await _db.into(_db.apiKeys).insert(
          ApiKeysCompanion(
            id: Value(key.id),
            appId: Value(key.appId),
            keyPrefix: Value(key.keyPrefix),
            name: Value(key.name),
            scopes: Value(key.scopes.join(',')),
            data: Value(jsonEncode(key.toJson())),
            expiresAt: Value(key.expiresAt),
            createdAt: Value(key.createdAt),
            lastUsedAt: Value(key.lastUsedAt),
            isActive: Value(key.isValid),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<ApiKey?> getApiKey(String keyId) async {
    final row = await (_db.select(_db.apiKeys)
          ..where((t) => t.id.equals(keyId)))
        .getSingleOrNull();
    if (row == null) return null;
    return ApiKey.fromJson(jsonDecode(row.data) as Map<String, dynamic>);
  }

  @override
  Future<void> removeApiKey(String keyId) async {
    await (_db.delete(_db.apiKeys)..where((t) => t.id.equals(keyId))).go();
  }

  @override
  Future<void> cacheWebhooks(String appId, List<Webhook> webhooks) async {
    for (final wh in webhooks) {
      await _cacheWebhookInternal(wh);
    }
  }

  @override
  Future<List<Webhook>> getWebhooks(String appId) async {
    final rows = await (_db.select(_db.webhooks)
          ..where((t) => t.appId.equals(appId)))
        .get();
    return rows
        .map((row) =>
            Webhook.fromJson(jsonDecode(row.data) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheWebhook(Webhook webhook) => _cacheWebhookInternal(webhook);

  Future<void> _cacheWebhookInternal(Webhook webhook) async {
    await _db.into(_db.webhooks).insert(
          WebhooksCompanion(
            id: Value(webhook.id),
            appId: Value(webhook.appId),
            name: Value(webhook.name),
            targetUrl: Value(webhook.targetUrl),
            events: Value(webhook.events.join(',')),
            data: Value(jsonEncode(webhook.toJson())),
            isActive: Value(webhook.isActive),
            createdAt: Value(webhook.createdAt),
            updatedAt: Value(webhook.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> removeWebhook(String webhookId) async {
    await (_db.delete(_db.webhooks)..where((t) => t.id.equals(webhookId))).go();
    await (_db.delete(_db.webhookDeliveryLogs)
          ..where((t) => t.webhookId.equals(webhookId)))
        .go();
  }

  @override
  Future<void> cacheBots(String appId, List<Bot> bots) async {
    for (final bot in bots) {
      await _cacheBotInternal(bot);
    }
  }

  @override
  Future<List<Bot>> getBots(String appId) async {
    final rows =
        await (_db.select(_db.bots)..where((t) => t.appId.equals(appId))).get();
    return rows
        .map(
            (row) => Bot.fromJson(jsonDecode(row.data) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheBot(Bot bot) => _cacheBotInternal(bot);

  Future<void> _cacheBotInternal(Bot bot) async {
    await _db.into(_db.bots).insert(
          BotsCompanion(
            id: Value(bot.id),
            appId: Value(bot.appId),
            name: Value(bot.name),
            data: Value(jsonEncode(bot.toJson())),
            createdAt: Value(bot.createdAt),
            updatedAt: Value(bot.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> removeBot(String botId) async {
    await (_db.delete(_db.bots)..where((t) => t.id.equals(botId))).go();
  }

  @override
  Future<void> cacheMetrics(DeveloperMetrics metrics) async {
    final rows = await (_db.select(_db.metricDataPoints)
          ..where((t) => t.appId.equals(metrics.appId)))
        .get();
    await (_db.delete(_db.metricDataPoints)
          ..where((t) => t.appId.equals(metrics.appId)))
        .go();
    for (final point in metrics.dataPoints) {
      await _db.into(_db.metricDataPoints).insert(MetricDataPointsCompanion(
            id: Value(
                '${point.timestamp.millisecondsSinceEpoch}_${metrics.appId}'),
            appId: Value(metrics.appId),
            period: Value(metrics.period),
            timestamp: Value(point.timestamp),
            value: Value(point.value),
            label: Value(point.label),
            metricKey: Value('latency'),
          ));
    }
  }

  @override
  Future<DeveloperMetrics?> getMetrics(String appId, String period) async {
    final rows = await (_db.select(_db.metricDataPoints)
          ..where((t) => t.appId.equals(appId) & t.period.equals(period))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
    if (rows.isEmpty) return null;
    final points = rows
        .map((r) => MetricDataPoint(
            timestamp: r.timestamp, value: r.value, label: r.label))
        .toList();
    return DeveloperMetrics(
      appId: appId,
      period: period,
      dataPoints: points,
    );
  }

  @override
  Future<void> appendMetricDataPoint(
      String appId, String period, MetricDataPoint point) async {
    await _db.into(_db.metricDataPoints).insert(MetricDataPointsCompanion(
          id: Value(
              '${point.timestamp.millisecondsSinceEpoch}_${appId}_${point.label ?? 'default'}'),
          appId: Value(appId),
          period: Value(period),
          timestamp: Value(point.timestamp),
          value: Value(point.value),
          label: Value(point.label),
          metricKey: Value(point.label ?? 'default'),
        ));
  }

  @override
  Stream<List<MetricDataPoint>> watchMetrics(String appId, String period) {
    return (_db.select(_db.metricDataPoints)
          ..where((t) => t.appId.equals(appId) & t.period.equals(period))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .watch()
        .map((rows) => rows
            .map((r) => MetricDataPoint(
                timestamp: r.timestamp, value: r.value, label: r.label))
            .toList());
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.developerApps).go();
    await _db.delete(_db.apiKeys).go();
    await _db.delete(_db.webhooks).go();
    await _db.delete(_db.webhookDeliveryLogs).go();
    await _db.delete(_db.bots).go();
    await _db.delete(_db.metricDataPoints).go();
  }
}
