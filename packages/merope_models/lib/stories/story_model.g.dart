// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryUserImpl _$$StoryUserImplFromJson(Map<String, dynamic> json) =>
    _$StoryUserImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isMe: json['isMe'] as bool? ?? false,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      lastActive: json['last_active'] == null
          ? null
          : DateTime.parse(json['last_active'] as String),
      unreadStoryIds: (json['unread_story_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isViewed: json['isViewed'] as bool? ?? false,
    );

Map<String, dynamic> _$$StoryUserImplToJson(_$StoryUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'isMe': instance.isMe,
      'streak': instance.streak,
      'last_active': instance.lastActive?.toIso8601String(),
      'unread_story_ids': instance.unreadStoryIds,
      'isViewed': instance.isViewed,
    };

_$StorySegmentImpl _$$StorySegmentImplFromJson(Map<String, dynamic> json) =>
    _$StorySegmentImpl(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      mediaType: $enumDecode(_$StoryMediaTypeEnumMap, json['media_type']),
      mediaUrl: json['media_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 5,
      textContent: json['text_content'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$StorySegmentImplToJson(_$StorySegmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'story_id': instance.storyId,
      'media_type': _$StoryMediaTypeEnumMap[instance.mediaType]!,
      'media_url': instance.mediaUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'duration': instance.duration,
      'text_content': instance.textContent,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$StoryMediaTypeEnumMap = {
  StoryMediaType.image: 'image',
  StoryMediaType.video: 'video',
  StoryMediaType.text: 'text',
  StoryMediaType.gif: 'gif',
};

_$StoryImpl _$$StoryImplFromJson(Map<String, dynamic> json) => _$StoryImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      segments: (json['segments'] as List<dynamic>?)
              ?.map((e) => StorySegment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      isViewed: json['isViewed'] as bool? ?? false,
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      reactionCount: (json['reaction_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$StoryImplToJson(_$StoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'segments': instance.segments,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
      'isViewed': instance.isViewed,
      'view_count': instance.viewCount,
      'reaction_count': instance.reactionCount,
    };

_$StoryReactionImpl _$$StoryReactionImplFromJson(Map<String, dynamic> json) =>
    _$StoryReactionImpl(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      userId: json['user_id'] as String,
      emoji: json['emoji'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$StoryReactionImplToJson(_$StoryReactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'story_id': instance.storyId,
      'user_id': instance.userId,
      'emoji': instance.emoji,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$StoryPollElementImpl _$$StoryPollElementImplFromJson(
        Map<String, dynamic> json) =>
    _$StoryPollElementImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      votes: (json['votes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$StoryPollElementImplToJson(
        _$StoryPollElementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'votes': instance.votes,
      'type': instance.$type,
    };

_$StorySliderElementImpl _$$StorySliderElementImplFromJson(
        Map<String, dynamic> json) =>
    _$StorySliderElementImpl(
      id: json['id'] as String,
      min: (json['min'] as num?)?.toDouble() ?? 0.0,
      max: (json['max'] as num?)?.toDouble() ?? 100.0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      label: json['label'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$StorySliderElementImplToJson(
        _$StorySliderElementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'min': instance.min,
      'max': instance.max,
      'value': instance.value,
      'label': instance.label,
      'type': instance.$type,
    };

_$StoryQnaElementImpl _$$StoryQnaElementImplFromJson(
        Map<String, dynamic> json) =>
    _$StoryQnaElementImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$StoryQnaElementImplToJson(
        _$StoryQnaElementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answers': instance.answers,
      'type': instance.$type,
    };

_$StoryStickerElementImpl _$$StoryStickerElementImplFromJson(
        Map<String, dynamic> json) =>
    _$StoryStickerElementImpl(
      id: json['id'] as String,
      url: json['url'] as String,
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$StoryStickerElementImplToJson(
        _$StoryStickerElementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'x': instance.x,
      'y': instance.y,
      'scale': instance.scale,
      'type': instance.$type,
    };
