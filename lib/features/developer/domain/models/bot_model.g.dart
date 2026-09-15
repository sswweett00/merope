// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BotCapabilityImpl _$$BotCapabilityImplFromJson(Map<String, dynamic> json) =>
    _$BotCapabilityImpl(
      type: $enumDecode(_$BotCapabilityTypeEnumMap, json['type']),
      permission: json['permission'] as String,
      description: json['description'] as String?,
      isEnabled: json['is_enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$BotCapabilityImplToJson(_$BotCapabilityImpl instance) =>
    <String, dynamic>{
      'type': _$BotCapabilityTypeEnumMap[instance.type]!,
      'permission': instance.permission,
      'description': instance.description,
      'is_enabled': instance.isEnabled,
    };

const _$BotCapabilityTypeEnumMap = {
  BotCapabilityType.messaging: 'messaging',
  BotCapabilityType.commands: 'commands',
  BotCapabilityType.events: 'events',
  BotCapabilityType.webhooks: 'webhooks',
};

_$BotSettingsImpl _$$BotSettingsImplFromJson(Map<String, dynamic> json) =>
    _$BotSettingsImpl(
      allowDirectMessages: json['allow_direct_messages'] as bool? ?? true,
      allowGroupMessages: json['allow_group_messages'] as bool? ?? true,
      enableCommands: json['enable_commands'] as bool? ?? true,
      enableWebhooks: json['enable_webhooks'] as bool? ?? false,
      privacyMode: json['privacy_mode'] as String? ?? 'private',
      rateLimitPerUser: (json['rate_limit_per_user'] as num?)?.toInt() ?? 30,
      maxCommandQueue: (json['max_command_queue'] as num?)?.toInt() ?? 100,
    );

Map<String, dynamic> _$$BotSettingsImplToJson(_$BotSettingsImpl instance) =>
    <String, dynamic>{
      'allow_direct_messages': instance.allowDirectMessages,
      'allow_group_messages': instance.allowGroupMessages,
      'enable_commands': instance.enableCommands,
      'enable_webhooks': instance.enableWebhooks,
      'privacy_mode': instance.privacyMode,
      'rate_limit_per_user': instance.rateLimitPerUser,
      'max_command_queue': instance.maxCommandQueue,
    };

_$BotStatsImpl _$$BotStatsImplFromJson(Map<String, dynamic> json) =>
    _$BotStatsImpl(
      totalUsers: (json['total_users'] as num?)?.toInt() ?? 0,
      activeUsers: (json['active_users'] as num?)?.toInt() ?? 0,
      messagesSent: (json['messages_sent'] as num?)?.toInt() ?? 0,
      commandsExecuted: (json['commands_executed'] as num?)?.toInt() ?? 0,
      errorsOccurred: (json['errors_occurred'] as num?)?.toInt() ?? 0,
      avgResponseTime: (json['avg_response_time'] as num?)?.toDouble() ?? 0.0,
      uptime: (json['uptime'] as num?)?.toDouble() ?? 0.0,
      lastActiveAt: json['last_active_at'] == null
          ? null
          : DateTime.parse(json['last_active_at'] as String),
    );

Map<String, dynamic> _$$BotStatsImplToJson(_$BotStatsImpl instance) =>
    <String, dynamic>{
      'total_users': instance.totalUsers,
      'active_users': instance.activeUsers,
      'messages_sent': instance.messagesSent,
      'commands_executed': instance.commandsExecuted,
      'errors_occurred': instance.errorsOccurred,
      'avg_response_time': instance.avgResponseTime,
      'uptime': instance.uptime,
      'last_active_at': instance.lastActiveAt?.toIso8601String(),
    };

_$BotImpl _$$BotImplFromJson(Map<String, dynamic> json) => _$BotImpl(
      id: json['id'] as String,
      appId: json['app_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      isOfficial: json['is_official'] as bool? ?? false,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      capabilities: (json['capabilities'] as List<dynamic>?)
              ?.map((e) => BotCapability.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      stats: json['stats'] == null
          ? null
          : BotStats.fromJson(json['stats'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : BotSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BotImplToJson(_$BotImpl instance) => <String, dynamic>{
      'id': instance.id,
      'app_id': instance.appId,
      'name': instance.name,
      'description': instance.description,
      'avatar_url': instance.avatarUrl,
      'is_public': instance.isPublic,
      'is_active': instance.isActive,
      'is_official': instance.isOfficial,
      'permissions': instance.permissions,
      'capabilities': instance.capabilities,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'stats': instance.stats,
      'settings': instance.settings,
    };
