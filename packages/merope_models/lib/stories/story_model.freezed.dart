// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoryUser _$StoryUserFromJson(Map<String, dynamic> json) {
  return _StoryUser.fromJson(json);
}

/// @nodoc
mixin _$StoryUser {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  bool get isMe => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_active')
  DateTime? get lastActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_story_ids')
  List<String> get unreadStoryIds => throw _privateConstructorUsedError;
  bool get isViewed => throw _privateConstructorUsedError;

  /// Serializes this StoryUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryUserCopyWith<StoryUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryUserCopyWith<$Res> {
  factory $StoryUserCopyWith(StoryUser value, $Res Function(StoryUser) then) =
      _$StoryUserCopyWithImpl<$Res, StoryUser>;
  @useResult
  $Res call(
      {String id,
      String username,
      String? displayName,
      String? avatarUrl,
      bool isMe,
      int streak,
      @JsonKey(name: 'last_active') DateTime? lastActive,
      @JsonKey(name: 'unread_story_ids') List<String> unreadStoryIds,
      bool isViewed});
}

/// @nodoc
class _$StoryUserCopyWithImpl<$Res, $Val extends StoryUser>
    implements $StoryUserCopyWith<$Res> {
  _$StoryUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? isMe = null,
    Object? streak = null,
    Object? lastActive = freezed,
    Object? unreadStoryIds = null,
    Object? isViewed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadStoryIds: null == unreadStoryIds
          ? _value.unreadStoryIds
          : unreadStoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isViewed: null == isViewed
          ? _value.isViewed
          : isViewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryUserImplCopyWith<$Res>
    implements $StoryUserCopyWith<$Res> {
  factory _$$StoryUserImplCopyWith(
          _$StoryUserImpl value, $Res Function(_$StoryUserImpl) then) =
      __$$StoryUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      String? displayName,
      String? avatarUrl,
      bool isMe,
      int streak,
      @JsonKey(name: 'last_active') DateTime? lastActive,
      @JsonKey(name: 'unread_story_ids') List<String> unreadStoryIds,
      bool isViewed});
}

/// @nodoc
class __$$StoryUserImplCopyWithImpl<$Res>
    extends _$StoryUserCopyWithImpl<$Res, _$StoryUserImpl>
    implements _$$StoryUserImplCopyWith<$Res> {
  __$$StoryUserImplCopyWithImpl(
      _$StoryUserImpl _value, $Res Function(_$StoryUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? isMe = null,
    Object? streak = null,
    Object? lastActive = freezed,
    Object? unreadStoryIds = null,
    Object? isViewed = null,
  }) {
    return _then(_$StoryUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadStoryIds: null == unreadStoryIds
          ? _value._unreadStoryIds
          : unreadStoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isViewed: null == isViewed
          ? _value.isViewed
          : isViewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryUserImpl implements _StoryUser {
  const _$StoryUserImpl(
      {required this.id,
      required this.username,
      this.displayName,
      this.avatarUrl,
      this.isMe = false,
      this.streak = 0,
      @JsonKey(name: 'last_active') this.lastActive,
      @JsonKey(name: 'unread_story_ids')
      final List<String> unreadStoryIds = const [],
      this.isViewed = false})
      : _unreadStoryIds = unreadStoryIds;

  factory _$StoryUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryUserImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String? displayName;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final bool isMe;
  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey(name: 'last_active')
  final DateTime? lastActive;
  final List<String> _unreadStoryIds;
  @override
  @JsonKey(name: 'unread_story_ids')
  List<String> get unreadStoryIds {
    if (_unreadStoryIds is EqualUnmodifiableListView) return _unreadStoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unreadStoryIds);
  }

  @override
  @JsonKey()
  final bool isViewed;

  @override
  String toString() {
    return 'StoryUser(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, isMe: $isMe, streak: $streak, lastActive: $lastActive, unreadStoryIds: $unreadStoryIds, isViewed: $isViewed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            const DeepCollectionEquality()
                .equals(other._unreadStoryIds, _unreadStoryIds) &&
            (identical(other.isViewed, isViewed) ||
                other.isViewed == isViewed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      displayName,
      avatarUrl,
      isMe,
      streak,
      lastActive,
      const DeepCollectionEquality().hash(_unreadStoryIds),
      isViewed);

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryUserImplCopyWith<_$StoryUserImpl> get copyWith =>
      __$$StoryUserImplCopyWithImpl<_$StoryUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryUserImplToJson(
      this,
    );
  }
}

abstract class _StoryUser implements StoryUser {
  const factory _StoryUser(
      {required final String id,
      required final String username,
      final String? displayName,
      final String? avatarUrl,
      final bool isMe,
      final int streak,
      @JsonKey(name: 'last_active') final DateTime? lastActive,
      @JsonKey(name: 'unread_story_ids') final List<String> unreadStoryIds,
      final bool isViewed}) = _$StoryUserImpl;

  factory _StoryUser.fromJson(Map<String, dynamic> json) =
      _$StoryUserImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String? get displayName;
  @override
  String? get avatarUrl;
  @override
  bool get isMe;
  @override
  int get streak;
  @override
  @JsonKey(name: 'last_active')
  DateTime? get lastActive;
  @override
  @JsonKey(name: 'unread_story_ids')
  List<String> get unreadStoryIds;
  @override
  bool get isViewed;

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryUserImplCopyWith<_$StoryUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StorySegment _$StorySegmentFromJson(Map<String, dynamic> json) {
  return _StorySegment.fromJson(json);
}

/// @nodoc
mixin _$StorySegment {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'story_id')
  String get storyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_type')
  StoryMediaType get mediaType => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_url')
  String get mediaUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  @JsonKey(name: 'text_content')
  String? get textContent => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this StorySegment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StorySegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StorySegmentCopyWith<StorySegment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StorySegmentCopyWith<$Res> {
  factory $StorySegmentCopyWith(
          StorySegment value, $Res Function(StorySegment) then) =
      _$StorySegmentCopyWithImpl<$Res, StorySegment>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'story_id') String storyId,
      @JsonKey(name: 'media_type') StoryMediaType mediaType,
      @JsonKey(name: 'media_url') String mediaUrl,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      int duration,
      @JsonKey(name: 'text_content') String? textContent,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$StorySegmentCopyWithImpl<$Res, $Val extends StorySegment>
    implements $StorySegmentCopyWith<$Res> {
  _$StorySegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StorySegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? mediaType = null,
    Object? mediaUrl = null,
    Object? thumbnailUrl = freezed,
    Object? duration = null,
    Object? textContent = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as StoryMediaType,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      textContent: freezed == textContent
          ? _value.textContent
          : textContent // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StorySegmentImplCopyWith<$Res>
    implements $StorySegmentCopyWith<$Res> {
  factory _$$StorySegmentImplCopyWith(
          _$StorySegmentImpl value, $Res Function(_$StorySegmentImpl) then) =
      __$$StorySegmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'story_id') String storyId,
      @JsonKey(name: 'media_type') StoryMediaType mediaType,
      @JsonKey(name: 'media_url') String mediaUrl,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      int duration,
      @JsonKey(name: 'text_content') String? textContent,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$StorySegmentImplCopyWithImpl<$Res>
    extends _$StorySegmentCopyWithImpl<$Res, _$StorySegmentImpl>
    implements _$$StorySegmentImplCopyWith<$Res> {
  __$$StorySegmentImplCopyWithImpl(
      _$StorySegmentImpl _value, $Res Function(_$StorySegmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of StorySegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? mediaType = null,
    Object? mediaUrl = null,
    Object? thumbnailUrl = freezed,
    Object? duration = null,
    Object? textContent = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$StorySegmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as StoryMediaType,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      textContent: freezed == textContent
          ? _value.textContent
          : textContent // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StorySegmentImpl implements _StorySegment {
  const _$StorySegmentImpl(
      {required this.id,
      @JsonKey(name: 'story_id') required this.storyId,
      @JsonKey(name: 'media_type') required this.mediaType,
      @JsonKey(name: 'media_url') required this.mediaUrl,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      this.duration = 5,
      @JsonKey(name: 'text_content') this.textContent,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$StorySegmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StorySegmentImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'story_id')
  final String storyId;
  @override
  @JsonKey(name: 'media_type')
  final StoryMediaType mediaType;
  @override
  @JsonKey(name: 'media_url')
  final String mediaUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  @JsonKey()
  final int duration;
  @override
  @JsonKey(name: 'text_content')
  final String? textContent;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'StorySegment(id: $id, storyId: $storyId, mediaType: $mediaType, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, duration: $duration, textContent: $textContent, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorySegmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.textContent, textContent) ||
                other.textContent == textContent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storyId, mediaType, mediaUrl,
      thumbnailUrl, duration, textContent, createdAt);

  /// Create a copy of StorySegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorySegmentImplCopyWith<_$StorySegmentImpl> get copyWith =>
      __$$StorySegmentImplCopyWithImpl<_$StorySegmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StorySegmentImplToJson(
      this,
    );
  }
}

abstract class _StorySegment implements StorySegment {
  const factory _StorySegment(
          {required final String id,
          @JsonKey(name: 'story_id') required final String storyId,
          @JsonKey(name: 'media_type') required final StoryMediaType mediaType,
          @JsonKey(name: 'media_url') required final String mediaUrl,
          @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
          final int duration,
          @JsonKey(name: 'text_content') final String? textContent,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$StorySegmentImpl;

  factory _StorySegment.fromJson(Map<String, dynamic> json) =
      _$StorySegmentImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'story_id')
  String get storyId;
  @override
  @JsonKey(name: 'media_type')
  StoryMediaType get mediaType;
  @override
  @JsonKey(name: 'media_url')
  String get mediaUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override
  int get duration;
  @override
  @JsonKey(name: 'text_content')
  String? get textContent;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of StorySegment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorySegmentImplCopyWith<_$StorySegmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Story _$StoryFromJson(Map<String, dynamic> json) {
  return _Story.fromJson(json);
}

/// @nodoc
mixin _$Story {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  List<StorySegment> get segments => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;
  bool get isViewed => throw _privateConstructorUsedError;
  @JsonKey(name: 'view_count')
  int get viewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reaction_count')
  int get reactionCount => throw _privateConstructorUsedError;

  /// Serializes this Story to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryCopyWith<Story> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryCopyWith<$Res> {
  factory $StoryCopyWith(Story value, $Res Function(Story) then) =
      _$StoryCopyWithImpl<$Res, Story>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      List<StorySegment> segments,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      bool isViewed,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'reaction_count') int reactionCount});
}

/// @nodoc
class _$StoryCopyWithImpl<$Res, $Val extends Story>
    implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? segments = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? isViewed = null,
    Object? viewCount = null,
    Object? reactionCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      segments: null == segments
          ? _value.segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<StorySegment>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isViewed: null == isViewed
          ? _value.isViewed
          : isViewed // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      reactionCount: null == reactionCount
          ? _value.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryImplCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$$StoryImplCopyWith(
          _$StoryImpl value, $Res Function(_$StoryImpl) then) =
      __$$StoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      List<StorySegment> segments,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      bool isViewed,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'reaction_count') int reactionCount});
}

/// @nodoc
class __$$StoryImplCopyWithImpl<$Res>
    extends _$StoryCopyWithImpl<$Res, _$StoryImpl>
    implements _$$StoryImplCopyWith<$Res> {
  __$$StoryImplCopyWithImpl(
      _$StoryImpl _value, $Res Function(_$StoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? segments = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? isViewed = null,
    Object? viewCount = null,
    Object? reactionCount = null,
  }) {
    return _then(_$StoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      segments: null == segments
          ? _value._segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<StorySegment>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isViewed: null == isViewed
          ? _value.isViewed
          : isViewed // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      reactionCount: null == reactionCount
          ? _value.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryImpl implements _Story {
  const _$StoryImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      final List<StorySegment> segments = const [],
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'expires_at') required this.expiresAt,
      this.isViewed = false,
      @JsonKey(name: 'view_count') this.viewCount = 0,
      @JsonKey(name: 'reaction_count') this.reactionCount = 0})
      : _segments = segments;

  factory _$StoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  final List<StorySegment> _segments;
  @override
  @JsonKey()
  List<StorySegment> get segments {
    if (_segments is EqualUnmodifiableListView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_segments);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @override
  @JsonKey()
  final bool isViewed;
  @override
  @JsonKey(name: 'view_count')
  final int viewCount;
  @override
  @JsonKey(name: 'reaction_count')
  final int reactionCount;

  @override
  String toString() {
    return 'Story(id: $id, userId: $userId, segments: $segments, createdAt: $createdAt, expiresAt: $expiresAt, isViewed: $isViewed, viewCount: $viewCount, reactionCount: $reactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._segments, _segments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isViewed, isViewed) ||
                other.isViewed == isViewed) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      const DeepCollectionEquality().hash(_segments),
      createdAt,
      expiresAt,
      isViewed,
      viewCount,
      reactionCount);

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryImplCopyWith<_$StoryImpl> get copyWith =>
      __$$StoryImplCopyWithImpl<_$StoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryImplToJson(
      this,
    );
  }
}

abstract class _Story implements Story {
  const factory _Story(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      final List<StorySegment> segments,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'expires_at') required final DateTime expiresAt,
      final bool isViewed,
      @JsonKey(name: 'view_count') final int viewCount,
      @JsonKey(name: 'reaction_count') final int reactionCount}) = _$StoryImpl;

  factory _Story.fromJson(Map<String, dynamic> json) = _$StoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  List<StorySegment> get segments;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;
  @override
  bool get isViewed;
  @override
  @JsonKey(name: 'view_count')
  int get viewCount;
  @override
  @JsonKey(name: 'reaction_count')
  int get reactionCount;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryImplCopyWith<_$StoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryReaction _$StoryReactionFromJson(Map<String, dynamic> json) {
  return _StoryReaction.fromJson(json);
}

/// @nodoc
mixin _$StoryReaction {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'story_id')
  String get storyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this StoryReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryReactionCopyWith<StoryReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryReactionCopyWith<$Res> {
  factory $StoryReactionCopyWith(
          StoryReaction value, $Res Function(StoryReaction) then) =
      _$StoryReactionCopyWithImpl<$Res, StoryReaction>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'story_id') String storyId,
      @JsonKey(name: 'user_id') String userId,
      String emoji,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$StoryReactionCopyWithImpl<$Res, $Val extends StoryReaction>
    implements $StoryReactionCopyWith<$Res> {
  _$StoryReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? userId = null,
    Object? emoji = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryReactionImplCopyWith<$Res>
    implements $StoryReactionCopyWith<$Res> {
  factory _$$StoryReactionImplCopyWith(
          _$StoryReactionImpl value, $Res Function(_$StoryReactionImpl) then) =
      __$$StoryReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'story_id') String storyId,
      @JsonKey(name: 'user_id') String userId,
      String emoji,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$StoryReactionImplCopyWithImpl<$Res>
    extends _$StoryReactionCopyWithImpl<$Res, _$StoryReactionImpl>
    implements _$$StoryReactionImplCopyWith<$Res> {
  __$$StoryReactionImplCopyWithImpl(
      _$StoryReactionImpl _value, $Res Function(_$StoryReactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? userId = null,
    Object? emoji = null,
    Object? createdAt = null,
  }) {
    return _then(_$StoryReactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryReactionImpl implements _StoryReaction {
  const _$StoryReactionImpl(
      {required this.id,
      @JsonKey(name: 'story_id') required this.storyId,
      @JsonKey(name: 'user_id') required this.userId,
      required this.emoji,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$StoryReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryReactionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'story_id')
  final String storyId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String emoji;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'StoryReaction(id: $id, storyId: $storyId, userId: $userId, emoji: $emoji, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryReactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, storyId, userId, emoji, createdAt);

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryReactionImplCopyWith<_$StoryReactionImpl> get copyWith =>
      __$$StoryReactionImplCopyWithImpl<_$StoryReactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryReactionImplToJson(
      this,
    );
  }
}

abstract class _StoryReaction implements StoryReaction {
  const factory _StoryReaction(
          {required final String id,
          @JsonKey(name: 'story_id') required final String storyId,
          @JsonKey(name: 'user_id') required final String userId,
          required final String emoji,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$StoryReactionImpl;

  factory _StoryReaction.fromJson(Map<String, dynamic> json) =
      _$StoryReactionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'story_id')
  String get storyId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get emoji;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryReactionImplCopyWith<_$StoryReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryInteractiveElement _$StoryInteractiveElementFromJson(
    Map<String, dynamic> json) {
  switch (json['type']) {
    case 'poll':
      return _StoryPollElement.fromJson(json);
    case 'slider':
      return _StorySliderElement.fromJson(json);
    case 'qna':
      return _StoryQnaElement.fromJson(json);
    case 'sticker':
      return _StoryStickerElement.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'type', 'StoryInteractiveElement',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$StoryInteractiveElement {
  String get id => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)
        poll,
    required TResult Function(
            String id, double min, double max, double value, String label)
        slider,
    required TResult Function(String id, String question, List<String> answers)
        qna,
    required TResult Function(
            String id, String url, double x, double y, double scale)
        sticker,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult? Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult? Function(String id, String question, List<String> answers)? qna,
    TResult? Function(String id, String url, double x, double y, double scale)?
        sticker,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult Function(String id, String question, List<String> answers)? qna,
    TResult Function(String id, String url, double x, double y, double scale)?
        sticker,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoryPollElement value) poll,
    required TResult Function(_StorySliderElement value) slider,
    required TResult Function(_StoryQnaElement value) qna,
    required TResult Function(_StoryStickerElement value) sticker,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoryPollElement value)? poll,
    TResult? Function(_StorySliderElement value)? slider,
    TResult? Function(_StoryQnaElement value)? qna,
    TResult? Function(_StoryStickerElement value)? sticker,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoryPollElement value)? poll,
    TResult Function(_StorySliderElement value)? slider,
    TResult Function(_StoryQnaElement value)? qna,
    TResult Function(_StoryStickerElement value)? sticker,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StoryInteractiveElement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryInteractiveElementCopyWith<StoryInteractiveElement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryInteractiveElementCopyWith<$Res> {
  factory $StoryInteractiveElementCopyWith(StoryInteractiveElement value,
          $Res Function(StoryInteractiveElement) then) =
      _$StoryInteractiveElementCopyWithImpl<$Res, StoryInteractiveElement>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$StoryInteractiveElementCopyWithImpl<$Res,
        $Val extends StoryInteractiveElement>
    implements $StoryInteractiveElementCopyWith<$Res> {
  _$StoryInteractiveElementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryPollElementImplCopyWith<$Res>
    implements $StoryInteractiveElementCopyWith<$Res> {
  factory _$$StoryPollElementImplCopyWith(_$StoryPollElementImpl value,
          $Res Function(_$StoryPollElementImpl) then) =
      __$$StoryPollElementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String question,
      List<String> options,
      Map<String, int> votes});
}

/// @nodoc
class __$$StoryPollElementImplCopyWithImpl<$Res>
    extends _$StoryInteractiveElementCopyWithImpl<$Res, _$StoryPollElementImpl>
    implements _$$StoryPollElementImplCopyWith<$Res> {
  __$$StoryPollElementImplCopyWithImpl(_$StoryPollElementImpl _value,
      $Res Function(_$StoryPollElementImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? votes = null,
  }) {
    return _then(_$StoryPollElementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      votes: null == votes
          ? _value._votes
          : votes // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryPollElementImpl implements _StoryPollElement {
  const _$StoryPollElementImpl(
      {required this.id,
      required this.question,
      final List<String> options = const [],
      final Map<String, int> votes = const {},
      final String? $type})
      : _options = options,
        _votes = votes,
        $type = $type ?? 'poll';

  factory _$StoryPollElementImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryPollElementImplFromJson(json);

  @override
  final String id;
  @override
  final String question;
  final List<String> _options;
  @override
  @JsonKey()
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  final Map<String, int> _votes;
  @override
  @JsonKey()
  Map<String, int> get votes {
    if (_votes is EqualUnmodifiableMapView) return _votes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_votes);
  }

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'StoryInteractiveElement.poll(id: $id, question: $question, options: $options, votes: $votes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryPollElementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality().equals(other._votes, _votes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      question,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_votes));

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryPollElementImplCopyWith<_$StoryPollElementImpl> get copyWith =>
      __$$StoryPollElementImplCopyWithImpl<_$StoryPollElementImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)
        poll,
    required TResult Function(
            String id, double min, double max, double value, String label)
        slider,
    required TResult Function(String id, String question, List<String> answers)
        qna,
    required TResult Function(
            String id, String url, double x, double y, double scale)
        sticker,
  }) {
    return poll(id, question, options, votes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult? Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult? Function(String id, String question, List<String> answers)? qna,
    TResult? Function(String id, String url, double x, double y, double scale)?
        sticker,
  }) {
    return poll?.call(id, question, options, votes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult Function(String id, String question, List<String> answers)? qna,
    TResult Function(String id, String url, double x, double y, double scale)?
        sticker,
    required TResult orElse(),
  }) {
    if (poll != null) {
      return poll(id, question, options, votes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoryPollElement value) poll,
    required TResult Function(_StorySliderElement value) slider,
    required TResult Function(_StoryQnaElement value) qna,
    required TResult Function(_StoryStickerElement value) sticker,
  }) {
    return poll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoryPollElement value)? poll,
    TResult? Function(_StorySliderElement value)? slider,
    TResult? Function(_StoryQnaElement value)? qna,
    TResult? Function(_StoryStickerElement value)? sticker,
  }) {
    return poll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoryPollElement value)? poll,
    TResult Function(_StorySliderElement value)? slider,
    TResult Function(_StoryQnaElement value)? qna,
    TResult Function(_StoryStickerElement value)? sticker,
    required TResult orElse(),
  }) {
    if (poll != null) {
      return poll(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryPollElementImplToJson(
      this,
    );
  }
}

abstract class _StoryPollElement implements StoryInteractiveElement {
  const factory _StoryPollElement(
      {required final String id,
      required final String question,
      final List<String> options,
      final Map<String, int> votes}) = _$StoryPollElementImpl;

  factory _StoryPollElement.fromJson(Map<String, dynamic> json) =
      _$StoryPollElementImpl.fromJson;

  @override
  String get id;
  String get question;
  List<String> get options;
  Map<String, int> get votes;

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryPollElementImplCopyWith<_$StoryPollElementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorySliderElementImplCopyWith<$Res>
    implements $StoryInteractiveElementCopyWith<$Res> {
  factory _$$StorySliderElementImplCopyWith(_$StorySliderElementImpl value,
          $Res Function(_$StorySliderElementImpl) then) =
      __$$StorySliderElementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, double min, double max, double value, String label});
}

/// @nodoc
class __$$StorySliderElementImplCopyWithImpl<$Res>
    extends _$StoryInteractiveElementCopyWithImpl<$Res,
        _$StorySliderElementImpl>
    implements _$$StorySliderElementImplCopyWith<$Res> {
  __$$StorySliderElementImplCopyWithImpl(_$StorySliderElementImpl _value,
      $Res Function(_$StorySliderElementImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? min = null,
    Object? max = null,
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_$StorySliderElementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StorySliderElementImpl implements _StorySliderElement {
  const _$StorySliderElementImpl(
      {required this.id,
      this.min = 0.0,
      this.max = 100.0,
      this.value = 0.0,
      required this.label,
      final String? $type})
      : $type = $type ?? 'slider';

  factory _$StorySliderElementImpl.fromJson(Map<String, dynamic> json) =>
      _$$StorySliderElementImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final double min;
  @override
  @JsonKey()
  final double max;
  @override
  @JsonKey()
  final double value;
  @override
  final String label;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'StoryInteractiveElement.slider(id: $id, min: $min, max: $max, value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorySliderElementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, min, max, value, label);

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorySliderElementImplCopyWith<_$StorySliderElementImpl> get copyWith =>
      __$$StorySliderElementImplCopyWithImpl<_$StorySliderElementImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)
        poll,
    required TResult Function(
            String id, double min, double max, double value, String label)
        slider,
    required TResult Function(String id, String question, List<String> answers)
        qna,
    required TResult Function(
            String id, String url, double x, double y, double scale)
        sticker,
  }) {
    return slider(id, min, max, value, label);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult? Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult? Function(String id, String question, List<String> answers)? qna,
    TResult? Function(String id, String url, double x, double y, double scale)?
        sticker,
  }) {
    return slider?.call(id, min, max, value, label);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult Function(String id, String question, List<String> answers)? qna,
    TResult Function(String id, String url, double x, double y, double scale)?
        sticker,
    required TResult orElse(),
  }) {
    if (slider != null) {
      return slider(id, min, max, value, label);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoryPollElement value) poll,
    required TResult Function(_StorySliderElement value) slider,
    required TResult Function(_StoryQnaElement value) qna,
    required TResult Function(_StoryStickerElement value) sticker,
  }) {
    return slider(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoryPollElement value)? poll,
    TResult? Function(_StorySliderElement value)? slider,
    TResult? Function(_StoryQnaElement value)? qna,
    TResult? Function(_StoryStickerElement value)? sticker,
  }) {
    return slider?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoryPollElement value)? poll,
    TResult Function(_StorySliderElement value)? slider,
    TResult Function(_StoryQnaElement value)? qna,
    TResult Function(_StoryStickerElement value)? sticker,
    required TResult orElse(),
  }) {
    if (slider != null) {
      return slider(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StorySliderElementImplToJson(
      this,
    );
  }
}

abstract class _StorySliderElement implements StoryInteractiveElement {
  const factory _StorySliderElement(
      {required final String id,
      final double min,
      final double max,
      final double value,
      required final String label}) = _$StorySliderElementImpl;

  factory _StorySliderElement.fromJson(Map<String, dynamic> json) =
      _$StorySliderElementImpl.fromJson;

  @override
  String get id;
  double get min;
  double get max;
  double get value;
  String get label;

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorySliderElementImplCopyWith<_$StorySliderElementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StoryQnaElementImplCopyWith<$Res>
    implements $StoryInteractiveElementCopyWith<$Res> {
  factory _$$StoryQnaElementImplCopyWith(_$StoryQnaElementImpl value,
          $Res Function(_$StoryQnaElementImpl) then) =
      __$$StoryQnaElementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String question, List<String> answers});
}

/// @nodoc
class __$$StoryQnaElementImplCopyWithImpl<$Res>
    extends _$StoryInteractiveElementCopyWithImpl<$Res, _$StoryQnaElementImpl>
    implements _$$StoryQnaElementImplCopyWith<$Res> {
  __$$StoryQnaElementImplCopyWithImpl(
      _$StoryQnaElementImpl _value, $Res Function(_$StoryQnaElementImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? answers = null,
  }) {
    return _then(_$StoryQnaElementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryQnaElementImpl implements _StoryQnaElement {
  const _$StoryQnaElementImpl(
      {required this.id,
      required this.question,
      final List<String> answers = const [],
      final String? $type})
      : _answers = answers,
        $type = $type ?? 'qna';

  factory _$StoryQnaElementImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryQnaElementImplFromJson(json);

  @override
  final String id;
  @override
  final String question;
  final List<String> _answers;
  @override
  @JsonKey()
  List<String> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'StoryInteractiveElement.qna(id: $id, question: $question, answers: $answers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryQnaElementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._answers, _answers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, question, const DeepCollectionEquality().hash(_answers));

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryQnaElementImplCopyWith<_$StoryQnaElementImpl> get copyWith =>
      __$$StoryQnaElementImplCopyWithImpl<_$StoryQnaElementImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)
        poll,
    required TResult Function(
            String id, double min, double max, double value, String label)
        slider,
    required TResult Function(String id, String question, List<String> answers)
        qna,
    required TResult Function(
            String id, String url, double x, double y, double scale)
        sticker,
  }) {
    return qna(id, question, answers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult? Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult? Function(String id, String question, List<String> answers)? qna,
    TResult? Function(String id, String url, double x, double y, double scale)?
        sticker,
  }) {
    return qna?.call(id, question, answers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult Function(String id, String question, List<String> answers)? qna,
    TResult Function(String id, String url, double x, double y, double scale)?
        sticker,
    required TResult orElse(),
  }) {
    if (qna != null) {
      return qna(id, question, answers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoryPollElement value) poll,
    required TResult Function(_StorySliderElement value) slider,
    required TResult Function(_StoryQnaElement value) qna,
    required TResult Function(_StoryStickerElement value) sticker,
  }) {
    return qna(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoryPollElement value)? poll,
    TResult? Function(_StorySliderElement value)? slider,
    TResult? Function(_StoryQnaElement value)? qna,
    TResult? Function(_StoryStickerElement value)? sticker,
  }) {
    return qna?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoryPollElement value)? poll,
    TResult Function(_StorySliderElement value)? slider,
    TResult Function(_StoryQnaElement value)? qna,
    TResult Function(_StoryStickerElement value)? sticker,
    required TResult orElse(),
  }) {
    if (qna != null) {
      return qna(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryQnaElementImplToJson(
      this,
    );
  }
}

abstract class _StoryQnaElement implements StoryInteractiveElement {
  const factory _StoryQnaElement(
      {required final String id,
      required final String question,
      final List<String> answers}) = _$StoryQnaElementImpl;

  factory _StoryQnaElement.fromJson(Map<String, dynamic> json) =
      _$StoryQnaElementImpl.fromJson;

  @override
  String get id;
  String get question;
  List<String> get answers;

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryQnaElementImplCopyWith<_$StoryQnaElementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StoryStickerElementImplCopyWith<$Res>
    implements $StoryInteractiveElementCopyWith<$Res> {
  factory _$$StoryStickerElementImplCopyWith(_$StoryStickerElementImpl value,
          $Res Function(_$StoryStickerElementImpl) then) =
      __$$StoryStickerElementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String url, double x, double y, double scale});
}

/// @nodoc
class __$$StoryStickerElementImplCopyWithImpl<$Res>
    extends _$StoryInteractiveElementCopyWithImpl<$Res,
        _$StoryStickerElementImpl>
    implements _$$StoryStickerElementImplCopyWith<$Res> {
  __$$StoryStickerElementImplCopyWithImpl(_$StoryStickerElementImpl _value,
      $Res Function(_$StoryStickerElementImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? x = null,
    Object? y = null,
    Object? scale = null,
  }) {
    return _then(_$StoryStickerElementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryStickerElementImpl implements _StoryStickerElement {
  const _$StoryStickerElementImpl(
      {required this.id,
      required this.url,
      this.x = 0.0,
      this.y = 0.0,
      this.scale = 1.0,
      final String? $type})
      : $type = $type ?? 'sticker';

  factory _$StoryStickerElementImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryStickerElementImplFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  @JsonKey()
  final double x;
  @override
  @JsonKey()
  final double y;
  @override
  @JsonKey()
  final double scale;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'StoryInteractiveElement.sticker(id: $id, url: $url, x: $x, y: $y, scale: $scale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryStickerElementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.scale, scale) || other.scale == scale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, x, y, scale);

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryStickerElementImplCopyWith<_$StoryStickerElementImpl> get copyWith =>
      __$$StoryStickerElementImplCopyWithImpl<_$StoryStickerElementImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)
        poll,
    required TResult Function(
            String id, double min, double max, double value, String label)
        slider,
    required TResult Function(String id, String question, List<String> answers)
        qna,
    required TResult Function(
            String id, String url, double x, double y, double scale)
        sticker,
  }) {
    return sticker(id, url, x, y, scale);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult? Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult? Function(String id, String question, List<String> answers)? qna,
    TResult? Function(String id, String url, double x, double y, double scale)?
        sticker,
  }) {
    return sticker?.call(id, url, x, y, scale);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String question, List<String> options,
            Map<String, int> votes)?
        poll,
    TResult Function(
            String id, double min, double max, double value, String label)?
        slider,
    TResult Function(String id, String question, List<String> answers)? qna,
    TResult Function(String id, String url, double x, double y, double scale)?
        sticker,
    required TResult orElse(),
  }) {
    if (sticker != null) {
      return sticker(id, url, x, y, scale);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoryPollElement value) poll,
    required TResult Function(_StorySliderElement value) slider,
    required TResult Function(_StoryQnaElement value) qna,
    required TResult Function(_StoryStickerElement value) sticker,
  }) {
    return sticker(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoryPollElement value)? poll,
    TResult? Function(_StorySliderElement value)? slider,
    TResult? Function(_StoryQnaElement value)? qna,
    TResult? Function(_StoryStickerElement value)? sticker,
  }) {
    return sticker?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoryPollElement value)? poll,
    TResult Function(_StorySliderElement value)? slider,
    TResult Function(_StoryQnaElement value)? qna,
    TResult Function(_StoryStickerElement value)? sticker,
    required TResult orElse(),
  }) {
    if (sticker != null) {
      return sticker(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryStickerElementImplToJson(
      this,
    );
  }
}

abstract class _StoryStickerElement implements StoryInteractiveElement {
  const factory _StoryStickerElement(
      {required final String id,
      required final String url,
      final double x,
      final double y,
      final double scale}) = _$StoryStickerElementImpl;

  factory _StoryStickerElement.fromJson(Map<String, dynamic> json) =
      _$StoryStickerElementImpl.fromJson;

  @override
  String get id;
  String get url;
  double get x;
  double get y;
  double get scale;

  /// Create a copy of StoryInteractiveElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryStickerElementImplCopyWith<_$StoryStickerElementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
