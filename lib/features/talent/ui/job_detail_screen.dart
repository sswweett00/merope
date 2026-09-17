import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import '../data/providers/talent_provider.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import 'package:merope_core/utils/merope_acoustics.dart';

class JobDetailScreen extends ConsumerWidget {
  final TalentJob job;
  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text('Opportunity Details',
            style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: tokens.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
                  ),
                  child: Icon(Icons.business, color: tokens.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title,
                          style: TextStyle(
                              color: tokens.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text('${job.company} • ${job.location}',
                          style: TextStyle(
                              color: tokens.textSecondary, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: 'Description', tokens: tokens),
            Text(
              'We are seeking a high-performance individual to join our neural core team. Experience with distributed systems and real-time social OS architecture is a plus.',
              style: TextStyle(
                  color: tokens.textPrimary, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 24),
            _SectionHeader(title: 'Requirements', tokens: tokens),
            ...job.tags.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: tokens.secondary, size: 16),
                      const SizedBox(width: 8),
                      Text(t,
                          style: TextStyle(
                              color: tokens.textPrimary, fontSize: 14)),
                    ],
                  ),
                )),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tokens.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Compensation',
                          style: TextStyle(
                              color: tokens.textSecondary, fontSize: 12)),
                      Text(job.compensation,
                          style: TextStyle(
                              color: tokens.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  MeropeButton(
                    text: 'One-Tap Apply',
                    onPressed: () {
                      MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
                      MeropeAcoustics.trigger(AcousticEffect.resonance);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Profile Alignment shared with recruiter!')),
                      );
                      context.pop();
                    },
                    style: MeropeButtonStyle.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final MeropeColorTokens tokens;
  const _SectionHeader({required this.title, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
            color: tokens.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5),
      ),
    );
  }
}
