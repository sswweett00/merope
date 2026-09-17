import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../data/providers/signal_comments_provider.dart';
import '../data/providers/signal_provider.dart';
import 'nexus_timeline_card.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key, required this.postId});
  final String postId;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      ref
          .read(signalCommentsProvider(widget.postId).notifier)
          .addComment(_commentController.text.trim());
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final signalAsync = ref.watch(signalProvider(widget.postId));
    final commentsAsync = ref.watch(signalCommentsProvider(widget.postId));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: tokens.surface,
        elevation: 0,
      ),
      body: signalAsync.when(
        data: (signal) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: NexusTimelineCard(signal: signal),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'Comments',
                  style: TextStyle(
                    color: tokens.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            commentsAsync.when(
              data: (comments) => comments.isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'Henüz yorum yapılmamış. İlk düğümü siz ekleyin!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _CommentNode(
                          author: comments[index]['author'] as String,
                          content: comments[index]['content'] as String,
                          tokens: tokens,
                        ),
                        childCount: comments.length,
                      ),
                    ),
              loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator())),
              error: (err, _) =>
                  SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load post: $err')),
      ),
      bottomSheet: _CommentInputBar(
        controller: _commentController,
        tokens: tokens,
        onSend: _submitComment,
      ),
    );
  }
}

class _CommentNode extends StatelessWidget {
  const _CommentNode({
    required this.author,
    required this.content,
    required this.tokens,
  });
  final String author;
  final String content;
  final MeropeColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 48,
            padding: const EdgeInsets.only(left: 24),
            child: Center(
              child: Container(
                width: 2,
                color: tokens.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 24, top: 12, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: tokens.primary.withValues(alpha: 0.1),
                    child: Text(author.isNotEmpty ? author[0] : '?',
                        style: TextStyle(color: tokens.primary, fontSize: 12)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(author,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: tokens.textPrimary,
                                    fontSize: 14)),
                            const SizedBox(width: 8),
                            Text('2h ago',
                                style: TextStyle(
                                    color: tokens.textSecondary, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          content,
                          style: TextStyle(
                              color: tokens.textSecondary,
                              fontSize: 13,
                              height: 1.4),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _SmallAction(
                                icon: Icons.favorite_border,
                                label: '12',
                                tokens: tokens),
                            const SizedBox(width: 16),
                            _SmallAction(
                                icon: Icons.bubble_chart_outlined,
                                label: 'Reply',
                                tokens: tokens),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction(
      {required this.icon, required this.label, required this.tokens});
  final IconData icon;
  final String label;
  final MeropeColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => MeropeHaptics.trigger(MeropeTokens.hapticSoft),
      child: Row(
        children: [
          Icon(icon, size: 14, color: tokens.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(color: tokens.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _CommentInputBar extends StatefulWidget {
  const _CommentInputBar({
    required this.controller,
    required this.tokens,
    required this.onSend,
  });
  final TextEditingController controller;
  final MeropeColorTokens tokens;
  final VoidCallback onSend;

  @override
  State<_CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<_CommentInputBar> {
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: widget.tokens.surface,
            border: Border(
                top: BorderSide(
                    color: widget.tokens.border.withValues(alpha: 0.2))),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _showEmoji
                      ? Icons.keyboard_rounded
                      : Icons.emoji_emotions_outlined,
                  color: widget.tokens.primary,
                ),
                onPressed: () {
                  setState(() => _showEmoji = !_showEmoji);
                  if (_showEmoji) FocusScope.of(context).unfocus();
                },
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  onTap: () {
                    if (_showEmoji) setState(() => _showEmoji = false);
                  },
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    filled: true,
                    fillColor: widget.tokens.background,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => widget.onSend(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.send, color: widget.tokens.primary),
                onPressed: widget.onSend,
              ),
            ],
          ),
        ),
        if (_showEmoji)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                widget.controller.text += emoji.emoji;
              },
              config: Config(
                indicatorColor: widget.tokens.primary,
                iconColorSelected: widget.tokens.primary,
                backspaceColor: widget.tokens.primary,
                skinToneDialogBgColor: widget.tokens.surface,
                skinToneIndicatorColor: widget.tokens.primary,
                enableSkinTones: true,
                recentTabBehavior: RecentTabBehavior.RECENT,
                recentsLimit: 28,
                noRecents: const Text('Henüz bir şey yok',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center),
                loadingIndicator: const SizedBox.shrink(),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          ),
      ],
    );
  }
}
