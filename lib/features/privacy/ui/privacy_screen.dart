import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTokens = MeropeColorTokens.darkDefault();

    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gizlilik ve Veri Kontrolü',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkTokens.textPrimary,
            ),
          ),
          const SizedBox(height: MeropeTokens.space16),
          Expanded(
            child: ListView(
              children: [
                MeropeCard(
                  color: darkTokens.surface,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text('Profilimi Arama Sonuçlarında Gizle',
                            style: TextStyle(color: darkTokens.textPrimary)),
                        value: false,
                        onChanged: (val) {},
                        activeThumbColor: darkTokens.primary,
                      ),
                      SwitchListTile(
                        title: Text('Okundu Bilgisini Gönder',
                            style: TextStyle(color: darkTokens.textPrimary)),
                        value: true,
                        onChanged: (val) {},
                        activeThumbColor: darkTokens.primary,
                      ),
                      SwitchListTile(
                        title: Text('Reklam Kişiselleştirme',
                            style: TextStyle(color: darkTokens.textPrimary)),
                        value: false,
                        onChanged: (val) {},
                        activeThumbColor: darkTokens.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
