import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class StickerPickerSheet extends StatelessWidget {
  final Function(String stickerUrl) onStickerSelected;

  const StickerPickerSheet({super.key, required this.onStickerSelected});

  @override
  Widget build(BuildContext context) {
    // Placeholder sticker list
    final stickers = [
      'https://cdn-icons-png.flaticon.com/512/2584/2584606.png',
      'https://cdn-icons-png.flaticon.com/512/2584/2584602.png',
      'https://cdn-icons-png.flaticon.com/512/2584/2584614.png',
      'https://cdn-icons-png.flaticon.com/512/2584/2584620.png',
      'https://cdn-icons-png.flaticon.com/512/2584/2584631.png',
      'https://cdn-icons-png.flaticon.com/512/2584/2584637.png',
    ];

    return Container(
      height: 400,
      padding: const EdgeInsets.all(MeropeTokens.space16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(MeropeTokens.radiusLg)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Stickerlar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: stickers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    onStickerSelected(stickers[index]);
                    Navigator.pop(context);
                  },
                  child: MeropeImage(
                    imageUrl: stickers[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
