import 'package:freezed_annotation/freezed_annotation.dart';

part 'developer_app_model.freezed.dart';
part 'developer_app_model.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @JsonKey(name: 'enable_webhooks') @Default(true) bool enableWebhooks,
    @JsonKey(name: 'enable_realtime') @Default(true) bool enableRealtime,
    @JsonKey(name: 'enable_batch_api') @Default(false) bool enableBatchApi,
    @JsonKey(name: 'rate_limit_per_minute')
    @Default(100)
    int rateLimitPerMinute,
    @JsonKey(name: 'rate_limit_per_hour') @Default(1000) int rateLimitPerHour,
    @JsonKey(name: 'max_concurrent_calls') @Default(10) int maxConcurrentCalls,
    @JsonKey(name: 'require_user_approval')
    @Default(false)
    bool requireUserApproval,
    @JsonKey(name: 'auto_approve_tokens') @Default(true) bool autoApproveTokens,
    @JsonKey(name: 'token_expiry') @Default(3600) int tokenExpiry,
    @JsonKey(name: 'refresh_token_expiry')
    @Default(86400)
    int refreshTokenExpiry,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

@freezed
class AppStats with _$AppStats {
  const factory AppStats({
    @JsonKey(name: 'total_users') @Default(0) int totalUsers,
    @JsonKey(name: 'active_users') @Default(0) int activeUsers,
    @JsonKey(name: 'total_api_requests') @Default(0) int totalApiRequests,
    @JsonKey(name: 'webhook_deliveries') @Default(0) int webhookDeliveries,
    @Default(0) int failures,
    @JsonKey(name: 'avg_latency') @Default(0.0) double avgLatency,
    @JsonKey(name: 'last_used_at') DateTime? lastUsedAt,
  }) = _AppStats;

  factory AppStats.fromJson(Map<String, dynamic> json) =>
      _$AppStatsFromJson(json);
}

@freezed
class DeveloperApp with _$DeveloperApp {
  const factory DeveloperApp({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    String? description,
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'client_secret') String? clientSecret,
    @JsonKey(name: 'redirect_uri') String? redirectUri,
    @Default([]) List<String> scopes,
    @JsonKey(name: 'grant_types') @Default([]) List<String> grantTypes,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'homepage_url') String? homepageUrl,
    @JsonKey(name: 'terms_url') String? termsUrl,
    @JsonKey(name: 'privacy_url') String? privacyUrl,
    @JsonKey(name: 'callback_urls') @Default([]) List<String> callbackUrls,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    AppStats? stats,
    AppSettings? settings,
  }) = _DeveloperApp;

  factory DeveloperApp.fromJson(Map<String, dynamic> json) =>
      _$DeveloperAppFromJson(json);
}
