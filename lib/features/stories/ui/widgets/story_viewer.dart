import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_models/stories/story_model.dart' as model;
import '../../logic/story_player_controller.dart';
import 'story_media_renderer.dart';
import 'story_progress_bar.dart';
import 'story_interactions.dart';
import 'story_reply_bar.dart';

class StoryViewer extends ConsumerWidget {
  const StoryViewer({super.key, required this.story, required this.onComplete});
  final model.Story story;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (story.segments.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text('No segments', style: TextStyle(color: Colors.white))),
      );
    }

    final controller = ref.watch(storyPlayerControllerProvider(story));
    final tokens = ref.watch(themeProvider).currentTokens;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Media Layer
          GestureDetector(
            onTapDown: (details) {
              final width = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < width / 3) {
                ref.read(storyPlayerControllerProvider(story).notifier).previous();
              } else if (details.globalPosition.dx > 2 * width / 3) {
                ref.read(storyPlayerControllerProvider(story).notifier).next();
              }
            },
            onLongPressStart: (_) => ref.read(storyPlayerControllerProvider(story).notifier).pause(),
            onLongPressEnd: (_) => ref.read(storyPlayerControllerProvider(story).notifier).resume(),
            child: StoryMediaRenderer(segment: story.segments[controller.currentIndex]),
          ),

          // Header
          SafeArea(
            child: Column(
              children: [
                StoryProgressBar(
                  segments: story.segments,
                  currentIndex: controller.currentIndex,
                  progress: controller.progress,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      MeropeImage.avatar(
                        imageUrl: null,
                        radius: 18,
                        initials: story.userId.isNotEmpty ? story.userId[0] : '?',
                      ),
                      const SizedBox(width: 12),
                      Text(
                        story.userId,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: onComplete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: StoryInteractions(
                segment: story.segments[controller.currentIndex],
                tokens: tokens,
                onReply: () => _showReplyBar(context, ref, tokens),
                onReact: (emoji) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyBar(BuildContext context, WidgetRef ref, MeropeColorTokens tokens) {
    ref.read(storyPlayerControllerProvider(story).notifier).pause();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StoryReplyBar(
        story: story,
        tokens: tokens,
        onSend: (msg) {
          Navigator.pop(context);
        },
      ),
    ).then((_) {
      if (context.mounted) {
        ref.read(storyPlayerControllerProvider(story).notifier).resume();
      }
    });
  }
}
