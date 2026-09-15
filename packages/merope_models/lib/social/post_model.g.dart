// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeropeAuthorImpl _$$MeropeAuthorImplFromJson(Map<String, dynamic> json) =>
    _$MeropeAuthorImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      influenceScore: (json['influence_score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$MeropeAuthorImplToJson(_$MeropeAuthorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'is_verified': instance.isVerified,
      'influence_score': instance.influenceScore,
    };

_$SignalResonanceImpl _$$SignalResonanceImplFromJson(
        Map<String, dynamic> json) =>
    _$SignalResonanceImpl(
      type: json['type'] as String,
      amplitude: (json['amplitude'] as num).toInt(),
      isResonated: json['is_resonated'] as bool? ?? false,
    );

Map<String, dynamic> _$$SignalResonanceImplToJson(
        _$SignalResonanceImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'amplitude': instance.amplitude,
      'is_resonated': instance.isResonated,
    };

_$SignalMediaImpl _$$SignalMediaImplFromJson(Map<String, dynamic> json) =>
    _$SignalMediaImpl(
      url: json['url'] as String,
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      thumbnailUrl: json['thumbnail_url'] as String?,
      metadata: json['metadata'] as String?,
    );

Map<String, dynamic> _$$SignalMediaImplToJson(_$SignalMediaImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'thumbnail_url': instance.thumbnailUrl,
      'metadata': instance.metadata,
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.audio: 'audio',
  MediaType.link: 'link',
  MediaType.sticker: 'sticker',
  MediaType.gif: 'gif',
};

_$PostLayerImpl _$$PostLayerImplFromJson(Map<String, dynamic> json) =>
    _$PostLayerImpl(
      index: (json['index'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => SignalMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PostLayerImplToJson(_$PostLayerImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'title': instance.title,
      'content': instance.content,
      'media': instance.media,
      'metadata': instance.metadata,
    };

_$MeropeAppCardImpl _$$MeropeAppCardImplFromJson(Map<String, dynamic> json) =>
    _$MeropeAppCardImpl(
      id: json['id'] as String,
      type: $enumDecode(_$AppCardTypeEnumMap, json['type']),
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$MeropeAppCardImplToJson(_$MeropeAppCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AppCardTypeEnumMap[instance.type]!,
      'data': instance.data,
    };

const _$AppCardTypeEnumMap = {
  AppCardType.poll: 'poll',
  AppCardType.todo: 'todo',
  AppCardType.code: 'code',
  AppCardType.countdown: 'countdown',
  AppCardType.unknown: 'unknown',
};

_$MeropeSignalImpl _$$MeropeSignalImplFromJson(Map<String, dynamic> json) =>
    _$MeropeSignalImpl(
      id: json['id'] as String,
      author: MeropeAuthor.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => SignalMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      resonances: (json['resonances'] as List<dynamic>?)
              ?.map((e) => SignalResonance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      layers: (json['layers'] as List<dynamic>?)
              ?.map((e) => PostLayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => MeropeAppCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nodeCount: (json['node_count'] as num?)?.toInt() ?? 0,
      amplificationCount: (json['amplification_count'] as num?)?.toInt() ?? 0,
      createdAt: (json['created_at'] as num).toInt(),
      isPinned: json['is_pinned'] as bool? ?? false,
      effect: json['effect'] as String?,
      resonanceFrequency:
          (json['resonance_frequency'] as num?)?.toDouble() ?? 0.0,
      repostOf: json['repost_of'] == null
          ? null
          : MeropeSignal.fromJson(json['repost_of'] as Map<String, dynamic>),
      quote: json['quote'] as String?,
      isBoosted: json['is_boosted'] as bool? ?? false,
      burnAt: (json['burn_at'] as num?)?.toInt(),
      neuralSummary: json['neural_summary'] as String?,
    );

Map<String, dynamic> _$$MeropeSignalImplToJson(_$MeropeSignalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'content': instance.content,
      'media': instance.media,
      'resonances': instance.resonances,
      'layers': instance.layers,
      'cards': instance.cards,
      'node_count': instance.nodeCount,
      'amplification_count': instance.amplificationCount,
      'created_at': instance.createdAt,
      'is_pinned': instance.isPinned,
      'effect': instance.effect,
      'resonance_frequency': instance.resonanceFrequency,
      'repost_of': instance.repostOf,
      'quote': instance.quote,
      'is_boosted': instance.isBoosted,
      'burn_at': instance.burnAt,
      'neural_summary': instance.neuralSummary,
    };
