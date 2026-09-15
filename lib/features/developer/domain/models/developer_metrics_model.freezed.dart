// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'developer_metrics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EndpointStats _$EndpointStatsFromJson(Map<String, dynamic> json) {
  return _EndpointStats.fromJson(json);
}

/// @nodoc
mixin _$EndpointStats {
  String get path => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_count')
  int get requestCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_latency')
  double get avgLatency => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_rate')
  double get errorRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EndpointStatsCopyWith<EndpointStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EndpointStatsCopyWith<$Res> {
  factory $EndpointStatsCopyWith(
          EndpointStats value, $Res Function(EndpointStats) then) =
      _$EndpointStatsCopyWithImpl<$Res, EndpointStats>;
  @useResult
  $Res call(
      {String path,
      String method,
      @JsonKey(name: 'request_count') int requestCount,
      @JsonKey(name: 'avg_latency') double avgLatency,
      @JsonKey(name: 'error_rate') double errorRate});
}

/// @nodoc
class _$EndpointStatsCopyWithImpl<$Res, $Val extends EndpointStats>
    implements $EndpointStatsCopyWith<$Res> {
  _$EndpointStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? method = null,
    Object? requestCount = null,
    Object? avgLatency = null,
    Object? errorRate = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      requestCount: null == requestCount
          ? _value.requestCount
          : requestCount // ignore: cast_nullable_to_non_nullable
              as int,
      avgLatency: null == avgLatency
          ? _value.avgLatency
          : avgLatency // ignore: cast_nullable_to_non_nullable
              as double,
      errorRate: null == errorRate
          ? _value.errorRate
          : errorRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EndpointStatsImplCopyWith<$Res>
    implements $EndpointStatsCopyWith<$Res> {
  factory _$$EndpointStatsImplCopyWith(
          _$EndpointStatsImpl value, $Res Function(_$EndpointStatsImpl) then) =
      __$$EndpointStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String path,
      String method,
      @JsonKey(name: 'request_count') int requestCount,
      @JsonKey(name: 'avg_latency') double avgLatency,
      @JsonKey(name: 'error_rate') double errorRate});
}

/// @nodoc
class __$$EndpointStatsImplCopyWithImpl<$Res>
    extends _$EndpointStatsCopyWithImpl<$Res, _$EndpointStatsImpl>
    implements _$$EndpointStatsImplCopyWith<$Res> {
  __$$EndpointStatsImplCopyWithImpl(
      _$EndpointStatsImpl _value, $Res Function(_$EndpointStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? method = null,
    Object? requestCount = null,
    Object? avgLatency = null,
    Object? errorRate = null,
  }) {
    return _then(_$EndpointStatsImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      requestCount: null == requestCount
          ? _value.requestCount
          : requestCount // ignore: cast_nullable_to_non_nullable
              as int,
      avgLatency: null == avgLatency
          ? _value.avgLatency
          : avgLatency // ignore: cast_nullable_to_non_nullable
              as double,
      errorRate: null == errorRate
          ? _value.errorRate
          : errorRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EndpointStatsImpl implements _EndpointStats {
  const _$EndpointStatsImpl(
      {required this.path,
      required this.method,
      @JsonKey(name: 'request_count') this.requestCount = 0,
      @JsonKey(name: 'avg_latency') this.avgLatency = 0.0,
      @JsonKey(name: 'error_rate') this.errorRate = 0.0});

  factory _$EndpointStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EndpointStatsImplFromJson(json);

  @override
  final String path;
  @override
  final String method;
  @override
  @JsonKey(name: 'request_count')
  final int requestCount;
  @override
  @JsonKey(name: 'avg_latency')
  final double avgLatency;
  @override
  @JsonKey(name: 'error_rate')
  final double errorRate;

  @override
  String toString() {
    return 'EndpointStats(path: $path, method: $method, requestCount: $requestCount, avgLatency: $avgLatency, errorRate: $errorRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndpointStatsImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.requestCount, requestCount) ||
                other.requestCount == requestCount) &&
            (identical(other.avgLatency, avgLatency) ||
                other.avgLatency == avgLatency) &&
            (identical(other.errorRate, errorRate) ||
                other.errorRate == errorRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, path, method, requestCount, avgLatency, errorRate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EndpointStatsImplCopyWith<_$EndpointStatsImpl> get copyWith =>
      __$$EndpointStatsImplCopyWithImpl<_$EndpointStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EndpointStatsImplToJson(
      this,
    );
  }
}

abstract class _EndpointStats implements EndpointStats {
  const factory _EndpointStats(
          {required final String path,
          required final String method,
          @JsonKey(name: 'request_count') final int requestCount,
          @JsonKey(name: 'avg_latency') final double avgLatency,
          @JsonKey(name: 'error_rate') final double errorRate}) =
      _$EndpointStatsImpl;

  factory _EndpointStats.fromJson(Map<String, dynamic> json) =
      _$EndpointStatsImpl.fromJson;

  @override
  String get path;
  @override
  String get method;
  @override
  @JsonKey(name: 'request_count')
  int get requestCount;
  @override
  @JsonKey(name: 'avg_latency')
  double get avgLatency;
  @override
  @JsonKey(name: 'error_rate')
  double get errorRate;
  @override
  @JsonKey(ignore: true)
  _$$EndpointStatsImplCopyWith<_$EndpointStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetricDataPoint _$MetricDataPointFromJson(Map<String, dynamic> json) {
  return _MetricDataPoint.fromJson(json);
}

/// @nodoc
mixin _$MetricDataPoint {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetricDataPointCopyWith<MetricDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricDataPointCopyWith<$Res> {
  factory $MetricDataPointCopyWith(
          MetricDataPoint value, $Res Function(MetricDataPoint) then) =
      _$MetricDataPointCopyWithImpl<$Res, MetricDataPoint>;
  @useResult
  $Res call({DateTime timestamp, double value, String? label});
}

/// @nodoc
class _$MetricDataPointCopyWithImpl<$Res, $Val extends MetricDataPoint>
    implements $MetricDataPointCopyWith<$Res> {
  _$MetricDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? value = null,
    Object? label = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetricDataPointImplCopyWith<$Res>
    implements $MetricDataPointCopyWith<$Res> {
  factory _$$MetricDataPointImplCopyWith(_$MetricDataPointImpl value,
          $Res Function(_$MetricDataPointImpl) then) =
      __$$MetricDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime timestamp, double value, String? label});
}

/// @nodoc
class __$$MetricDataPointImplCopyWithImpl<$Res>
    extends _$MetricDataPointCopyWithImpl<$Res, _$MetricDataPointImpl>
    implements _$$MetricDataPointImplCopyWith<$Res> {
  __$$MetricDataPointImplCopyWithImpl(
      _$MetricDataPointImpl _value, $Res Function(_$MetricDataPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? value = null,
    Object? label = freezed,
  }) {
    return _then(_$MetricDataPointImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetricDataPointImpl implements _MetricDataPoint {
  const _$MetricDataPointImpl(
      {required this.timestamp, this.value = 0.0, this.label});

  factory _$MetricDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetricDataPointImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final double value;
  @override
  final String? label;

  @override
  String toString() {
    return 'MetricDataPoint(timestamp: $timestamp, value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricDataPointImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp, value, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricDataPointImplCopyWith<_$MetricDataPointImpl> get copyWith =>
      __$$MetricDataPointImplCopyWithImpl<_$MetricDataPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetricDataPointImplToJson(
      this,
    );
  }
}

abstract class _MetricDataPoint implements MetricDataPoint {
  const factory _MetricDataPoint(
      {required final DateTime timestamp,
      final double value,
      final String? label}) = _$MetricDataPointImpl;

  factory _MetricDataPoint.fromJson(Map<String, dynamic> json) =
      _$MetricDataPointImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  double get value;
  @override
  String? get label;
  @override
  @JsonKey(ignore: true)
  _$$MetricDataPointImplCopyWith<_$MetricDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeveloperMetrics _$DeveloperMetricsFromJson(Map<String, dynamic> json) {
  return _DeveloperMetrics.fromJson(json);
}

/// @nodoc
mixin _$DeveloperMetrics {
  @JsonKey(name: 'app_id')
  String get appId => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  @JsonKey(name: 'api_requests')
  int get apiRequests => throw _privateConstructorUsedError;
  int get errors => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_latency')
  double get avgLatency => throw _privateConstructorUsedError;
  @JsonKey(name: 'p95_latency')
  double get p95Latency => throw _privateConstructorUsedError;
  @JsonKey(name: 'p99_latency')
  double get p99Latency => throw _privateConstructorUsedError;
  @JsonKey(name: 'success_rate')
  double get successRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'unique_users')
  int get uniqueUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'bandwidth_used')
  int get bandwidthUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_endpoints')
  List<EndpointStats> get topEndpoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'sync_rate')
  double? get syncRate => throw _privateConstructorUsedError;
  double? get load => throw _privateConstructorUsedError;
  double? get latency => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_points')
  List<MetricDataPoint> get dataPoints => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeveloperMetricsCopyWith<DeveloperMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeveloperMetricsCopyWith<$Res> {
  factory $DeveloperMetricsCopyWith(
          DeveloperMetrics value, $Res Function(DeveloperMetrics) then) =
      _$DeveloperMetricsCopyWithImpl<$Res, DeveloperMetrics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'app_id') String appId,
      String period,
      @JsonKey(name: 'api_requests') int apiRequests,
      int errors,
      @JsonKey(name: 'avg_latency') double avgLatency,
      @JsonKey(name: 'p95_latency') double p95Latency,
      @JsonKey(name: 'p99_latency') double p99Latency,
      @JsonKey(name: 'success_rate') double successRate,
      @JsonKey(name: 'unique_users') int uniqueUsers,
      @JsonKey(name: 'bandwidth_used') int bandwidthUsed,
      @JsonKey(name: 'top_endpoints') List<EndpointStats> topEndpoints,
      @JsonKey(name: 'sync_rate') double? syncRate,
      double? load,
      double? latency,
      @JsonKey(name: 'data_points') List<MetricDataPoint> dataPoints});
}

/// @nodoc
class _$DeveloperMetricsCopyWithImpl<$Res, $Val extends DeveloperMetrics>
    implements $DeveloperMetricsCopyWith<$Res> {
  _$DeveloperMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? period = null,
    Object? apiRequests = null,
    Object? errors = null,
    Object? avgLatency = null,
    Object? p95Latency = null,
    Object? p99Latency = null,
    Object? successRate = null,
    Object? uniqueUsers = null,
    Object? bandwidthUsed = null,
    Object? topEndpoints = null,
    Object? syncRate = freezed,
    Object? load = freezed,
    Object? latency = freezed,
    Object? dataPoints = null,
  }) {
    return _then(_value.copyWith(
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      apiRequests: null == apiRequests
          ? _value.apiRequests
          : apiRequests // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as int,
      avgLatency: null == avgLatency
          ? _value.avgLatency
          : avgLatency // ignore: cast_nullable_to_non_nullable
              as double,
      p95Latency: null == p95Latency
          ? _value.p95Latency
          : p95Latency // ignore: cast_nullable_to_non_nullable
              as double,
      p99Latency: null == p99Latency
          ? _value.p99Latency
          : p99Latency // ignore: cast_nullable_to_non_nullable
              as double,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      uniqueUsers: null == uniqueUsers
          ? _value.uniqueUsers
          : uniqueUsers // ignore: cast_nullable_to_non_nullable
              as int,
      bandwidthUsed: null == bandwidthUsed
          ? _value.bandwidthUsed
          : bandwidthUsed // ignore: cast_nullable_to_non_nullable
              as int,
      topEndpoints: null == topEndpoints
          ? _value.topEndpoints
          : topEndpoints // ignore: cast_nullable_to_non_nullable
              as List<EndpointStats>,
      syncRate: freezed == syncRate
          ? _value.syncRate
          : syncRate // ignore: cast_nullable_to_non_nullable
              as double?,
      load: freezed == load
          ? _value.load
          : load // ignore: cast_nullable_to_non_nullable
              as double?,
      latency: freezed == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as double?,
      dataPoints: null == dataPoints
          ? _value.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as List<MetricDataPoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeveloperMetricsImplCopyWith<$Res>
    implements $DeveloperMetricsCopyWith<$Res> {
  factory _$$DeveloperMetricsImplCopyWith(_$DeveloperMetricsImpl value,
          $Res Function(_$DeveloperMetricsImpl) then) =
      __$$DeveloperMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'app_id') String appId,
      String period,
      @JsonKey(name: 'api_requests') int apiRequests,
      int errors,
      @JsonKey(name: 'avg_latency') double avgLatency,
      @JsonKey(name: 'p95_latency') double p95Latency,
      @JsonKey(name: 'p99_latency') double p99Latency,
      @JsonKey(name: 'success_rate') double successRate,
      @JsonKey(name: 'unique_users') int uniqueUsers,
      @JsonKey(name: 'bandwidth_used') int bandwidthUsed,
      @JsonKey(name: 'top_endpoints') List<EndpointStats> topEndpoints,
      @JsonKey(name: 'sync_rate') double? syncRate,
      double? load,
      double? latency,
      @JsonKey(name: 'data_points') List<MetricDataPoint> dataPoints});
}

/// @nodoc
class __$$DeveloperMetricsImplCopyWithImpl<$Res>
    extends _$DeveloperMetricsCopyWithImpl<$Res, _$DeveloperMetricsImpl>
    implements _$$DeveloperMetricsImplCopyWith<$Res> {
  __$$DeveloperMetricsImplCopyWithImpl(_$DeveloperMetricsImpl _value,
      $Res Function(_$DeveloperMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? period = null,
    Object? apiRequests = null,
    Object? errors = null,
    Object? avgLatency = null,
    Object? p95Latency = null,
    Object? p99Latency = null,
    Object? successRate = null,
    Object? uniqueUsers = null,
    Object? bandwidthUsed = null,
    Object? topEndpoints = null,
    Object? syncRate = freezed,
    Object? load = freezed,
    Object? latency = freezed,
    Object? dataPoints = null,
  }) {
    return _then(_$DeveloperMetricsImpl(
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      apiRequests: null == apiRequests
          ? _value.apiRequests
          : apiRequests // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as int,
      avgLatency: null == avgLatency
          ? _value.avgLatency
          : avgLatency // ignore: cast_nullable_to_non_nullable
              as double,
      p95Latency: null == p95Latency
          ? _value.p95Latency
          : p95Latency // ignore: cast_nullable_to_non_nullable
              as double,
      p99Latency: null == p99Latency
          ? _value.p99Latency
          : p99Latency // ignore: cast_nullable_to_non_nullable
              as double,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      uniqueUsers: null == uniqueUsers
          ? _value.uniqueUsers
          : uniqueUsers // ignore: cast_nullable_to_non_nullable
              as int,
      bandwidthUsed: null == bandwidthUsed
          ? _value.bandwidthUsed
          : bandwidthUsed // ignore: cast_nullable_to_non_nullable
              as int,
      topEndpoints: null == topEndpoints
          ? _value._topEndpoints
          : topEndpoints // ignore: cast_nullable_to_non_nullable
              as List<EndpointStats>,
      syncRate: freezed == syncRate
          ? _value.syncRate
          : syncRate // ignore: cast_nullable_to_non_nullable
              as double?,
      load: freezed == load
          ? _value.load
          : load // ignore: cast_nullable_to_non_nullable
              as double?,
      latency: freezed == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as double?,
      dataPoints: null == dataPoints
          ? _value._dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as List<MetricDataPoint>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeveloperMetricsImpl extends _DeveloperMetrics {
  const _$DeveloperMetricsImpl(
      {@JsonKey(name: 'app_id') required this.appId,
      this.period = '24h',
      @JsonKey(name: 'api_requests') this.apiRequests = 0,
      this.errors = 0,
      @JsonKey(name: 'avg_latency') this.avgLatency = 0.0,
      @JsonKey(name: 'p95_latency') this.p95Latency = 0.0,
      @JsonKey(name: 'p99_latency') this.p99Latency = 0.0,
      @JsonKey(name: 'success_rate') this.successRate = 100.0,
      @JsonKey(name: 'unique_users') this.uniqueUsers = 0,
      @JsonKey(name: 'bandwidth_used') this.bandwidthUsed = 0,
      @JsonKey(name: 'top_endpoints')
      final List<EndpointStats> topEndpoints = const [],
      @JsonKey(name: 'sync_rate') this.syncRate,
      this.load,
      this.latency,
      @JsonKey(name: 'data_points')
      final List<MetricDataPoint> dataPoints = const []})
      : _topEndpoints = topEndpoints,
        _dataPoints = dataPoints,
        super._();

  factory _$DeveloperMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeveloperMetricsImplFromJson(json);

  @override
  @JsonKey(name: 'app_id')
  final String appId;
  @override
  @JsonKey()
  final String period;
  @override
  @JsonKey(name: 'api_requests')
  final int apiRequests;
  @override
  @JsonKey()
  final int errors;
  @override
  @JsonKey(name: 'avg_latency')
  final double avgLatency;
  @override
  @JsonKey(name: 'p95_latency')
  final double p95Latency;
  @override
  @JsonKey(name: 'p99_latency')
  final double p99Latency;
  @override
  @JsonKey(name: 'success_rate')
  final double successRate;
  @override
  @JsonKey(name: 'unique_users')
  final int uniqueUsers;
  @override
  @JsonKey(name: 'bandwidth_used')
  final int bandwidthUsed;
  final List<EndpointStats> _topEndpoints;
  @override
  @JsonKey(name: 'top_endpoints')
  List<EndpointStats> get topEndpoints {
    if (_topEndpoints is EqualUnmodifiableListView) return _topEndpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topEndpoints);
  }

  @override
  @JsonKey(name: 'sync_rate')
  final double? syncRate;
  @override
  final double? load;
  @override
  final double? latency;
  final List<MetricDataPoint> _dataPoints;
  @override
  @JsonKey(name: 'data_points')
  List<MetricDataPoint> get dataPoints {
    if (_dataPoints is EqualUnmodifiableListView) return _dataPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataPoints);
  }

  @override
  String toString() {
    return 'DeveloperMetrics(appId: $appId, period: $period, apiRequests: $apiRequests, errors: $errors, avgLatency: $avgLatency, p95Latency: $p95Latency, p99Latency: $p99Latency, successRate: $successRate, uniqueUsers: $uniqueUsers, bandwidthUsed: $bandwidthUsed, topEndpoints: $topEndpoints, syncRate: $syncRate, load: $load, latency: $latency, dataPoints: $dataPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeveloperMetricsImpl &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.apiRequests, apiRequests) ||
                other.apiRequests == apiRequests) &&
            (identical(other.errors, errors) || other.errors == errors) &&
            (identical(other.avgLatency, avgLatency) ||
                other.avgLatency == avgLatency) &&
            (identical(other.p95Latency, p95Latency) ||
                other.p95Latency == p95Latency) &&
            (identical(other.p99Latency, p99Latency) ||
                other.p99Latency == p99Latency) &&
            (identical(other.successRate, successRate) ||
                other.successRate == successRate) &&
            (identical(other.uniqueUsers, uniqueUsers) ||
                other.uniqueUsers == uniqueUsers) &&
            (identical(other.bandwidthUsed, bandwidthUsed) ||
                other.bandwidthUsed == bandwidthUsed) &&
            const DeepCollectionEquality()
                .equals(other._topEndpoints, _topEndpoints) &&
            (identical(other.syncRate, syncRate) ||
                other.syncRate == syncRate) &&
            (identical(other.load, load) || other.load == load) &&
            (identical(other.latency, latency) || other.latency == latency) &&
            const DeepCollectionEquality()
                .equals(other._dataPoints, _dataPoints));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appId,
      period,
      apiRequests,
      errors,
      avgLatency,
      p95Latency,
      p99Latency,
      successRate,
      uniqueUsers,
      bandwidthUsed,
      const DeepCollectionEquality().hash(_topEndpoints),
      syncRate,
      load,
      latency,
      const DeepCollectionEquality().hash(_dataPoints));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeveloperMetricsImplCopyWith<_$DeveloperMetricsImpl> get copyWith =>
      __$$DeveloperMetricsImplCopyWithImpl<_$DeveloperMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeveloperMetricsImplToJson(
      this,
    );
  }
}

abstract class _DeveloperMetrics extends DeveloperMetrics {
  const factory _DeveloperMetrics(
      {@JsonKey(name: 'app_id') required final String appId,
      final String period,
      @JsonKey(name: 'api_requests') final int apiRequests,
      final int errors,
      @JsonKey(name: 'avg_latency') final double avgLatency,
      @JsonKey(name: 'p95_latency') final double p95Latency,
      @JsonKey(name: 'p99_latency') final double p99Latency,
      @JsonKey(name: 'success_rate') final double successRate,
      @JsonKey(name: 'unique_users') final int uniqueUsers,
      @JsonKey(name: 'bandwidth_used') final int bandwidthUsed,
      @JsonKey(name: 'top_endpoints') final List<EndpointStats> topEndpoints,
      @JsonKey(name: 'sync_rate') final double? syncRate,
      final double? load,
      final double? latency,
      @JsonKey(name: 'data_points')
      final List<MetricDataPoint> dataPoints}) = _$DeveloperMetricsImpl;
  const _DeveloperMetrics._() : super._();

  factory _DeveloperMetrics.fromJson(Map<String, dynamic> json) =
      _$DeveloperMetricsImpl.fromJson;

  @override
  @JsonKey(name: 'app_id')
  String get appId;
  @override
  String get period;
  @override
  @JsonKey(name: 'api_requests')
  int get apiRequests;
  @override
  int get errors;
  @override
  @JsonKey(name: 'avg_latency')
  double get avgLatency;
  @override
  @JsonKey(name: 'p95_latency')
  double get p95Latency;
  @override
  @JsonKey(name: 'p99_latency')
  double get p99Latency;
  @override
  @JsonKey(name: 'success_rate')
  double get successRate;
  @override
  @JsonKey(name: 'unique_users')
  int get uniqueUsers;
  @override
  @JsonKey(name: 'bandwidth_used')
  int get bandwidthUsed;
  @override
  @JsonKey(name: 'top_endpoints')
  List<EndpointStats> get topEndpoints;
  @override
  @JsonKey(name: 'sync_rate')
  double? get syncRate;
  @override
  double? get load;
  @override
  double? get latency;
  @override
  @JsonKey(name: 'data_points')
  List<MetricDataPoint> get dataPoints;
  @override
  @JsonKey(ignore: true)
  _$$DeveloperMetricsImplCopyWith<_$DeveloperMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
