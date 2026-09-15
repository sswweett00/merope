import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/social_api.dart';
import 'package:merope_models/auth/auth_user.dart';
import 'package:merope_ui/merope_ui.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key, required this.post});
  final SignalModel post;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _showEmoji = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: Column(
        children: [
          Expanded(child: _buildPostContent(context)),
          _CommentComposer(
            controller: _commentController,
            showEmoji: _showEmoji,
            onToggleEmoji: () {
              setState(() => _showEmoji = !_showEmoji);
              if (_showEmoji) FocusScope.of(context).unfocus();
            },
            onSubmit: _submitComment,
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(widget.post.contentText),
      ],
    );
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    _commentController.clear();
  }
}

class _CommentComposer extends StatelessWidget {
  const _CommentComposer({
    required this.controller,
    required this.showEmoji,
    required this.onToggleEmoji,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool showEmoji;
  final VoidCallback onToggleEmoji;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(showEmoji ? Icons.keyboard_rounded : Icons.emoji_emotions_outlined),
            onPressed: onToggleEmoji,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
