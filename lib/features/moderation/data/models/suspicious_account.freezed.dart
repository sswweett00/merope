// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suspicious_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ModerationQueueItem _$ModerationQueueItemFromJson(Map<String, dynamic> json) {
  return _ModerationQueueItem.fromJson(json);
}

/// @nodoc
mixin _$ModerationQueueItem {
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  ModerationReason get reason => throw _privateConstructorUsedError;
  RiskLevel get riskLevel => throw _privateConstructorUsedError;
  double get botProbability => throw _privateConstructorUsedError;
  double get trustScore => throw _privateConstructorUsedError;
  int get reportCount => throw _privateConstructorUsedError;
  List<String> get reporterIds => throw _privateConstructorUsedError;
  List<String> get contentSampleIds => throw _privateConstructorUsedError;
  List<String> get evidenceUrls => throw _privateConstructorUsedError;
  LastAction? get lastAction => throw _privateConstructorUsedError;
  String? get moderatorNote => throw _privateConstructorUsedError;
  bool get isAppealed => throw _privateConstructorUsedError;
  AppealStatus? get appealStatus => throw _privateConstructorUsedError;
  String? get appealReason => throw _privateConstructorUsedError;
  double get behavioralScore => throw _privateConstructorUsedError;
  double get networkScore => throw _privateConstructorUsedError;
  double get contentScore => throw _privateConstructorUsedError;
  double get compositeScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ModerationQueueItemCopyWith<ModerationQueueItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModerationQueueItemCopyWith<$Res> {
  factory $ModerationQueueItemCopyWith(
          ModerationQueueItem value, $Res Function(ModerationQueueItem) then) =
      _$ModerationQueueItemCopyWithImpl<$Res, ModerationQueueItem>;
  @useResult
  $Res call(
      {String userId,
      String username,
      String displayName,
      String? avatarUrl,
      ModerationReason reason,
      RiskLevel riskLevel,
      double botProbability,
      double trustScore,
      int reportCount,
      List<String> reporterIds,
      List<String> contentSampleIds,
      List<String> evidenceUrls,
      LastAction? lastAction,
      String? moderatorNote,
      bool isAppealed,
      AppealStatus? appealStatus,
      String? appealReason,
      double behavioralScore,
      double networkScore,
      double contentScore,
      double compositeScore,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ModerationQueueItemCopyWithImpl<$Res, $Val extends ModerationQueueItem>
    implements $ModerationQueueItemCopyWith<$Res> {
  _$ModerationQueueItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? reason = null,
    Object? riskLevel = null,
    Object? botProbability = null,
    Object? trustScore = null,
    Object? reportCount = null,
    Object? reporterIds = null,
    Object? contentSampleIds = null,
    Object? evidenceUrls = null,
    Object? lastAction = freezed,
    Object? moderatorNote = freezed,
    Object? isAppealed = null,
    Object? appealStatus = freezed,
    Object? appealReason = freezed,
    Object? behavioralScore = null,
    Object? networkScore = null,
    Object? contentScore = null,
    Object? compositeScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as ModerationReason,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RiskLevel,
      botProbability: null == botProbability
          ? _value.botProbability
          : botProbability // ignore: cast_nullable_to_non_nullable
              as double,
      trustScore: null == trustScore
          ? _value.trustScore
          : trustScore // ignore: cast_nullable_to_non_nullable
              as double,
      reportCount: null == reportCount
          ? _value.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      reporterIds: null == reporterIds
          ? _value.reporterIds
          : reporterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contentSampleIds: null == contentSampleIds
          ? _value.contentSampleIds
          : contentSampleIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      evidenceUrls: null == evidenceUrls
          ? _value.evidenceUrls
          : evidenceUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastAction: freezed == lastAction
          ? _value.lastAction
          : lastAction // ignore: cast_nullable_to_non_nullable
              as LastAction?,
      moderatorNote: freezed == moderatorNote
          ? _value.moderatorNote
          : moderatorNote // ignore: cast_nullable_to_non_nullable
              as String?,
      isAppealed: null == isAppealed
          ? _value.isAppealed
          : isAppealed // ignore: cast_nullable_to_non_nullable
              as bool,
      appealStatus: freezed == appealStatus
          ? _value.appealStatus
          : appealStatus // ignore: cast_nullable_to_non_nullable
              as AppealStatus?,
      appealReason: freezed == appealReason
          ? _value.appealReason
          : appealReason // ignore: cast_nullable_to_non_nullable
              as String?,
      behavioralScore: null == behavioralScore
          ? _value.behavioralScore
          : behavioralScore // ignore: cast_nullable_to_non_nullable
              as double,
      networkScore: null == networkScore
          ? _value.networkScore
          : networkScore // ignore: cast_nullable_to_non_nullable
              as double,
      contentScore: null == contentScore
          ? _value.contentScore
          : contentScore // ignore: cast_nullable_to_non_nullable
              as double,
      compositeScore: null == compositeScore
          ? _value.compositeScore
          : compositeScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModerationQueueItemImplCopyWith<$Res>
    implements $ModerationQueueItemCopyWith<$Res> {
  factory _$$ModerationQueueItemImplCopyWith(_$ModerationQueueItemImpl value,
          $Res Function(_$ModerationQueueItemImpl) then) =
      __$$ModerationQueueItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String username,
      String displayName,
      String? avatarUrl,
      ModerationReason reason,
      RiskLevel riskLevel,
      double botProbability,
      double trustScore,
      int reportCount,
      List<String> reporterIds,
      List<String> contentSampleIds,
      List<String> evidenceUrls,
      LastAction? lastAction,
      String? moderatorNote,
      bool isAppealed,
      AppealStatus? appealStatus,
      String? appealReason,
      double behavioralScore,
      double networkScore,
      double contentScore,
      double compositeScore,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ModerationQueueItemImplCopyWithImpl<$Res>
    extends _$ModerationQueueItemCopyWithImpl<$Res, _$ModerationQueueItemImpl>
    implements _$$ModerationQueueItemImplCopyWith<$Res> {
  __$$ModerationQueueItemImplCopyWithImpl(_$ModerationQueueItemImpl _value,
      $Res Function(_$ModerationQueueItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? reason = null,
    Object? riskLevel = null,
    Object? botProbability = null,
    Object? trustScore = null,
    Object? reportCount = null,
    Object? reporterIds = null,
    Object? contentSampleIds = null,
    Object? evidenceUrls = null,
    Object? lastAction = freezed,
    Object? moderatorNote = freezed,
    Object? isAppealed = null,
    Object? appealStatus = freezed,
    Object? appealReason = freezed,
    Object? behavioralScore = null,
    Object? networkScore = null,
    Object? contentScore = null,
    Object? compositeScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ModerationQueueItemImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as ModerationReason,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RiskLevel,
      botProbability: null == botProbability
          ? _value.botProbability
          : botProbability // ignore: cast_nullable_to_non_nullable
              as double,
      trustScore: null == trustScore
          ? _value.trustScore
          : trustScore // ignore: cast_nullable_to_non_nullable
              as double,
      reportCount: null == reportCount
          ? _value.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      reporterIds: null == reporterIds
          ? _value._reporterIds
          : reporterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contentSampleIds: null == contentSampleIds
          ? _value._contentSampleIds
          : contentSampleIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      evidenceUrls: null == evidenceUrls
          ? _value._evidenceUrls
          : evidenceUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastAction: freezed == lastAction
          ? _value.lastAction
          : lastAction // ignore: cast_nullable_to_non_nullable
              as LastAction?,
      moderatorNote: freezed == moderatorNote
          ? _value.moderatorNote
          : moderatorNote // ignore: cast_nullable_to_non_nullable
              as String?,
      isAppealed: null == isAppealed
          ? _value.isAppealed
          : isAppealed // ignore: cast_nullable_to_non_nullable
              as bool,
      appealStatus: freezed == appealStatus
          ? _value.appealStatus
          : appealStatus // ignore: cast_nullable_to_non_nullable
              as AppealStatus?,
      appealReason: freezed == appealReason
          ? _value.appealReason
          : appealReason // ignore: cast_nullable_to_non_nullable
              as String?,
      behavioralScore: null == behavioralScore
          ? _value.behavioralScore
          : behavioralScore // ignore: cast_nullable_to_non_nullable
              as double,
      networkScore: null == networkScore
          ? _value.networkScore
          : networkScore // ignore: cast_nullable_to_non_nullable
              as double,
      contentScore: null == contentScore
          ? _value.contentScore
          : contentScore // ignore: cast_nullable_to_non_nullable
              as double,
      compositeScore: null == compositeScore
          ? _value.compositeScore
          : compositeScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModerationQueueItemImpl implements _ModerationQueueItem {
  const _$ModerationQueueItemImpl(
      {required this.userId,
      required this.username,
      required this.displayName,
      this.avatarUrl,
      required this.reason,
      required this.riskLevel,
      this.botProbability = 0.0,
      this.trustScore = 0.0,
      this.reportCount = 0,
      final List<String> reporterIds = const [],
      final List<String> contentSampleIds = const [],
      final List<String> evidenceUrls = const [],
      this.lastAction,
      this.moderatorNote,
      this.isAppealed = false,
      this.appealStatus,
      this.appealReason,
      this.behavioralScore = 0.0,
      this.networkScore = 0.0,
      this.contentScore = 0.0,
      this.compositeScore = 0.0,
      required this.createdAt,
      required this.updatedAt})
      : _reporterIds = reporterIds,
        _contentSampleIds = contentSampleIds,
        _evidenceUrls = evidenceUrls;

  factory _$ModerationQueueItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModerationQueueItemImplFromJson(json);

  @override
  final String userId;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final ModerationReason reason;
  @override
  final RiskLevel riskLevel;
  @override
  @JsonKey()
  final double botProbability;
  @override
  @JsonKey()
  final double trustScore;
  @override
  @JsonKey()
  final int reportCount;
  final List<String> _reporterIds;
  @override
  @JsonKey()
  List<String> get reporterIds {
    if (_reporterIds is EqualUnmodifiableListView) return _reporterIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reporterIds);
  }

  final List<String> _contentSampleIds;
  @override
  @JsonKey()
  List<String> get contentSampleIds {
    if (_contentSampleIds is EqualUnmodifiableListView)
      return _contentSampleIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contentSampleIds);
  }

  final List<String> _evidenceUrls;
  @override
  @JsonKey()
  List<String> get evidenceUrls {
    if (_evidenceUrls is EqualUnmodifiableListView) return _evidenceUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidenceUrls);
  }

  @override
  final LastAction? lastAction;
  @override
  final String? moderatorNote;
  @override
  @JsonKey()
  final bool isAppealed;
  @override
  final AppealStatus? appealStatus;
  @override
  final String? appealReason;
  @override
  @JsonKey()
  final double behavioralScore;
  @override
  @JsonKey()
  final double networkScore;
  @override
  @JsonKey()
  final double contentScore;
  @override
  @JsonKey()
  final double compositeScore;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ModerationQueueItem(userId: $userId, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, reason: $reason, riskLevel: $riskLevel, botProbability: $botProbability, trustScore: $trustScore, reportCount: $reportCount, reporterIds: $reporterIds, contentSampleIds: $contentSampleIds, evidenceUrls: $evidenceUrls, lastAction: $lastAction, moderatorNote: $moderatorNote, isAppealed: $isAppealed, appealStatus: $appealStatus, appealReason: $appealReason, behavioralScore: $behavioralScore, networkScore: $networkScore, contentScore: $contentScore, compositeScore: $compositeScore, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModerationQueueItemImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.botProbability, botProbability) ||
                other.botProbability == botProbability) &&
            (identical(other.trustScore, trustScore) ||
                other.trustScore == trustScore) &&
            (identical(other.reportCount, reportCount) ||
                other.reportCount == reportCount) &&
            const DeepCollectionEquality()
                .equals(other._reporterIds, _reporterIds) &&
            const DeepCollectionEquality()
                .equals(other._contentSampleIds, _contentSampleIds) &&
            const DeepCollectionEquality()
                .equals(other._evidenceUrls, _evidenceUrls) &&
            (identical(other.lastAction, lastAction) ||
                other.lastAction == lastAction) &&
            (identical(other.moderatorNote, moderatorNote) ||
                other.moderatorNote == moderatorNote) &&
            (identical(other.isAppealed, isAppealed) ||
                other.isAppealed == isAppealed) &&
            (identical(other.appealStatus, appealStatus) ||
                other.appealStatus == appealStatus) &&
            (identical(other.appealReason, appealReason) ||
                other.appealReason == appealReason) &&
            (identical(other.behavioralScore, behavioralScore) ||
                other.behavioralScore == behavioralScore) &&
            (identical(other.networkScore, networkScore) ||
                other.networkScore == networkScore) &&
            (identical(other.contentScore, contentScore) ||
                other.contentScore == contentScore) &&
            (identical(other.compositeScore, compositeScore) ||
                other.compositeScore == compositeScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        username,
        displayName,
        avatarUrl,
        reason,
        riskLevel,
        botProbability,
        trustScore,
        reportCount,
        const DeepCollectionEquality().hash(_reporterIds),
        const DeepCollectionEquality().hash(_contentSampleIds),
        const DeepCollectionEquality().hash(_evidenceUrls),
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
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModerationQueueItemImplCopyWith<_$ModerationQueueItemImpl> get copyWith =>
      __$$ModerationQueueItemImplCopyWithImpl<_$ModerationQueueItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModerationQueueItemImplToJson(
      this,
    );
  }
}

abstract class _ModerationQueueItem implements ModerationQueueItem {
  const factory _ModerationQueueItem(
      {required final String userId,
      required final String username,
      required final String displayName,
      final String? avatarUrl,
      required final ModerationReason reason,
      required final RiskLevel riskLevel,
      final double botProbability,
      final double trustScore,
      final int reportCount,
      final List<String> reporterIds,
      final List<String> contentSampleIds,
      final List<String> evidenceUrls,
      final LastAction? lastAction,
      final String? moderatorNote,
      final bool isAppealed,
      final AppealStatus? appealStatus,
      final String? appealReason,
      final double behavioralScore,
      final double networkScore,
      final double contentScore,
      final double compositeScore,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ModerationQueueItemImpl;

  factory _ModerationQueueItem.fromJson(Map<String, dynamic> json) =
      _$ModerationQueueItemImpl.fromJson;

  @override
  String get userId;
  @override
  String get username;
  @override
  String get displayName;
  @override
  String? get avatarUrl;
  @override
  ModerationReason get reason;
  @override
  RiskLevel get riskLevel;
  @override
  double get botProbability;
  @override
  double get trustScore;
  @override
  int get reportCount;
  @override
  List<String> get reporterIds;
  @override
  List<String> get contentSampleIds;
  @override
  List<String> get evidenceUrls;
  @override
  LastAction? get lastAction;
  @override
  String? get moderatorNote;
  @override
  bool get isAppealed;
  @override
  AppealStatus? get appealStatus;
  @override
  String? get appealReason;
  @override
  double get behavioralScore;
  @override
  double get networkScore;
  @override
  double get contentScore;
  @override
  double get compositeScore;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ModerationQueueItemImplCopyWith<_$ModerationQueueItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuspiciousAccount _$SuspiciousAccountFromJson(Map<String, dynamic> json) {
  return _SuspiciousAccount.fromJson(json);
}

/// @nodoc
mixin _$SuspiciousAccount {
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  ModerationReason get reason => throw _privateConstructorUsedError;
  RiskLevel get riskLevel => throw _privateConstructorUsedError;
  double get botProbability => throw _privateConstructorUsedError;
  double get trustScore => throw _privateConstructorUsedError;
  int get reportCount => throw _privateConstructorUsedError;
  List<String> get reporterIds => throw _privateConstructorUsedError;
  List<String> get contentSampleIds => throw _privateConstructorUsedError;
  List<String> get evidenceUrls => throw _privateConstructorUsedError;
  LastAction? get lastAction => throw _privateConstructorUsedError;
  String? get moderatorNote => throw _privateConstructorUsedError;
  bool get isAppealed => throw _privateConstructorUsedError;
  AppealStatus? get appealStatus => throw _privateConstructorUsedError;
  String? get appealReason => throw _privateConstructorUsedError;
  double get behavioralScore => throw _privateConstructorUsedError;
  double get networkScore => throw _privateConstructorUsedError;
  double get contentScore => throw _privateConstructorUsedError;
  double get compositeScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuspiciousAccountCopyWith<SuspiciousAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuspiciousAccountCopyWith<$Res> {
  factory $SuspiciousAccountCopyWith(
          SuspiciousAccount value, $Res Function(SuspiciousAccount) then) =
      _$SuspiciousAccountCopyWithImpl<$Res, SuspiciousAccount>;
  @useResult
  $Res call(
      {String userId,
      String username,
      String displayName,
      String? avatarUrl,
      ModerationReason reason,
      RiskLevel riskLevel,
      double botProbability,
      double trustScore,
      int reportCount,
      List<String> reporterIds,
      List<String> contentSampleIds,
      List<String> evidenceUrls,
      LastAction? lastAction,
      String? moderatorNote,
      bool isAppealed,
      AppealStatus? appealStatus,
      String? appealReason,
      double behavioralScore,
      double networkScore,
      double contentScore,
      double compositeScore,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$SuspiciousAccountCopyWithImpl<$Res, $Val extends SuspiciousAccount>
    implements $SuspiciousAccountCopyWith<$Res> {
  _$SuspiciousAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? reason = null,
    Object? riskLevel = null,
    Object? botProbability = null,
    Object? trustScore = null,
    Object? reportCount = null,
    Object? reporterIds = null,
    Object? contentSampleIds = null,
    Object? evidenceUrls = null,
    Object? lastAction = freezed,
    Object? moderatorNote = freezed,
    Object? isAppealed = null,
    Object? appealStatus = freezed,
    Object? appealReason = freezed,
    Object? behavioralScore = null,
    Object? networkScore = null,
    Object? contentScore = null,
    Object? compositeScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as ModerationReason,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RiskLevel,
      botProbability: null == botProbability
          ? _value.botProbability
          : botProbability // ignore: cast_nullable_to_non_nullable
              as double,
      trustScore: null == trustScore
          ? _value.trustScore
          : trustScore // ignore: cast_nullable_to_non_nullable
              as double,
      reportCount: null == reportCount
          ? _value.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      reporterIds: null == reporterIds
          ? _value.reporterIds
          : reporterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contentSampleIds: null == contentSampleIds
          ? _value.contentSampleIds
          : contentSampleIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      evidenceUrls: null == evidenceUrls
          ? _value.evidenceUrls
          : evidenceUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastAction: freezed == lastAction
          ? _value.lastAction
          : lastAction // ignore: cast_nullable_to_non_nullable
              as LastAction?,
      moderatorNote: freezed == moderatorNote
          ? _value.moderatorNote
          : moderatorNote // ignore: cast_nullable_to_non_nullable
              as String?,
      isAppealed: null == isAppealed
          ? _value.isAppealed
          : isAppealed // ignore: cast_nullable_to_non_nullable
              as bool,
      appealStatus: freezed == appealStatus
          ? _value.appealStatus
          : appealStatus // ignore: cast_nullable_to_non_nullable
              as AppealStatus?,
      appealReason: freezed == appealReason
          ? _value.appealReason
          : appealReason // ignore: cast_nullable_to_non_nullable
              as String?,
      behavioralScore: null == behavioralScore
          ? _value.behavioralScore
          : behavioralScore // ignore: cast_nullable_to_non_nullable
              as double,
      networkScore: null == networkScore
          ? _value.networkScore
          : networkScore // ignore: cast_nullable_to_non_nullable
              as double,
      contentScore: null == contentScore
          ? _value.contentScore
          : contentScore // ignore: cast_nullable_to_non_nullable
              as double,
      compositeScore: null == compositeScore
          ? _value.compositeScore
          : compositeScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuspiciousAccountImplCopyWith<$Res>
    implements $SuspiciousAccountCopyWith<$Res> {
  factory _$$SuspiciousAccountImplCopyWith(_$SuspiciousAccountImpl value,
          $Res Function(_$SuspiciousAccountImpl) then) =
      __$$SuspiciousAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String username,
      String displayName,
      String? avatarUrl,
      ModerationReason reason,
      RiskLevel riskLevel,
      double botProbability,
      double trustScore,
      int reportCount,
      List<String> reporterIds,
      List<String> contentSampleIds,
      List<String> evidenceUrls,
      LastAction? lastAction,
      String? moderatorNote,
      bool isAppealed,
      AppealStatus? appealStatus,
      String? appealReason,
      double behavioralScore,
      double networkScore,
      double contentScore,
      double compositeScore,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$SuspiciousAccountImplCopyWithImpl<$Res>
    extends _$SuspiciousAccountCopyWithImpl<$Res, _$SuspiciousAccountImpl>
    implements _$$SuspiciousAccountImplCopyWith<$Res> {
  __$$SuspiciousAccountImplCopyWithImpl(_$SuspiciousAccountImpl _value,
      $Res Function(_$SuspiciousAccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? reason = null,
    Object? riskLevel = null,
    Object? botProbability = null,
    Object? trustScore = null,
    Object? reportCount = null,
    Object? reporterIds = null,
    Object? contentSampleIds = null,
    Object? evidenceUrls = null,
    Object? lastAction = freezed,
    Object? moderatorNote = freezed,
    Object? isAppealed = null,
    Object? appealStatus = freezed,
    Object? appealReason = freezed,
    Object? behavioralScore = null,
    Object? networkScore = null,
    Object? contentScore = null,
    Object? compositeScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SuspiciousAccountImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as ModerationReason,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RiskLevel,
      botProbability: null == botProbability
          ? _value.botProbability
          : botProbability // ignore: cast_nullable_to_non_nullable
              as double,
      trustScore: null == trustScore
          ? _value.trustScore
          : trustScore // ignore: cast_nullable_to_non_nullable
              as double,
      reportCount: null == reportCount
          ? _value.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      reporterIds: null == reporterIds
          ? _value._reporterIds
          : reporterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contentSampleIds: null == contentSampleIds
          ? _value._contentSampleIds
          : contentSampleIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      evidenceUrls: null == evidenceUrls
          ? _value._evidenceUrls
          : evidenceUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastAction: freezed == lastAction
          ? _value.lastAction
          : lastAction // ignore: cast_nullable_to_non_nullable
              as LastAction?,
      moderatorNote: freezed == moderatorNote
          ? _value.moderatorNote
          : moderatorNote // ignore: cast_nullable_to_non_nullable
              as String?,
      isAppealed: null == isAppealed
          ? _value.isAppealed
          : isAppealed // ignore: cast_nullable_to_non_nullable
              as bool,
      appealStatus: freezed == appealStatus
          ? _value.appealStatus
          : appealStatus // ignore: cast_nullable_to_non_nullable
              as AppealStatus?,
      appealReason: freezed == appealReason
          ? _value.appealReason
          : appealReason // ignore: cast_nullable_to_non_nullable
              as String?,
      behavioralScore: null == behavioralScore
          ? _value.behavioralScore
          : behavioralScore // ignore: cast_nullable_to_non_nullable
              as double,
      networkScore: null == networkScore
          ? _value.networkScore
          : networkScore // ignore: cast_nullable_to_non_nullable
              as double,
      contentScore: null == contentScore
          ? _value.contentScore
          : contentScore // ignore: cast_nullable_to_non_nullable
              as double,
      compositeScore: null == compositeScore
          ? _value.compositeScore
          : compositeScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuspiciousAccountImpl implements _SuspiciousAccount {
  const _$SuspiciousAccountImpl(
      {required this.userId,
      required this.username,
      required this.displayName,
      this.avatarUrl,
      required this.reason,
      required this.riskLevel,
      this.botProbability = 0.0,
      this.trustScore = 0.0,
      this.reportCount = 0,
      final List<String> reporterIds = const [],
      final List<String> contentSampleIds = const [],
      final List<String> evidenceUrls = const [],
      this.lastAction,
      this.moderatorNote,
      this.isAppealed = false,
      this.appealStatus,
      this.appealReason,
      this.behavioralScore = 0.0,
      this.networkScore = 0.0,
      this.contentScore = 0.0,
      this.compositeScore = 0.0,
      required this.createdAt,
      required this.updatedAt})
      : _reporterIds = reporterIds,
        _contentSampleIds = contentSampleIds,
        _evidenceUrls = evidenceUrls;

  factory _$SuspiciousAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuspiciousAccountImplFromJson(json);

  @override
  final String userId;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final ModerationReason reason;
  @override
  final RiskLevel riskLevel;
  @override
  @JsonKey()
  final double botProbability;
  @override
  @JsonKey()
  final double trustScore;
  @override
  @JsonKey()
  final int reportCount;
  final List<String> _reporterIds;
  @override
  @JsonKey()
  List<String> get reporterIds {
    if (_reporterIds is EqualUnmodifiableListView) return _reporterIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reporterIds);
  }

  final List<String> _contentSampleIds;
  @override
  @JsonKey()
  List<String> get contentSampleIds {
    if (_contentSampleIds is EqualUnmodifiableListView)
      return _contentSampleIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contentSampleIds);
  }

  final List<String> _evidenceUrls;
  @override
  @JsonKey()
  List<String> get evidenceUrls {
    if (_evidenceUrls is EqualUnmodifiableListView) return _evidenceUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidenceUrls);
  }

  @override
  final LastAction? lastAction;
  @override
  final String? moderatorNote;
  @override
  @JsonKey()
  final bool isAppealed;
  @override
  final AppealStatus? appealStatus;
  @override
  final String? appealReason;
  @override
  @JsonKey()
  final double behavioralScore;
  @override
  @JsonKey()
  final double networkScore;
  @override
  @JsonKey()
  final double contentScore;
  @override
  @JsonKey()
  final double compositeScore;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SuspiciousAccount(userId: $userId, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, reason: $reason, riskLevel: $riskLevel, botProbability: $botProbability, trustScore: $trustScore, reportCount: $reportCount, reporterIds: $reporterIds, contentSampleIds: $contentSampleIds, evidenceUrls: $evidenceUrls, lastAction: $lastAction, moderatorNote: $moderatorNote, isAppealed: $isAppealed, appealStatus: $appealStatus, appealReason: $appealReason, behavioralScore: $behavioralScore, networkScore: $networkScore, contentScore: $contentScore, compositeScore: $compositeScore, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuspiciousAccountImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.botProbability, botProbability) ||
                other.botProbability == botProbability) &&
            (identical(other.trustScore, trustScore) ||
                other.trustScore == trustScore) &&
            (identical(other.reportCount, reportCount) ||
                other.reportCount == reportCount) &&
            const DeepCollectionEquality()
                .equals(other._reporterIds, _reporterIds) &&
            const DeepCollectionEquality()
                .equals(other._contentSampleIds, _contentSampleIds) &&
            const DeepCollectionEquality()
                .equals(other._evidenceUrls, _evidenceUrls) &&
            (identical(other.lastAction, lastAction) ||
                other.lastAction == lastAction) &&
            (identical(other.moderatorNote, moderatorNote) ||
                other.moderatorNote == moderatorNote) &&
            (identical(other.isAppealed, isAppealed) ||
                other.isAppealed == isAppealed) &&
            (identical(other.appealStatus, appealStatus) ||
                other.appealStatus == appealStatus) &&
            (identical(other.appealReason, appealReason) ||
                other.appealReason == appealReason) &&
            (identical(other.behavioralScore, behavioralScore) ||
                other.behavioralScore == behavioralScore) &&
            (identical(other.networkScore, networkScore) ||
                other.networkScore == networkScore) &&
            (identical(other.contentScore, contentScore) ||
                other.contentScore == contentScore) &&
            (identical(other.compositeScore, compositeScore) ||
                other.compositeScore == compositeScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        username,
        displayName,
        avatarUrl,
        reason,
        riskLevel,
        botProbability,
        trustScore,
        reportCount,
        const DeepCollectionEquality().hash(_reporterIds),
        const DeepCollectionEquality().hash(_contentSampleIds),
        const DeepCollectionEquality().hash(_evidenceUrls),
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
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuspiciousAccountImplCopyWith<_$SuspiciousAccountImpl> get copyWith =>
      __$$SuspiciousAccountImplCopyWithImpl<_$SuspiciousAccountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuspiciousAccountImplToJson(
      this,
    );
  }
}

abstract class _SuspiciousAccount implements SuspiciousAccount {
  const factory _SuspiciousAccount(
      {required final String userId,
      required final String username,
      required final String displayName,
      final String? avatarUrl,
      required final ModerationReason reason,
      required final RiskLevel riskLevel,
      final double botProbability,
      final double trustScore,
      final int reportCount,
      final List<String> reporterIds,
      final List<String> contentSampleIds,
      final List<String> evidenceUrls,
      final LastAction? lastAction,
      final String? moderatorNote,
      final bool isAppealed,
      final AppealStatus? appealStatus,
      final String? appealReason,
      final double behavioralScore,
      final double networkScore,
      final double contentScore,
      final double compositeScore,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$SuspiciousAccountImpl;

  factory _SuspiciousAccount.fromJson(Map<String, dynamic> json) =
      _$SuspiciousAccountImpl.fromJson;

  @override
  String get userId;
  @override
  String get username;
  @override
  String get displayName;
  @override
  String? get avatarUrl;
  @override
  ModerationReason get reason;
  @override
  RiskLevel get riskLevel;
  @override
  double get botProbability;
  @override
  double get trustScore;
  @override
  int get reportCount;
  @override
  List<String> get reporterIds;
  @override
  List<String> get contentSampleIds;
  @override
  List<String> get evidenceUrls;
  @override
  LastAction? get lastAction;
  @override
  String? get moderatorNote;
  @override
  bool get isAppealed;
  @override
  AppealStatus? get appealStatus;
  @override
  String? get appealReason;
  @override
  double get behavioralScore;
  @override
  double get networkScore;
  @override
  double get contentScore;
  @override
  double get compositeScore;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SuspiciousAccountImplCopyWith<_$SuspiciousAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
