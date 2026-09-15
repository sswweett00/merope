// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webhook_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebhookRetryPolicyImpl _$$WebhookRetryPolicyImplFromJson(
        Map<String, dynamic> json) =>
    _$WebhookRetryPolicyImpl(
      maxRetries: (json['max_retries'] as num?)?.toInt() ?? 3,
      retryInterval: (json['retry_interval'] as num?)?.toInt() ?? 60,
      backoffStrategy: $enumDecodeNullable(
              _$WebhookRetryStrategyEnumMap, json['backoff_strategy']) ??
          WebhookRetryStrategy.exponential,
      timeout: (json['timeout'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$$WebhookRetryPolicyImplToJson(
        _$WebhookRetryPolicyImpl instance) =>
    <String, dynamic>{
      'max_retries': instance.maxRetries,
      'retry_interval': instance.retryInterval,
      'backoff_strategy':
          _$WebhookRetryStrategyEnumMap[instance.backoffStrategy]!,
      'timeout': instance.timeout,
    };

const _$WebhookRetryStrategyEnumMap = {
  WebhookRetryStrategy.linear: 'linear',
  WebhookRetryStrategy.exponential: 'exponential',
};

_$WebhookStatsImpl _$$WebhookStatsImplFromJson(Map<String, dynamic> json) =>
    _$WebhookStatsImpl(
      totalDeliveries: (json['total_deliveries'] as num?)?.toInt() ?? 0,
      successCount: (json['success_count'] as num?)?.toInt() ?? 0,
      failureCount: (json['failure_count'] as num?)?.toInt() ?? 0,
      avgResponseTime: (json['avg_response_time'] as num?)?.toDouble() ?? 0.0,
      lastDeliveredAt: json['last_delivered_at'] == null
          ? null
          : DateTime.parse(json['last_delivered_at'] as String),
      lastFailedAt: json['last_failed_at'] == null
          ? null
          : DateTime.parse(json['last_failed_at'] as String),
    );

Map<String, dynamic> _$$WebhookStatsImplToJson(_$WebhookStatsImpl instance) =>
    <String, dynamic>{
      'total_deliveries': instance.totalDeliveries,
      'success_count': instance.successCount,
      'failure_count': instance.failureCount,
      'avg_response_time': instance.avgResponseTime,
      'last_delivered_at': instance.lastDeliveredAt?.toIso8601String(),
      'last_failed_at': instance.lastFailedAt?.toIso8601String(),
    };

_$WebhookDeliveryLogImpl _$$WebhookDeliveryLogImplFromJson(
        Map<String, dynamic> json) =>
    _$WebhookDeliveryLogImpl(
      id: json['id'] as String,
      payload: json['payload'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      success: json['success'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
      deliveredAt: DateTime.parse(json['delivered_at'] as String),
      responseBody: json['response_body'] as String?,
    );

Map<String, dynamic> _$$WebhookDeliveryLogImplToJson(
        _$WebhookDeliveryLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payload': instance.payload,
      'statusCode': instance.statusCode,
      'success': instance.success,
      'errorMessage': instance.errorMessage,
      'delivered_at': instance.deliveredAt.toIso8601String(),
      'response_body': instance.responseBody,
    };

_$WebhookImpl _$$WebhookImplFromJson(Map<String, dynamic> json) =>
    _$WebhookImpl(
      id: json['id'] as String,
      appId: json['app_id'] as String,
      name: json['name'] as String,
      targetUrl: json['target_url'] as String,
      secret: json['secret'] as String?,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['is_active'] as bool? ?? true,
      retryPolicy: json['retry_policy'] == null
          ? null
          : WebhookRetryPolicy.fromJson(
              json['retry_policy'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      stats: json['stats'] == null
          ? null
          : WebhookStats.fromJson(json['stats'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$WebhookStatusEnumMap, json['status']) ??
          WebhookStatus.active,
      deliveryLogs: (json['delivery_logs'] as List<dynamic>?)
              ?.map(
                  (e) => WebhookDeliveryLog.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WebhookImplToJson(_$WebhookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'app_id': instance.appId,
      'name': instance.name,
      'target_url': instance.targetUrl,
      'secret': instance.secret,
      'events': instance.events,
      'is_active': instance.isActive,
      'retry_policy': instance.retryPolicy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'stats': instance.stats,
      'status': _$WebhookStatusEnumMap[instance.status]!,
      'delivery_logs': instance.deliveryLogs,
    };

const _$WebhookStatusEnumMap = {
  WebhookStatus.active: 'active',
  WebhookStatus.paused: 'paused',
  WebhookStatus.failed: 'failed',
};
