import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class AISuggestionsBar extends ConsumerWidget {
  final String conversationId;
  final Function(String) onSuggestionTap;

  const AISuggestionsBar({
    super.key,
    required this.conversationId,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    // In a real app, this would be a provider that fetches suggestions from the backend
    final suggestions = [
      "Sounds good!",
      "I'm on my way.",
      "Can we reschedule?",
      "Send me the link.",
      "Check this out 🚀",
    ];

    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              suggestions[index],
              style: TextStyle(color: tokens.primary, fontSize: 12),
            ),
            backgroundColor: tokens.primary.withValues(alpha: 0.1),
            side: BorderSide(color: tokens.primary.withValues(alpha: 0.2)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () => onSuggestionTap(suggestions[index]),
          );
        },
      ),
    );
  }
}
