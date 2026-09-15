import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/stories_provider.dart';
import '../widgets/story_viewer.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyProvider(userId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: storyAsync.when(
        data: (story) => StoryViewer(
          story: story,
          onComplete: () => Navigator.of(context).pop(),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (err, _) => Center(
          child: Text(
            'Failed to load story: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
