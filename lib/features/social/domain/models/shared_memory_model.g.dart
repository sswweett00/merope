// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_memory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SharedMemoryItemImpl _$$SharedMemoryItemImplFromJson(
        Map<String, dynamic> json) =>
    _$SharedMemoryItemImpl(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      type: $enumDecode(_$MemoryItemTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      content: json['content'] as String,
      mediaUrl: json['mediaUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SharedMemoryItemImplToJson(
        _$SharedMemoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'type': _$MemoryItemTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'content': instance.content,
      'mediaUrl': instance.mediaUrl,
      'metadata': instance.metadata,
    };

const _$MemoryItemTypeEnumMap = {
  MemoryItemType.signal: 'signal',
  MemoryItemType.media: 'media',
  MemoryItemType.liveRecord: 'liveRecord',
  MemoryItemType.pollResult: 'pollResult',
  MemoryItemType.note: 'note',
};

_$SharedMemoryImpl _$$SharedMemoryImplFromJson(Map<String, dynamic> json) =>
    _$SharedMemoryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => MeropeAuthor.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: DateTime.parse(json['date'] as String),
      timeline: (json['timeline'] as List<dynamic>)
          .map((e) => SharedMemoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$SharedMemoryImplToJson(_$SharedMemoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'coverUrl': instance.coverUrl,
      'participants': instance.participants,
      'date': instance.date.toIso8601String(),
      'timeline': instance.timeline,
      'location': instance.location,
      'tags': instance.tags,
    };
