// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_database.dart';

// ignore_for_file: type=lint
class $ModerationQueueCacheTable extends ModerationQueueCache
    with TableInfo<$ModerationQueueCacheTable, ModerationQueueCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModerationQueueCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _riskLevelMeta =
      const VerificationMeta('riskLevel');
  @override
  late final GeneratedColumn<String> riskLevel = GeneratedColumn<String>(
      'risk_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _botProbabilityMeta =
      const VerificationMeta('botProbability');
  @override
  late final GeneratedColumn<double> botProbability = GeneratedColumn<double>(
      'bot_probability', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _trustScoreMeta =
      const VerificationMeta('trustScore');
  @override
  late final GeneratedColumn<double> trustScore = GeneratedColumn<double>(
      'trust_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reportCountMeta =
      const VerificationMeta('reportCount');
  @override
  late final GeneratedColumn<int> reportCount = GeneratedColumn<int>(
      'report_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reporterIdsMeta =
      const VerificationMeta('reporterIds');
  @override
  late final GeneratedColumn<String> reporterIds = GeneratedColumn<String>(
      'reporter_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentSampleIdsMeta =
      const VerificationMeta('contentSampleIds');
  @override
  late final GeneratedColumn<String> contentSampleIds = GeneratedColumn<String>(
      'content_sample_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _evidenceUrlsMeta =
      const VerificationMeta('evidenceUrls');
  @override
  late final GeneratedColumn<String> evidenceUrls = GeneratedColumn<String>(
      'evidence_urls', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastActionMeta =
      const VerificationMeta('lastAction');
  @override
  late final GeneratedColumn<String> lastAction = GeneratedColumn<String>(
      'last_action', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moderatorNoteMeta =
      const VerificationMeta('moderatorNote');
  @override
  late final GeneratedColumn<String> moderatorNote = GeneratedColumn<String>(
      'moderator_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isAppealedMeta =
      const VerificationMeta('isAppealed');
  @override
  late final GeneratedColumn<bool> isAppealed = GeneratedColumn<bool>(
      'is_appealed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_appealed" IN (0, 1))'));
  static const VerificationMeta _appealStatusMeta =
      const VerificationMeta('appealStatus');
  @override
  late final GeneratedColumn<String> appealStatus = GeneratedColumn<String>(
      'appeal_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _appealReasonMeta =
      const VerificationMeta('appealReason');
  @override
  late final GeneratedColumn<String> appealReason = GeneratedColumn<String>(
      'appeal_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _behavioralScoreMeta =
      const VerificationMeta('behavioralScore');
  @override
  late final GeneratedColumn<double> behavioralScore = GeneratedColumn<double>(
      'behavioral_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _networkScoreMeta =
      const VerificationMeta('networkScore');
  @override
  late final GeneratedColumn<double> networkScore = GeneratedColumn<double>(
      'network_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _contentScoreMeta =
      const VerificationMeta('contentScore');
  @override
  late final GeneratedColumn<double> contentScore = GeneratedColumn<double>(
      'content_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _compositeScoreMeta =
      const VerificationMeta('compositeScore');
  @override
  late final GeneratedColumn<double> compositeScore = GeneratedColumn<double>(
      'composite_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        username,
        displayName,
        avatarUrl,
        reason,
        riskLevel,
        botProbability,
        trustScore,
        reportCount,
        reporterIds,
        contentSampleIds,
        evidenceUrls,
        lastAction,
        moderatorNote,
        isAppealed,
        appealStatus,
        appealReason,
        behavioralScore,
        networkScore,
        contentScore,
        compositeScore,
        createdAt,
        updatedAt,
        isSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moderation_queue_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<ModerationQueueCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('risk_level')) {
      context.handle(_riskLevelMeta,
          riskLevel.isAcceptableOrUnknown(data['risk_level']!, _riskLevelMeta));
    } else if (isInserting) {
      context.missing(_riskLevelMeta);
    }
    if (data.containsKey('bot_probability')) {
      context.handle(
          _botProbabilityMeta,
          botProbability.isAcceptableOrUnknown(
              data['bot_probability']!, _botProbabilityMeta));
    } else if (isInserting) {
      context.missing(_botProbabilityMeta);
    }
    if (data.containsKey('trust_score')) {
      context.handle(
          _trustScoreMeta,
          trustScore.isAcceptableOrUnknown(
              data['trust_score']!, _trustScoreMeta));
    } else if (isInserting) {
      context.missing(_trustScoreMeta);
    }
    if (data.containsKey('report_count')) {
      context.handle(
          _reportCountMeta,
          reportCount.isAcceptableOrUnknown(
              data['report_count']!, _reportCountMeta));
    } else if (isInserting) {
      context.missing(_reportCountMeta);
    }
    if (data.containsKey('reporter_ids')) {
      context.handle(
          _reporterIdsMeta,
          reporterIds.isAcceptableOrUnknown(
              data['reporter_ids']!, _reporterIdsMeta));
    } else if (isInserting) {
      context.missing(_reporterIdsMeta);
    }
    if (data.containsKey('content_sample_ids')) {
      context.handle(
          _contentSampleIdsMeta,
          contentSampleIds.isAcceptableOrUnknown(
              data['content_sample_ids']!, _contentSampleIdsMeta));
    } else if (isInserting) {
      context.missing(_contentSampleIdsMeta);
    }
    if (data.containsKey('evidence_urls')) {
      context.handle(
          _evidenceUrlsMeta,
          evidenceUrls.isAcceptableOrUnknown(
              data['evidence_urls']!, _evidenceUrlsMeta));
    } else if (isInserting) {
      context.missing(_evidenceUrlsMeta);
    }
    if (data.containsKey('last_action')) {
      context.handle(
          _lastActionMeta,
          lastAction.isAcceptableOrUnknown(
              data['last_action']!, _lastActionMeta));
    }
    if (data.containsKey('moderator_note')) {
      context.handle(
          _moderatorNoteMeta,
          moderatorNote.isAcceptableOrUnknown(
              data['moderator_note']!, _moderatorNoteMeta));
    }
    if (data.containsKey('is_appealed')) {
      context.handle(
          _isAppealedMeta,
          isAppealed.isAcceptableOrUnknown(
              data['is_appealed']!, _isAppealedMeta));
    } else if (isInserting) {
      context.missing(_isAppealedMeta);
    }
    if (data.containsKey('appeal_status')) {
      context.handle(
          _appealStatusMeta,
          appealStatus.isAcceptableOrUnknown(
              data['appeal_status']!, _appealStatusMeta));
    }
    if (data.containsKey('appeal_reason')) {
      context.handle(
          _appealReasonMeta,
          appealReason.isAcceptableOrUnknown(
              data['appeal_reason']!, _appealReasonMeta));
    }
    if (data.containsKey('behavioral_score')) {
      context.handle(
          _behavioralScoreMeta,
          behavioralScore.isAcceptableOrUnknown(
              data['behavioral_score']!, _behavioralScoreMeta));
    } else if (isInserting) {
      context.missing(_behavioralScoreMeta);
    }
    if (data.containsKey('network_score')) {
      context.handle(
          _networkScoreMeta,
          networkScore.isAcceptableOrUnknown(
              data['network_score']!, _networkScoreMeta));
    } else if (isInserting) {
      context.missing(_networkScoreMeta);
    }
    if (data.containsKey('content_score')) {
      context.handle(
          _contentScoreMeta,
          contentScore.isAcceptableOrUnknown(
              data['content_score']!, _contentScoreMeta));
    } else if (isInserting) {
      context.missing(_contentScoreMeta);
    }
    if (data.containsKey('composite_score')) {
      context.handle(
          _compositeScoreMeta,
          compositeScore.isAcceptableOrUnknown(
              data['composite_score']!, _compositeScoreMeta));
    } else if (isInserting) {
      context.missing(_compositeScoreMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {id},
      ];
  @override
  ModerationQueueCacheData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModerationQueueCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      riskLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}risk_level'])!,
      botProbability: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}bot_probability'])!,
      trustScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}trust_score'])!,
      reportCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}report_count'])!,
      reporterIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reporter_ids'])!,
      contentSampleIds: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}content_sample_ids'])!,
      evidenceUrls: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evidence_urls'])!,
      lastAction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_action']),
      moderatorNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}moderator_note']),
      isAppealed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_appealed'])!,
      appealStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}appeal_status']),
      appealReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}appeal_reason']),
      behavioralScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}behavioral_score'])!,
      networkScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}network_score'])!,
      contentScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}content_score'])!,
      compositeScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}composite_score'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $ModerationQueueCacheTable createAlias(String alias) {
    return $ModerationQueueCacheTable(attachedDatabase, alias);
  }
}

class ModerationQueueCacheData extends DataClass
    implements Insertable<ModerationQueueCacheData> {
  final String id;
  final String userId;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String reason;
  final String riskLevel;
  final double botProbability;
  final double trustScore;
  final int reportCount;
  final String reporterIds;
  final String contentSampleIds;
  final String evidenceUrls;
  final String? lastAction;
  final String? moderatorNote;
  final bool isAppealed;
  final String? appealStatus;
  final String? appealReason;
  final double behavioralScore;
  final double networkScore;
  final double contentScore;
  final double compositeScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const ModerationQueueCacheData(
      {required this.id,
      required this.userId,
      required this.username,
      required this.displayName,
      this.avatarUrl,
      required this.reason,
      required this.riskLevel,
      required this.botProbability,
      required this.trustScore,
      required this.reportCount,
      required this.reporterIds,
      required this.contentSampleIds,
      required this.evidenceUrls,
      this.lastAction,
      this.moderatorNote,
      required this.isAppealed,
      this.appealStatus,
      this.appealReason,
      required this.behavioralScore,
      required this.networkScore,
      required this.contentScore,
      required this.compositeScore,
      required this.createdAt,
      required this.updatedAt,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['username'] = Variable<String>(username);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['reason'] = Variable<String>(reason);
    map['risk_level'] = Variable<String>(riskLevel);
    map['bot_probability'] = Variable<double>(botProbability);
    map['trust_score'] = Variable<double>(trustScore);
    map['report_count'] = Variable<int>(reportCount);
    map['reporter_ids'] = Variable<String>(reporterIds);
    map['content_sample_ids'] = Variable<String>(contentSampleIds);
    map['evidence_urls'] = Variable<String>(evidenceUrls);
    if (!nullToAbsent || lastAction != null) {
      map['last_action'] = Variable<String>(lastAction);
    }
    if (!nullToAbsent || moderatorNote != null) {
      map['moderator_note'] = Variable<String>(moderatorNote);
    }
    map['is_appealed'] = Variable<bool>(isAppealed);
    if (!nullToAbsent || appealStatus != null) {
      map['appeal_status'] = Variable<String>(appealStatus);
    }
    if (!nullToAbsent || appealReason != null) {
      map['appeal_reason'] = Variable<String>(appealReason);
    }
    map['behavioral_score'] = Variable<double>(behavioralScore);
    map['network_score'] = Variable<double>(networkScore);
    map['content_score'] = Variable<double>(contentScore);
    map['composite_score'] = Variable<double>(compositeScore);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ModerationQueueCacheCompanion toCompanion(bool nullToAbsent) {
    return ModerationQueueCacheCompanion(
      id: Value(id),
      userId: Value(userId),
      username: Value(username),
      displayName: Value(displayName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      reason: Value(reason),
      riskLevel: Value(riskLevel),
      botProbability: Value(botProbability),
      trustScore: Value(trustScore),
      reportCount: Value(reportCount),
      reporterIds: Value(reporterIds),
      contentSampleIds: Value(contentSampleIds),
      evidenceUrls: Value(evidenceUrls),
      lastAction: lastAction == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAction),
      moderatorNote: moderatorNote == null && nullToAbsent
          ? const Value.absent()
          : Value(moderatorNote),
      isAppealed: Value(isAppealed),
      appealStatus: appealStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(appealStatus),
      appealReason: appealReason == null && nullToAbsent
          ? const Value.absent()
          : Value(appealReason),
      behavioralScore: Value(behavioralScore),
      networkScore: Value(networkScore),
      contentScore: Value(contentScore),
      compositeScore: Value(compositeScore),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory ModerationQueueCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModerationQueueCacheData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String>(json['displayName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      reason: serializer.fromJson<String>(json['reason']),
      riskLevel: serializer.fromJson<String>(json['riskLevel']),
      botProbability: serializer.fromJson<double>(json['botProbability']),
      trustScore: serializer.fromJson<double>(json['trustScore']),
      reportCount: serializer.fromJson<int>(json['reportCount']),
      reporterIds: serializer.fromJson<String>(json['reporterIds']),
      contentSampleIds: serializer.fromJson<String>(json['contentSampleIds']),
      evidenceUrls: serializer.fromJson<String>(json['evidenceUrls']),
      lastAction: serializer.fromJson<String?>(json['lastAction']),
      moderatorNote: serializer.fromJson<String?>(json['moderatorNote']),
      isAppealed: serializer.fromJson<bool>(json['isAppealed']),
      appealStatus: serializer.fromJson<String?>(json['appealStatus']),
      appealReason: serializer.fromJson<String?>(json['appealReason']),
      behavioralScore: serializer.fromJson<double>(json['behavioralScore']),
      networkScore: serializer.fromJson<double>(json['networkScore']),
      contentScore: serializer.fromJson<double>(json['contentScore']),
      compositeScore: serializer.fromJson<double>(json['compositeScore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String>(displayName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'reason': serializer.toJson<String>(reason),
      'riskLevel': serializer.toJson<String>(riskLevel),
      'botProbability': serializer.toJson<double>(botProbability),
      'trustScore': serializer.toJson<double>(trustScore),
      'reportCount': serializer.toJson<int>(reportCount),
      'reporterIds': serializer.toJson<String>(reporterIds),
      'contentSampleIds': serializer.toJson<String>(contentSampleIds),
      'evidenceUrls': serializer.toJson<String>(evidenceUrls),
      'lastAction': serializer.toJson<String?>(lastAction),
      'moderatorNote': serializer.toJson<String?>(moderatorNote),
      'isAppealed': serializer.toJson<bool>(isAppealed),
      'appealStatus': serializer.toJson<String?>(appealStatus),
      'appealReason': serializer.toJson<String?>(appealReason),
      'behavioralScore': serializer.toJson<double>(behavioralScore),
      'networkScore': serializer.toJson<double>(networkScore),
      'contentScore': serializer.toJson<double>(contentScore),
      'compositeScore': serializer.toJson<double>(compositeScore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ModerationQueueCacheData copyWith(
          {String? id,
          String? userId,
          String? username,
          String? displayName,
          Value<String?> avatarUrl = const Value.absent(),
          String? reason,
          String? riskLevel,
          double? botProbability,
          double? trustScore,
          int? reportCount,
          String? reporterIds,
          String? contentSampleIds,
          String? evidenceUrls,
          Value<String?> lastAction = const Value.absent(),
          Value<String?> moderatorNote = const Value.absent(),
          bool? isAppealed,
          Value<String?> appealStatus = const Value.absent(),
          Value<String?> appealReason = const Value.absent(),
          double? behavioralScore,
          double? networkScore,
          double? contentScore,
          double? compositeScore,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isSynced}) =>
      ModerationQueueCacheData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        reason: reason ?? this.reason,
        riskLevel: riskLevel ?? this.riskLevel,
        botProbability: botProbability ?? this.botProbability,
        trustScore: trustScore ?? this.trustScore,
        reportCount: reportCount ?? this.reportCount,
        reporterIds: reporterIds ?? this.reporterIds,
        contentSampleIds: contentSampleIds ?? this.contentSampleIds,
        evidenceUrls: evidenceUrls ?? this.evidenceUrls,
        lastAction: lastAction.present ? lastAction.value : this.lastAction,
        moderatorNote:
            moderatorNote.present ? moderatorNote.value : this.moderatorNote,
        isAppealed: isAppealed ?? this.isAppealed,
        appealStatus:
            appealStatus.present ? appealStatus.value : this.appealStatus,
        appealReason:
            appealReason.present ? appealReason.value : this.appealReason,
        behavioralScore: behavioralScore ?? this.behavioralScore,
        networkScore: networkScore ?? this.networkScore,
        contentScore: contentScore ?? this.contentScore,
        compositeScore: compositeScore ?? this.compositeScore,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
      );
  ModerationQueueCacheData copyWithCompanion(
      ModerationQueueCacheCompanion data) {
    return ModerationQueueCacheData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      username: data.username.present ? data.username.value : this.username,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      reason: data.reason.present ? data.reason.value : this.reason,
      riskLevel: data.riskLevel.present ? data.riskLevel.value : this.riskLevel,
      botProbability: data.botProbability.present
          ? data.botProbability.value
          : this.botProbability,
      trustScore:
          data.trustScore.present ? data.trustScore.value : this.trustScore,
      reportCount:
          data.reportCount.present ? data.reportCount.value : this.reportCount,
      reporterIds:
          data.reporterIds.present ? data.reporterIds.value : this.reporterIds,
      contentSampleIds: data.contentSampleIds.present
          ? data.contentSampleIds.value
          : this.contentSampleIds,
      evidenceUrls: data.evidenceUrls.present
          ? data.evidenceUrls.value
          : this.evidenceUrls,
      lastAction:
          data.lastAction.present ? data.lastAction.value : this.lastAction,
      moderatorNote: data.moderatorNote.present
          ? data.moderatorNote.value
          : this.moderatorNote,
      isAppealed:
          data.isAppealed.present ? data.isAppealed.value : this.isAppealed,
      appealStatus: data.appealStatus.present
          ? data.appealStatus.value
          : this.appealStatus,
      appealReason: data.appealReason.present
          ? data.appealReason.value
          : this.appealReason,
      behavioralScore: data.behavioralScore.present
          ? data.behavioralScore.value
          : this.behavioralScore,
      networkScore: data.networkScore.present
          ? data.networkScore.value
          : this.networkScore,
      contentScore: data.contentScore.present
          ? data.contentScore.value
          : this.contentScore,
      compositeScore: data.compositeScore.present
          ? data.compositeScore.value
          : this.compositeScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModerationQueueCacheData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('reason: $reason, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('botProbability: $botProbability, ')
          ..write('trustScore: $trustScore, ')
          ..write('reportCount: $reportCount, ')
          ..write('reporterIds: $reporterIds, ')
          ..write('contentSampleIds: $contentSampleIds, ')
          ..write('evidenceUrls: $evidenceUrls, ')
          ..write('lastAction: $lastAction, ')
          ..write('moderatorNote: $moderatorNote, ')
          ..write('isAppealed: $isAppealed, ')
          ..write('appealStatus: $appealStatus, ')
          ..write('appealReason: $appealReason, ')
          ..write('behavioralScore: $behavioralScore, ')
          ..write('networkScore: $networkScore, ')
          ..write('contentScore: $contentScore, ')
          ..write('compositeScore: $compositeScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        username,
        displayName,
        avatarUrl,
        reason,
        riskLevel,
        botProbability,
        trustScore,
        reportCount,
        reporterIds,
        contentSampleIds,
        evidenceUrls,
        lastAction,
        moderatorNote,
        isAppealed,
        appealStatus,
        appealReason,
        behavioralScore,
        networkScore,
        contentScore,
        compositeScore,
        createdAt,
        updatedAt,
        isSynced
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModerationQueueCacheData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.avatarUrl == this.avatarUrl &&
          other.reason == this.reason &&
          other.riskLevel == this.riskLevel &&
          other.botProbability == this.botProbability &&
          other.trustScore == this.trustScore &&
          other.reportCount == this.reportCount &&
          other.reporterIds == this.reporterIds &&
          other.contentSampleIds == this.contentSampleIds &&
          other.evidenceUrls == this.evidenceUrls &&
          other.lastAction == this.lastAction &&
          other.moderatorNote == this.moderatorNote &&
          other.isAppealed == this.isAppealed &&
          other.appealStatus == this.appealStatus &&
          other.appealReason == this.appealReason &&
          other.behavioralScore == this.behavioralScore &&
          other.networkScore == this.networkScore &&
          other.contentScore == this.contentScore &&
          other.compositeScore == this.compositeScore &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class ModerationQueueCacheCompanion
    extends UpdateCompanion<ModerationQueueCacheData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> username;
  final Value<String> displayName;
  final Value<String?> avatarUrl;
  final Value<String> reason;
  final Value<String> riskLevel;
  final Value<double> botProbability;
  final Value<double> trustScore;
  final Value<int> reportCount;
  final Value<String> reporterIds;
  final Value<String> contentSampleIds;
  final Value<String> evidenceUrls;
  final Value<String?> lastAction;
  final Value<String?> moderatorNote;
  final Value<bool> isAppealed;
  final Value<String?> appealStatus;
  final Value<String?> appealReason;
  final Value<double> behavioralScore;
  final Value<double> networkScore;
  final Value<double> contentScore;
  final Value<double> compositeScore;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const ModerationQueueCacheCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.reason = const Value.absent(),
    this.riskLevel = const Value.absent(),
    this.botProbability = const Value.absent(),
    this.trustScore = const Value.absent(),
    this.reportCount = const Value.absent(),
    this.reporterIds = const Value.absent(),
    this.contentSampleIds = const Value.absent(),
    this.evidenceUrls = const Value.absent(),
    this.lastAction = const Value.absent(),
    this.moderatorNote = const Value.absent(),
    this.isAppealed = const Value.absent(),
    this.appealStatus = const Value.absent(),
    this.appealReason = const Value.absent(),
    this.behavioralScore = const Value.absent(),
    this.networkScore = const Value.absent(),
    this.contentScore = const Value.absent(),
    this.compositeScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModerationQueueCacheCompanion.insert({
    required String id,
    required String userId,
    required String username,
    required String displayName,
    this.avatarUrl = const Value.absent(),
    required String reason,
    required String riskLevel,
    required double botProbability,
    required double trustScore,
    required int reportCount,
    required String reporterIds,
    required String contentSampleIds,
    required String evidenceUrls,
    this.lastAction = const Value.absent(),
    this.moderatorNote = const Value.absent(),
    required bool isAppealed,
    this.appealStatus = const Value.absent(),
    this.appealReason = const Value.absent(),
    required double behavioralScore,
    required double networkScore,
    required double contentScore,
    required double compositeScore,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        username = Value(username),
        displayName = Value(displayName),
        reason = Value(reason),
        riskLevel = Value(riskLevel),
        botProbability = Value(botProbability),
        trustScore = Value(trustScore),
        reportCount = Value(reportCount),
        reporterIds = Value(reporterIds),
        contentSampleIds = Value(contentSampleIds),
        evidenceUrls = Value(evidenceUrls),
        isAppealed = Value(isAppealed),
        behavioralScore = Value(behavioralScore),
        networkScore = Value(networkScore),
        contentScore = Value(contentScore),
        compositeScore = Value(compositeScore),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ModerationQueueCacheData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? avatarUrl,
    Expression<String>? reason,
    Expression<String>? riskLevel,
    Expression<double>? botProbability,
    Expression<double>? trustScore,
    Expression<int>? reportCount,
    Expression<String>? reporterIds,
    Expression<String>? contentSampleIds,
    Expression<String>? evidenceUrls,
    Expression<String>? lastAction,
    Expression<String>? moderatorNote,
    Expression<bool>? isAppealed,
    Expression<String>? appealStatus,
    Expression<String>? appealReason,
    Expression<double>? behavioralScore,
    Expression<double>? networkScore,
    Expression<double>? contentScore,
    Expression<double>? compositeScore,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (reason != null) 'reason': reason,
      if (riskLevel != null) 'risk_level': riskLevel,
      if (botProbability != null) 'bot_probability': botProbability,
      if (trustScore != null) 'trust_score': trustScore,
      if (reportCount != null) 'report_count': reportCount,
      if (reporterIds != null) 'reporter_ids': reporterIds,
      if (contentSampleIds != null) 'content_sample_ids': contentSampleIds,
      if (evidenceUrls != null) 'evidence_urls': evidenceUrls,
      if (lastAction != null) 'last_action': lastAction,
      if (moderatorNote != null) 'moderator_note': moderatorNote,
      if (isAppealed != null) 'is_appealed': isAppealed,
      if (appealStatus != null) 'appeal_status': appealStatus,
      if (appealReason != null) 'appeal_reason': appealReason,
      if (behavioralScore != null) 'behavioral_score': behavioralScore,
      if (networkScore != null) 'network_score': networkScore,
      if (contentScore != null) 'content_score': contentScore,
      if (compositeScore != null) 'composite_score': compositeScore,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModerationQueueCacheCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? username,
      Value<String>? displayName,
      Value<String?>? avatarUrl,
      Value<String>? reason,
      Value<String>? riskLevel,
      Value<double>? botProbability,
      Value<double>? trustScore,
      Value<int>? reportCount,
      Value<String>? reporterIds,
      Value<String>? contentSampleIds,
      Value<String>? evidenceUrls,
      Value<String?>? lastAction,
      Value<String?>? moderatorNote,
      Value<bool>? isAppealed,
      Value<String?>? appealStatus,
      Value<String?>? appealReason,
      Value<double>? behavioralScore,
      Value<double>? networkScore,
      Value<double>? contentScore,
      Value<double>? compositeScore,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return ModerationQueueCacheCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      reason: reason ?? this.reason,
      riskLevel: riskLevel ?? this.riskLevel,
      botProbability: botProbability ?? this.botProbability,
      trustScore: trustScore ?? this.trustScore,
      reportCount: reportCount ?? this.reportCount,
      reporterIds: reporterIds ?? this.reporterIds,
      contentSampleIds: contentSampleIds ?? this.contentSampleIds,
      evidenceUrls: evidenceUrls ?? this.evidenceUrls,
      lastAction: lastAction ?? this.lastAction,
      moderatorNote: moderatorNote ?? this.moderatorNote,
      isAppealed: isAppealed ?? this.isAppealed,
      appealStatus: appealStatus ?? this.appealStatus,
      appealReason: appealReason ?? this.appealReason,
      behavioralScore: behavioralScore ?? this.behavioralScore,
      networkScore: networkScore ?? this.networkScore,
      contentScore: contentScore ?? this.contentScore,
      compositeScore: compositeScore ?? this.compositeScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (riskLevel.present) {
      map['risk_level'] = Variable<String>(riskLevel.value);
    }
    if (botProbability.present) {
      map['bot_probability'] = Variable<double>(botProbability.value);
    }
    if (trustScore.present) {
      map['trust_score'] = Variable<double>(trustScore.value);
    }
    if (reportCount.present) {
      map['report_count'] = Variable<int>(reportCount.value);
    }
    if (reporterIds.present) {
      map['reporter_ids'] = Variable<String>(reporterIds.value);
    }
    if (contentSampleIds.present) {
      map['content_sample_ids'] = Variable<String>(contentSampleIds.value);
    }
    if (evidenceUrls.present) {
      map['evidence_urls'] = Variable<String>(evidenceUrls.value);
    }
    if (lastAction.present) {
      map['last_action'] = Variable<String>(lastAction.value);
    }
    if (moderatorNote.present) {
      map['moderator_note'] = Variable<String>(moderatorNote.value);
    }
    if (isAppealed.present) {
      map['is_appealed'] = Variable<bool>(isAppealed.value);
    }
    if (appealStatus.present) {
      map['appeal_status'] = Variable<String>(appealStatus.value);
    }
    if (appealReason.present) {
      map['appeal_reason'] = Variable<String>(appealReason.value);
    }
    if (behavioralScore.present) {
      map['behavioral_score'] = Variable<double>(behavioralScore.value);
    }
    if (networkScore.present) {
      map['network_score'] = Variable<double>(networkScore.value);
    }
    if (contentScore.present) {
      map['content_score'] = Variable<double>(contentScore.value);
    }
    if (compositeScore.present) {
      map['composite_score'] = Variable<double>(compositeScore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModerationQueueCacheCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('reason: $reason, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('botProbability: $botProbability, ')
          ..write('trustScore: $trustScore, ')
          ..write('reportCount: $reportCount, ')
          ..write('reporterIds: $reporterIds, ')
          ..write('contentSampleIds: $contentSampleIds, ')
          ..write('evidenceUrls: $evidenceUrls, ')
          ..write('lastAction: $lastAction, ')
          ..write('moderatorNote: $moderatorNote, ')
          ..write('isAppealed: $isAppealed, ')
          ..write('appealStatus: $appealStatus, ')
          ..write('appealReason: $appealReason, ')
          ..write('behavioralScore: $behavioralScore, ')
          ..write('networkScore: $networkScore, ')
          ..write('contentScore: $contentScore, ')
          ..write('compositeScore: $compositeScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModerationActionLogTable extends ModerationActionLog
    with TableInfo<$ModerationActionLogTable, ModerationActionLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModerationActionLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionTypeMeta =
      const VerificationMeta('actionType');
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
      'action_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moderatorIdMeta =
      const VerificationMeta('moderatorId');
  @override
  late final GeneratedColumn<String> moderatorId = GeneratedColumn<String>(
      'moderator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moderatorNoteMeta =
      const VerificationMeta('moderatorNote');
  @override
  late final GeneratedColumn<String> moderatorNote = GeneratedColumn<String>(
      'moderator_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _performedAtMeta =
      const VerificationMeta('performedAt');
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
      'performed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        actionType,
        moderatorId,
        moderatorNote,
        metadata,
        performedAt,
        isSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moderation_action_log';
  @override
  VerificationContext validateIntegrity(
      Insertable<ModerationActionLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
          _actionTypeMeta,
          actionType.isAcceptableOrUnknown(
              data['action_type']!, _actionTypeMeta));
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('moderator_id')) {
      context.handle(
          _moderatorIdMeta,
          moderatorId.isAcceptableOrUnknown(
              data['moderator_id']!, _moderatorIdMeta));
    } else if (isInserting) {
      context.missing(_moderatorIdMeta);
    }
    if (data.containsKey('moderator_note')) {
      context.handle(
          _moderatorNoteMeta,
          moderatorNote.isAcceptableOrUnknown(
              data['moderator_note']!, _moderatorNoteMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('performed_at')) {
      context.handle(
          _performedAtMeta,
          performedAt.isAcceptableOrUnknown(
              data['performed_at']!, _performedAtMeta));
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {id},
      ];
  @override
  ModerationActionLogData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModerationActionLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      actionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_type'])!,
      moderatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}moderator_id'])!,
      moderatorNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}moderator_note']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      performedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}performed_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $ModerationActionLogTable createAlias(String alias) {
    return $ModerationActionLogTable(attachedDatabase, alias);
  }
}

class ModerationActionLogData extends DataClass
    implements Insertable<ModerationActionLogData> {
  final String id;
  final String userId;
  final String actionType;
  final String moderatorId;
  final String? moderatorNote;
  final String? metadata;
  final DateTime performedAt;
  final bool isSynced;
  const ModerationActionLogData(
      {required this.id,
      required this.userId,
      required this.actionType,
      required this.moderatorId,
      this.moderatorNote,
      this.metadata,
      required this.performedAt,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['action_type'] = Variable<String>(actionType);
    map['moderator_id'] = Variable<String>(moderatorId);
    if (!nullToAbsent || moderatorNote != null) {
      map['moderator_note'] = Variable<String>(moderatorNote);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['performed_at'] = Variable<DateTime>(performedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ModerationActionLogCompanion toCompanion(bool nullToAbsent) {
    return ModerationActionLogCompanion(
      id: Value(id),
      userId: Value(userId),
      actionType: Value(actionType),
      moderatorId: Value(moderatorId),
      moderatorNote: moderatorNote == null && nullToAbsent
          ? const Value.absent()
          : Value(moderatorNote),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      performedAt: Value(performedAt),
      isSynced: Value(isSynced),
    );
  }

  factory ModerationActionLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModerationActionLogData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      moderatorId: serializer.fromJson<String>(json['moderatorId']),
      moderatorNote: serializer.fromJson<String?>(json['moderatorNote']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'actionType': serializer.toJson<String>(actionType),
      'moderatorId': serializer.toJson<String>(moderatorId),
      'moderatorNote': serializer.toJson<String?>(moderatorNote),
      'metadata': serializer.toJson<String?>(metadata),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ModerationActionLogData copyWith(
          {String? id,
          String? userId,
          String? actionType,
          String? moderatorId,
          Value<String?> moderatorNote = const Value.absent(),
          Value<String?> metadata = const Value.absent(),
          DateTime? performedAt,
          bool? isSynced}) =>
      ModerationActionLogData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        actionType: actionType ?? this.actionType,
        moderatorId: moderatorId ?? this.moderatorId,
        moderatorNote:
            moderatorNote.present ? moderatorNote.value : this.moderatorNote,
        metadata: metadata.present ? metadata.value : this.metadata,
        performedAt: performedAt ?? this.performedAt,
        isSynced: isSynced ?? this.isSynced,
      );
  ModerationActionLogData copyWithCompanion(ModerationActionLogCompanion data) {
    return ModerationActionLogData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      actionType:
          data.actionType.present ? data.actionType.value : this.actionType,
      moderatorId:
          data.moderatorId.present ? data.moderatorId.value : this.moderatorId,
      moderatorNote: data.moderatorNote.present
          ? data.moderatorNote.value
          : this.moderatorNote,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      performedAt:
          data.performedAt.present ? data.performedAt.value : this.performedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModerationActionLogData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('actionType: $actionType, ')
          ..write('moderatorId: $moderatorId, ')
          ..write('moderatorNote: $moderatorNote, ')
          ..write('metadata: $metadata, ')
          ..write('performedAt: $performedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, actionType, moderatorId,
      moderatorNote, metadata, performedAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModerationActionLogData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.actionType == this.actionType &&
          other.moderatorId == this.moderatorId &&
          other.moderatorNote == this.moderatorNote &&
          other.metadata == this.metadata &&
          other.performedAt == this.performedAt &&
          other.isSynced == this.isSynced);
}

class ModerationActionLogCompanion
    extends UpdateCompanion<ModerationActionLogData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> actionType;
  final Value<String> moderatorId;
  final Value<String?> moderatorNote;
  final Value<String?> metadata;
  final Value<DateTime> performedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const ModerationActionLogCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.moderatorId = const Value.absent(),
    this.moderatorNote = const Value.absent(),
    this.metadata = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModerationActionLogCompanion.insert({
    required String id,
    required String userId,
    required String actionType,
    required String moderatorId,
    this.moderatorNote = const Value.absent(),
    this.metadata = const Value.absent(),
    required DateTime performedAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        actionType = Value(actionType),
        moderatorId = Value(moderatorId),
        performedAt = Value(performedAt);
  static Insertable<ModerationActionLogData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? actionType,
    Expression<String>? moderatorId,
    Expression<String>? moderatorNote,
    Expression<String>? metadata,
    Expression<DateTime>? performedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (actionType != null) 'action_type': actionType,
      if (moderatorId != null) 'moderator_id': moderatorId,
      if (moderatorNote != null) 'moderator_note': moderatorNote,
      if (metadata != null) 'metadata': metadata,
      if (performedAt != null) 'performed_at': performedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModerationActionLogCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? actionType,
      Value<String>? moderatorId,
      Value<String?>? moderatorNote,
      Value<String?>? metadata,
      Value<DateTime>? performedAt,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return ModerationActionLogCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      actionType: actionType ?? this.actionType,
      moderatorId: moderatorId ?? this.moderatorId,
      moderatorNote: moderatorNote ?? this.moderatorNote,
      metadata: metadata ?? this.metadata,
      performedAt: performedAt ?? this.performedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (moderatorId.present) {
      map['moderator_id'] = Variable<String>(moderatorId.value);
    }
    if (moderatorNote.present) {
      map['moderator_note'] = Variable<String>(moderatorNote.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModerationActionLogCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('actionType: $actionType, ')
          ..write('moderatorId: $moderatorId, ')
          ..write('moderatorNote: $moderatorNote, ')
          ..write('metadata: $metadata, ')
          ..write('performedAt: $performedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModerationSavedFilterTable extends ModerationSavedFilter
    with TableInfo<$ModerationSavedFilterTable, ModerationSavedFilterData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModerationSavedFilterTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _riskLevelsMeta =
      const VerificationMeta('riskLevels');
  @override
  late final GeneratedColumn<String> riskLevels = GeneratedColumn<String>(
      'risk_levels', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonsMeta =
      const VerificationMeta('reasons');
  @override
  late final GeneratedColumn<String> reasons = GeneratedColumn<String>(
      'reasons', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateRangeMeta =
      const VerificationMeta('dateRange');
  @override
  late final GeneratedColumn<String> dateRange = GeneratedColumn<String>(
      'date_range', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _searchQueryMeta =
      const VerificationMeta('searchQuery');
  @override
  late final GeneratedColumn<String> searchQuery = GeneratedColumn<String>(
      'search_query', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, riskLevels, reasons, dateRange, searchQuery, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moderation_saved_filter';
  @override
  VerificationContext validateIntegrity(
      Insertable<ModerationSavedFilterData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('risk_levels')) {
      context.handle(
          _riskLevelsMeta,
          riskLevels.isAcceptableOrUnknown(
              data['risk_levels']!, _riskLevelsMeta));
    } else if (isInserting) {
      context.missing(_riskLevelsMeta);
    }
    if (data.containsKey('reasons')) {
      context.handle(_reasonsMeta,
          reasons.isAcceptableOrUnknown(data['reasons']!, _reasonsMeta));
    } else if (isInserting) {
      context.missing(_reasonsMeta);
    }
    if (data.containsKey('date_range')) {
      context.handle(_dateRangeMeta,
          dateRange.isAcceptableOrUnknown(data['date_range']!, _dateRangeMeta));
    }
    if (data.containsKey('search_query')) {
      context.handle(
          _searchQueryMeta,
          searchQuery.isAcceptableOrUnknown(
              data['search_query']!, _searchQueryMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {id},
      ];
  @override
  ModerationSavedFilterData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModerationSavedFilterData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      riskLevels: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}risk_levels'])!,
      reasons: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reasons'])!,
      dateRange: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_range']),
      searchQuery: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}search_query']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ModerationSavedFilterTable createAlias(String alias) {
    return $ModerationSavedFilterTable(attachedDatabase, alias);
  }
}

class ModerationSavedFilterData extends DataClass
    implements Insertable<ModerationSavedFilterData> {
  final String id;
  final String name;
  final String riskLevels;
  final String reasons;
  final String? dateRange;
  final String? searchQuery;
  final DateTime createdAt;
  const ModerationSavedFilterData(
      {required this.id,
      required this.name,
      required this.riskLevels,
      required this.reasons,
      this.dateRange,
      this.searchQuery,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['risk_levels'] = Variable<String>(riskLevels);
    map['reasons'] = Variable<String>(reasons);
    if (!nullToAbsent || dateRange != null) {
      map['date_range'] = Variable<String>(dateRange);
    }
    if (!nullToAbsent || searchQuery != null) {
      map['search_query'] = Variable<String>(searchQuery);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ModerationSavedFilterCompanion toCompanion(bool nullToAbsent) {
    return ModerationSavedFilterCompanion(
      id: Value(id),
      name: Value(name),
      riskLevels: Value(riskLevels),
      reasons: Value(reasons),
      dateRange: dateRange == null && nullToAbsent
          ? const Value.absent()
          : Value(dateRange),
      searchQuery: searchQuery == null && nullToAbsent
          ? const Value.absent()
          : Value(searchQuery),
      createdAt: Value(createdAt),
    );
  }

  factory ModerationSavedFilterData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModerationSavedFilterData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      riskLevels: serializer.fromJson<String>(json['riskLevels']),
      reasons: serializer.fromJson<String>(json['reasons']),
      dateRange: serializer.fromJson<String?>(json['dateRange']),
      searchQuery: serializer.fromJson<String?>(json['searchQuery']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'riskLevels': serializer.toJson<String>(riskLevels),
      'reasons': serializer.toJson<String>(reasons),
      'dateRange': serializer.toJson<String?>(dateRange),
      'searchQuery': serializer.toJson<String?>(searchQuery),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ModerationSavedFilterData copyWith(
          {String? id,
          String? name,
          String? riskLevels,
          String? reasons,
          Value<String?> dateRange = const Value.absent(),
          Value<String?> searchQuery = const Value.absent(),
          DateTime? createdAt}) =>
      ModerationSavedFilterData(
        id: id ?? this.id,
        name: name ?? this.name,
        riskLevels: riskLevels ?? this.riskLevels,
        reasons: reasons ?? this.reasons,
        dateRange: dateRange.present ? dateRange.value : this.dateRange,
        searchQuery: searchQuery.present ? searchQuery.value : this.searchQuery,
        createdAt: createdAt ?? this.createdAt,
      );
  ModerationSavedFilterData copyWithCompanion(
      ModerationSavedFilterCompanion data) {
    return ModerationSavedFilterData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      riskLevels:
          data.riskLevels.present ? data.riskLevels.value : this.riskLevels,
      reasons: data.reasons.present ? data.reasons.value : this.reasons,
      dateRange: data.dateRange.present ? data.dateRange.value : this.dateRange,
      searchQuery:
          data.searchQuery.present ? data.searchQuery.value : this.searchQuery,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModerationSavedFilterData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('riskLevels: $riskLevels, ')
          ..write('reasons: $reasons, ')
          ..write('dateRange: $dateRange, ')
          ..write('searchQuery: $searchQuery, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, riskLevels, reasons, dateRange, searchQuery, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModerationSavedFilterData &&
          other.id == this.id &&
          other.name == this.name &&
          other.riskLevels == this.riskLevels &&
          other.reasons == this.reasons &&
          other.dateRange == this.dateRange &&
          other.searchQuery == this.searchQuery &&
          other.createdAt == this.createdAt);
}

class ModerationSavedFilterCompanion
    extends UpdateCompanion<ModerationSavedFilterData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> riskLevels;
  final Value<String> reasons;
  final Value<String?> dateRange;
  final Value<String?> searchQuery;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ModerationSavedFilterCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.riskLevels = const Value.absent(),
    this.reasons = const Value.absent(),
    this.dateRange = const Value.absent(),
    this.searchQuery = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModerationSavedFilterCompanion.insert({
    required String id,
    required String name,
    required String riskLevels,
    required String reasons,
    this.dateRange = const Value.absent(),
    this.searchQuery = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        riskLevels = Value(riskLevels),
        reasons = Value(reasons),
        createdAt = Value(createdAt);
  static Insertable<ModerationSavedFilterData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? riskLevels,
    Expression<String>? reasons,
    Expression<String>? dateRange,
    Expression<String>? searchQuery,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (riskLevels != null) 'risk_levels': riskLevels,
      if (reasons != null) 'reasons': reasons,
      if (dateRange != null) 'date_range': dateRange,
      if (searchQuery != null) 'search_query': searchQuery,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModerationSavedFilterCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? riskLevels,
      Value<String>? reasons,
      Value<String?>? dateRange,
      Value<String?>? searchQuery,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ModerationSavedFilterCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      riskLevels: riskLevels ?? this.riskLevels,
      reasons: reasons ?? this.reasons,
      dateRange: dateRange ?? this.dateRange,
      searchQuery: searchQuery ?? this.searchQuery,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (riskLevels.present) {
      map['risk_levels'] = Variable<String>(riskLevels.value);
    }
    if (reasons.present) {
      map['reasons'] = Variable<String>(reasons.value);
    }
    if (dateRange.present) {
      map['date_range'] = Variable<String>(dateRange.value);
    }
    if (searchQuery.present) {
      map['search_query'] = Variable<String>(searchQuery.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModerationSavedFilterCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('riskLevels: $riskLevels, ')
          ..write('reasons: $reasons, ')
          ..write('dateRange: $dateRange, ')
          ..write('searchQuery: $searchQuery, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ModerationDatabase extends GeneratedDatabase {
  _$ModerationDatabase(QueryExecutor e) : super(e);
  $ModerationDatabaseManager get managers => $ModerationDatabaseManager(this);
  late final $ModerationQueueCacheTable moderationQueueCache =
      $ModerationQueueCacheTable(this);
  late final $ModerationActionLogTable moderationActionLog =
      $ModerationActionLogTable(this);
  late final $ModerationSavedFilterTable moderationSavedFilter =
      $ModerationSavedFilterTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [moderationQueueCache, moderationActionLog, moderationSavedFilter];
}

typedef $$ModerationQueueCacheTableCreateCompanionBuilder
    = ModerationQueueCacheCompanion Function({
  required String id,
  required String userId,
  required String username,
  required String displayName,
  Value<String?> avatarUrl,
  required String reason,
  required String riskLevel,
  required double botProbability,
  required double trustScore,
  required int reportCount,
  required String reporterIds,
  required String contentSampleIds,
  required String evidenceUrls,
  Value<String?> lastAction,
  Value<String?> moderatorNote,
  required bool isAppealed,
  Value<String?> appealStatus,
  Value<String?> appealReason,
  required double behavioralScore,
  required double networkScore,
  required double contentScore,
  required double compositeScore,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$ModerationQueueCacheTableUpdateCompanionBuilder
    = ModerationQueueCacheCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> username,
  Value<String> displayName,
  Value<String?> avatarUrl,
  Value<String> reason,
  Value<String> riskLevel,
  Value<double> botProbability,
  Value<double> trustScore,
  Value<int> reportCount,
  Value<String> reporterIds,
  Value<String> contentSampleIds,
  Value<String> evidenceUrls,
  Value<String?> lastAction,
  Value<String?> moderatorNote,
  Value<bool> isAppealed,
  Value<String?> appealStatus,
  Value<String?> appealReason,
  Value<double> behavioralScore,
  Value<double> networkScore,
  Value<double> contentScore,
  Value<double> compositeScore,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isSynced,
  Value<int> rowid,
});

class $$ModerationQueueCacheTableTableManager extends RootTableManager<
    _$ModerationDatabase,
    $ModerationQueueCacheTable,
    ModerationQueueCacheData,
    $$ModerationQueueCacheTableFilterComposer,
    $$ModerationQueueCacheTableOrderingComposer,
    $$ModerationQueueCacheTableCreateCompanionBuilder,
    $$ModerationQueueCacheTableUpdateCompanionBuilder> {
  $$ModerationQueueCacheTableTableManager(
      _$ModerationDatabase db, $ModerationQueueCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ModerationQueueCacheTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$ModerationQueueCacheTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String> riskLevel = const Value.absent(),
            Value<double> botProbability = const Value.absent(),
            Value<double> trustScore = const Value.absent(),
            Value<int> reportCount = const Value.absent(),
            Value<String> reporterIds = const Value.absent(),
            Value<String> contentSampleIds = const Value.absent(),
            Value<String> evidenceUrls = const Value.absent(),
            Value<String?> lastAction = const Value.absent(),
            Value<String?> moderatorNote = const Value.absent(),
            Value<bool> isAppealed = const Value.absent(),
            Value<String?> appealStatus = const Value.absent(),
            Value<String?> appealReason = const Value.absent(),
            Value<double> behavioralScore = const Value.absent(),
            Value<double> networkScore = const Value.absent(),
            Value<double> contentScore = const Value.absent(),
            Value<double> compositeScore = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationQueueCacheCompanion(
            id: id,
            userId: userId,
            username: username,
            displayName: displayName,
            avatarUrl: avatarUrl,
            reason: reason,
            riskLevel: riskLevel,
            botProbability: botProbability,
            trustScore: trustScore,
            reportCount: reportCount,
            reporterIds: reporterIds,
            contentSampleIds: contentSampleIds,
            evidenceUrls: evidenceUrls,
            lastAction: lastAction,
            moderatorNote: moderatorNote,
            isAppealed: isAppealed,
            appealStatus: appealStatus,
            appealReason: appealReason,
            behavioralScore: behavioralScore,
            networkScore: networkScore,
            contentScore: contentScore,
            compositeScore: compositeScore,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String username,
            required String displayName,
            Value<String?> avatarUrl = const Value.absent(),
            required String reason,
            required String riskLevel,
            required double botProbability,
            required double trustScore,
            required int reportCount,
            required String reporterIds,
            required String contentSampleIds,
            required String evidenceUrls,
            Value<String?> lastAction = const Value.absent(),
            Value<String?> moderatorNote = const Value.absent(),
            required bool isAppealed,
            Value<String?> appealStatus = const Value.absent(),
            Value<String?> appealReason = const Value.absent(),
            required double behavioralScore,
            required double networkScore,
            required double contentScore,
            required double compositeScore,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationQueueCacheCompanion.insert(
            id: id,
            userId: userId,
            username: username,
            displayName: displayName,
            avatarUrl: avatarUrl,
            reason: reason,
            riskLevel: riskLevel,
            botProbability: botProbability,
            trustScore: trustScore,
            reportCount: reportCount,
            reporterIds: reporterIds,
            contentSampleIds: contentSampleIds,
            evidenceUrls: evidenceUrls,
            lastAction: lastAction,
            moderatorNote: moderatorNote,
            isAppealed: isAppealed,
            appealStatus: appealStatus,
            appealReason: appealReason,
            behavioralScore: behavioralScore,
            networkScore: networkScore,
            contentScore: contentScore,
            compositeScore: compositeScore,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            rowid: rowid,
          ),
        ));
}

class $$ModerationQueueCacheTableFilterComposer
    extends FilterComposer<_$ModerationDatabase, $ModerationQueueCacheTable> {
  $$ModerationQueueCacheTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get displayName => $state.composableBuilder(
      column: $state.table.displayName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get avatarUrl => $state.composableBuilder(
      column: $state.table.avatarUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get riskLevel => $state.composableBuilder(
      column: $state.table.riskLevel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get botProbability => $state.composableBuilder(
      column: $state.table.botProbability,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get trustScore => $state.composableBuilder(
      column: $state.table.trustScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reportCount => $state.composableBuilder(
      column: $state.table.reportCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reporterIds => $state.composableBuilder(
      column: $state.table.reporterIds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get contentSampleIds => $state.composableBuilder(
      column: $state.table.contentSampleIds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get evidenceUrls => $state.composableBuilder(
      column: $state.table.evidenceUrls,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lastAction => $state.composableBuilder(
      column: $state.table.lastAction,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get moderatorNote => $state.composableBuilder(
      column: $state.table.moderatorNote,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isAppealed => $state.composableBuilder(
      column: $state.table.isAppealed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get appealStatus => $state.composableBuilder(
      column: $state.table.appealStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get appealReason => $state.composableBuilder(
      column: $state.table.appealReason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get behavioralScore => $state.composableBuilder(
      column: $state.table.behavioralScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get networkScore => $state.composableBuilder(
      column: $state.table.networkScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get contentScore => $state.composableBuilder(
      column: $state.table.contentScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get compositeScore => $state.composableBuilder(
      column: $state.table.compositeScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isSynced => $state.composableBuilder(
      column: $state.table.isSynced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ModerationQueueCacheTableOrderingComposer
    extends OrderingComposer<_$ModerationDatabase, $ModerationQueueCacheTable> {
  $$ModerationQueueCacheTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get displayName => $state.composableBuilder(
      column: $state.table.displayName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get avatarUrl => $state.composableBuilder(
      column: $state.table.avatarUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reason => $state.composableBuilder(
      column: $state.table.reason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get riskLevel => $state.composableBuilder(
      column: $state.table.riskLevel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get botProbability => $state.composableBuilder(
      column: $state.table.botProbability,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get trustScore => $state.composableBuilder(
      column: $state.table.trustScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reportCount => $state.composableBuilder(
      column: $state.table.reportCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reporterIds => $state.composableBuilder(
      column: $state.table.reporterIds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contentSampleIds => $state.composableBuilder(
      column: $state.table.contentSampleIds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get evidenceUrls => $state.composableBuilder(
      column: $state.table.evidenceUrls,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lastAction => $state.composableBuilder(
      column: $state.table.lastAction,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get moderatorNote => $state.composableBuilder(
      column: $state.table.moderatorNote,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isAppealed => $state.composableBuilder(
      column: $state.table.isAppealed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get appealStatus => $state.composableBuilder(
      column: $state.table.appealStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get appealReason => $state.composableBuilder(
      column: $state.table.appealReason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get behavioralScore => $state.composableBuilder(
      column: $state.table.behavioralScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get networkScore => $state.composableBuilder(
      column: $state.table.networkScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get contentScore => $state.composableBuilder(
      column: $state.table.contentScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get compositeScore => $state.composableBuilder(
      column: $state.table.compositeScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isSynced => $state.composableBuilder(
      column: $state.table.isSynced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ModerationActionLogTableCreateCompanionBuilder
    = ModerationActionLogCompanion Function({
  required String id,
  required String userId,
  required String actionType,
  required String moderatorId,
  Value<String?> moderatorNote,
  Value<String?> metadata,
  required DateTime performedAt,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$ModerationActionLogTableUpdateCompanionBuilder
    = ModerationActionLogCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> actionType,
  Value<String> moderatorId,
  Value<String?> moderatorNote,
  Value<String?> metadata,
  Value<DateTime> performedAt,
  Value<bool> isSynced,
  Value<int> rowid,
});

class $$ModerationActionLogTableTableManager extends RootTableManager<
    _$ModerationDatabase,
    $ModerationActionLogTable,
    ModerationActionLogData,
    $$ModerationActionLogTableFilterComposer,
    $$ModerationActionLogTableOrderingComposer,
    $$ModerationActionLogTableCreateCompanionBuilder,
    $$ModerationActionLogTableUpdateCompanionBuilder> {
  $$ModerationActionLogTableTableManager(
      _$ModerationDatabase db, $ModerationActionLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ModerationActionLogTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$ModerationActionLogTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> actionType = const Value.absent(),
            Value<String> moderatorId = const Value.absent(),
            Value<String?> moderatorNote = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> performedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationActionLogCompanion(
            id: id,
            userId: userId,
            actionType: actionType,
            moderatorId: moderatorId,
            moderatorNote: moderatorNote,
            metadata: metadata,
            performedAt: performedAt,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String actionType,
            required String moderatorId,
            Value<String?> moderatorNote = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            required DateTime performedAt,
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationActionLogCompanion.insert(
            id: id,
            userId: userId,
            actionType: actionType,
            moderatorId: moderatorId,
            moderatorNote: moderatorNote,
            metadata: metadata,
            performedAt: performedAt,
            isSynced: isSynced,
            rowid: rowid,
          ),
        ));
}

class $$ModerationActionLogTableFilterComposer
    extends FilterComposer<_$ModerationDatabase, $ModerationActionLogTable> {
  $$ModerationActionLogTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get actionType => $state.composableBuilder(
      column: $state.table.actionType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get moderatorId => $state.composableBuilder(
      column: $state.table.moderatorId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get moderatorNote => $state.composableBuilder(
      column: $state.table.moderatorNote,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get metadata => $state.composableBuilder(
      column: $state.table.metadata,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get performedAt => $state.composableBuilder(
      column: $state.table.performedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isSynced => $state.composableBuilder(
      column: $state.table.isSynced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ModerationActionLogTableOrderingComposer
    extends OrderingComposer<_$ModerationDatabase, $ModerationActionLogTable> {
  $$ModerationActionLogTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get actionType => $state.composableBuilder(
      column: $state.table.actionType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get moderatorId => $state.composableBuilder(
      column: $state.table.moderatorId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get moderatorNote => $state.composableBuilder(
      column: $state.table.moderatorNote,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get metadata => $state.composableBuilder(
      column: $state.table.metadata,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get performedAt => $state.composableBuilder(
      column: $state.table.performedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isSynced => $state.composableBuilder(
      column: $state.table.isSynced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ModerationSavedFilterTableCreateCompanionBuilder
    = ModerationSavedFilterCompanion Function({
  required String id,
  required String name,
  required String riskLevels,
  required String reasons,
  Value<String?> dateRange,
  Value<String?> searchQuery,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ModerationSavedFilterTableUpdateCompanionBuilder
    = ModerationSavedFilterCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> riskLevels,
  Value<String> reasons,
  Value<String?> dateRange,
  Value<String?> searchQuery,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ModerationSavedFilterTableTableManager extends RootTableManager<
    _$ModerationDatabase,
    $ModerationSavedFilterTable,
    ModerationSavedFilterData,
    $$ModerationSavedFilterTableFilterComposer,
    $$ModerationSavedFilterTableOrderingComposer,
    $$ModerationSavedFilterTableCreateCompanionBuilder,
    $$ModerationSavedFilterTableUpdateCompanionBuilder> {
  $$ModerationSavedFilterTableTableManager(
      _$ModerationDatabase db, $ModerationSavedFilterTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ModerationSavedFilterTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$ModerationSavedFilterTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> riskLevels = const Value.absent(),
            Value<String> reasons = const Value.absent(),
            Value<String?> dateRange = const Value.absent(),
            Value<String?> searchQuery = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationSavedFilterCompanion(
            id: id,
            name: name,
            riskLevels: riskLevels,
            reasons: reasons,
            dateRange: dateRange,
            searchQuery: searchQuery,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String riskLevels,
            required String reasons,
            Value<String?> dateRange = const Value.absent(),
            Value<String?> searchQuery = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ModerationSavedFilterCompanion.insert(
            id: id,
            name: name,
            riskLevels: riskLevels,
            reasons: reasons,
            dateRange: dateRange,
            searchQuery: searchQuery,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$ModerationSavedFilterTableFilterComposer
    extends FilterComposer<_$ModerationDatabase, $ModerationSavedFilterTable> {
  $$ModerationSavedFilterTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get riskLevels => $state.composableBuilder(
      column: $state.table.riskLevels,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reasons => $state.composableBuilder(
      column: $state.table.reasons,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dateRange => $state.composableBuilder(
      column: $state.table.dateRange,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get searchQuery => $state.composableBuilder(
      column: $state.table.searchQuery,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ModerationSavedFilterTableOrderingComposer extends OrderingComposer<
    _$ModerationDatabase, $ModerationSavedFilterTable> {
  $$ModerationSavedFilterTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get riskLevels => $state.composableBuilder(
      column: $state.table.riskLevels,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reasons => $state.composableBuilder(
      column: $state.table.reasons,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dateRange => $state.composableBuilder(
      column: $state.table.dateRange,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get searchQuery => $state.composableBuilder(
      column: $state.table.searchQuery,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $ModerationDatabaseManager {
  final _$ModerationDatabase _db;
  $ModerationDatabaseManager(this._db);
  $$ModerationQueueCacheTableTableManager get moderationQueueCache =>
      $$ModerationQueueCacheTableTableManager(_db, _db.moderationQueueCache);
  $$ModerationActionLogTableTableManager get moderationActionLog =>
      $$ModerationActionLogTableTableManager(_db, _db.moderationActionLog);
  $$ModerationSavedFilterTableTableManager get moderationSavedFilter =>
      $$ModerationSavedFilterTableTableManager(_db, _db.moderationSavedFilter);
}
