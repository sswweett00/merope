// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_action_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModerationActionRequestImpl _$$ModerationActionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ModerationActionRequestImpl(
      type: $enumDecode(_$ModerationActionTypeEnumMap, json['type']),
      userId: json['userId'] as String,
      reason: json['reason'] as String?,
      durationDays: (json['durationDays'] as num?)?.toInt(),
      escalationTarget: json['escalationTarget'] as String?,
      moderatorNote: json['moderatorNote'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ModerationActionRequestImplToJson(
        _$ModerationActionRequestImpl instance) =>
    <String, dynamic>{
      'type': _$ModerationActionTypeEnumMap[instance.type]!,
      'userId': instance.userId,
      'reason': instance.reason,
      'durationDays': instance.durationDays,
      'escalationTarget': instance.escalationTarget,
      'moderatorNote': instance.moderatorNote,
      'metadata': instance.metadata,
    };

const _$ModerationActionTypeEnumMap = {
  ModerationActionType.ban: 'ban',
  ModerationActionType.markSafe: 'markSafe',
  ModerationActionType.escalate: 'escalate',
  ModerationActionType.warn: 'warn',
  ModerationActionType.review: 'review',
};

_$BulkModerationActionRequestImpl _$$BulkModerationActionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$BulkModerationActionRequestImpl(
      type: $enumDecode(_$ModerationActionTypeEnumMap, json['type']),
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      reason: json['reason'] as String?,
      durationDays: (json['durationDays'] as num?)?.toInt(),
      moderatorNote: json['moderatorNote'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$BulkModerationActionRequestImplToJson(
        _$BulkModerationActionRequestImpl instance) =>
    <String, dynamic>{
      'type': _$ModerationActionTypeEnumMap[instance.type]!,
      'userIds': instance.userIds,
      'reason': instance.reason,
      'durationDays': instance.durationDays,
      'moderatorNote': instance.moderatorNote,
      'metadata': instance.metadata,
    };
