import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/media/media_compression.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/image_theme_customizer.dart';
import 'package:merope_ui/widgets/merope_card.dart';

class ImageThemeStudioScreen extends ConsumerWidget {
  const ImageThemeStudioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final imageTheme = ref.watch(imageThemeProvider);
    final picker = ImagePicker();

    Future<void> pickImage(bool isPrimary) async {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        // High-performance compression via Isolate before setting theme image
        final compressedPath =
            await MediaCompressionIsolate.compressMedia(picked.path);

        if (isPrimary) {
          ref.read(imageThemeProvider.notifier).setPrimaryImage(compressedPath);
        } else {
          ref
              .read(imageThemeProvider.notifier)
              .setSecondaryImage(compressedPath);
        }
      }
    }

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text('Görsel Tabanlı Tema Stüdyosu',
            style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(MeropeTokens.space24),
        children: [
          Text(
            'Özel Görsel Katmanları (Maksimum 2 Resim)',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Arka plan ve atmosferik derinlik için iki farklı görsel yükleyebilir, bulanıklık ve renk tonu yoğunluğunu özelleştirebilirsiniz.',
            style: TextStyle(fontSize: 12, color: tokens.textSecondary),
          ),
          const SizedBox(height: MeropeTokens.space24),
          Row(
            children: [
              Expanded(
                child: _ImagePickerBox(
                  title: '1. Arka Plan Görseli',
                  imagePath: imageTheme.primaryImagePath,
                  onTap: () => pickImage(true),
                  tokens: tokens,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ImagePickerBox(
                  title: '2. Atmosferik Görsel',
                  imagePath: imageTheme.secondaryImagePath,
                  onTap: () => pickImage(false),
                  tokens: tokens,
                ),
              ),
            ],
          ),
          const SizedBox(height: MeropeTokens.space32),
          Text(
            'Görsel İşleme & Karıştırma Ayarları',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary),
          ),
          const SizedBox(height: MeropeTokens.space16),
          MeropeCard(
            color: tokens.surface,
            child: Column(
              children: [
                _buildSlider(
                  title: 'Bulanıklık (Blur Intensity)',
                  value: imageTheme.blurIntensity,
                  min: 0,
                  max: 40,
                  onChanged: (val) => ref
                      .read(imageThemeProvider.notifier)
                      .setBlurIntensity(val),
                  tokens: tokens,
                ),
                const Divider(height: 1),
                _buildSlider(
                  title: 'Ton Kaplaması (Tint Opacity)',
                  value: imageTheme.tintOpacity,
                  min: 0.0,
                  max: 0.9,
                  onChanged: (val) =>
                      ref.read(imageThemeProvider.notifier).setTintOpacity(val),
                  tokens: tokens,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required MeropeColorTokens tokens,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      color: tokens.textPrimary, fontWeight: FontWeight.bold)),
              Text(value.toStringAsFixed(1),
                  style: TextStyle(color: tokens.textSecondary)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: tokens.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ImagePickerBox extends StatelessWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final MeropeColorTokens tokens;

  const _ImagePickerBox({
    required this.title,
    required this.imagePath,
    required this.onTap,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          border: Border.all(color: tokens.border, width: 1.5),
        ),
        child: imagePath != null
            ? Stack(
                children: [
                  Positioned.fill(
                    child: MeropeImage(
                      file: imagePath!,
                      fit: BoxFit.cover,
                      borderRadius:
                          BorderRadius.circular(MeropeTokens.radiusMd - 1.5),
                      enableViewer: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.black54, shape: BoxShape.circle),
                      child:
                          const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_rounded,
                      size: 36, color: tokens.primary),
                  const SizedBox(height: 8),
                  Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          color: tokens.textSecondary,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ],
              ),
      ),
    );
  }
}
