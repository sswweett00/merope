import 'package:freezed_annotation/freezed_annotation.dart';

part 'developer_metrics_model.freezed.dart';
part 'developer_metrics_model.g.dart';

@freezed
class EndpointStats with _$EndpointStats {
  const factory EndpointStats({
    required String path,
    required String method,
    @JsonKey(name: 'request_count') @Default(0) int requestCount,
    @JsonKey(name: 'avg_latency') @Default(0.0) double avgLatency,
    @JsonKey(name: 'error_rate') @Default(0.0) double errorRate,
  }) = _EndpointStats;

  factory EndpointStats.fromJson(Map<String, dynamic> json) =>
      _$EndpointStatsFromJson(json);
}

@freezed
class MetricDataPoint with _$MetricDataPoint {
  const factory MetricDataPoint({
    required DateTime timestamp,
    @Default(0.0) double value,
    String? label,
  }) = _MetricDataPoint;

  factory MetricDataPoint.fromJson(Map<String, dynamic> json) =>
      _$MetricDataPointFromJson(json);
}

@freezed
class DeveloperMetrics with _$DeveloperMetrics {
  const DeveloperMetrics._();

  const factory DeveloperMetrics({
    @JsonKey(name: 'app_id') required String appId,
    @Default('24h') String period,
    @JsonKey(name: 'api_requests') @Default(0) int apiRequests,
    @Default(0) int errors,
    @JsonKey(name: 'avg_latency') @Default(0.0) double avgLatency,
    @JsonKey(name: 'p95_latency') @Default(0.0) double p95Latency,
    @JsonKey(name: 'p99_latency') @Default(0.0) double p99Latency,
    @JsonKey(name: 'success_rate') @Default(100.0) double successRate,
    @JsonKey(name: 'unique_users') @Default(0) int uniqueUsers,
    @JsonKey(name: 'bandwidth_used') @Default(0) int bandwidthUsed,
    @JsonKey(name: 'top_endpoints')
    @Default([])
    List<EndpointStats> topEndpoints,
    @JsonKey(name: 'sync_rate') double? syncRate,
    double? load,
    double? latency,
    @JsonKey(name: 'data_points') @Default([]) List<MetricDataPoint> dataPoints,
  }) = _DeveloperMetrics;

  factory DeveloperMetrics.fromJson(Map<String, dynamic> json) =>
      _$DeveloperMetricsFromJson(json);

  List<MetricDataPoint> get latencySeries => dataPoints;

  double get healthScore {
    if (apiRequests == 0) return 100.0;
    var score = successRate;
    score -= (errors.toDouble() / apiRequests) * 5;
    if (avgLatency > 1000) score -= 10;
    if (score < 0) score = 0.0;
    if (score > 100) score = 100.0;
    return score;
  }
}
