import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import '../../auth/logic/auth_logic.dart';

import 'package:go_router/go_router.dart';
import 'privacy_settings_screen.dart';
import 'security_settings_screen.dart';
import 'data_usage_screen.dart';
import 'edit_profile_screen.dart';
import 'theme_customization_screen.dart';
import 'image_theme_studio_screen.dart';
import '../../developer/ui/forge_sandbox_screen.dart';
import '../../developer/ui/enterprise_dashboard_screen.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ayarlar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: MeropeTokens.space16),
          Expanded(
            child: ListView(
              children: [
                MeropeCard(
                  color: tokens.surface,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person_outline, color: tokens.primary),
                        title: Text('Profili Düzenle', style: TextStyle(color: tokens.textPrimary)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                      ),
                      ListTile(
                        leading: Icon(Icons.verified_user_outlined, color: tokens.primary),
                        title: Text('Verified Status', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Identity Handshake process'),
                        onTap: () => context.push('/settings/verification'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.image_rounded, color: tokens.primary),
                        title: Text('Görsel Tabanlı Tema Stüdyosu', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('2 özel resim ve blur/tint kombinasyonu'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ImageThemeStudioScreen())),
                      ),
                      ListTile(
                        leading: Icon(Icons.palette_rounded, color: tokens.primary),
                        title: Text('Tema & Stüdyo (11 Varyant)', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Cyberpunk, Emerald, Midnight, vb.'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemeCustomizationScreen())),
                      ),
                      SwitchListTile(
                        title: Text('Karanlık Mod', style: TextStyle(color: tokens.textPrimary)),
                        value: themeState.isDark,
                        onChanged: (val) {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                         activeThumbColor: tokens.primary,
                      ),
                      SwitchListTile(
                        title: Text('Shadow Browsing Mode', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Hide online status and read receipts'),
                        value: false,
                        onChanged: (val) {
                           MeropeHaptics.trigger(MeropeTokens.hapticSelection);
                        },
                        activeThumbColor: tokens.primary,
                      ),
                      ListTile(
                        leading: Icon(Icons.language, color: tokens.primary),
                        title: Text('Dil', style: TextStyle(color: tokens.textPrimary)),
                        trailing: const Text('Türkçe'),
                        onTap: () => _showLanguagePicker(context),
                      ),
                      ListTile(
                        leading: Icon(Icons.lock_outline, color: tokens.primary),
                        title: Text('Gizlilik', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Hayalet Modu, Son Görülme'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacySettingsScreen())),
                      ),
                      ListTile(
                        leading: Icon(Icons.security, color: tokens.primary),
                        title: Text('Güvenlik', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('2FA, Aktif Oturumlar'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecuritySettingsScreen())),
                      ),
                      ListTile(
                        leading: Icon(Icons.data_usage, color: tokens.primary),
                        title: Text('Veri Kullanımı', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Ağ ve Depolama Takibi'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DataUsageScreen())),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.admin_panel_settings_rounded, color: tokens.primary),
                        title: Text('Enterprise Governance Dashboard', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Telemetry, Uptime & Circuit Breakers'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EnterpriseDashboardScreen(appId: 'merope-prime-internal'))),
                      ),
                      ListTile(
                        leading: Icon(Icons.code, color: tokens.primary),
                        title: Text('Developer Forge Sandbox', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Test design tokens, haptics & acoustics'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgeSandboxScreen())),
                      ),
                      ListTile(
                        leading: Icon(Icons.code, color: tokens.primary),
                        title: Text('Developer Portal', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Manage Bots and API Keys'),
                        onTap: () => context.push('/developer'),
                      ),
                      ListTile(
                        leading: Icon(Icons.analytics_outlined, color: tokens.primary),
                        title: Text('Insights', style: TextStyle(color: tokens.textPrimary)),
                        subtitle: const Text('Engagement and Metrics'),
                        onTap: () => context.push('/analytics'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: MeropeTokens.space24),
                MeropeCard(
                  color: tokens.surface,
                  child: ListTile(
                    leading: Icon(Icons.logout, color: tokens.dndStatus),
                    title: Text('Çıkış Yap', style: TextStyle(color: tokens.dndStatus)),
                    onTap: () {
                      ref.read(authControllerProvider.notifier).logout();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Dil Seçin', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(title: const Text('English'), onTap: () => Navigator.pop(context)),
          ListTile(title: const Text('Türkçe'), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
