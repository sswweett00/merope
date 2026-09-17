import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_models/stories/story_model.dart' as model;

class StoryInteractions extends StatelessWidget {
  const StoryInteractions({
    super.key,
    required this.segment,
    required this.tokens,
    required this.onReply,
    required this.onReact,
  });
  final model.StorySegment segment;
  final MeropeColorTokens tokens;
  final VoidCallback onReply;
  final Function(String) onReact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: _StoryReplyField(onTap: onReply, tokens: tokens),
          ),
          const SizedBox(width: 16),
          _StoryAction(
            icon: Icons.favorite_border_rounded,
            onTap: () => onReact('❤️'),
            tokens: tokens,
          ),
          const SizedBox(width: 12),
          _StoryAction(
            icon: Icons.send_rounded,
            onTap: () {},
            tokens: tokens,
          ),
        ],
      ),
    );
  }
}

class _StoryReplyField extends StatelessWidget {
  const _StoryReplyField({required this.onTap, required this.tokens});
  final VoidCallback onTap;
  final MeropeColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          color: Colors.black.withValues(alpha: 0.1),
        ),
        child: Row(
          children: [
            Text(
              'Mesaj gönder...',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryAction extends StatelessWidget {
  const _StoryAction(
      {required this.icon, required this.onTap, required this.tokens});
  final IconData icon;
  final VoidCallback onTap;
  final MeropeColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 28),
      onPressed: onTap,
    );
  }
}
