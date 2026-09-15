import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class PrismGridProfile extends ConsumerWidget {
  const PrismGridProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            backgroundColor: tokens.primary,
            child: const Icon(Icons.blur_on, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 12),
          Text(
            'Prism Curator',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: tokens.textPrimary),
          ),
          Text(
            'Refracting Light into Neural Art',
            style: TextStyle(color: tokens.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
                  border: Border.all(color: tokens.border.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Icon(Icons.grain, color: tokens.primary.withValues(alpha: 0.3)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
