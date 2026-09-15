// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_metrics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EndpointStatsImpl _$$EndpointStatsImplFromJson(Map<String, dynamic> json) =>
    _$EndpointStatsImpl(
      path: json['path'] as String,
      method: json['method'] as String,
      requestCount: (json['request_count'] as num?)?.toInt() ?? 0,
      avgLatency: (json['avg_latency'] as num?)?.toDouble() ?? 0.0,
      errorRate: (json['error_rate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$EndpointStatsImplToJson(_$EndpointStatsImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'method': instance.method,
      'request_count': instance.requestCount,
      'avg_latency': instance.avgLatency,
      'error_rate': instance.errorRate,
    };

_$MetricDataPointImpl _$$MetricDataPointImplFromJson(
        Map<String, dynamic> json) =>
    _$MetricDataPointImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$$MetricDataPointImplToJson(
        _$MetricDataPointImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'value': instance.value,
      'label': instance.label,
    };

_$DeveloperMetricsImpl _$$DeveloperMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$DeveloperMetricsImpl(
      appId: json['app_id'] as String,
      period: json['period'] as String? ?? '24h',
      apiRequests: (json['api_requests'] as num?)?.toInt() ?? 0,
      errors: (json['errors'] as num?)?.toInt() ?? 0,
      avgLatency: (json['avg_latency'] as num?)?.toDouble() ?? 0.0,
      p95Latency: (json['p95_latency'] as num?)?.toDouble() ?? 0.0,
      p99Latency: (json['p99_latency'] as num?)?.toDouble() ?? 0.0,
      successRate: (json['success_rate'] as num?)?.toDouble() ?? 100.0,
      uniqueUsers: (json['unique_users'] as num?)?.toInt() ?? 0,
      bandwidthUsed: (json['bandwidth_used'] as num?)?.toInt() ?? 0,
      topEndpoints: (json['top_endpoints'] as List<dynamic>?)
              ?.map((e) => EndpointStats.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      syncRate: (json['sync_rate'] as num?)?.toDouble(),
      load: (json['load'] as num?)?.toDouble(),
      latency: (json['latency'] as num?)?.toDouble(),
      dataPoints: (json['data_points'] as List<dynamic>?)
              ?.map((e) => MetricDataPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DeveloperMetricsImplToJson(
        _$DeveloperMetricsImpl instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'period': instance.period,
      'api_requests': instance.apiRequests,
      'errors': instance.errors,
      'avg_latency': instance.avgLatency,
      'p95_latency': instance.p95Latency,
      'p99_latency': instance.p99Latency,
      'success_rate': instance.successRate,
      'unique_users': instance.uniqueUsers,
      'bandwidth_used': instance.bandwidthUsed,
      'top_endpoints': instance.topEndpoints,
      'sync_rate': instance.syncRate,
      'load': instance.load,
      'latency': instance.latency,
      'data_points': instance.dataPoints,
    };
