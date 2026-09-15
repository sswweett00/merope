import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../logic/settings_provider.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final settings = ref.watch(meropeSettingsProvider);
    final notifier = ref.read(meropeSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: const Text('Güvenlik'),
        backgroundColor: tokens.surface,
        foregroundColor: tokens.textPrimary,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Uygulama Kilidi', style: TextStyle(color: tokens.textPrimary)),
            subtitle: Text('Biyometrik (Yüz/Parmak İzi) ile giriş yapın', style: TextStyle(color: tokens.textSecondary)),
            value: settings.isAppLockEnabled,
            onChanged: (val) => notifier.setAppLock(val),
            activeThumbColor: tokens.primary,
          ),
          const Divider(),
          SwitchListTile(
            title: Text('İki Faktörlü Doğrulama (2FA)', style: TextStyle(color: tokens.textPrimary)),
            subtitle: Text('Hesabınızı ek bir güvenlik katmanıyla koruyun', style: TextStyle(color: tokens.textSecondary)),
            value: settings.is2FAEnabled,
            onChanged: (val) => notifier.set2FA(val),
            activeThumbColor: tokens.primary,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Aktif Oturumlar', style: TextStyle(fontWeight: FontWeight.bold, color: tokens.textPrimary)),
          ),
          _buildSessionTile('Android SDK 34 - Istanbul', '192.168.1.1', 'Şu an aktif', true, tokens),
          _buildSessionTile('Web - Chrome - Ankara', '85.100.20.10', '2 saat önce', false, tokens),
          const Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: tokens.dndStatus),
            title: Text('Tüm Oturumlardan Çıkış Yap', style: TextStyle(color: tokens.dndStatus)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTile(String device, String ip, String lastUsed, bool isCurrent, MeropeColorTokens tokens) {
    return ListTile(
      leading: Icon(Icons.devices, color: tokens.primary),
      title: Text(device, style: TextStyle(color: tokens.textPrimary)),
      subtitle: Text('$ip • $lastUsed', style: TextStyle(color: tokens.textSecondary)),
      trailing: isCurrent
          ? Text('Bu Cihaz', style: TextStyle(color: tokens.secondary))
          : Icon(Icons.close, color: tokens.textSecondary),
    );
  }
}
