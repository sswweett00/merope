import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_model.freezed.dart';
part 'bot_model.g.dart';

enum BotCapabilityType { messaging, commands, events, webhooks }

@freezed
class BotCapability with _$BotCapability {
  const factory BotCapability({
    required BotCapabilityType type,
    required String permission,
    String? description,
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,
  }) = _BotCapability;

  factory BotCapability.fromJson(Map<String, dynamic> json) =>
      _$BotCapabilityFromJson(json);
}

@freezed
class BotSettings with _$BotSettings {
  const factory BotSettings({
    @JsonKey(name: 'allow_direct_messages')
    @Default(true)
    bool allowDirectMessages,
    @JsonKey(name: 'allow_group_messages')
    @Default(true)
    bool allowGroupMessages,
    @JsonKey(name: 'enable_commands') @Default(true) bool enableCommands,
    @JsonKey(name: 'enable_webhooks') @Default(false) bool enableWebhooks,
    @JsonKey(name: 'privacy_mode') @Default('private') String privacyMode,
    @JsonKey(name: 'rate_limit_per_user') @Default(30) int rateLimitPerUser,
    @JsonKey(name: 'max_command_queue') @Default(100) int maxCommandQueue,
  }) = _BotSettings;

  factory BotSettings.fromJson(Map<String, dynamic> json) =>
      _$BotSettingsFromJson(json);
}

@freezed
class BotStats with _$BotStats {
  const factory BotStats({
    @JsonKey(name: 'total_users') @Default(0) int totalUsers,
    @JsonKey(name: 'active_users') @Default(0) int activeUsers,
    @JsonKey(name: 'messages_sent') @Default(0) int messagesSent,
    @JsonKey(name: 'commands_executed') @Default(0) int commandsExecuted,
    @JsonKey(name: 'errors_occurred') @Default(0) int errorsOccurred,
    @JsonKey(name: 'avg_response_time') @Default(0.0) double avgResponseTime,
    @Default(0.0) double uptime,
    @JsonKey(name: 'last_active_at') DateTime? lastActiveAt,
  }) = _BotStats;

  factory BotStats.fromJson(Map<String, dynamic> json) =>
      _$BotStatsFromJson(json);
}

@freezed
class Bot with _$Bot {
  const Bot._();

  const factory Bot({
    required String id,
    @JsonKey(name: 'app_id') required String appId,
    required String name,
    String? description,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_official') @Default(false) bool isOfficial,
    @Default([]) List<String> permissions,
    @Default([]) List<BotCapability> capabilities,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    BotStats? stats,
    BotSettings? settings,
  }) = _Bot;

  factory Bot.fromJson(Map<String, dynamic> json) => _$BotFromJson(json);
}
