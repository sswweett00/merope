// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiKeyUsageStatsImpl _$$ApiKeyUsageStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiKeyUsageStatsImpl(
      totalRequests: (json['total_requests'] as num?)?.toInt() ?? 0,
      failedRequests: (json['failed_requests'] as num?)?.toInt() ?? 0,
      lastUsedIp: json['last_used_ip'] as String? ?? '',
      usageByDay: json['usage_by_day'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ApiKeyUsageStatsImplToJson(
        _$ApiKeyUsageStatsImpl instance) =>
    <String, dynamic>{
      'total_requests': instance.totalRequests,
      'failed_requests': instance.failedRequests,
      'last_used_ip': instance.lastUsedIp,
      'usage_by_day': instance.usageByDay,
    };

_$ApiKeyImpl _$$ApiKeyImplFromJson(Map<String, dynamic> json) => _$ApiKeyImpl(
      id: json['id'] as String,
      appId: json['app_id'] as String,
      keyHash: json['key_hash'] as String?,
      keyPrefix: json['key_prefix'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      scopes: (json['scopes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rateLimitRpm: (json['rate_limit_rpm'] as num?)?.toInt() ?? 100,
      rateLimitRph: (json['rate_limit_rph'] as num?)?.toInt() ?? 1000,
      isActive: json['is_active'] as bool? ?? true,
      lastUsedAt: json['last_used_at'] == null
          ? null
          : DateTime.parse(json['last_used_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      ipWhitelist: (json['ip_whitelist'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      usageStats: json['usage_stats'] == null
          ? null
          : ApiKeyUsageStats.fromJson(
              json['usage_stats'] as Map<String, dynamic>),
      rawKey: json['raw_key'] as String?,
    );

Map<String, dynamic> _$$ApiKeyImplToJson(_$ApiKeyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'app_id': instance.appId,
      'key_hash': instance.keyHash,
      'key_prefix': instance.keyPrefix,
      'name': instance.name,
      'description': instance.description,
      'scopes': instance.scopes,
      'rate_limit_rpm': instance.rateLimitRpm,
      'rate_limit_rph': instance.rateLimitRph,
      'is_active': instance.isActive,
      'last_used_at': instance.lastUsedAt?.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'ip_whitelist': instance.ipWhitelist,
      'usage_stats': instance.usageStats,
      'raw_key': instance.rawKey,
    };
