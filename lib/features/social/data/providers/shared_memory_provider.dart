import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_models/social/post_model.dart';
import '../../domain/models/shared_memory_model.dart';

class SharedMemoryList extends AsyncNotifier<List<SharedMemory>> {
  @override
  FutureOr<List<SharedMemory>> build() async {
    // Simulated fetch from production backend
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      SharedMemory(
        id: 'mem_1',
        title: 'Merope Global Launch Event',
        description: 'The day we synchronized the world.',
        coverUrl:
            'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070',
        date: DateTime(2026, 7, 15),
        participants: [
          MeropeAuthor(
            id: 'me',
            username: 'merope_user',
            isVerified: true,
          ),
          MeropeAuthor(
            id: 'a1',
            username: 'vanguard',
            displayName: 'Tech Vanguard',
          ),
        ],
        tags: ['Launch', 'Nexus', 'Future'],
        timeline: [
          SharedMemoryItem(
            id: 'i1',
            authorId: 'me',
            authorName: 'Merope Explorer',
            type: MemoryItemType.signal,
            timestamp: DateTime(2026, 7, 15, 8, 15),
            content: 'Arrival at the high-bandwidth zone!',
          ),
          SharedMemoryItem(
            id: 'i2',
            authorId: 'a1',
            authorName: 'Tech Vanguard',
            type: MemoryItemType.media,
            timestamp: DateTime(2026, 7, 15, 8, 22),
            content: 'Check out the neural visuals!',
            mediaUrl:
                'https://images.unsplash.com/photo-1614850523296-d8c1af93d400?q=80&w=2070',
          ),
        ],
      ),
    ];
  }
}

final sharedMemoryListProvider =
    AsyncNotifierProvider<SharedMemoryList, List<SharedMemory>>(
        SharedMemoryList.new);
