import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class ResonanceStreakWidget extends StatelessWidget {
  final int streak;
  final MeropeColorTokens tokens;

  const ResonanceStreakWidget({
    super.key,
    required this.streak,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    if (streak == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
        border: Border.all(color: tokens.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: tokens.secondary, size: 16),
          const SizedBox(width: 4),
          Text(
            '$streak DAY STREAK',
            style: TextStyle(
              color: tokens.secondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
