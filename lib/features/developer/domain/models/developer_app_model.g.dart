// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      enableWebhooks: json['enable_webhooks'] as bool? ?? true,
      enableRealtime: json['enable_realtime'] as bool? ?? true,
      enableBatchApi: json['enable_batch_api'] as bool? ?? false,
      rateLimitPerMinute:
          (json['rate_limit_per_minute'] as num?)?.toInt() ?? 100,
      rateLimitPerHour: (json['rate_limit_per_hour'] as num?)?.toInt() ?? 1000,
      maxConcurrentCalls: (json['max_concurrent_calls'] as num?)?.toInt() ?? 10,
      requireUserApproval: json['require_user_approval'] as bool? ?? false,
      autoApproveTokens: json['auto_approve_tokens'] as bool? ?? true,
      tokenExpiry: (json['token_expiry'] as num?)?.toInt() ?? 3600,
      refreshTokenExpiry:
          (json['refresh_token_expiry'] as num?)?.toInt() ?? 86400,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'enable_webhooks': instance.enableWebhooks,
      'enable_realtime': instance.enableRealtime,
      'enable_batch_api': instance.enableBatchApi,
      'rate_limit_per_minute': instance.rateLimitPerMinute,
      'rate_limit_per_hour': instance.rateLimitPerHour,
      'max_concurrent_calls': instance.maxConcurrentCalls,
      'require_user_approval': instance.requireUserApproval,
      'auto_approve_tokens': instance.autoApproveTokens,
      'token_expiry': instance.tokenExpiry,
      'refresh_token_expiry': instance.refreshTokenExpiry,
    };

_$AppStatsImpl _$$AppStatsImplFromJson(Map<String, dynamic> json) =>
    _$AppStatsImpl(
      totalUsers: (json['total_users'] as num?)?.toInt() ?? 0,
      activeUsers: (json['active_users'] as num?)?.toInt() ?? 0,
      totalApiRequests: (json['total_api_requests'] as num?)?.toInt() ?? 0,
      webhookDeliveries: (json['webhook_deliveries'] as num?)?.toInt() ?? 0,
      failures: (json['failures'] as num?)?.toInt() ?? 0,
      avgLatency: (json['avg_latency'] as num?)?.toDouble() ?? 0.0,
      lastUsedAt: json['last_used_at'] == null
          ? null
          : DateTime.parse(json['last_used_at'] as String),
    );

Map<String, dynamic> _$$AppStatsImplToJson(_$AppStatsImpl instance) =>
    <String, dynamic>{
      'total_users': instance.totalUsers,
      'active_users': instance.activeUsers,
      'total_api_requests': instance.totalApiRequests,
      'webhook_deliveries': instance.webhookDeliveries,
      'failures': instance.failures,
      'avg_latency': instance.avgLatency,
      'last_used_at': instance.lastUsedAt?.toIso8601String(),
    };

_$DeveloperAppImpl _$$DeveloperAppImplFromJson(Map<String, dynamic> json) =>
    _$DeveloperAppImpl(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String?,
      redirectUri: json['redirect_uri'] as String?,
      scopes: (json['scopes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      grantTypes: (json['grant_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isPublic: json['is_public'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      iconUrl: json['icon_url'] as String?,
      homepageUrl: json['homepage_url'] as String?,
      termsUrl: json['terms_url'] as String?,
      privacyUrl: json['privacy_url'] as String?,
      callbackUrls: (json['callback_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      stats: json['stats'] == null
          ? null
          : AppStats.fromJson(json['stats'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : AppSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DeveloperAppImplToJson(_$DeveloperAppImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'redirect_uri': instance.redirectUri,
      'scopes': instance.scopes,
      'grant_types': instance.grantTypes,
      'is_public': instance.isPublic,
      'is_active': instance.isActive,
      'is_verified': instance.isVerified,
      'icon_url': instance.iconUrl,
      'homepage_url': instance.homepageUrl,
      'terms_url': instance.termsUrl,
      'privacy_url': instance.privacyUrl,
      'callback_urls': instance.callbackUrls,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'stats': instance.stats,
      'settings': instance.settings,
    };
