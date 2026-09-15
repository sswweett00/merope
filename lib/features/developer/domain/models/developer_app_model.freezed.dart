// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'developer_app_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  @JsonKey(name: 'enable_webhooks')
  bool get enableWebhooks => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_realtime')
  bool get enableRealtime => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_batch_api')
  bool get enableBatchApi => throw _privateConstructorUsedError;
  @JsonKey(name: 'rate_limit_per_minute')
  int get rateLimitPerMinute => throw _privateConstructorUsedError;
  @JsonKey(name: 'rate_limit_per_hour')
  int get rateLimitPerHour => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_concurrent_calls')
  int get maxConcurrentCalls => throw _privateConstructorUsedError;
  @JsonKey(name: 'require_user_approval')
  bool get requireUserApproval => throw _privateConstructorUsedError;
  @JsonKey(name: 'auto_approve_tokens')
  bool get autoApproveTokens => throw _privateConstructorUsedError;
  @JsonKey(name: 'token_expiry')
  int get tokenExpiry => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token_expiry')
  int get refreshTokenExpiry => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {@JsonKey(name: 'enable_webhooks') bool enableWebhooks,
      @JsonKey(name: 'enable_realtime') bool enableRealtime,
      @JsonKey(name: 'enable_batch_api') bool enableBatchApi,
      @JsonKey(name: 'rate_limit_per_minute') int rateLimitPerMinute,
      @JsonKey(name: 'rate_limit_per_hour') int rateLimitPerHour,
      @JsonKey(name: 'max_concurrent_calls') int maxConcurrentCalls,
      @JsonKey(name: 'require_user_approval') bool requireUserApproval,
      @JsonKey(name: 'auto_approve_tokens') bool autoApproveTokens,
      @JsonKey(name: 'token_expiry') int tokenExpiry,
      @JsonKey(name: 'refresh_token_expiry') int refreshTokenExpiry});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableWebhooks = null,
    Object? enableRealtime = null,
    Object? enableBatchApi = null,
    Object? rateLimitPerMinute = null,
    Object? rateLimitPerHour = null,
    Object? maxConcurrentCalls = null,
    Object? requireUserApproval = null,
    Object? autoApproveTokens = null,
    Object? tokenExpiry = null,
    Object? refreshTokenExpiry = null,
  }) {
    return _then(_value.copyWith(
      enableWebhooks: null == enableWebhooks
          ? _value.enableWebhooks
          : enableWebhooks // ignore: cast_nullable_to_non_nullable
              as bool,
      enableRealtime: null == enableRealtime
          ? _value.enableRealtime
          : enableRealtime // ignore: cast_nullable_to_non_nullable
              as bool,
      enableBatchApi: null == enableBatchApi
          ? _value.enableBatchApi
          : enableBatchApi // ignore: cast_nullable_to_non_nullable
              as bool,
      rateLimitPerMinute: null == rateLimitPerMinute
          ? _value.rateLimitPerMinute
          : rateLimitPerMinute // ignore: cast_nullable_to_non_nullable
              as int,
      rateLimitPerHour: null == rateLimitPerHour
          ? _value.rateLimitPerHour
          : rateLimitPerHour // ignore: cast_nullable_to_non_nullable
              as int,
      maxConcurrentCalls: null == maxConcurrentCalls
          ? _value.maxConcurrentCalls
          : maxConcurrentCalls // ignore: cast_nullable_to_non_nullable
              as int,
      requireUserApproval: null == requireUserApproval
          ? _value.requireUserApproval
          : requireUserApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      autoApproveTokens: null == autoApproveTokens
          ? _value.autoApproveTokens
          : autoApproveTokens // ignore: cast_nullable_to_non_nullable
              as bool,
      tokenExpiry: null == tokenExpiry
          ? _value.tokenExpiry
          : tokenExpiry // ignore: cast_nullable_to_non_nullable
              as int,
      refreshTokenExpiry: null == refreshTokenExpiry
          ? _value.refreshTokenExpiry
          : refreshTokenExpiry // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'enable_webhooks') bool enableWebhooks,
      @JsonKey(name: 'enable_realtime') bool enableRealtime,
      @JsonKey(name: 'enable_batch_api') bool enableBatchApi,
      @JsonKey(name: 'rate_limit_per_minute') int rateLimitPerMinute,
      @JsonKey(name: 'rate_limit_per_hour') int rateLimitPerHour,
      @JsonKey(name: 'max_concurrent_calls') int maxConcurrentCalls,
      @JsonKey(name: 'require_user_approval') bool requireUserApproval,
      @JsonKey(name: 'auto_approve_tokens') bool autoApproveTokens,
      @JsonKey(name: 'token_expiry') int tokenExpiry,
      @JsonKey(name: 'refresh_token_expiry') int refreshTokenExpiry});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableWebhooks = null,
    Object? enableRealtime = null,
    Object? enableBatchApi = null,
    Object? rateLimitPerMinute = null,
    Object? rateLimitPerHour = null,
    Object? maxConcurrentCalls = null,
    Object? requireUserApproval = null,
    Object? autoApproveTokens = null,
    Object? tokenExpiry = null,
    Object? refreshTokenExpiry = null,
  }) {
    return _then(_$AppSettingsImpl(
      enableWebhooks: null == enableWebhooks
          ? _value.enableWebhooks
          : enableWebhooks // ignore: cast_nullable_to_non_nullable
              as bool,
      enableRealtime: null == enableRealtime
          ? _value.enableRealtime
          : enableRealtime // ignore: cast_nullable_to_non_nullable
              as bool,
      enableBatchApi: null == enableBatchApi
          ? _value.enableBatchApi
          : enableBatchApi // ignore: cast_nullable_to_non_nullable
              as bool,
      rateLimitPerMinute: null == rateLimitPerMinute
          ? _value.rateLimitPerMinute
          : rateLimitPerMinute // ignore: cast_nullable_to_non_nullable
              as int,
      rateLimitPerHour: null == rateLimitPerHour
          ? _value.rateLimitPerHour
          : rateLimitPerHour // ignore: cast_nullable_to_non_nullable
              as int,
      maxConcurrentCalls: null == maxConcurrentCalls
          ? _value.maxConcurrentCalls
          : maxConcurrentCalls // ignore: cast_nullable_to_non_nullable
              as int,
      requireUserApproval: null == requireUserApproval
          ? _value.requireUserApproval
          : requireUserApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      autoApproveTokens: null == autoApproveTokens
          ? _value.autoApproveTokens
          : autoApproveTokens // ignore: cast_nullable_to_non_nullable
              as bool,
      tokenExpiry: null == tokenExpiry
          ? _value.tokenExpiry
          : tokenExpiry // ignore: cast_nullable_to_non_nullable
              as int,
      refreshTokenExpiry: null == refreshTokenExpiry
          ? _value.refreshTokenExpiry
          : refreshTokenExpiry // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {@JsonKey(name: 'enable_webhooks') this.enableWebhooks = true,
      @JsonKey(name: 'enable_realtime') this.enableRealtime = true,
      @JsonKey(name: 'enable_batch_api') this.enableBatchApi = false,
      @JsonKey(name: 'rate_limit_per_minute') this.rateLimitPerMinute = 100,
      @JsonKey(name: 'rate_limit_per_hour') this.rateLimitPerHour = 1000,
      @JsonKey(name: 'max_concurrent_calls') this.maxConcurrentCalls = 10,
      @JsonKey(name: 'require_user_approval') this.requireUserApproval = false,
      @JsonKey(name: 'auto_approve_tokens') this.autoApproveTokens = true,
      @JsonKey(name: 'token_expiry') this.tokenExpiry = 3600,
      @JsonKey(name: 'refresh_token_expiry') this.refreshTokenExpiry = 86400});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey(name: 'enable_webhooks')
  final bool enableWebhooks;
  @override
  @JsonKey(name: 'enable_realtime')
  final bool enableRealtime;
  @override
  @JsonKey(name: 'enable_batch_api')
  final bool enableBatchApi;
  @override
  @JsonKey(name: 'rate_limit_per_minute')
  final int rateLimitPerMinute;
  @override
  @JsonKey(name: 'rate_limit_per_hour')
  final int rateLimitPerHour;
  @override
  @JsonKey(name: 'max_concurrent_calls')
  final int maxConcurrentCalls;
  @override
  @JsonKey(name: 'require_user_approval')
  final bool requireUserApproval;
  @override
  @JsonKey(name: 'auto_approve_tokens')
  final bool autoApproveTokens;
  @override
  @JsonKey(name: 'token_expiry')
  final int tokenExpiry;
  @override
  @JsonKey(name: 'refresh_token_expiry')
  final int refreshTokenExpiry;

  @override
  String toString() {
    return 'AppSettings(enableWebhooks: $enableWebhooks, enableRealtime: $enableRealtime, enableBatchApi: $enableBatchApi, rateLimitPerMinute: $rateLimitPerMinute, rateLimitPerHour: $rateLimitPerHour, maxConcurrentCalls: $maxConcurrentCalls, requireUserApproval: $requireUserApproval, autoApproveTokens: $autoApproveTokens, tokenExpiry: $tokenExpiry, refreshTokenExpiry: $refreshTokenExpiry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.enableWebhooks, enableWebhooks) ||
                other.enableWebhooks == enableWebhooks) &&
            (identical(other.enableRealtime, enableRealtime) ||
                other.enableRealtime == enableRealtime) &&
            (identical(other.enableBatchApi, enableBatchApi) ||
                other.enableBatchApi == enableBatchApi) &&
            (identical(other.rateLimitPerMinute, rateLimitPerMinute) ||
                other.rateLimitPerMinute == rateLimitPerMinute) &&
            (identical(other.rateLimitPerHour, rateLimitPerHour) ||
                other.rateLimitPerHour == rateLimitPerHour) &&
            (identical(other.maxConcurrentCalls, maxConcurrentCalls) ||
                other.maxConcurrentCalls == maxConcurrentCalls) &&
            (identical(other.requireUserApproval, requireUserApproval) ||
                other.requireUserApproval == requireUserApproval) &&
            (identical(other.autoApproveTokens, autoApproveTokens) ||
                other.autoApproveTokens == autoApproveTokens) &&
            (identical(other.tokenExpiry, tokenExpiry) ||
                other.tokenExpiry == tokenExpiry) &&
            (identical(other.refreshTokenExpiry, refreshTokenExpiry) ||
                other.refreshTokenExpiry == refreshTokenExpiry));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enableWebhooks,
      enableRealtime,
      enableBatchApi,
      rateLimitPerMinute,
      rateLimitPerHour,
      maxConcurrentCalls,
      requireUserApproval,
      autoApproveTokens,
      tokenExpiry,
      refreshTokenExpiry);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {@JsonKey(name: 'enable_webhooks') final bool enableWebhooks,
      @JsonKey(name: 'enable_realtime') final bool enableRealtime,
      @JsonKey(name: 'enable_batch_api') final bool enableBatchApi,
      @JsonKey(name: 'rate_limit_per_minute') final int rateLimitPerMinute,
      @JsonKey(name: 'rate_limit_per_hour') final int rateLimitPerHour,
      @JsonKey(name: 'max_concurrent_calls') final int maxConcurrentCalls,
      @JsonKey(name: 'require_user_approval') final bool requireUserApproval,
      @JsonKey(name: 'auto_approve_tokens') final bool autoApproveTokens,
      @JsonKey(name: 'token_expiry') final int tokenExpiry,
      @JsonKey(name: 'refresh_token_expiry')
      final int refreshTokenExpiry}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  @JsonKey(name: 'enable_webhooks')
  bool get enableWebhooks;
  @override
  @JsonKey(name: 'enable_realtime')
  bool get enableRealtime;
  @override
  @JsonKey(name: 'enable_batch_api')
  bool get enableBatchApi;
  @override
  @JsonKey(name: 'rate_limit_per_minute')
  int get rateLimitPerMinute;
  @override
  @JsonKey(name: 'rate_limit_per_hour')
  int get rateLimitPerHour;
  @override
  @JsonKey(name: 'max_concurrent_calls')
  int get maxConcurrentCalls;
  @override
  @JsonKey(name: 'require_user_approval')
  bool get requireUserApproval;
  @override
  @JsonKey(name: 'auto_approve_tokens')
  bool get autoApproveTokens;
  @override
  @JsonKey(name: 'token_expiry')
  int get tokenExpiry;
  @override
  @JsonKey(name: 'refresh_token_expiry')
  int get refreshTokenExpiry;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppStats _$AppStatsFromJson(Map<String, dynamic> json) {
  return _AppStats.fromJson(json);
}

/// @nodoc
mixin _$AppStats {
  @JsonKey(name: 'total_users')
  int get totalUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_users')
  int get activeUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_api_requests')
  int get totalApiRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'webhook_deliveries')
  int get webhookDeliveries => throw _privateConstructorUsedError;
  int get failures => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_latency')
  double get avgLatency => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_used_at')
  DateTime? get lastUsedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppStatsCopyWith<AppStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStatsCopyWith<$Res> {
  factory $AppStatsCopyWith(AppStats value, $Res Function(AppStats) then) =
      _$AppStatsCopyWithImpl<$Res, AppStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers,
      @JsonKey(name: 'active_users') int activeUsers,
      @JsonKey(name: 'total_api_requests') int totalApiRequests,
      @JsonKey(name: 'webhook_deliveries') int webhookDeliveries,
      int failures,
      @JsonKey(name: 'avg_latency') double avgLatency,
      @JsonKey(name: 'last_used_at') DateTime? lastUsedAt});
}

/// @nodoc
class _$AppStatsCopyWithImpl<$Res, $Val extends AppStats>
    implements $AppStatsCopyWith<$Res> {
  _$AppStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? totalApiRequests = null,
    Object? webhookDeliveries = null,
    Object? failures = null,
    Object? avgLatency = null,
    Object? lastUsedAt = freezed,
  }) {
    return _then(_value.copyWith(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalApiRequests: null == totalApiRequests
          ? _value.totalApiRequests
          : totalApiRequests // ignore: cast_nullable_to_non_nullable
              as int,
      webhookDeliveries: null == webhookDeliveries
          ? _value.webhookDeliveries
          : webhookDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      failures: null == failures
          ? _value.failures
          : failures // ignore: cast_nullable_to_non_nullable
              as int,
      avgLatency: null == avgLatency
          ? _value.avgLatency
          : avgLatency // ignore: cast_nullable_to_non_nullable
              as double,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppStatsImplCopyWith<$Res>
    implements $AppStatsCopyWith<$Res> {
  factory _$$AppStatsImplCopyWith(
          _$AppStatsImpl value, $Res Function(_$AppStatsImpl) then) =
      __$$AppStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers,
      @JsonKey(name: 'active_users') int activeUsers,
      @JsonKey(name: 'total_api_requests') int totalApiRequests,
      @JsonKey(name: 'webhook_deliveries') int webhookDeliveries,
      int failures,
      @JsonKey(name: 'avg_latency') double avgLatency,
      @JsonKey(name: 'last_used_at') DateTime? lastUsedAt});
}

/// @nodoc
class __$$AppStatsImplCopyWithImpl<$Res>
    extends _$AppStatsCopyWithImpl<$Res, _$AppStatsImpl>
    implements _$$AppStatsImplCopyWith<$Res> {
  __$$AppStatsImplCopyWithImpl(
      _$AppStatsImpl _value, $Res Function(_$AppStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? totalApiRequests = null,
    Object? webhookDeliveries = null,
    Object? failures = null,
    Object? avgLatency = null,
    Object? lastUsedAt = freezed,
  }) {
    return _then(_$AppStatsImpl(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalApiRequests: null == totalApiRequests
          ? _value.totalApiRequests
          : totalApiRequests // ignore: cast_nullable_to_non_nullable
              as int,
      webhookDeliveries: null == webhookDeliveries
          ? _value.webhookDeliveries
          : webhookDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      failures: null == failures
          ? _value.failures
          : failures // ignore: cast_nullable_to_non_nullable
              as int,
      avgLatency: null == avgLatency
          ? _value.avgLatency
          : avgLatency // ignore: cast_nullable_to_non_nullable
              as double,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppStatsImpl implements _AppStats {
  const _$AppStatsImpl(
      {@JsonKey(name: 'total_users') this.totalUsers = 0,
      @JsonKey(name: 'active_users') this.activeUsers = 0,
      @JsonKey(name: 'total_api_requests') this.totalApiRequests = 0,
      @JsonKey(name: 'webhook_deliveries') this.webhookDeliveries = 0,
      this.failures = 0,
      @JsonKey(name: 'avg_latency') this.avgLatency = 0.0,
      @JsonKey(name: 'last_used_at') this.lastUsedAt});

  factory _$AppStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_users')
  final int totalUsers;
  @override
  @JsonKey(name: 'active_users')
  final int activeUsers;
  @override
  @JsonKey(name: 'total_api_requests')
  final int totalApiRequests;
  @override
  @JsonKey(name: 'webhook_deliveries')
  final int webhookDeliveries;
  @override
  @JsonKey()
  final int failures;
  @override
  @JsonKey(name: 'avg_latency')
  final double avgLatency;
  @override
  @JsonKey(name: 'last_used_at')
  final DateTime? lastUsedAt;

  @override
  String toString() {
    return 'AppStats(totalUsers: $totalUsers, activeUsers: $activeUsers, totalApiRequests: $totalApiRequests, webhookDeliveries: $webhookDeliveries, failures: $failures, avgLatency: $avgLatency, lastUsedAt: $lastUsedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStatsImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.totalApiRequests, totalApiRequests) ||
                other.totalApiRequests == totalApiRequests) &&
            (identical(other.webhookDeliveries, webhookDeliveries) ||
                other.webhookDeliveries == webhookDeliveries) &&
            (identical(other.failures, failures) ||
                other.failures == failures) &&
            (identical(other.avgLatency, avgLatency) ||
                other.avgLatency == avgLatency) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalUsers, activeUsers,
      totalApiRequests, webhookDeliveries, failures, avgLatency, lastUsedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppStatsImplCopyWith<_$AppStatsImpl> get copyWith =>
      __$$AppStatsImplCopyWithImpl<_$AppStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppStatsImplToJson(
      this,
    );
  }
}

abstract class _AppStats implements AppStats {
  const factory _AppStats(
          {@JsonKey(name: 'total_users') final int totalUsers,
          @JsonKey(name: 'active_users') final int activeUsers,
          @JsonKey(name: 'total_api_requests') final int totalApiRequests,
          @JsonKey(name: 'webhook_deliveries') final int webhookDeliveries,
          final int failures,
          @JsonKey(name: 'avg_latency') final double avgLatency,
          @JsonKey(name: 'last_used_at') final DateTime? lastUsedAt}) =
      _$AppStatsImpl;

  factory _AppStats.fromJson(Map<String, dynamic> json) =
      _$AppStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_users')
  int get totalUsers;
  @override
  @JsonKey(name: 'active_users')
  int get activeUsers;
  @override
  @JsonKey(name: 'total_api_requests')
  int get totalApiRequests;
  @override
  @JsonKey(name: 'webhook_deliveries')
  int get webhookDeliveries;
  @override
  int get failures;
  @override
  @JsonKey(name: 'avg_latency')
  double get avgLatency;
  @override
  @JsonKey(name: 'last_used_at')
  DateTime? get lastUsedAt;
  @override
  @JsonKey(ignore: true)
  _$$AppStatsImplCopyWith<_$AppStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeveloperApp _$DeveloperAppFromJson(Map<String, dynamic> json) {
  return _DeveloperApp.fromJson(json);
}

/// @nodoc
mixin _$DeveloperApp {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_id')
  String get clientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_secret')
  String? get clientSecret => throw _privateConstructorUsedError;
  @JsonKey(name: 'redirect_uri')
  String? get redirectUri => throw _privateConstructorUsedError;
  List<String> get scopes => throw _privateConstructorUsedError;
  @JsonKey(name: 'grant_types')
  List<String> get grantTypes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'homepage_url')
  String? get homepageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'terms_url')
  String? get termsUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'privacy_url')
  String? get privacyUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'callback_urls')
  List<String> get callbackUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  AppStats? get stats => throw _privateConstructorUsedError;
  AppSettings? get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeveloperAppCopyWith<DeveloperApp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeveloperAppCopyWith<$Res> {
  factory $DeveloperAppCopyWith(
          DeveloperApp value, $Res Function(DeveloperApp) then) =
      _$DeveloperAppCopyWithImpl<$Res, DeveloperApp>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'owner_id') String ownerId,
      String name,
      String? description,
      @JsonKey(name: 'client_id') String clientId,
      @JsonKey(name: 'client_secret') String? clientSecret,
      @JsonKey(name: 'redirect_uri') String? redirectUri,
      List<String> scopes,
      @JsonKey(name: 'grant_types') List<String> grantTypes,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'homepage_url') String? homepageUrl,
      @JsonKey(name: 'terms_url') String? termsUrl,
      @JsonKey(name: 'privacy_url') String? privacyUrl,
      @JsonKey(name: 'callback_urls') List<String> callbackUrls,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      AppStats? stats,
      AppSettings? settings});

  $AppStatsCopyWith<$Res>? get stats;
  $AppSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$DeveloperAppCopyWithImpl<$Res, $Val extends DeveloperApp>
    implements $DeveloperAppCopyWith<$Res> {
  _$DeveloperAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = freezed,
    Object? clientId = null,
    Object? clientSecret = freezed,
    Object? redirectUri = freezed,
    Object? scopes = null,
    Object? grantTypes = null,
    Object? isPublic = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? iconUrl = freezed,
    Object? homepageUrl = freezed,
    Object? termsUrl = freezed,
    Object? privacyUrl = freezed,
    Object? callbackUrls = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stats = freezed,
    Object? settings = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: freezed == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String?,
      redirectUri: freezed == redirectUri
          ? _value.redirectUri
          : redirectUri // ignore: cast_nullable_to_non_nullable
              as String?,
      scopes: null == scopes
          ? _value.scopes
          : scopes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      grantTypes: null == grantTypes
          ? _value.grantTypes
          : grantTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      homepageUrl: freezed == homepageUrl
          ? _value.homepageUrl
          : homepageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      termsUrl: freezed == termsUrl
          ? _value.termsUrl
          : termsUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      privacyUrl: freezed == privacyUrl
          ? _value.privacyUrl
          : privacyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      callbackUrls: null == callbackUrls
          ? _value.callbackUrls
          : callbackUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
              as AppStats?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as AppSettings?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AppStatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $AppStatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AppSettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $AppSettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeveloperAppImplCopyWith<$Res>
    implements $DeveloperAppCopyWith<$Res> {
  factory _$$DeveloperAppImplCopyWith(
          _$DeveloperAppImpl value, $Res Function(_$DeveloperAppImpl) then) =
      __$$DeveloperAppImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'owner_id') String ownerId,
      String name,
      String? description,
      @JsonKey(name: 'client_id') String clientId,
      @JsonKey(name: 'client_secret') String? clientSecret,
      @JsonKey(name: 'redirect_uri') String? redirectUri,
      List<String> scopes,
      @JsonKey(name: 'grant_types') List<String> grantTypes,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'homepage_url') String? homepageUrl,
      @JsonKey(name: 'terms_url') String? termsUrl,
      @JsonKey(name: 'privacy_url') String? privacyUrl,
      @JsonKey(name: 'callback_urls') List<String> callbackUrls,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      AppStats? stats,
      AppSettings? settings});

  @override
  $AppStatsCopyWith<$Res>? get stats;
  @override
  $AppSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$DeveloperAppImplCopyWithImpl<$Res>
    extends _$DeveloperAppCopyWithImpl<$Res, _$DeveloperAppImpl>
    implements _$$DeveloperAppImplCopyWith<$Res> {
  __$$DeveloperAppImplCopyWithImpl(
      _$DeveloperAppImpl _value, $Res Function(_$DeveloperAppImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = freezed,
    Object? clientId = null,
    Object? clientSecret = freezed,
    Object? redirectUri = freezed,
    Object? scopes = null,
    Object? grantTypes = null,
    Object? isPublic = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? iconUrl = freezed,
    Object? homepageUrl = freezed,
    Object? termsUrl = freezed,
    Object? privacyUrl = freezed,
    Object? callbackUrls = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stats = freezed,
    Object? settings = freezed,
  }) {
    return _then(_$DeveloperAppImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: freezed == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String?,
      redirectUri: freezed == redirectUri
          ? _value.redirectUri
          : redirectUri // ignore: cast_nullable_to_non_nullable
              as String?,
      scopes: null == scopes
          ? _value._scopes
          : scopes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      grantTypes: null == grantTypes
          ? _value._grantTypes
          : grantTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      homepageUrl: freezed == homepageUrl
          ? _value.homepageUrl
          : homepageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      termsUrl: freezed == termsUrl
          ? _value.termsUrl
          : termsUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      privacyUrl: freezed == privacyUrl
          ? _value.privacyUrl
          : privacyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      callbackUrls: null == callbackUrls
          ? _value._callbackUrls
          : callbackUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
              as AppStats?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as AppSettings?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeveloperAppImpl implements _DeveloperApp {
  const _$DeveloperAppImpl(
      {required this.id,
      @JsonKey(name: 'owner_id') required this.ownerId,
      required this.name,
      this.description,
      @JsonKey(name: 'client_id') required this.clientId,
      @JsonKey(name: 'client_secret') this.clientSecret,
      @JsonKey(name: 'redirect_uri') this.redirectUri,
      final List<String> scopes = const [],
      @JsonKey(name: 'grant_types') final List<String> grantTypes = const [],
      @JsonKey(name: 'is_public') this.isPublic = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'icon_url') this.iconUrl,
      @JsonKey(name: 'homepage_url') this.homepageUrl,
      @JsonKey(name: 'terms_url') this.termsUrl,
      @JsonKey(name: 'privacy_url') this.privacyUrl,
      @JsonKey(name: 'callback_urls')
      final List<String> callbackUrls = const [],
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.stats,
      this.settings})
      : _scopes = scopes,
        _grantTypes = grantTypes,
        _callbackUrls = callbackUrls;

  factory _$DeveloperAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeveloperAppImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'client_id')
  final String clientId;
  @override
  @JsonKey(name: 'client_secret')
  final String? clientSecret;
  @override
  @JsonKey(name: 'redirect_uri')
  final String? redirectUri;
  final List<String> _scopes;
  @override
  @JsonKey()
  List<String> get scopes {
    if (_scopes is EqualUnmodifiableListView) return _scopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scopes);
  }

  final List<String> _grantTypes;
  @override
  @JsonKey(name: 'grant_types')
  List<String> get grantTypes {
    if (_grantTypes is EqualUnmodifiableListView) return _grantTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_grantTypes);
  }

  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey(name: 'homepage_url')
  final String? homepageUrl;
  @override
  @JsonKey(name: 'terms_url')
  final String? termsUrl;
  @override
  @JsonKey(name: 'privacy_url')
  final String? privacyUrl;
  final List<String> _callbackUrls;
  @override
  @JsonKey(name: 'callback_urls')
  List<String> get callbackUrls {
    if (_callbackUrls is EqualUnmodifiableListView) return _callbackUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_callbackUrls);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  final AppStats? stats;
  @override
  final AppSettings? settings;

  @override
  String toString() {
    return 'DeveloperApp(id: $id, ownerId: $ownerId, name: $name, description: $description, clientId: $clientId, clientSecret: $clientSecret, redirectUri: $redirectUri, scopes: $scopes, grantTypes: $grantTypes, isPublic: $isPublic, isActive: $isActive, isVerified: $isVerified, iconUrl: $iconUrl, homepageUrl: $homepageUrl, termsUrl: $termsUrl, privacyUrl: $privacyUrl, callbackUrls: $callbackUrls, createdAt: $createdAt, updatedAt: $updatedAt, stats: $stats, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeveloperAppImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.redirectUri, redirectUri) ||
                other.redirectUri == redirectUri) &&
            const DeepCollectionEquality().equals(other._scopes, _scopes) &&
            const DeepCollectionEquality()
                .equals(other._grantTypes, _grantTypes) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.homepageUrl, homepageUrl) ||
                other.homepageUrl == homepageUrl) &&
            (identical(other.termsUrl, termsUrl) ||
                other.termsUrl == termsUrl) &&
            (identical(other.privacyUrl, privacyUrl) ||
                other.privacyUrl == privacyUrl) &&
            const DeepCollectionEquality()
                .equals(other._callbackUrls, _callbackUrls) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        ownerId,
        name,
        description,
        clientId,
        clientSecret,
        redirectUri,
        const DeepCollectionEquality().hash(_scopes),
        const DeepCollectionEquality().hash(_grantTypes),
        isPublic,
        isActive,
        isVerified,
        iconUrl,
        homepageUrl,
        termsUrl,
        privacyUrl,
        const DeepCollectionEquality().hash(_callbackUrls),
        createdAt,
        updatedAt,
        stats,
        settings
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeveloperAppImplCopyWith<_$DeveloperAppImpl> get copyWith =>
      __$$DeveloperAppImplCopyWithImpl<_$DeveloperAppImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeveloperAppImplToJson(
      this,
    );
  }
}

abstract class _DeveloperApp implements DeveloperApp {
  const factory _DeveloperApp(
      {required final String id,
      @JsonKey(name: 'owner_id') required final String ownerId,
      required final String name,
      final String? description,
      @JsonKey(name: 'client_id') required final String clientId,
      @JsonKey(name: 'client_secret') final String? clientSecret,
      @JsonKey(name: 'redirect_uri') final String? redirectUri,
      final List<String> scopes,
      @JsonKey(name: 'grant_types') final List<String> grantTypes,
      @JsonKey(name: 'is_public') final bool isPublic,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'is_verified') final bool isVerified,
      @JsonKey(name: 'icon_url') final String? iconUrl,
      @JsonKey(name: 'homepage_url') final String? homepageUrl,
      @JsonKey(name: 'terms_url') final String? termsUrl,
      @JsonKey(name: 'privacy_url') final String? privacyUrl,
      @JsonKey(name: 'callback_urls') final List<String> callbackUrls,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final AppStats? stats,
      final AppSettings? settings}) = _$DeveloperAppImpl;

  factory _DeveloperApp.fromJson(Map<String, dynamic> json) =
      _$DeveloperAppImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'client_id')
  String get clientId;
  @override
  @JsonKey(name: 'client_secret')
  String? get clientSecret;
  @override
  @JsonKey(name: 'redirect_uri')
  String? get redirectUri;
  @override
  List<String> get scopes;
  @override
  @JsonKey(name: 'grant_types')
  List<String> get grantTypes;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'homepage_url')
  String? get homepageUrl;
  @override
  @JsonKey(name: 'terms_url')
  String? get termsUrl;
  @override
  @JsonKey(name: 'privacy_url')
  String? get privacyUrl;
  @override
  @JsonKey(name: 'callback_urls')
  List<String> get callbackUrls;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  AppStats? get stats;
  @override
  AppSettings? get settings;
  @override
  @JsonKey(ignore: true)
  _$$DeveloperAppImplCopyWith<_$DeveloperAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
