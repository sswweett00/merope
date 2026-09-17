import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/soundscape_provider.dart';
import 'package:merope_ui/widgets/merope_card.dart';

class ForgeSandboxScreen extends ConsumerWidget {
  const ForgeSandboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final soundscape = ref.watch(soundscapeProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text('Forge Design Sandbox',
            style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(MeropeTokens.space24),
        children: [
          Text(
            'Acoustic & Haptic Profile',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary),
          ),
          const SizedBox(height: MeropeTokens.space12),
          MeropeCard(
            color: tokens.surface,
            child: RadioGroup<SoundscapeProfile>(
              groupValue: soundscape,
              onChanged: (val) {
                if (val != null) {
                  ref.read(soundscapeProvider.notifier).setProfile(val);
                }
              },
              child: Column(
                children: SoundscapeProfile.values.map((profile) {
                  return RadioListTile<SoundscapeProfile>(
                    title: Text(profile.label,
                        style: TextStyle(color: tokens.textPrimary)),
                    value: profile,
                    activeColor: tokens.primary,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: MeropeTokens.space24),
          Text(
            'Interactive Component Stress Test',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary),
          ),
          const SizedBox(height: MeropeTokens.space12),
          ElevatedButton(
            onPressed: () {
              soundscape.playFeedback();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text('Forge Feedback Triggered'),
                    backgroundColor: tokens.primary),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: tokens.primary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MeropeTokens.radiusMd)),
            ),
            child: Text('Test Haptic & Acoustic Response',
                style: TextStyle(color: tokens.onPrimary)),
          ),
        ],
      ),
    );
  }
}
