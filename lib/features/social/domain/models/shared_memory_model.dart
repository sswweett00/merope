import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:merope_models/social/post_model.dart';

part 'shared_memory_model.freezed.dart';
part 'shared_memory_model.g.dart';

enum MemoryItemType { signal, media, liveRecord, pollResult, note }

@freezed
class SharedMemoryItem with _$SharedMemoryItem {
  const factory SharedMemoryItem({
    required String id,
    required String authorId,
    required String authorName,
    required MemoryItemType type,
    required DateTime timestamp,
    required String content,
    String? mediaUrl,
    Map<String, dynamic>? metadata,
  }) = _SharedMemoryItem;

  factory SharedMemoryItem.fromJson(Map<String, dynamic> json) => _$SharedMemoryItemFromJson(json);
}

@freezed
class SharedMemory with _$SharedMemory {
  const factory SharedMemory({
    required String id,
    required String title,
    required String description,
    required String coverUrl,
    required List<MeropeAuthor> participants,
    required DateTime date,
    required List<SharedMemoryItem> timeline,
    String? location,
    @Default([]) List<String> tags,
  }) = _SharedMemory;

  factory SharedMemory.fromJson(Map<String, dynamic> json) => _$SharedMemoryFromJson(json);
}
