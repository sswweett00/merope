import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class ChatSummaryCard extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatSummaryCard({super.key, required this.conversationId});

  @override
  ConsumerState<ChatSummaryCard> createState() => _ChatSummaryCardState();
}

class _ChatSummaryCardState extends ConsumerState<ChatSummaryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        duration: MeropeTokens.durationNormal,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: tokens.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tokens.primary.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, size: 16, color: tokens.primary),
                const SizedBox(width: 8),
                Text(
                  "AI Summary",
                  style: TextStyle(
                    color: tokens.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: tokens.textSecondary,
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 8),
              Text(
                "Users discussed the upcoming project deadline and agreed to finalize the requirements by Friday. John will handle the backend while Sarah focuses on the UI components.",
                style: TextStyle(
                  color: tokens.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
