// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'webhook_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebhookRetryPolicy _$WebhookRetryPolicyFromJson(Map<String, dynamic> json) {
  return _WebhookRetryPolicy.fromJson(json);
}

/// @nodoc
mixin _$WebhookRetryPolicy {
  @JsonKey(name: 'max_retries')
  int get maxRetries => throw _privateConstructorUsedError;
  @JsonKey(name: 'retry_interval')
  int get retryInterval => throw _privateConstructorUsedError;
  @JsonKey(name: 'backoff_strategy')
  WebhookRetryStrategy get backoffStrategy =>
      throw _privateConstructorUsedError;
  int get timeout => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebhookRetryPolicyCopyWith<WebhookRetryPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebhookRetryPolicyCopyWith<$Res> {
  factory $WebhookRetryPolicyCopyWith(
          WebhookRetryPolicy value, $Res Function(WebhookRetryPolicy) then) =
      _$WebhookRetryPolicyCopyWithImpl<$Res, WebhookRetryPolicy>;
  @useResult
  $Res call(
      {@JsonKey(name: 'max_retries') int maxRetries,
      @JsonKey(name: 'retry_interval') int retryInterval,
      @JsonKey(name: 'backoff_strategy') WebhookRetryStrategy backoffStrategy,
      int timeout});
}

/// @nodoc
class _$WebhookRetryPolicyCopyWithImpl<$Res, $Val extends WebhookRetryPolicy>
    implements $WebhookRetryPolicyCopyWith<$Res> {
  _$WebhookRetryPolicyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxRetries = null,
    Object? retryInterval = null,
    Object? backoffStrategy = null,
    Object? timeout = null,
  }) {
    return _then(_value.copyWith(
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      retryInterval: null == retryInterval
          ? _value.retryInterval
          : retryInterval // ignore: cast_nullable_to_non_nullable
              as int,
      backoffStrategy: null == backoffStrategy
          ? _value.backoffStrategy
          : backoffStrategy // ignore: cast_nullable_to_non_nullable
              as WebhookRetryStrategy,
      timeout: null == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebhookRetryPolicyImplCopyWith<$Res>
    implements $WebhookRetryPolicyCopyWith<$Res> {
  factory _$$WebhookRetryPolicyImplCopyWith(_$WebhookRetryPolicyImpl value,
          $Res Function(_$WebhookRetryPolicyImpl) then) =
      __$$WebhookRetryPolicyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'max_retries') int maxRetries,
      @JsonKey(name: 'retry_interval') int retryInterval,
      @JsonKey(name: 'backoff_strategy') WebhookRetryStrategy backoffStrategy,
      int timeout});
}

/// @nodoc
class __$$WebhookRetryPolicyImplCopyWithImpl<$Res>
    extends _$WebhookRetryPolicyCopyWithImpl<$Res, _$WebhookRetryPolicyImpl>
    implements _$$WebhookRetryPolicyImplCopyWith<$Res> {
  __$$WebhookRetryPolicyImplCopyWithImpl(_$WebhookRetryPolicyImpl _value,
      $Res Function(_$WebhookRetryPolicyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxRetries = null,
    Object? retryInterval = null,
    Object? backoffStrategy = null,
    Object? timeout = null,
  }) {
    return _then(_$WebhookRetryPolicyImpl(
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      retryInterval: null == retryInterval
          ? _value.retryInterval
          : retryInterval // ignore: cast_nullable_to_non_nullable
              as int,
      backoffStrategy: null == backoffStrategy
          ? _value.backoffStrategy
          : backoffStrategy // ignore: cast_nullable_to_non_nullable
              as WebhookRetryStrategy,
      timeout: null == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebhookRetryPolicyImpl implements _WebhookRetryPolicy {
  const _$WebhookRetryPolicyImpl(
      {@JsonKey(name: 'max_retries') this.maxRetries = 3,
      @JsonKey(name: 'retry_interval') this.retryInterval = 60,
      @JsonKey(name: 'backoff_strategy')
      this.backoffStrategy = WebhookRetryStrategy.exponential,
      this.timeout = 30});

  factory _$WebhookRetryPolicyImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebhookRetryPolicyImplFromJson(json);

  @override
  @JsonKey(name: 'max_retries')
  final int maxRetries;
  @override
  @JsonKey(name: 'retry_interval')
  final int retryInterval;
  @override
  @JsonKey(name: 'backoff_strategy')
  final WebhookRetryStrategy backoffStrategy;
  @override
  @JsonKey()
  final int timeout;

  @override
  String toString() {
    return 'WebhookRetryPolicy(maxRetries: $maxRetries, retryInterval: $retryInterval, backoffStrategy: $backoffStrategy, timeout: $timeout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebhookRetryPolicyImpl &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.retryInterval, retryInterval) ||
                other.retryInterval == retryInterval) &&
            (identical(other.backoffStrategy, backoffStrategy) ||
                other.backoffStrategy == backoffStrategy) &&
            (identical(other.timeout, timeout) || other.timeout == timeout));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, maxRetries, retryInterval, backoffStrategy, timeout);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebhookRetryPolicyImplCopyWith<_$WebhookRetryPolicyImpl> get copyWith =>
      __$$WebhookRetryPolicyImplCopyWithImpl<_$WebhookRetryPolicyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebhookRetryPolicyImplToJson(
      this,
    );
  }
}

abstract class _WebhookRetryPolicy implements WebhookRetryPolicy {
  const factory _WebhookRetryPolicy(
      {@JsonKey(name: 'max_retries') final int maxRetries,
      @JsonKey(name: 'retry_interval') final int retryInterval,
      @JsonKey(name: 'backoff_strategy')
      final WebhookRetryStrategy backoffStrategy,
      final int timeout}) = _$WebhookRetryPolicyImpl;

  factory _WebhookRetryPolicy.fromJson(Map<String, dynamic> json) =
      _$WebhookRetryPolicyImpl.fromJson;

  @override
  @JsonKey(name: 'max_retries')
  int get maxRetries;
  @override
  @JsonKey(name: 'retry_interval')
  int get retryInterval;
  @override
  @JsonKey(name: 'backoff_strategy')
  WebhookRetryStrategy get backoffStrategy;
  @override
  int get timeout;
  @override
  @JsonKey(ignore: true)
  _$$WebhookRetryPolicyImplCopyWith<_$WebhookRetryPolicyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WebhookStats _$WebhookStatsFromJson(Map<String, dynamic> json) {
  return _WebhookStats.fromJson(json);
}

/// @nodoc
mixin _$WebhookStats {
  @JsonKey(name: 'total_deliveries')
  int get totalDeliveries => throw _privateConstructorUsedError;
  @JsonKey(name: 'success_count')
  int get successCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'failure_count')
  int get failureCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_response_time')
  double get avgResponseTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_delivered_at')
  DateTime? get lastDeliveredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_failed_at')
  DateTime? get lastFailedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebhookStatsCopyWith<WebhookStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebhookStatsCopyWith<$Res> {
  factory $WebhookStatsCopyWith(
          WebhookStats value, $Res Function(WebhookStats) then) =
      _$WebhookStatsCopyWithImpl<$Res, WebhookStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_deliveries') int totalDeliveries,
      @JsonKey(name: 'success_count') int successCount,
      @JsonKey(name: 'failure_count') int failureCount,
      @JsonKey(name: 'avg_response_time') double avgResponseTime,
      @JsonKey(name: 'last_delivered_at') DateTime? lastDeliveredAt,
      @JsonKey(name: 'last_failed_at') DateTime? lastFailedAt});
}

/// @nodoc
class _$WebhookStatsCopyWithImpl<$Res, $Val extends WebhookStats>
    implements $WebhookStatsCopyWith<$Res> {
  _$WebhookStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDeliveries = null,
    Object? successCount = null,
    Object? failureCount = null,
    Object? avgResponseTime = null,
    Object? lastDeliveredAt = freezed,
    Object? lastFailedAt = freezed,
  }) {
    return _then(_value.copyWith(
      totalDeliveries: null == totalDeliveries
          ? _value.totalDeliveries
          : totalDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
      avgResponseTime: null == avgResponseTime
          ? _value.avgResponseTime
          : avgResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastDeliveredAt: freezed == lastDeliveredAt
          ? _value.lastDeliveredAt
          : lastDeliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastFailedAt: freezed == lastFailedAt
          ? _value.lastFailedAt
          : lastFailedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebhookStatsImplCopyWith<$Res>
    implements $WebhookStatsCopyWith<$Res> {
  factory _$$WebhookStatsImplCopyWith(
          _$WebhookStatsImpl value, $Res Function(_$WebhookStatsImpl) then) =
      __$$WebhookStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_deliveries') int totalDeliveries,
      @JsonKey(name: 'success_count') int successCount,
      @JsonKey(name: 'failure_count') int failureCount,
      @JsonKey(name: 'avg_response_time') double avgResponseTime,
      @JsonKey(name: 'last_delivered_at') DateTime? lastDeliveredAt,
      @JsonKey(name: 'last_failed_at') DateTime? lastFailedAt});
}

/// @nodoc
class __$$WebhookStatsImplCopyWithImpl<$Res>
    extends _$WebhookStatsCopyWithImpl<$Res, _$WebhookStatsImpl>
    implements _$$WebhookStatsImplCopyWith<$Res> {
  __$$WebhookStatsImplCopyWithImpl(
      _$WebhookStatsImpl _value, $Res Function(_$WebhookStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDeliveries = null,
    Object? successCount = null,
    Object? failureCount = null,
    Object? avgResponseTime = null,
    Object? lastDeliveredAt = freezed,
    Object? lastFailedAt = freezed,
  }) {
    return _then(_$WebhookStatsImpl(
      totalDeliveries: null == totalDeliveries
          ? _value.totalDeliveries
          : totalDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
      avgResponseTime: null == avgResponseTime
          ? _value.avgResponseTime
          : avgResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastDeliveredAt: freezed == lastDeliveredAt
          ? _value.lastDeliveredAt
          : lastDeliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastFailedAt: freezed == lastFailedAt
          ? _value.lastFailedAt
          : lastFailedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebhookStatsImpl implements _WebhookStats {
  const _$WebhookStatsImpl(
      {@JsonKey(name: 'total_deliveries') this.totalDeliveries = 0,
      @JsonKey(name: 'success_count') this.successCount = 0,
      @JsonKey(name: 'failure_count') this.failureCount = 0,
      @JsonKey(name: 'avg_response_time') this.avgResponseTime = 0.0,
      @JsonKey(name: 'last_delivered_at') this.lastDeliveredAt,
      @JsonKey(name: 'last_failed_at') this.lastFailedAt});

  factory _$WebhookStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebhookStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_deliveries')
  final int totalDeliveries;
  @override
  @JsonKey(name: 'success_count')
  final int successCount;
  @override
  @JsonKey(name: 'failure_count')
  final int failureCount;
  @override
  @JsonKey(name: 'avg_response_time')
  final double avgResponseTime;
  @override
  @JsonKey(name: 'last_delivered_at')
  final DateTime? lastDeliveredAt;
  @override
  @JsonKey(name: 'last_failed_at')
  final DateTime? lastFailedAt;

  @override
  String toString() {
    return 'WebhookStats(totalDeliveries: $totalDeliveries, successCount: $successCount, failureCount: $failureCount, avgResponseTime: $avgResponseTime, lastDeliveredAt: $lastDeliveredAt, lastFailedAt: $lastFailedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebhookStatsImpl &&
            (identical(other.totalDeliveries, totalDeliveries) ||
                other.totalDeliveries == totalDeliveries) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.failureCount, failureCount) ||
                other.failureCount == failureCount) &&
            (identical(other.avgResponseTime, avgResponseTime) ||
                other.avgResponseTime == avgResponseTime) &&
            (identical(other.lastDeliveredAt, lastDeliveredAt) ||
                other.lastDeliveredAt == lastDeliveredAt) &&
            (identical(other.lastFailedAt, lastFailedAt) ||
                other.lastFailedAt == lastFailedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalDeliveries, successCount,
      failureCount, avgResponseTime, lastDeliveredAt, lastFailedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebhookStatsImplCopyWith<_$WebhookStatsImpl> get copyWith =>
      __$$WebhookStatsImplCopyWithImpl<_$WebhookStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebhookStatsImplToJson(
      this,
    );
  }
}

abstract class _WebhookStats implements WebhookStats {
  const factory _WebhookStats(
          {@JsonKey(name: 'total_deliveries') final int totalDeliveries,
          @JsonKey(name: 'success_count') final int successCount,
          @JsonKey(name: 'failure_count') final int failureCount,
          @JsonKey(name: 'avg_response_time') final double avgResponseTime,
          @JsonKey(name: 'last_delivered_at') final DateTime? lastDeliveredAt,
          @JsonKey(name: 'last_failed_at') final DateTime? lastFailedAt}) =
      _$WebhookStatsImpl;

  factory _WebhookStats.fromJson(Map<String, dynamic> json) =
      _$WebhookStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_deliveries')
  int get totalDeliveries;
  @override
  @JsonKey(name: 'success_count')
  int get successCount;
  @override
  @JsonKey(name: 'failure_count')
  int get failureCount;
  @override
  @JsonKey(name: 'avg_response_time')
  double get avgResponseTime;
  @override
  @JsonKey(name: 'last_delivered_at')
  DateTime? get lastDeliveredAt;
  @override
  @JsonKey(name: 'last_failed_at')
  DateTime? get lastFailedAt;
  @override
  @JsonKey(ignore: true)
  _$$WebhookStatsImplCopyWith<_$WebhookStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WebhookDeliveryLog _$WebhookDeliveryLogFromJson(Map<String, dynamic> json) {
  return _WebhookDeliveryLog.fromJson(json);
}

/// @nodoc
mixin _$WebhookDeliveryLog {
  String get id => throw _privateConstructorUsedError;
  String get payload => throw _privateConstructorUsedError;
  int get statusCode => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_at')
  DateTime get deliveredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'response_body')
  String? get responseBody => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebhookDeliveryLogCopyWith<WebhookDeliveryLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebhookDeliveryLogCopyWith<$Res> {
  factory $WebhookDeliveryLogCopyWith(
          WebhookDeliveryLog value, $Res Function(WebhookDeliveryLog) then) =
      _$WebhookDeliveryLogCopyWithImpl<$Res, WebhookDeliveryLog>;
  @useResult
  $Res call(
      {String id,
      String payload,
      int statusCode,
      bool success,
      String? errorMessage,
      @JsonKey(name: 'delivered_at') DateTime deliveredAt,
      @JsonKey(name: 'response_body') String? responseBody});
}

/// @nodoc
class _$WebhookDeliveryLogCopyWithImpl<$Res, $Val extends WebhookDeliveryLog>
    implements $WebhookDeliveryLogCopyWith<$Res> {
  _$WebhookDeliveryLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? payload = null,
    Object? statusCode = null,
    Object? success = null,
    Object? errorMessage = freezed,
    Object? deliveredAt = null,
    Object? responseBody = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveredAt: null == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      responseBody: freezed == responseBody
          ? _value.responseBody
          : responseBody // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebhookDeliveryLogImplCopyWith<$Res>
    implements $WebhookDeliveryLogCopyWith<$Res> {
  factory _$$WebhookDeliveryLogImplCopyWith(_$WebhookDeliveryLogImpl value,
          $Res Function(_$WebhookDeliveryLogImpl) then) =
      __$$WebhookDeliveryLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String payload,
      int statusCode,
      bool success,
      String? errorMessage,
      @JsonKey(name: 'delivered_at') DateTime deliveredAt,
      @JsonKey(name: 'response_body') String? responseBody});
}

/// @nodoc
class __$$WebhookDeliveryLogImplCopyWithImpl<$Res>
    extends _$WebhookDeliveryLogCopyWithImpl<$Res, _$WebhookDeliveryLogImpl>
    implements _$$WebhookDeliveryLogImplCopyWith<$Res> {
  __$$WebhookDeliveryLogImplCopyWithImpl(_$WebhookDeliveryLogImpl _value,
      $Res Function(_$WebhookDeliveryLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? payload = null,
    Object? statusCode = null,
    Object? success = null,
    Object? errorMessage = freezed,
    Object? deliveredAt = null,
    Object? responseBody = freezed,
  }) {
    return _then(_$WebhookDeliveryLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveredAt: null == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      responseBody: freezed == responseBody
          ? _value.responseBody
          : responseBody // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebhookDeliveryLogImpl implements _WebhookDeliveryLog {
  const _$WebhookDeliveryLogImpl(
      {required this.id,
      required this.payload,
      required this.statusCode,
      this.success = false,
      this.errorMessage,
      @JsonKey(name: 'delivered_at') required this.deliveredAt,
      @JsonKey(name: 'response_body') this.responseBody});

  factory _$WebhookDeliveryLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebhookDeliveryLogImplFromJson(json);

  @override
  final String id;
  @override
  final String payload;
  @override
  final int statusCode;
  @override
  @JsonKey()
  final bool success;
  @override
  final String? errorMessage;
  @override
  @JsonKey(name: 'delivered_at')
  final DateTime deliveredAt;
  @override
  @JsonKey(name: 'response_body')
  final String? responseBody;

  @override
  String toString() {
    return 'WebhookDeliveryLog(id: $id, payload: $payload, statusCode: $statusCode, success: $success, errorMessage: $errorMessage, deliveredAt: $deliveredAt, responseBody: $responseBody)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebhookDeliveryLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.responseBody, responseBody) ||
                other.responseBody == responseBody));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, payload, statusCode, success,
      errorMessage, deliveredAt, responseBody);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebhookDeliveryLogImplCopyWith<_$WebhookDeliveryLogImpl> get copyWith =>
      __$$WebhookDeliveryLogImplCopyWithImpl<_$WebhookDeliveryLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebhookDeliveryLogImplToJson(
      this,
    );
  }
}

abstract class _WebhookDeliveryLog implements WebhookDeliveryLog {
  const factory _WebhookDeliveryLog(
          {required final String id,
          required final String payload,
          required final int statusCode,
          final bool success,
          final String? errorMessage,
          @JsonKey(name: 'delivered_at') required final DateTime deliveredAt,
          @JsonKey(name: 'response_body') final String? responseBody}) =
      _$WebhookDeliveryLogImpl;

  factory _WebhookDeliveryLog.fromJson(Map<String, dynamic> json) =
      _$WebhookDeliveryLogImpl.fromJson;

  @override
  String get id;
  @override
  String get payload;
  @override
  int get statusCode;
  @override
  bool get success;
  @override
  String? get errorMessage;
  @override
  @JsonKey(name: 'delivered_at')
  DateTime get deliveredAt;
  @override
  @JsonKey(name: 'response_body')
  String? get responseBody;
  @override
  @JsonKey(ignore: true)
  _$$WebhookDeliveryLogImplCopyWith<_$WebhookDeliveryLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Webhook _$WebhookFromJson(Map<String, dynamic> json) {
  return _Webhook.fromJson(json);
}

/// @nodoc
mixin _$Webhook {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_id')
  String get appId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_url')
  String get targetUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'secret')
  String? get secret => throw _privateConstructorUsedError;
  List<String> get events => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'retry_policy')
  WebhookRetryPolicy? get retryPolicy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  WebhookStats? get stats => throw _privateConstructorUsedError;
  WebhookStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_logs')
  List<WebhookDeliveryLog> get deliveryLogs =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebhookCopyWith<Webhook> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebhookCopyWith<$Res> {
  factory $WebhookCopyWith(Webhook value, $Res Function(Webhook) then) =
      _$WebhookCopyWithImpl<$Res, Webhook>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'app_id') String appId,
      String name,
      @JsonKey(name: 'target_url') String targetUrl,
      @JsonKey(name: 'secret') String? secret,
      List<String> events,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'retry_policy') WebhookRetryPolicy? retryPolicy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      WebhookStats? stats,
      WebhookStatus status,
      @JsonKey(name: 'delivery_logs') List<WebhookDeliveryLog> deliveryLogs});

  $WebhookRetryPolicyCopyWith<$Res>? get retryPolicy;
  $WebhookStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class _$WebhookCopyWithImpl<$Res, $Val extends Webhook>
    implements $WebhookCopyWith<$Res> {
  _$WebhookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appId = null,
    Object? name = null,
    Object? targetUrl = null,
    Object? secret = freezed,
    Object? events = null,
    Object? isActive = null,
    Object? retryPolicy = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stats = freezed,
    Object? status = null,
    Object? deliveryLogs = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetUrl: null == targetUrl
          ? _value.targetUrl
          : targetUrl // ignore: cast_nullable_to_non_nullable
              as String,
      secret: freezed == secret
          ? _value.secret
          : secret // ignore: cast_nullable_to_non_nullable
              as String?,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      retryPolicy: freezed == retryPolicy
          ? _value.retryPolicy
          : retryPolicy // ignore: cast_nullable_to_non_nullable
              as WebhookRetryPolicy?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as WebhookStats?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WebhookStatus,
      deliveryLogs: null == deliveryLogs
          ? _value.deliveryLogs
          : deliveryLogs // ignore: cast_nullable_to_non_nullable
              as List<WebhookDeliveryLog>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WebhookRetryPolicyCopyWith<$Res>? get retryPolicy {
    if (_value.retryPolicy == null) {
      return null;
    }

    return $WebhookRetryPolicyCopyWith<$Res>(_value.retryPolicy!, (value) {
      return _then(_value.copyWith(retryPolicy: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WebhookStatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $WebhookStatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WebhookImplCopyWith<$Res> implements $WebhookCopyWith<$Res> {
  factory _$$WebhookImplCopyWith(
          _$WebhookImpl value, $Res Function(_$WebhookImpl) then) =
      __$$WebhookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'app_id') String appId,
      String name,
      @JsonKey(name: 'target_url') String targetUrl,
      @JsonKey(name: 'secret') String? secret,
      List<String> events,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'retry_policy') WebhookRetryPolicy? retryPolicy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      WebhookStats? stats,
      WebhookStatus status,
      @JsonKey(name: 'delivery_logs') List<WebhookDeliveryLog> deliveryLogs});

  @override
  $WebhookRetryPolicyCopyWith<$Res>? get retryPolicy;
  @override
  $WebhookStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class __$$WebhookImplCopyWithImpl<$Res>
    extends _$WebhookCopyWithImpl<$Res, _$WebhookImpl>
    implements _$$WebhookImplCopyWith<$Res> {
  __$$WebhookImplCopyWithImpl(
      _$WebhookImpl _value, $Res Function(_$WebhookImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appId = null,
    Object? name = null,
    Object? targetUrl = null,
    Object? secret = freezed,
    Object? events = null,
    Object? isActive = null,
    Object? retryPolicy = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stats = freezed,
    Object? status = null,
    Object? deliveryLogs = null,
  }) {
    return _then(_$WebhookImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetUrl: null == targetUrl
          ? _value.targetUrl
          : targetUrl // ignore: cast_nullable_to_non_nullable
              as String,
      secret: freezed == secret
          ? _value.secret
          : secret // ignore: cast_nullable_to_non_nullable
              as String?,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      retryPolicy: freezed == retryPolicy
          ? _value.retryPolicy
          : retryPolicy // ignore: cast_nullable_to_non_nullable
              as WebhookRetryPolicy?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as WebhookStats?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WebhookStatus,
      deliveryLogs: null == deliveryLogs
          ? _value._deliveryLogs
          : deliveryLogs // ignore: cast_nullable_to_non_nullable
              as List<WebhookDeliveryLog>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebhookImpl extends _Webhook {
  const _$WebhookImpl(
      {required this.id,
      @JsonKey(name: 'app_id') required this.appId,
      required this.name,
      @JsonKey(name: 'target_url') required this.targetUrl,
      @JsonKey(name: 'secret') this.secret,
      final List<String> events = const [],
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'retry_policy') this.retryPolicy,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.stats,
      this.status = WebhookStatus.active,
      @JsonKey(name: 'delivery_logs')
      final List<WebhookDeliveryLog> deliveryLogs = const []})
      : _events = events,
        _deliveryLogs = deliveryLogs,
        super._();

  factory _$WebhookImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebhookImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'app_id')
  final String appId;
  @override
  final String name;
  @override
  @JsonKey(name: 'target_url')
  final String targetUrl;
  @override
  @JsonKey(name: 'secret')
  final String? secret;
  final List<String> _events;
  @override
  @JsonKey()
  List<String> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'retry_policy')
  final WebhookRetryPolicy? retryPolicy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  final WebhookStats? stats;
  @override
  @JsonKey()
  final WebhookStatus status;
  final List<WebhookDeliveryLog> _deliveryLogs;
  @override
  @JsonKey(name: 'delivery_logs')
  List<WebhookDeliveryLog> get deliveryLogs {
    if (_deliveryLogs is EqualUnmodifiableListView) return _deliveryLogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deliveryLogs);
  }

  @override
  String toString() {
    return 'Webhook(id: $id, appId: $appId, name: $name, targetUrl: $targetUrl, secret: $secret, events: $events, isActive: $isActive, retryPolicy: $retryPolicy, createdAt: $createdAt, updatedAt: $updatedAt, stats: $stats, status: $status, deliveryLogs: $deliveryLogs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebhookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetUrl, targetUrl) ||
                other.targetUrl == targetUrl) &&
            (identical(other.secret, secret) || other.secret == secret) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.retryPolicy, retryPolicy) ||
                other.retryPolicy == retryPolicy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._deliveryLogs, _deliveryLogs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      appId,
      name,
      targetUrl,
      secret,
      const DeepCollectionEquality().hash(_events),
      isActive,
      retryPolicy,
      createdAt,
      updatedAt,
      stats,
      status,
      const DeepCollectionEquality().hash(_deliveryLogs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebhookImplCopyWith<_$WebhookImpl> get copyWith =>
      __$$WebhookImplCopyWithImpl<_$WebhookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebhookImplToJson(
      this,
    );
  }
}

abstract class _Webhook extends Webhook {
  const factory _Webhook(
      {required final String id,
      @JsonKey(name: 'app_id') required final String appId,
      required final String name,
      @JsonKey(name: 'target_url') required final String targetUrl,
      @JsonKey(name: 'secret') final String? secret,
      final List<String> events,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'retry_policy') final WebhookRetryPolicy? retryPolicy,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final WebhookStats? stats,
      final WebhookStatus status,
      @JsonKey(name: 'delivery_logs')
      final List<WebhookDeliveryLog> deliveryLogs}) = _$WebhookImpl;
  const _Webhook._() : super._();

  factory _Webhook.fromJson(Map<String, dynamic> json) = _$WebhookImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'app_id')
  String get appId;
  @override
  String get name;
  @override
  @JsonKey(name: 'target_url')
  String get targetUrl;
  @override
  @JsonKey(name: 'secret')
  String? get secret;
  @override
  List<String> get events;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'retry_policy')
  WebhookRetryPolicy? get retryPolicy;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  WebhookStats? get stats;
  @override
  WebhookStatus get status;
  @override
  @JsonKey(name: 'delivery_logs')
  List<WebhookDeliveryLog> get deliveryLogs;
  @override
  @JsonKey(ignore: true)
  _$$WebhookImplCopyWith<_$WebhookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
