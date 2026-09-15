// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suspicious_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModerationQueueItemImpl _$$ModerationQueueItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ModerationQueueItemImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      reason: $enumDecode(_$ModerationReasonEnumMap, json['reason']),
      riskLevel: $enumDecode(_$RiskLevelEnumMap, json['riskLevel']),
      botProbability: (json['botProbability'] as num?)?.toDouble() ?? 0.0,
      trustScore: (json['trustScore'] as num?)?.toDouble() ?? 0.0,
      reportCount: (json['reportCount'] as num?)?.toInt() ?? 0,
      reporterIds: (json['reporterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      contentSampleIds: (json['contentSampleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      evidenceUrls: (json['evidenceUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastAction: $enumDecodeNullable(_$LastActionEnumMap, json['lastAction']),
      moderatorNote: json['moderatorNote'] as String?,
      isAppealed: json['isAppealed'] as bool? ?? false,
      appealStatus:
          $enumDecodeNullable(_$AppealStatusEnumMap, json['appealStatus']),
      appealReason: json['appealReason'] as String?,
      behavioralScore: (json['behavioralScore'] as num?)?.toDouble() ?? 0.0,
      networkScore: (json['networkScore'] as num?)?.toDouble() ?? 0.0,
      contentScore: (json['contentScore'] as num?)?.toDouble() ?? 0.0,
      compositeScore: (json['compositeScore'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ModerationQueueItemImplToJson(
        _$ModerationQueueItemImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'reason': _$ModerationReasonEnumMap[instance.reason]!,
      'riskLevel': _$RiskLevelEnumMap[instance.riskLevel]!,
      'botProbability': instance.botProbability,
      'trustScore': instance.trustScore,
      'reportCount': instance.reportCount,
      'reporterIds': instance.reporterIds,
      'contentSampleIds': instance.contentSampleIds,
      'evidenceUrls': instance.evidenceUrls,
      'lastAction': _$LastActionEnumMap[instance.lastAction],
      'moderatorNote': instance.moderatorNote,
      'isAppealed': instance.isAppealed,
      'appealStatus': _$AppealStatusEnumMap[instance.appealStatus],
      'appealReason': instance.appealReason,
      'behavioralScore': instance.behavioralScore,
      'networkScore': instance.networkScore,
      'contentScore': instance.contentScore,
      'compositeScore': instance.compositeScore,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ModerationReasonEnumMap = {
  ModerationReason.bot: 'bot',
  ModerationReason.spam: 'spam',
  ModerationReason.harassment: 'harassment',
  ModerationReason.impersonation: 'impersonation',
  ModerationReason.csam: 'csam',
  ModerationReason.copyright: 'copyright',
  ModerationReason.misinformation: 'misinformation',
  ModerationReason.coordinatedInauthentic: 'coordinated_inauthentic',
};

const _$RiskLevelEnumMap = {
  RiskLevel.low: 'low',
  RiskLevel.medium: 'medium',
  RiskLevel.high: 'high',
  RiskLevel.critical: 'critical',
};

const _$LastActionEnumMap = {
  LastAction.banned: 'banned',
  LastAction.warned: 'warned',
  LastAction.safe: 'safe',
  LastAction.escalated: 'escalated',
  LastAction.underReview: 'underReview',
};

const _$AppealStatusEnumMap = {
  AppealStatus.pending: 'pending',
  AppealStatus.approved: 'approved',
  AppealStatus.rejected: 'rejected',
  AppealStatus.withdrawn: 'withdrawn',
};

_$SuspiciousAccountImpl _$$SuspiciousAccountImplFromJson(
        Map<String, dynamic> json) =>
    _$SuspiciousAccountImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      reason: $enumDecode(_$ModerationReasonEnumMap, json['reason']),
      riskLevel: $enumDecode(_$RiskLevelEnumMap, json['riskLevel']),
      botProbability: (json['botProbability'] as num?)?.toDouble() ?? 0.0,
      trustScore: (json['trustScore'] as num?)?.toDouble() ?? 0.0,
      reportCount: (json['reportCount'] as num?)?.toInt() ?? 0,
      reporterIds: (json['reporterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      contentSampleIds: (json['contentSampleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      evidenceUrls: (json['evidenceUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastAction: $enumDecodeNullable(_$LastActionEnumMap, json['lastAction']),
      moderatorNote: json['moderatorNote'] as String?,
      isAppealed: json['isAppealed'] as bool? ?? false,
      appealStatus:
          $enumDecodeNullable(_$AppealStatusEnumMap, json['appealStatus']),
      appealReason: json['appealReason'] as String?,
      behavioralScore: (json['behavioralScore'] as num?)?.toDouble() ?? 0.0,
      networkScore: (json['networkScore'] as num?)?.toDouble() ?? 0.0,
      contentScore: (json['contentScore'] as num?)?.toDouble() ?? 0.0,
      compositeScore: (json['compositeScore'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SuspiciousAccountImplToJson(
        _$SuspiciousAccountImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'reason': _$ModerationReasonEnumMap[instance.reason]!,
      'riskLevel': _$RiskLevelEnumMap[instance.riskLevel]!,
      'botProbability': instance.botProbability,
      'trustScore': instance.trustScore,
      'reportCount': instance.reportCount,
      'reporterIds': instance.reporterIds,
      'contentSampleIds': instance.contentSampleIds,
      'evidenceUrls': instance.evidenceUrls,
      'lastAction': _$LastActionEnumMap[instance.lastAction],
      'moderatorNote': instance.moderatorNote,
      'isAppealed': instance.isAppealed,
      'appealStatus': _$AppealStatusEnumMap[instance.appealStatus],
      'appealReason': instance.appealReason,
      'behavioralScore': instance.behavioralScore,
      'networkScore': instance.networkScore,
      'contentScore': instance.contentScore,
      'compositeScore': instance.compositeScore,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
