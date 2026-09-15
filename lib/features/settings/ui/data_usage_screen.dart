import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../logic/settings_provider.dart';

class DataUsageScreen extends ConsumerWidget {
  const DataUsageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final settings = ref.watch(meropeSettingsProvider);
    final notifier = ref.read(meropeSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: const Text('Veri Kullanımı'),
        backgroundColor: tokens.surface,
        foregroundColor: tokens.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUsageItem('Mesajlar', '1.2 GB', Icons.message, tokens),
          _buildUsageItem('Medya (Resim/Video)', '5.4 GB', Icons.image, tokens),
          _buildUsageItem('Sesli Mesajlar', '450 MB', Icons.mic, tokens),
          const Divider(height: 32),
          ListTile(
            title: Text('Depolamayı Temizle', style: TextStyle(color: tokens.textPrimary)),
            subtitle: Text('Geçici dosyaları ve önbelleği sil', style: TextStyle(color: tokens.textSecondary)),
            trailing: Icon(Icons.delete_sweep, color: tokens.dndStatus),
            onTap: () async {
              await notifier.clearCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Önbellek temizlendi.')),
                );
              }
            },
          ),
          SwitchListTile(
            title: Text('Düşük Veri Modu', style: TextStyle(color: tokens.textPrimary)),
            subtitle: Text('Medya indirmelerini sınırla', style: TextStyle(color: tokens.textSecondary)),
            value: settings.lowDataMode,
            onChanged: (val) => notifier.setLowDataMode(val),
            activeThumbColor: tokens.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(String title, String value, IconData icon, MeropeColorTokens tokens) {
    return Card(
      color: tokens.surface,
      child: ListTile(
        leading: Icon(icon, color: tokens.primary),
        title: Text(title, style: TextStyle(color: tokens.textPrimary)),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: tokens.textPrimary)),
      ),
    );
  }
}
