import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class StoryInteractiveLayer extends ConsumerWidget {
  const StoryInteractiveLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Stack(
      children: [
        // Poll Widget
        Center(
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Next Planet to Visit?",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
                const SizedBox(height: 16),
                _PollOption(label: "Mars 🔴", percentage: 65, tokens: tokens),
                const SizedBox(height: 8),
                _PollOption(
                    label: "Jupiter 🪐", percentage: 35, tokens: tokens),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PollOption extends StatelessWidget {
  final String label;
  final int percentage;
  final dynamic tokens;

  const _PollOption(
      {required this.label, required this.percentage, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black87)),
                Text("%$percentage",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
