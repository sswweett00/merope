import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class ReactionPicker extends StatelessWidget {
  final Function(String) onReactionSelected;
  final List<String> reactions;

  const ReactionPicker({
    super.key,
    required this.onReactionSelected,
    this.reactions = const ['❤️', '👍', '🔥', '😮', '😢', '👏'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
        boxShadow: const [MeropeTokens.shadowMd],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((emoji) {
          return InkWell(
            onTap: () => onReactionSelected(emoji),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
