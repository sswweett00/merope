import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_models/stories/story_model.dart' as model;

class StoryReplyBar extends StatefulWidget {
  const StoryReplyBar({
    super.key,
    required this.story,
    required this.tokens,
    required this.onSend,
  });
  final model.Story story;
  final MeropeColorTokens tokens;
  final Function(String) onSend;

  @override
  State<StoryReplyBar> createState() => _StoryReplyBarState();
}

class _StoryReplyBarState extends State<StoryReplyBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: widget.tokens.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: TextStyle(color: widget.tokens.textPrimary),
              decoration: InputDecoration(
                hintText: 'Mesaj gönder...',
                hintStyle: TextStyle(
                    color: widget.tokens.textSecondary.withValues(alpha: 0.6)),
                border: InputBorder.none,
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  widget.onSend(val.trim());
                  _controller.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send_rounded, color: widget.tokens.primary),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                widget.onSend(_controller.text.trim());
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
