import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../logic/settings_provider.dart';

class PrivacySettingsScreen extends ConsumerWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final settings = ref.watch(meropeSettingsProvider);
    final notifier = ref.read(meropeSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: tokens.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Security Apex'),
            backgroundColor: tokens.surface,
            actions: [
              _PrivacyBadge(level: settings.privacyLevel),
              const SizedBox(width: 16),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSecurityDashboard(tokens, settings),
              const Divider(),
              _buildSectionTitle(tokens, 'Deniability (Ether Layer)'),
              SwitchListTile(
                title: const Text('Decoy Environment'),
                subtitle: const Text('Enables the duress passkey logic'),
                value: settings.decoyEnabled,
                onChanged: (v) => notifier.setDecoyEnabled(v),
              ),
              SwitchListTile(
                title: const Text('Constant Bitrate (CBR)'),
                subtitle: const Text('Masks traffic timing patterns'),
                value: settings.cbrEnabled,
                onChanged: (v) => notifier.setCbrEnabled(v),
              ),
              const Divider(),
              _buildSectionTitle(tokens, 'Invisible Metadata (Phantom Layer)'),
              SwitchListTile(
                title: const Text('Metadata Stego-Shield'),
                subtitle: const Text('Embeds hidden provenance in media'),
                value: settings.stegoEnabled,
                onChanged: (v) => notifier.setStegoEnabled(v),
              ),
              const Divider(),
              _buildSectionTitle(tokens, 'Identity Anchoring'),
              ListTile(
                title: const Text('StrongBox Identity Rotation'),
                subtitle: Text('Last rotated: ${settings.lastRotationDate}'),
                trailing: const Icon(Icons.refresh),
                onTap: () => notifier.rotateIdentity(),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityDashboard(MeropeColorTokens tokens, MeropeSettingsState settings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [tokens.primary, tokens.primaryVariant]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Safety Score', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('${settings.safetyScore}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: settings.safetyScore / 100, backgroundColor: Colors.white24, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(MeropeColorTokens tokens, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: TextStyle(color: tokens.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }
}

class _PrivacyBadge extends StatelessWidget {
  final String level;
  const _PrivacyBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(level),
      backgroundColor: level == 'Titan' ? Colors.amber : Colors.green,
      labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    );
  }
}
