import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';

class TimelinePostCard extends ConsumerStatefulWidget {
  final String author;
  final String handle;
  final String time;
  final String content;
  final int likesCount;
  final int retweetsCount;
  final int commentsCount;

  const TimelinePostCard({
    super.key,
    required this.author,
    required this.handle,
    required this.time,
    required this.content,
    required this.likesCount,
    required this.retweetsCount,
    required this.commentsCount,
  });

  @override
  ConsumerState<TimelinePostCard> createState() => _TimelinePostCardState();
}

class _TimelinePostCardState extends ConsumerState<TimelinePostCard> {
  String? _selectedReaction;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.likesCount;
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Padding(
      padding: const EdgeInsets.only(bottom: MeropeTokens.space12),
      child: MeropeCard(
        color: tokens.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Row
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: tokens.primary,
                  child: Text(widget.author[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: MeropeTokens.space12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(widget.author, style: TextStyle(fontWeight: FontWeight.bold, color: tokens.textPrimary)),
                        const SizedBox(width: 6),
                        Icon(Icons.verified, color: tokens.primary, size: 16),
                      ],
                    ),
                    Text('${widget.handle} • ${widget.time}', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: tokens.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: MeropeTokens.space12),
            // Text Content
            Text(
              widget.content,
              style: TextStyle(color: tokens.textPrimary, fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: MeropeTokens.space16),
            const Divider(),
            // Facebook/Twitter Style Interaction Bar (Reactions, Repulse, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reaction Picker Menu
                PopupMenuButton<String>(
                  tooltip: 'Tepki Ver',
                  icon: Row(
                    children: [
                      Text(_selectedReaction ?? '👍', style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 4),
                      Text('$_likes', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
                    ],
                  ),
                  onSelected: (reaction) {
                    setState(() {
                      if (_selectedReaction == reaction) {
                        _selectedReaction = null;
                        _likes--;
                      } else {
                        if (_selectedReaction == null) _likes++;
                        _selectedReaction = reaction;
                      }
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: '👍', child: Text('👍 Beğen')),
                    const PopupMenuItem(value: '❤️', child: Text('❤️ Sevdim')),
                    const PopupMenuItem(value: '😂', child: Text('😂 Gülünç')),
                    const PopupMenuItem(value: '😲', child: Text('😲 Vay Canına')),
                    const PopupMenuItem(value: '😢', child: Text('😢 Üzücü')),
                    const PopupMenuItem(value: '🔥', child: Text('🔥 Ateş')),
                  ],
                ),
                // Comment Action
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.chat_bubble_outline, size: 18, color: tokens.textSecondary),
                  label: Text('${widget.commentsCount}', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
                ),
                // Re-pulse Action
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profilinizde Yeniden Paylaşıldı!')),
                    );
                  },
                  icon: Icon(Icons.repeat, size: 18, color: tokens.textSecondary),
                  label: Text('${widget.retweetsCount}', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
                ),
                // Share Action
                IconButton(
                  icon: Icon(Icons.share_outlined, size: 18, color: tokens.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
