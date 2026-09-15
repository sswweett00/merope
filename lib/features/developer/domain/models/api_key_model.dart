import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_key_model.freezed.dart';
part 'api_key_model.g.dart';

@freezed
class ApiKeyUsageStats with _$ApiKeyUsageStats {
  const factory ApiKeyUsageStats({
    @JsonKey(name: 'total_requests') @Default(0) int totalRequests,
    @JsonKey(name: 'failed_requests') @Default(0) int failedRequests,
    @JsonKey(name: 'last_used_ip') @Default('') String lastUsedIp,
    @JsonKey(name: 'usage_by_day') @Default({}) Map<String, dynamic> usageByDay,
  }) = _ApiKeyUsageStats;

  factory ApiKeyUsageStats.fromJson(Map<String, dynamic> json) => _$ApiKeyUsageStatsFromJson(json);
}

@freezed
class ApiKey with _$ApiKey {
  const ApiKey._();

  const factory ApiKey({
    required String id,
    @JsonKey(name: 'app_id') required String appId,
    @JsonKey(name: 'key_hash') String? keyHash,
    @JsonKey(name: 'key_prefix') required String keyPrefix,
    required String name,
    String? description,
    @Default([]) List<String> scopes,
    @JsonKey(name: 'rate_limit_rpm') @Default(100) int rateLimitRpm,
    @JsonKey(name: 'rate_limit_rph') @Default(1000) int rateLimitRph,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_used_at') DateTime? lastUsedAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'ip_whitelist') @Default([]) List<String> ipWhitelist,
    @JsonKey(name: 'usage_stats') ApiKeyUsageStats? usageStats,
    @JsonKey(name: 'raw_key') String? rawKey,
  }) = _ApiKey;

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);

  String get maskedDisplay {
    if (rawKey != null && rawKey!.isNotEmpty) {
      if (rawKey!.length <= 8) return rawKey!;
      return '${rawKey!.substring(0, 4)}...${rawKey!.substring(rawKey!.length - 4)}';
    }
    return '$keyPrefix••••••••';
  }

  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());

  bool get isValid => isActive && !isExpired;
}
