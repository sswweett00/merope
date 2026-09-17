import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text(
            _currentStep == 0
                ? 'Verified Status'
                : 'Handshake Phase $_currentStep',
            style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
      ),
      body: AnimatedSwitcher(
        duration: MeropeTokens.durationNormal,
        child:
            _currentStep == 0 ? _buildIntro(tokens) : _buildUploadStep(tokens),
      ),
    );
  }

  Widget _buildIntro(MeropeColorTokens tokens) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      key: const ValueKey(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: tokens.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.verified, color: tokens.primary, size: 48),
          ),
          const SizedBox(height: 32),
          Text(
            'Identity Handshake',
            style: TextStyle(
                color: tokens.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Apply for official node verification to increase your synergy limits and influence score.',
            style: TextStyle(color: tokens.textSecondary, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _VerificationRequirement(
            icon: Icons.badge_outlined,
            title: 'Official Identity',
            subtitle: 'Passport or National ID scan.',
            tokens: tokens,
          ),
          _VerificationRequirement(
            icon: Icons.alternate_email,
            title: 'Professional Domain',
            subtitle: 'Verify work email address.',
            tokens: tokens,
          ),
          _VerificationRequirement(
            icon: Icons.shield_moon_outlined,
            title: 'Legacy Security',
            subtitle: 'Account active for > 30 days.',
            tokens: tokens,
          ),
          const SizedBox(height: 64),
          MeropeButton(
            text: 'Begin Verification',
            onPressed: () => setState(() => _currentStep = 1),
            style: MeropeButtonStyle.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadStep(MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.all(24),
      key: const ValueKey(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 64, color: tokens.primary),
          const SizedBox(height: 32),
          Text('Upload National ID',
              style: TextStyle(
                  color: tokens.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('Ensure all edges are visible and the image is clear.',
              style: TextStyle(color: tokens.textSecondary, fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 48),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: tokens.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: tokens.primary.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.none), // Simulated border
            ),
            child: Icon(Icons.add_a_photo_outlined,
                color: tokens.textSecondary, size: 32),
          ),
          const SizedBox(height: 48),
          MeropeButton(
            text: 'Simulate Upload',
            onPressed: () {
              MeropeHaptics.neuralSyncPulse();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Identity packet transmitted.')));
              setState(() => _currentStep = 0);
            },
            style: MeropeButtonStyle.primary,
          ),
        ],
      ),
    );
  }
}

class _VerificationRequirement extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final MeropeColorTokens tokens;

  const _VerificationRequirement({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, color: tokens.primary, size: 24),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(subtitle,
                    style:
                        TextStyle(color: tokens.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: tokens.border, size: 16),
        ],
      ),
    );
  }
}
