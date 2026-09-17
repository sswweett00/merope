import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_customizer_provider.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/theme_scheduler.dart';

class ThemeCustomizationScreen extends ConsumerWidget {
  const ThemeCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(themeCustomizerProvider);
    final tokens = ref.watch(themeProvider).currentTokens;
    final isAutoSchedule = ref.watch(themeSchedulerProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title:
            Text('Tema & Stüdyo', style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(MeropeTokens.space24),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
              border: Border.all(color: tokens.border),
            ),
            child: SwitchListTile(
              title: Text('Otomatik Zamanlayıcı',
                  style: TextStyle(
                      color: tokens.textPrimary, fontWeight: FontWeight.bold)),
              subtitle: Text('Gündüz Arctic, Gece Obsidian moduna geçer',
                  style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
              value: isAutoSchedule,
              activeThumbColor: tokens.primary,
              onChanged: (val) {
                ref
                    .read(themeSchedulerProvider.notifier)
                    .toggleAutoSchedule(val, ref);
              },
            ),
          ),
          const SizedBox(height: MeropeTokens.space24),
          Text(
            'Hazır Temalar (${ThemePreset.values.length} Varyant)',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary),
          ),
          const SizedBox(height: MeropeTokens.space12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: ThemePreset.values.length,
            itemBuilder: (context, index) {
              final preset = ThemePreset.values[index];
              final isSelected = config.preset == preset;
              final presetTokens = preset.tokens;

              return GestureDetector(
                onTap: () => ref
                    .read(themeCustomizerProvider.notifier)
                    .setPreset(preset),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: presetTokens.surface,
                    borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
                    border: Border.all(
                      color: isSelected
                          ? presetTokens.primary
                          : presetTokens.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: presetTokens.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          preset.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: presetTokens.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: MeropeTokens.space32),
          Text(
            'Gelişmiş Özelleştirme',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary),
          ),
          const SizedBox(height: MeropeTokens.space16),
          _buildSliderSetting(
            title: 'Köşe Yuvarlaklığı (Radius)',
            value: config.radiusMultiplier,
            min: 0.5,
            max: 2.0,
            onChanged: (val) => ref
                .read(themeCustomizerProvider.notifier)
                .setRadiusMultiplier(val),
            tokens: tokens,
          ),
          const SizedBox(height: MeropeTokens.space16),
          _buildSliderSetting(
            title: 'Yazı Boyutu Ölçeği',
            value: config.fontScale,
            min: 0.85,
            max: 1.25,
            onChanged: (val) =>
                ref.read(themeCustomizerProvider.notifier).setFontScale(val),
            tokens: tokens,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required MeropeColorTokens tokens,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      color: tokens.textPrimary, fontWeight: FontWeight.bold)),
              Text(value.toStringAsFixed(2),
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
