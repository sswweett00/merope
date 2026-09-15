import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'package:merope_ui/widgets/merope_button.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTokens = MeropeColorTokens.darkDefault();

    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reklam ve Kampanya Yönetimi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkTokens.textPrimary,
            ),
          ),
          const SizedBox(height: MeropeTokens.space16),
          MeropeCard(
            color: darkTokens.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aktif Kampanyalar',
                  style: TextStyle(fontWeight: FontWeight.bold, color: darkTokens.textPrimary),
                ),
                const SizedBox(height: MeropeTokens.space8),
                Text(
                  'Toplam Gösterim: 145,200\nTıklama Oranı (CTR): %3.45',
                  style: TextStyle(color: darkTokens.textSecondary),
                ),
                const SizedBox(height: MeropeTokens.space16),
                MeropeButton(
                  text: 'Yeni Kampanya Oluştur',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
