import 'package:freezed_annotation/freezed_annotation.dart';

part 'webhook_model.freezed.dart';
part 'webhook_model.g.dart';

enum WebhookRetryStrategy { linear, exponential }
enum WebhookStatus { active, paused, failed }

@freezed
class WebhookRetryPolicy with _$WebhookRetryPolicy {
  const factory WebhookRetryPolicy({
    @JsonKey(name: 'max_retries') @Default(3) int maxRetries,
    @JsonKey(name: 'retry_interval') @Default(60) int retryInterval,
    @JsonKey(name: 'backoff_strategy') @Default(WebhookRetryStrategy.exponential) WebhookRetryStrategy backoffStrategy,
    @Default(30) int timeout,
  }) = _WebhookRetryPolicy;

  factory WebhookRetryPolicy.fromJson(Map<String, dynamic> json) => _$WebhookRetryPolicyFromJson(json);
}

@freezed
class WebhookStats with _$WebhookStats {
  const factory WebhookStats({
    @JsonKey(name: 'total_deliveries') @Default(0) int totalDeliveries,
    @JsonKey(name: 'success_count') @Default(0) int successCount,
    @JsonKey(name: 'failure_count') @Default(0) int failureCount,
    @JsonKey(name: 'avg_response_time') @Default(0.0) double avgResponseTime,
    @JsonKey(name: 'last_delivered_at') DateTime? lastDeliveredAt,
    @JsonKey(name: 'last_failed_at') DateTime? lastFailedAt,
  }) = _WebhookStats;

  factory WebhookStats.fromJson(Map<String, dynamic> json) => _$WebhookStatsFromJson(json);
}

@freezed
class WebhookDeliveryLog with _$WebhookDeliveryLog {
  const factory WebhookDeliveryLog({
    required String id,
    required String payload,
    required int statusCode,
    @Default(false) bool success,
    String? errorMessage,
    @JsonKey(name: 'delivered_at') required DateTime deliveredAt,
    @JsonKey(name: 'response_body') String? responseBody,
  }) = _WebhookDeliveryLog;

  factory WebhookDeliveryLog.fromJson(Map<String, dynamic> json) => _$WebhookDeliveryLogFromJson(json);
}

@freezed
class Webhook with _$Webhook {
  const Webhook._();

  const factory Webhook({
    required String id,
    @JsonKey(name: 'app_id') required String appId,
    required String name,
    @JsonKey(name: 'target_url') required String targetUrl,
    @JsonKey(name: 'secret') String? secret,
    @Default([]) List<String> events,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'retry_policy') WebhookRetryPolicy? retryPolicy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    WebhookStats? stats,
    @Default(WebhookStatus.active) WebhookStatus status,
    @JsonKey(name: 'delivery_logs') @Default([]) List<WebhookDeliveryLog> deliveryLogs,
  }) = _Webhook;

  factory Webhook.fromJson(Map<String, dynamic> json) => _$WebhookFromJson(json);

  bool get isHealthy => status == WebhookStatus.active && (stats?.failureCount ?? 0) == 0;

  bool get hasFailures => (stats?.failureCount ?? 0) > 0;
}
