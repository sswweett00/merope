import 'package:flutter/material.dart';
import 'package:merope_models/stories/story_model.dart' as model;

class StoryProgressBar extends StatelessWidget {
  const StoryProgressBar({
    super.key,
    required this.segments,
    required this.currentIndex,
    required this.progress,
  });
  final List<model.StorySegment> segments;
  final int currentIndex;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: List.generate(
          segments.length,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1),
              ),
              child: index < currentIndex
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    )
                  : index == currentIndex
                      ? LayoutBuilder(
                          builder: (context, constraints) => Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: constraints.maxWidth * progress,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
