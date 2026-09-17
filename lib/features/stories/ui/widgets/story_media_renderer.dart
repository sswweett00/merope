import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_models/stories/story_model.dart' as model;

class StoryMediaRenderer extends StatelessWidget {
  const StoryMediaRenderer({super.key, required this.segment});
  final model.StorySegment segment;

  @override
  Widget build(BuildContext context) {
    switch (segment.mediaType) {
      case model.StoryMediaType.image:
        return MeropeImage(
          imageUrl: segment.mediaUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      case model.StoryMediaType.video:
        return const Center(
          child: Text('Video Story (Preview)',
              style: TextStyle(color: Colors.white)),
        );
      case model.StoryMediaType.text:
        return _TextStory(segment: segment);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TextStory extends StatelessWidget {
  const _TextStory({required this.segment});
  final model.StorySegment segment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Text(
        segment.textContent ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
