// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_memory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SharedMemoryItem _$SharedMemoryItemFromJson(Map<String, dynamic> json) {
  return _SharedMemoryItem.fromJson(json);
}

/// @nodoc
mixin _$SharedMemoryItem {
  String get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  MemoryItemType get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharedMemoryItemCopyWith<SharedMemoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedMemoryItemCopyWith<$Res> {
  factory $SharedMemoryItemCopyWith(
          SharedMemoryItem value, $Res Function(SharedMemoryItem) then) =
      _$SharedMemoryItemCopyWithImpl<$Res, SharedMemoryItem>;
  @useResult
  $Res call(
      {String id,
      String authorId,
      String authorName,
      MemoryItemType type,
      DateTime timestamp,
      String content,
      String? mediaUrl,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$SharedMemoryItemCopyWithImpl<$Res, $Val extends SharedMemoryItem>
    implements $SharedMemoryItemCopyWith<$Res> {
  _$SharedMemoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? type = null,
    Object? timestamp = null,
    Object? content = null,
    Object? mediaUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MemoryItemType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedMemoryItemImplCopyWith<$Res>
    implements $SharedMemoryItemCopyWith<$Res> {
  factory _$$SharedMemoryItemImplCopyWith(_$SharedMemoryItemImpl value,
          $Res Function(_$SharedMemoryItemImpl) then) =
      __$$SharedMemoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String authorId,
      String authorName,
      MemoryItemType type,
      DateTime timestamp,
      String content,
      String? mediaUrl,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$SharedMemoryItemImplCopyWithImpl<$Res>
    extends _$SharedMemoryItemCopyWithImpl<$Res, _$SharedMemoryItemImpl>
    implements _$$SharedMemoryItemImplCopyWith<$Res> {
  __$$SharedMemoryItemImplCopyWithImpl(_$SharedMemoryItemImpl _value,
      $Res Function(_$SharedMemoryItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? type = null,
    Object? timestamp = null,
    Object? content = null,
    Object? mediaUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$SharedMemoryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MemoryItemType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharedMemoryItemImpl implements _SharedMemoryItem {
  const _$SharedMemoryItemImpl(
      {required this.id,
      required this.authorId,
      required this.authorName,
      required this.type,
      required this.timestamp,
      required this.content,
      this.mediaUrl,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$SharedMemoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharedMemoryItemImplFromJson(json);

  @override
  final String id;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final MemoryItemType type;
  @override
  final DateTime timestamp;
  @override
  final String content;
  @override
  final String? mediaUrl;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SharedMemoryItem(id: $id, authorId: $authorId, authorName: $authorName, type: $type, timestamp: $timestamp, content: $content, mediaUrl: $mediaUrl, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedMemoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      authorId,
      authorName,
      type,
      timestamp,
      content,
      mediaUrl,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedMemoryItemImplCopyWith<_$SharedMemoryItemImpl> get copyWith =>
      __$$SharedMemoryItemImplCopyWithImpl<_$SharedMemoryItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharedMemoryItemImplToJson(
      this,
    );
  }
}

abstract class _SharedMemoryItem implements SharedMemoryItem {
  const factory _SharedMemoryItem(
      {required final String id,
      required final String authorId,
      required final String authorName,
      required final MemoryItemType type,
      required final DateTime timestamp,
      required final String content,
      final String? mediaUrl,
      final Map<String, dynamic>? metadata}) = _$SharedMemoryItemImpl;

  factory _SharedMemoryItem.fromJson(Map<String, dynamic> json) =
      _$SharedMemoryItemImpl.fromJson;

  @override
  String get id;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  MemoryItemType get type;
  @override
  DateTime get timestamp;
  @override
  String get content;
  @override
  String? get mediaUrl;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$SharedMemoryItemImplCopyWith<_$SharedMemoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SharedMemory _$SharedMemoryFromJson(Map<String, dynamic> json) {
  return _SharedMemory.fromJson(json);
}

/// @nodoc
mixin _$SharedMemory {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get coverUrl => throw _privateConstructorUsedError;
  List<MeropeAuthor> get participants => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  List<SharedMemoryItem> get timeline => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharedMemoryCopyWith<SharedMemory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedMemoryCopyWith<$Res> {
  factory $SharedMemoryCopyWith(
          SharedMemory value, $Res Function(SharedMemory) then) =
      _$SharedMemoryCopyWithImpl<$Res, SharedMemory>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String coverUrl,
      List<MeropeAuthor> participants,
      DateTime date,
      List<SharedMemoryItem> timeline,
      String? location,
      List<String> tags});
}

/// @nodoc
class _$SharedMemoryCopyWithImpl<$Res, $Val extends SharedMemory>
    implements $SharedMemoryCopyWith<$Res> {
  _$SharedMemoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? coverUrl = null,
    Object? participants = null,
    Object? date = null,
    Object? timeline = null,
    Object? location = freezed,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: null == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<MeropeAuthor>,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeline: null == timeline
          ? _value.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<SharedMemoryItem>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedMemoryImplCopyWith<$Res>
    implements $SharedMemoryCopyWith<$Res> {
  factory _$$SharedMemoryImplCopyWith(
          _$SharedMemoryImpl value, $Res Function(_$SharedMemoryImpl) then) =
      __$$SharedMemoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String coverUrl,
      List<MeropeAuthor> participants,
      DateTime date,
      List<SharedMemoryItem> timeline,
      String? location,
      List<String> tags});
}

/// @nodoc
class __$$SharedMemoryImplCopyWithImpl<$Res>
    extends _$SharedMemoryCopyWithImpl<$Res, _$SharedMemoryImpl>
    implements _$$SharedMemoryImplCopyWith<$Res> {
  __$$SharedMemoryImplCopyWithImpl(
      _$SharedMemoryImpl _value, $Res Function(_$SharedMemoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? coverUrl = null,
    Object? participants = null,
    Object? date = null,
    Object? timeline = null,
    Object? location = freezed,
    Object? tags = null,
  }) {
    return _then(_$SharedMemoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: null == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<MeropeAuthor>,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeline: null == timeline
          ? _value._timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<SharedMemoryItem>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharedMemoryImpl implements _SharedMemory {
  const _$SharedMemoryImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.coverUrl,
      required final List<MeropeAuthor> participants,
      required this.date,
      required final List<SharedMemoryItem> timeline,
      this.location,
      final List<String> tags = const []})
      : _participants = participants,
        _timeline = timeline,
        _tags = tags;

  factory _$SharedMemoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharedMemoryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String coverUrl;
  final List<MeropeAuthor> _participants;
  @override
  List<MeropeAuthor> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final DateTime date;
  final List<SharedMemoryItem> _timeline;
  @override
  List<SharedMemoryItem> get timeline {
    if (_timeline is EqualUnmodifiableListView) return _timeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline);
  }

  @override
  final String? location;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'SharedMemory(id: $id, title: $title, description: $description, coverUrl: $coverUrl, participants: $participants, date: $date, timeline: $timeline, location: $location, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedMemoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._timeline, _timeline) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      coverUrl,
      const DeepCollectionEquality().hash(_participants),
      date,
      const DeepCollectionEquality().hash(_timeline),
      location,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedMemoryImplCopyWith<_$SharedMemoryImpl> get copyWith =>
      __$$SharedMemoryImplCopyWithImpl<_$SharedMemoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharedMemoryImplToJson(
      this,
    );
  }
}

abstract class _SharedMemory implements SharedMemory {
  const factory _SharedMemory(
      {required final String id,
      required final String title,
      required final String description,
      required final String coverUrl,
      required final List<MeropeAuthor> participants,
      required final DateTime date,
      required final List<SharedMemoryItem> timeline,
      final String? location,
      final List<String> tags}) = _$SharedMemoryImpl;

  factory _SharedMemory.fromJson(Map<String, dynamic> json) =
      _$SharedMemoryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get coverUrl;
  @override
  List<MeropeAuthor> get participants;
  @override
  DateTime get date;
  @override
  List<SharedMemoryItem> get timeline;
  @override
  String? get location;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$SharedMemoryImplCopyWith<_$SharedMemoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
