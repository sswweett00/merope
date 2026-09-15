// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_action_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ModerationActionRequest _$ModerationActionRequestFromJson(
    Map<String, dynamic> json) {
  return _ModerationActionRequest.fromJson(json);
}

/// @nodoc
mixin _$ModerationActionRequest {
  ModerationActionType get type => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  int? get durationDays => throw _privateConstructorUsedError;
  String? get escalationTarget => throw _privateConstructorUsedError;
  String? get moderatorNote => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ModerationActionRequestCopyWith<ModerationActionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModerationActionRequestCopyWith<$Res> {
  factory $ModerationActionRequestCopyWith(ModerationActionRequest value,
          $Res Function(ModerationActionRequest) then) =
      _$ModerationActionRequestCopyWithImpl<$Res, ModerationActionRequest>;
  @useResult
  $Res call(
      {ModerationActionType type,
      String userId,
      String? reason,
      int? durationDays,
      String? escalationTarget,
      String? moderatorNote,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$ModerationActionRequestCopyWithImpl<$Res,
        $Val extends ModerationActionRequest>
    implements $ModerationActionRequestCopyWith<$Res> {
  _$ModerationActionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? userId = null,
    Object? reason = freezed,
    Object? durationDays = freezed,
    Object? escalationTarget = freezed,
    Object? moderatorNote = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ModerationActionType,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      durationDays: freezed == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int?,
      escalationTarget: freezed == escalationTarget
          ? _value.escalationTarget
          : escalationTarget // ignore: cast_nullable_to_non_nullable
              as String?,
      moderatorNote: freezed == moderatorNote
          ? _value.moderatorNote
          : moderatorNote // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModerationActionRequestImplCopyWith<$Res>
    implements $ModerationActionRequestCopyWith<$Res> {
  factory _$$ModerationActionRequestImplCopyWith(
          _$ModerationActionRequestImpl value,
          $Res Function(_$ModerationActionRequestImpl) then) =
      __$$ModerationActionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ModerationActionType type,
      String userId,
      String? reason,
      int? durationDays,
      String? escalationTarget,
      String? moderatorNote,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$ModerationActionRequestImplCopyWithImpl<$Res>
    extends _$ModerationActionRequestCopyWithImpl<$Res,
        _$ModerationActionRequestImpl>
    implements _$$ModerationActionRequestImplCopyWith<$Res> {
  __$$ModerationActionRequestImplCopyWithImpl(
      _$ModerationActionRequestImpl _value,
      $Res Function(_$ModerationActionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? userId = null,
    Object? reason = freezed,
    Object? durationDays = freezed,
    Object? escalationTarget = freezed,
    Object? moderatorNote = freezed,
    Object? metadata = null,
  }) {
    return _then(_$ModerationActionRequestImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ModerationActionType,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      durationDays: freezed == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int?,
      escalationTarget: freezed == escalationTarget
          ? _value.escalationTarget
          : escalationTarget // ignore: cast_nullable_to_non_nullable
              as String?,
      moderatorNote: freezed == moderatorNote
          ? _value.moderatorNote
          : moderatorNote // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModerationActionRequestImpl implements _ModerationActionRequest {
  const _$ModerationActionRequestImpl(
      {required this.type,
      required this.userId,
      this.reason,
      this.durationDays,
      this.escalationTarget,
      this.moderatorNote,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$ModerationActionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModerationActionRequestImplFromJson(json);

  @override
  final ModerationActionType type;
  @override
  final String userId;
  @override
  final String? reason;
  @override
  final int? durationDays;
  @override
  final String? escalationTarget;
  @override
  final String? moderatorNote;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'ModerationActionRequest(type: $type, userId: $userId, reason: $reason, durationDays: $durationDays, escalationTarget: $escalationTarget, moderatorNote: $moderatorNote, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModerationActionRequestImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays) &&
            (identical(other.escalationTarget, escalationTarget) ||
                other.escalationTarget == escalationTarget) &&
            (identical(other.moderatorNote, moderatorNote) ||
                other.moderatorNote == moderatorNote) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      userId,
      reason,
      durationDays,
      escalationTarget,
      moderatorNote,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModerationActionRequestImplCopyWith<_$ModerationActionRequestImpl>
      get copyWith => __$$ModerationActionRequestImplCopyWithImpl<
          _$ModerationActionRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModerationActionRequestImplToJson(
      this,
    );
  }
}

abstract class _ModerationActionRequest implements ModerationActionRequest {
  const factory _ModerationActionRequest(
      {required final ModerationActionType type,
      required final String userId,
      final String? reason,
      final int? durationDays,
      final String? escalationTarget,
      final String? moderatorNote,
      final Map<String, dynamic> metadata}) = _$ModerationActionRequestImpl;

  factory _ModerationActionRequest.fromJson(Map<String, dynamic> json) =
      _$ModerationActionRequestImpl.fromJson;

  @override
  ModerationActionType get type;
  @override
  String get userId;
  @override
  String? get reason;
  @override
  int? get durationDays;
  @override
  String? get escalationTarget;
  @override
  String? get moderatorNote;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ModerationActionRequestImplCopyWith<_$ModerationActionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BulkModerationActionRequest _$BulkModerationActionRequestFromJson(
    Map<String, dynamic> json) {
  return _BulkModerationActionRequest.fromJson(json);
}

/// @nodoc
mixin _$BulkModerationActionRequest {
  ModerationActionType get type => throw _privateConstructorUsedError;
  List<String> get userIds => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  int? get durationDays => throw _privateConstructorUsedError;
  String? get moderatorNote => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BulkModerationActionRequestCopyWith<BulkModerationActionRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkModerationActionRequestCopyWith<$Res> {
  factory $BulkModerationActionRequestCopyWith(
          BulkModerationActionRequest value,
          $Res Function(BulkModerationActionRequest) then) =
      _$BulkModerationActionRequestCopyWithImpl<$Res,
          BulkModerationActionRequest>;
  @useResult
  $Res call(
      {ModerationActionType type,
      List<String> userIds,
      String? reason,
      int? durationDays,
      String? moderatorNote,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$BulkModerationActionRequestCopyWithImpl<$Res,
        $Val extends BulkModerationActionRequest>
    implements $BulkModerationActionRequestCopyWith<$Res> {
  _$BulkModerationActionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? userIds = null,
    Object? reason = freezed,
    Object? durationDays = freezed,
    Object? moderatorNote = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ModerationActionType,
      userIds: null == userIds
          ? _value.userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      durationDays: freezed == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int?,
      moderatorNote: freezed == moderatorNote
          ? _value.moderatorNote
          : moderatorNote // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BulkModerationActionRequestImplCopyWith<$Res>
    implements $BulkModerationActionRequestCopyWith<$Res> {
  factory _$$BulkModerationActionRequestImplCopyWith(
          _$BulkModerationActionRequestImpl value,
          $Res Function(_$BulkModerationActionRequestImpl) then) =
      __$$BulkModerationActionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ModerationActionType type,
      List<String> userIds,
      String? reason,
      int? durationDays,
      String? moderatorNote,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$BulkModerationActionRequestImplCopyWithImpl<$Res>
    extends _$BulkModerationActionRequestCopyWithImpl<$Res,
        _$BulkModerationActionRequestImpl>
    implements _$$BulkModerationActionRequestImplCopyWith<$Res> {
  __$$BulkModerationActionRequestImplCopyWithImpl(
      _$BulkModerationActionRequestImpl _value,
      $Res Function(_$BulkModerationActionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? userIds = null,
    Object? reason = freezed,
    Object? durationDays = freezed,
    Object? moderatorNote = freezed,
    Object? metadata = null,
  }) {
    return _then(_$BulkModerationActionRequestImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ModerationActionType,
      userIds: null == userIds
          ? _value._userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      durationDays: freezed == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int?,
      moderatorNote: freezed == moderatorNote
          ? _value.moderatorNote
          : moderatorNote // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BulkModerationActionRequestImpl
    implements _BulkModerationActionRequest {
  const _$BulkModerationActionRequestImpl(
      {required this.type,
      required final List<String> userIds,
      this.reason,
      this.durationDays,
      this.moderatorNote,
      final Map<String, dynamic> metadata = const {}})
      : _userIds = userIds,
        _metadata = metadata;

  factory _$BulkModerationActionRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BulkModerationActionRequestImplFromJson(json);

  @override
  final ModerationActionType type;
  final List<String> _userIds;
  @override
  List<String> get userIds {
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userIds);
  }

  @override
  final String? reason;
  @override
  final int? durationDays;
  @override
  final String? moderatorNote;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'BulkModerationActionRequest(type: $type, userIds: $userIds, reason: $reason, durationDays: $durationDays, moderatorNote: $moderatorNote, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkModerationActionRequestImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._userIds, _userIds) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays) &&
            (identical(other.moderatorNote, moderatorNote) ||
                other.moderatorNote == moderatorNote) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      const DeepCollectionEquality().hash(_userIds),
      reason,
      durationDays,
      moderatorNote,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkModerationActionRequestImplCopyWith<_$BulkModerationActionRequestImpl>
      get copyWith => __$$BulkModerationActionRequestImplCopyWithImpl<
          _$BulkModerationActionRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BulkModerationActionRequestImplToJson(
      this,
    );
  }
}

abstract class _BulkModerationActionRequest
    implements BulkModerationActionRequest {
  const factory _BulkModerationActionRequest(
      {required final ModerationActionType type,
      required final List<String> userIds,
      final String? reason,
      final int? durationDays,
      final String? moderatorNote,
      final Map<String, dynamic> metadata}) = _$BulkModerationActionRequestImpl;

  factory _BulkModerationActionRequest.fromJson(Map<String, dynamic> json) =
      _$BulkModerationActionRequestImpl.fromJson;

  @override
  ModerationActionType get type;
  @override
  List<String> get userIds;
  @override
  String? get reason;
  @override
  int? get durationDays;
  @override
  String? get moderatorNote;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$BulkModerationActionRequestImplCopyWith<_$BulkModerationActionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
