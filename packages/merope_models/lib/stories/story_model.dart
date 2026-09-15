// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

enum StoryMediaType { image, video, text, gif }

@freezed
class StoryUser with _$StoryUser {
  const factory StoryUser({
    required String id,
    required String username,
    String? displayName,
    String? avatarUrl,
    @Default(false) bool isMe,
    @Default(0) int streak,
    @JsonKey(name: 'last_active') DateTime? lastActive,
    @JsonKey(name: 'unread_story_ids') @Default([]) List<String> unreadStoryIds,
    @Default(false) bool isViewed,
  }) = _StoryUser;

  factory StoryUser.fromJson(Map<String, dynamic> json) => _$StoryUserFromJson(json);
}

@freezed
class StorySegment with _$StorySegment {
  const factory StorySegment({
    required String id,
    @JsonKey(name: 'story_id') required String storyId,
    @JsonKey(name: 'media_type') required StoryMediaType mediaType,
    @JsonKey(name: 'media_url') required String mediaUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @Default(5) int duration,
    @JsonKey(name: 'text_content') String? textContent,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _StorySegment;

  factory StorySegment.fromJson(Map<String, dynamic> json) => _$StorySegmentFromJson(json);
}

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @Default([]) List<StorySegment> segments,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @Default(false) bool isViewed,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'reaction_count') @Default(0) int reactionCount,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

@freezed
class StoryReaction with _$StoryReaction {
  const factory StoryReaction({
    required String id,
    @JsonKey(name: 'story_id') required String storyId,
    @JsonKey(name: 'user_id') required String userId,
    required String emoji,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _StoryReaction;

  factory StoryReaction.fromJson(Map<String, dynamic> json) => _$StoryReactionFromJson(json);
}

@Freezed(unionKey: 'type')
class StoryInteractiveElement with _$StoryInteractiveElement {
  const factory StoryInteractiveElement.poll({
    required String id,
    required String question,
    @Default([]) List<String> options,
    @Default({}) Map<String, int> votes,
  }) = _StoryPollElement;

  const factory StoryInteractiveElement.slider({
    required String id,
    @Default(0.0) double min,
    @Default(100.0) double max,
    @Default(0.0) double value,
    required String label,
  }) = _StorySliderElement;

  const factory StoryInteractiveElement.qna({
    required String id,
    required String question,
    @Default([]) List<String> answers,
  }) = _StoryQnaElement;

  const factory StoryInteractiveElement.sticker({
    required String id,
    required String url,
    @Default(0.0) double x,
    @Default(0.0) double y,
    @Default(1.0) double scale,
  }) = _StoryStickerElement;

  factory StoryInteractiveElement.fromJson(Map<String, dynamic> json) => _$StoryInteractiveElementFromJson(json);
}
