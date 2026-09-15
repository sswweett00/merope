// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BotCapability _$BotCapabilityFromJson(Map<String, dynamic> json) {
  return _BotCapability.fromJson(json);
}

/// @nodoc
mixin _$BotCapability {
  BotCapabilityType get type => throw _privateConstructorUsedError;
  String get permission => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_enabled')
  bool get isEnabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BotCapabilityCopyWith<BotCapability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BotCapabilityCopyWith<$Res> {
  factory $BotCapabilityCopyWith(
          BotCapability value, $Res Function(BotCapability) then) =
      _$BotCapabilityCopyWithImpl<$Res, BotCapability>;
  @useResult
  $Res call(
      {BotCapabilityType type,
      String permission,
      String? description,
      @JsonKey(name: 'is_enabled') bool isEnabled});
}

/// @nodoc
class _$BotCapabilityCopyWithImpl<$Res, $Val extends BotCapability>
    implements $BotCapabilityCopyWith<$Res> {
  _$BotCapabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? permission = null,
    Object? description = freezed,
    Object? isEnabled = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BotCapabilityType,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BotCapabilityImplCopyWith<$Res>
    implements $BotCapabilityCopyWith<$Res> {
  factory _$$BotCapabilityImplCopyWith(
          _$BotCapabilityImpl value, $Res Function(_$BotCapabilityImpl) then) =
      __$$BotCapabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BotCapabilityType type,
      String permission,
      String? description,
      @JsonKey(name: 'is_enabled') bool isEnabled});
}

/// @nodoc
class __$$BotCapabilityImplCopyWithImpl<$Res>
    extends _$BotCapabilityCopyWithImpl<$Res, _$BotCapabilityImpl>
    implements _$$BotCapabilityImplCopyWith<$Res> {
  __$$BotCapabilityImplCopyWithImpl(
      _$BotCapabilityImpl _value, $Res Function(_$BotCapabilityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? permission = null,
    Object? description = freezed,
    Object? isEnabled = null,
  }) {
    return _then(_$BotCapabilityImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BotCapabilityType,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BotCapabilityImpl implements _BotCapability {
  const _$BotCapabilityImpl(
      {required this.type,
      required this.permission,
      this.description,
      @JsonKey(name: 'is_enabled') this.isEnabled = true});

  factory _$BotCapabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$BotCapabilityImplFromJson(json);

  @override
  final BotCapabilityType type;
  @override
  final String permission;
  @override
  final String? description;
  @override
  @JsonKey(name: 'is_enabled')
  final bool isEnabled;

  @override
  String toString() {
    return 'BotCapability(type: $type, permission: $permission, description: $description, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BotCapabilityImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.permission, permission) ||
                other.permission == permission) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, permission, description, isEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BotCapabilityImplCopyWith<_$BotCapabilityImpl> get copyWith =>
      __$$BotCapabilityImplCopyWithImpl<_$BotCapabilityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BotCapabilityImplToJson(
      this,
    );
  }
}

abstract class _BotCapability implements BotCapability {
  const factory _BotCapability(
      {required final BotCapabilityType type,
      required final String permission,
      final String? description,
      @JsonKey(name: 'is_enabled') final bool isEnabled}) = _$BotCapabilityImpl;

  factory _BotCapability.fromJson(Map<String, dynamic> json) =
      _$BotCapabilityImpl.fromJson;

  @override
  BotCapabilityType get type;
  @override
  String get permission;
  @override
  String? get description;
  @override
  @JsonKey(name: 'is_enabled')
  bool get isEnabled;
  @override
  @JsonKey(ignore: true)
  _$$BotCapabilityImplCopyWith<_$BotCapabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BotSettings _$BotSettingsFromJson(Map<String, dynamic> json) {
  return _BotSettings.fromJson(json);
}

/// @nodoc
mixin _$BotSettings {
  @JsonKey(name: 'allow_direct_messages')
  bool get allowDirectMessages => throw _privateConstructorUsedError;
  @JsonKey(name: 'allow_group_messages')
  bool get allowGroupMessages => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_commands')
  bool get enableCommands => throw _privateConstructorUsedError;
  @JsonKey(name: 'enable_webhooks')
  bool get enableWebhooks => throw _privateConstructorUsedError;
  @JsonKey(name: 'privacy_mode')
  String get privacyMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'rate_limit_per_user')
  int get rateLimitPerUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_command_queue')
  int get maxCommandQueue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BotSettingsCopyWith<BotSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BotSettingsCopyWith<$Res> {
  factory $BotSettingsCopyWith(
          BotSettings value, $Res Function(BotSettings) then) =
      _$BotSettingsCopyWithImpl<$Res, BotSettings>;
  @useResult
  $Res call(
      {@JsonKey(name: 'allow_direct_messages') bool allowDirectMessages,
      @JsonKey(name: 'allow_group_messages') bool allowGroupMessages,
      @JsonKey(name: 'enable_commands') bool enableCommands,
      @JsonKey(name: 'enable_webhooks') bool enableWebhooks,
      @JsonKey(name: 'privacy_mode') String privacyMode,
      @JsonKey(name: 'rate_limit_per_user') int rateLimitPerUser,
      @JsonKey(name: 'max_command_queue') int maxCommandQueue});
}

/// @nodoc
class _$BotSettingsCopyWithImpl<$Res, $Val extends BotSettings>
    implements $BotSettingsCopyWith<$Res> {
  _$BotSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowDirectMessages = null,
    Object? allowGroupMessages = null,
    Object? enableCommands = null,
    Object? enableWebhooks = null,
    Object? privacyMode = null,
    Object? rateLimitPerUser = null,
    Object? maxCommandQueue = null,
  }) {
    return _then(_value.copyWith(
      allowDirectMessages: null == allowDirectMessages
          ? _value.allowDirectMessages
          : allowDirectMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      allowGroupMessages: null == allowGroupMessages
          ? _value.allowGroupMessages
          : allowGroupMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCommands: null == enableCommands
          ? _value.enableCommands
          : enableCommands // ignore: cast_nullable_to_non_nullable
              as bool,
      enableWebhooks: null == enableWebhooks
          ? _value.enableWebhooks
          : enableWebhooks // ignore: cast_nullable_to_non_nullable
              as bool,
      privacyMode: null == privacyMode
          ? _value.privacyMode
          : privacyMode // ignore: cast_nullable_to_non_nullable
              as String,
      rateLimitPerUser: null == rateLimitPerUser
          ? _value.rateLimitPerUser
          : rateLimitPerUser // ignore: cast_nullable_to_non_nullable
              as int,
      maxCommandQueue: null == maxCommandQueue
          ? _value.maxCommandQueue
          : maxCommandQueue // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BotSettingsImplCopyWith<$Res>
    implements $BotSettingsCopyWith<$Res> {
  factory _$$BotSettingsImplCopyWith(
          _$BotSettingsImpl value, $Res Function(_$BotSettingsImpl) then) =
      __$$BotSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'allow_direct_messages') bool allowDirectMessages,
      @JsonKey(name: 'allow_group_messages') bool allowGroupMessages,
      @JsonKey(name: 'enable_commands') bool enableCommands,
      @JsonKey(name: 'enable_webhooks') bool enableWebhooks,
      @JsonKey(name: 'privacy_mode') String privacyMode,
      @JsonKey(name: 'rate_limit_per_user') int rateLimitPerUser,
      @JsonKey(name: 'max_command_queue') int maxCommandQueue});
}

/// @nodoc
class __$$BotSettingsImplCopyWithImpl<$Res>
    extends _$BotSettingsCopyWithImpl<$Res, _$BotSettingsImpl>
    implements _$$BotSettingsImplCopyWith<$Res> {
  __$$BotSettingsImplCopyWithImpl(
      _$BotSettingsImpl _value, $Res Function(_$BotSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowDirectMessages = null,
    Object? allowGroupMessages = null,
    Object? enableCommands = null,
    Object? enableWebhooks = null,
    Object? privacyMode = null,
    Object? rateLimitPerUser = null,
    Object? maxCommandQueue = null,
  }) {
    return _then(_$BotSettingsImpl(
      allowDirectMessages: null == allowDirectMessages
          ? _value.allowDirectMessages
          : allowDirectMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      allowGroupMessages: null == allowGroupMessages
          ? _value.allowGroupMessages
          : allowGroupMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCommands: null == enableCommands
          ? _value.enableCommands
          : enableCommands // ignore: cast_nullable_to_non_nullable
              as bool,
      enableWebhooks: null == enableWebhooks
          ? _value.enableWebhooks
          : enableWebhooks // ignore: cast_nullable_to_non_nullable
              as bool,
      privacyMode: null == privacyMode
          ? _value.privacyMode
          : privacyMode // ignore: cast_nullable_to_non_nullable
              as String,
      rateLimitPerUser: null == rateLimitPerUser
          ? _value.rateLimitPerUser
          : rateLimitPerUser // ignore: cast_nullable_to_non_nullable
              as int,
      maxCommandQueue: null == maxCommandQueue
          ? _value.maxCommandQueue
          : maxCommandQueue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BotSettingsImpl implements _BotSettings {
  const _$BotSettingsImpl(
      {@JsonKey(name: 'allow_direct_messages') this.allowDirectMessages = true,
      @JsonKey(name: 'allow_group_messages') this.allowGroupMessages = true,
      @JsonKey(name: 'enable_commands') this.enableCommands = true,
      @JsonKey(name: 'enable_webhooks') this.enableWebhooks = false,
      @JsonKey(name: 'privacy_mode') this.privacyMode = 'private',
      @JsonKey(name: 'rate_limit_per_user') this.rateLimitPerUser = 30,
      @JsonKey(name: 'max_command_queue') this.maxCommandQueue = 100});

  factory _$BotSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BotSettingsImplFromJson(json);

  @override
  @JsonKey(name: 'allow_direct_messages')
  final bool allowDirectMessages;
  @override
  @JsonKey(name: 'allow_group_messages')
  final bool allowGroupMessages;
  @override
  @JsonKey(name: 'enable_commands')
  final bool enableCommands;
  @override
  @JsonKey(name: 'enable_webhooks')
  final bool enableWebhooks;
  @override
  @JsonKey(name: 'privacy_mode')
  final String privacyMode;
  @override
  @JsonKey(name: 'rate_limit_per_user')
  final int rateLimitPerUser;
  @override
  @JsonKey(name: 'max_command_queue')
  final int maxCommandQueue;

  @override
  String toString() {
    return 'BotSettings(allowDirectMessages: $allowDirectMessages, allowGroupMessages: $allowGroupMessages, enableCommands: $enableCommands, enableWebhooks: $enableWebhooks, privacyMode: $privacyMode, rateLimitPerUser: $rateLimitPerUser, maxCommandQueue: $maxCommandQueue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BotSettingsImpl &&
            (identical(other.allowDirectMessages, allowDirectMessages) ||
                other.allowDirectMessages == allowDirectMessages) &&
            (identical(other.allowGroupMessages, allowGroupMessages) ||
                other.allowGroupMessages == allowGroupMessages) &&
            (identical(other.enableCommands, enableCommands) ||
                other.enableCommands == enableCommands) &&
            (identical(other.enableWebhooks, enableWebhooks) ||
                other.enableWebhooks == enableWebhooks) &&
            (identical(other.privacyMode, privacyMode) ||
                other.privacyMode == privacyMode) &&
            (identical(other.rateLimitPerUser, rateLimitPerUser) ||
                other.rateLimitPerUser == rateLimitPerUser) &&
            (identical(other.maxCommandQueue, maxCommandQueue) ||
                other.maxCommandQueue == maxCommandQueue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      allowDirectMessages,
      allowGroupMessages,
      enableCommands,
      enableWebhooks,
      privacyMode,
      rateLimitPerUser,
      maxCommandQueue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BotSettingsImplCopyWith<_$BotSettingsImpl> get copyWith =>
      __$$BotSettingsImplCopyWithImpl<_$BotSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BotSettingsImplToJson(
      this,
    );
  }
}

abstract class _BotSettings implements BotSettings {
  const factory _BotSettings(
      {@JsonKey(name: 'allow_direct_messages') final bool allowDirectMessages,
      @JsonKey(name: 'allow_group_messages') final bool allowGroupMessages,
      @JsonKey(name: 'enable_commands') final bool enableCommands,
      @JsonKey(name: 'enable_webhooks') final bool enableWebhooks,
      @JsonKey(name: 'privacy_mode') final String privacyMode,
      @JsonKey(name: 'rate_limit_per_user') final int rateLimitPerUser,
      @JsonKey(name: 'max_command_queue')
      final int maxCommandQueue}) = _$BotSettingsImpl;

  factory _BotSettings.fromJson(Map<String, dynamic> json) =
      _$BotSettingsImpl.fromJson;

  @override
  @JsonKey(name: 'allow_direct_messages')
  bool get allowDirectMessages;
  @override
  @JsonKey(name: 'allow_group_messages')
  bool get allowGroupMessages;
  @override
  @JsonKey(name: 'enable_commands')
  bool get enableCommands;
  @override
  @JsonKey(name: 'enable_webhooks')
  bool get enableWebhooks;
  @override
  @JsonKey(name: 'privacy_mode')
  String get privacyMode;
  @override
  @JsonKey(name: 'rate_limit_per_user')
  int get rateLimitPerUser;
  @override
  @JsonKey(name: 'max_command_queue')
  int get maxCommandQueue;
  @override
  @JsonKey(ignore: true)
  _$$BotSettingsImplCopyWith<_$BotSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BotStats _$BotStatsFromJson(Map<String, dynamic> json) {
  return _BotStats.fromJson(json);
}

/// @nodoc
mixin _$BotStats {
  @JsonKey(name: 'total_users')
  int get totalUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_users')
  int get activeUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'messages_sent')
  int get messagesSent => throw _privateConstructorUsedError;
  @JsonKey(name: 'commands_executed')
  int get commandsExecuted => throw _privateConstructorUsedError;
  @JsonKey(name: 'errors_occurred')
  int get errorsOccurred => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_response_time')
  double get avgResponseTime => throw _privateConstructorUsedError;
  double get uptime => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_active_at')
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BotStatsCopyWith<BotStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BotStatsCopyWith<$Res> {
  factory $BotStatsCopyWith(BotStats value, $Res Function(BotStats) then) =
      _$BotStatsCopyWithImpl<$Res, BotStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers,
      @JsonKey(name: 'active_users') int activeUsers,
      @JsonKey(name: 'messages_sent') int messagesSent,
      @JsonKey(name: 'commands_executed') int commandsExecuted,
      @JsonKey(name: 'errors_occurred') int errorsOccurred,
      @JsonKey(name: 'avg_response_time') double avgResponseTime,
      double uptime,
      @JsonKey(name: 'last_active_at') DateTime? lastActiveAt});
}

/// @nodoc
class _$BotStatsCopyWithImpl<$Res, $Val extends BotStats>
    implements $BotStatsCopyWith<$Res> {
  _$BotStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? messagesSent = null,
    Object? commandsExecuted = null,
    Object? errorsOccurred = null,
    Object? avgResponseTime = null,
    Object? uptime = null,
    Object? lastActiveAt = freezed,
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
      messagesSent: null == messagesSent
          ? _value.messagesSent
          : messagesSent // ignore: cast_nullable_to_non_nullable
              as int,
      commandsExecuted: null == commandsExecuted
          ? _value.commandsExecuted
          : commandsExecuted // ignore: cast_nullable_to_non_nullable
              as int,
      errorsOccurred: null == errorsOccurred
          ? _value.errorsOccurred
          : errorsOccurred // ignore: cast_nullable_to_non_nullable
              as int,
      avgResponseTime: null == avgResponseTime
          ? _value.avgResponseTime
          : avgResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      uptime: null == uptime
          ? _value.uptime
          : uptime // ignore: cast_nullable_to_non_nullable
              as double,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BotStatsImplCopyWith<$Res>
    implements $BotStatsCopyWith<$Res> {
  factory _$$BotStatsImplCopyWith(
          _$BotStatsImpl value, $Res Function(_$BotStatsImpl) then) =
      __$$BotStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers,
      @JsonKey(name: 'active_users') int activeUsers,
      @JsonKey(name: 'messages_sent') int messagesSent,
      @JsonKey(name: 'commands_executed') int commandsExecuted,
      @JsonKey(name: 'errors_occurred') int errorsOccurred,
      @JsonKey(name: 'avg_response_time') double avgResponseTime,
      double uptime,
      @JsonKey(name: 'last_active_at') DateTime? lastActiveAt});
}

/// @nodoc
class __$$BotStatsImplCopyWithImpl<$Res>
    extends _$BotStatsCopyWithImpl<$Res, _$BotStatsImpl>
    implements _$$BotStatsImplCopyWith<$Res> {
  __$$BotStatsImplCopyWithImpl(
      _$BotStatsImpl _value, $Res Function(_$BotStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? messagesSent = null,
    Object? commandsExecuted = null,
    Object? errorsOccurred = null,
    Object? avgResponseTime = null,
    Object? uptime = null,
    Object? lastActiveAt = freezed,
  }) {
    return _then(_$BotStatsImpl(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      messagesSent: null == messagesSent
          ? _value.messagesSent
          : messagesSent // ignore: cast_nullable_to_non_nullable
              as int,
      commandsExecuted: null == commandsExecuted
          ? _value.commandsExecuted
          : commandsExecuted // ignore: cast_nullable_to_non_nullable
              as int,
      errorsOccurred: null == errorsOccurred
          ? _value.errorsOccurred
          : errorsOccurred // ignore: cast_nullable_to_non_nullable
              as int,
      avgResponseTime: null == avgResponseTime
          ? _value.avgResponseTime
          : avgResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      uptime: null == uptime
          ? _value.uptime
          : uptime // ignore: cast_nullable_to_non_nullable
              as double,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BotStatsImpl implements _BotStats {
  const _$BotStatsImpl(
      {@JsonKey(name: 'total_users') this.totalUsers = 0,
      @JsonKey(name: 'active_users') this.activeUsers = 0,
      @JsonKey(name: 'messages_sent') this.messagesSent = 0,
      @JsonKey(name: 'commands_executed') this.commandsExecuted = 0,
      @JsonKey(name: 'errors_occurred') this.errorsOccurred = 0,
      @JsonKey(name: 'avg_response_time') this.avgResponseTime = 0.0,
      this.uptime = 0.0,
      @JsonKey(name: 'last_active_at') this.lastActiveAt});

  factory _$BotStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BotStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_users')
  final int totalUsers;
  @override
  @JsonKey(name: 'active_users')
  final int activeUsers;
  @override
  @JsonKey(name: 'messages_sent')
  final int messagesSent;
  @override
  @JsonKey(name: 'commands_executed')
  final int commandsExecuted;
  @override
  @JsonKey(name: 'errors_occurred')
  final int errorsOccurred;
  @override
  @JsonKey(name: 'avg_response_time')
  final double avgResponseTime;
  @override
  @JsonKey()
  final double uptime;
  @override
  @JsonKey(name: 'last_active_at')
  final DateTime? lastActiveAt;

  @override
  String toString() {
    return 'BotStats(totalUsers: $totalUsers, activeUsers: $activeUsers, messagesSent: $messagesSent, commandsExecuted: $commandsExecuted, errorsOccurred: $errorsOccurred, avgResponseTime: $avgResponseTime, uptime: $uptime, lastActiveAt: $lastActiveAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BotStatsImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.messagesSent, messagesSent) ||
                other.messagesSent == messagesSent) &&
            (identical(other.commandsExecuted, commandsExecuted) ||
                other.commandsExecuted == commandsExecuted) &&
            (identical(other.errorsOccurred, errorsOccurred) ||
                other.errorsOccurred == errorsOccurred) &&
            (identical(other.avgResponseTime, avgResponseTime) ||
                other.avgResponseTime == avgResponseTime) &&
            (identical(other.uptime, uptime) || other.uptime == uptime) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalUsers,
      activeUsers,
      messagesSent,
      commandsExecuted,
      errorsOccurred,
      avgResponseTime,
      uptime,
      lastActiveAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BotStatsImplCopyWith<_$BotStatsImpl> get copyWith =>
      __$$BotStatsImplCopyWithImpl<_$BotStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BotStatsImplToJson(
      this,
    );
  }
}

abstract class _BotStats implements BotStats {
  const factory _BotStats(
          {@JsonKey(name: 'total_users') final int totalUsers,
          @JsonKey(name: 'active_users') final int activeUsers,
          @JsonKey(name: 'messages_sent') final int messagesSent,
          @JsonKey(name: 'commands_executed') final int commandsExecuted,
          @JsonKey(name: 'errors_occurred') final int errorsOccurred,
          @JsonKey(name: 'avg_response_time') final double avgResponseTime,
          final double uptime,
          @JsonKey(name: 'last_active_at') final DateTime? lastActiveAt}) =
      _$BotStatsImpl;

  factory _BotStats.fromJson(Map<String, dynamic> json) =
      _$BotStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_users')
  int get totalUsers;
  @override
  @JsonKey(name: 'active_users')
  int get activeUsers;
  @override
  @JsonKey(name: 'messages_sent')
  int get messagesSent;
  @override
  @JsonKey(name: 'commands_executed')
  int get commandsExecuted;
  @override
  @JsonKey(name: 'errors_occurred')
  int get errorsOccurred;
  @override
  @JsonKey(name: 'avg_response_time')
  double get avgResponseTime;
  @override
  double get uptime;
  @override
  @JsonKey(name: 'last_active_at')
  DateTime? get lastActiveAt;
  @override
  @JsonKey(ignore: true)
  _$$BotStatsImplCopyWith<_$BotStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Bot _$BotFromJson(Map<String, dynamic> json) {
  return _Bot.fromJson(json);
}

/// @nodoc
mixin _$Bot {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_id')
  String get appId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_official')
  bool get isOfficial => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  List<BotCapability> get capabilities => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  BotStats? get stats => throw _privateConstructorUsedError;
  BotSettings? get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BotCopyWith<Bot> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BotCopyWith<$Res> {
  factory $BotCopyWith(Bot value, $Res Function(Bot) then) =
      _$BotCopyWithImpl<$Res, Bot>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'app_id') String appId,
      String name,
      String? description,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_official') bool isOfficial,
      List<String> permissions,
      List<BotCapability> capabilities,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      BotStats? stats,
      BotSettings? settings});

  $BotStatsCopyWith<$Res>? get stats;
  $BotSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$BotCopyWithImpl<$Res, $Val extends Bot> implements $BotCopyWith<$Res> {
  _$BotCopyWithImpl(this._value, this._then);

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
    Object? description = freezed,
    Object? avatarUrl = freezed,
    Object? isPublic = null,
    Object? isActive = null,
    Object? isOfficial = null,
    Object? permissions = null,
    Object? capabilities = null,
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
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isOfficial: null == isOfficial
          ? _value.isOfficial
          : isOfficial // ignore: cast_nullable_to_non_nullable
              as bool,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as List<BotCapability>,
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
              as BotStats?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BotSettings?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BotStatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $BotStatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BotSettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $BotSettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BotImplCopyWith<$Res> implements $BotCopyWith<$Res> {
  factory _$$BotImplCopyWith(_$BotImpl value, $Res Function(_$BotImpl) then) =
      __$$BotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'app_id') String appId,
      String name,
      String? description,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_official') bool isOfficial,
      List<String> permissions,
      List<BotCapability> capabilities,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      BotStats? stats,
      BotSettings? settings});

  @override
  $BotStatsCopyWith<$Res>? get stats;
  @override
  $BotSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$BotImplCopyWithImpl<$Res> extends _$BotCopyWithImpl<$Res, _$BotImpl>
    implements _$$BotImplCopyWith<$Res> {
  __$$BotImplCopyWithImpl(_$BotImpl _value, $Res Function(_$BotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appId = null,
    Object? name = null,
    Object? description = freezed,
    Object? avatarUrl = freezed,
    Object? isPublic = null,
    Object? isActive = null,
    Object? isOfficial = null,
    Object? permissions = null,
    Object? capabilities = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? stats = freezed,
    Object? settings = freezed,
  }) {
    return _then(_$BotImpl(
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isOfficial: null == isOfficial
          ? _value.isOfficial
          : isOfficial // ignore: cast_nullable_to_non_nullable
              as bool,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      capabilities: null == capabilities
          ? _value._capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as List<BotCapability>,
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
              as BotStats?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BotSettings?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BotImpl extends _Bot {
  const _$BotImpl(
      {required this.id,
      @JsonKey(name: 'app_id') required this.appId,
      required this.name,
      this.description,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'is_public') this.isPublic = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_official') this.isOfficial = false,
      final List<String> permissions = const [],
      final List<BotCapability> capabilities = const [],
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.stats,
      this.settings})
      : _permissions = permissions,
        _capabilities = capabilities,
        super._();

  factory _$BotImpl.fromJson(Map<String, dynamic> json) =>
      _$$BotImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'app_id')
  final String appId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_official')
  final bool isOfficial;
  final List<String> _permissions;
  @override
  @JsonKey()
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  final List<BotCapability> _capabilities;
  @override
  @JsonKey()
  List<BotCapability> get capabilities {
    if (_capabilities is EqualUnmodifiableListView) return _capabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capabilities);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  final BotStats? stats;
  @override
  final BotSettings? settings;

  @override
  String toString() {
    return 'Bot(id: $id, appId: $appId, name: $name, description: $description, avatarUrl: $avatarUrl, isPublic: $isPublic, isActive: $isActive, isOfficial: $isOfficial, permissions: $permissions, capabilities: $capabilities, createdAt: $createdAt, updatedAt: $updatedAt, stats: $stats, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isOfficial, isOfficial) ||
                other.isOfficial == isOfficial) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            const DeepCollectionEquality()
                .equals(other._capabilities, _capabilities) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      id,
      appId,
      name,
      description,
      avatarUrl,
      isPublic,
      isActive,
      isOfficial,
      const DeepCollectionEquality().hash(_permissions),
      const DeepCollectionEquality().hash(_capabilities),
      createdAt,
      updatedAt,
      stats,
      settings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BotImplCopyWith<_$BotImpl> get copyWith =>
      __$$BotImplCopyWithImpl<_$BotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BotImplToJson(
      this,
    );
  }
}

abstract class _Bot extends Bot {
  const factory _Bot(
      {required final String id,
      @JsonKey(name: 'app_id') required final String appId,
      required final String name,
      final String? description,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'is_public') final bool isPublic,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'is_official') final bool isOfficial,
      final List<String> permissions,
      final List<BotCapability> capabilities,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final BotStats? stats,
      final BotSettings? settings}) = _$BotImpl;
  const _Bot._() : super._();

  factory _Bot.fromJson(Map<String, dynamic> json) = _$BotImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'app_id')
  String get appId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_official')
  bool get isOfficial;
  @override
  List<String> get permissions;
  @override
  List<BotCapability> get capabilities;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  BotStats? get stats;
  @override
  BotSettings? get settings;
  @override
  @JsonKey(ignore: true)
  _$$BotImplCopyWith<_$BotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
