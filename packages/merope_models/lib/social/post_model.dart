// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class MeropeAuthor with _$MeropeAuthor {
  const factory MeropeAuthor({
    required String id,
    required String username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'influence_score') @Default(0.0) double influenceScore,
  }) = _MeropeAuthor;

  factory MeropeAuthor.fromJson(Map<String, dynamic> json) =>
      _$MeropeAuthorFromJson(json);
}

@freezed
class SignalResonance with _$SignalResonance {
  const factory SignalResonance({
    required String type, // resonance, sync, flash
    required int amplitude, // Replaces count
    @JsonKey(name: 'is_resonated') @Default(false) bool isResonated,
  }) = _SignalResonance;

  factory SignalResonance.fromJson(Map<String, dynamic> json) =>
      _$SignalResonanceFromJson(json);
}

enum MediaType { image, video, audio, link, sticker, gif }

@freezed
class SignalMedia with _$SignalMedia {
  const factory SignalMedia({
    required String url,
    required MediaType type,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    String? metadata,
  }) = _SignalMedia;

  factory SignalMedia.fromJson(Map<String, dynamic> json) =>
      _$SignalMediaFromJson(json);
}

@freezed
class PostLayer with _$PostLayer {
  const factory PostLayer({
    required int index,
    required String title,
    required String content,
    @Default([]) List<SignalMedia> media,
    Map<String, dynamic>? metadata,
  }) = _PostLayer;

  factory PostLayer.fromJson(Map<String, dynamic> json) =>
      _$PostLayerFromJson(json);
}

enum AppCardType { poll, todo, code, countdown, unknown }

@freezed
class MeropeAppCard with _$MeropeAppCard {
  const factory MeropeAppCard({
    required String id,
    required AppCardType type,
    required Map<String, dynamic> data,
  }) = _MeropeAppCard;

  factory MeropeAppCard.fromJson(Map<String, dynamic> json) =>
      _$MeropeAppCardFromJson(json);
}

@freezed
class MeropeSignal with _$MeropeSignal {
  const factory MeropeSignal({
    required String id,
    required MeropeAuthor author,
    required String content,
    @Default([]) List<SignalMedia> media,
    @Default([]) List<SignalResonance> resonances,
    @Default([]) List<PostLayer> layers,
    @Default([]) List<MeropeAppCard> cards,
    @JsonKey(name: 'node_count') @Default(0) int nodeCount,
    @JsonKey(name: 'amplification_count') @Default(0) int amplificationCount,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'is_pinned') @Default(false) bool isPinned,
    String? effect,
    @JsonKey(name: 'resonance_frequency')
    @Default(0.0)
    double resonanceFrequency,
    @JsonKey(name: 'repost_of') MeropeSignal? repostOf,
    String? quote,

    // Apex Mechanics
    @JsonKey(name: 'is_boosted') @Default(false) bool isBoosted,
    @JsonKey(name: 'burn_at') int? burnAt,
    @JsonKey(name: 'neural_summary') String? neuralSummary,
  }) = _MeropeSignal;

  factory MeropeSignal.fromJson(Map<String, dynamic> json) =>
      _$MeropeSignalFromJson(json);
}
