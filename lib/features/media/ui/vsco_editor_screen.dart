import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_button.dart';

class VscoEditorScreen extends ConsumerStatefulWidget {
  const VscoEditorScreen({super.key});

  @override
  ConsumerState<VscoEditorScreen> createState() => _VscoEditorScreenState();
}

class _VscoEditorScreenState extends ConsumerState<VscoEditorScreen> {
  String _selectedPreset = 'A4 / Warm Analog';
  double _exposure = 0.0;
  double _contrast = 0.0;
  double _grain = 0.2;
  double _saturation = 0.0;

  final Map<String, Color> _presetFilters = {
    'A4 / Warm Analog': const Color(0xFFE8D3A7),
    'C1 / Vibrant Cyan': const Color(0xFFA7E8E3),
    'B1 / B&W Grain': const Color(0xFF888888),
    'G3 / Muted Portrait': const Color(0xFFD4A7E8),
    'M5 / Moody Film': const Color(0xFF332211),
  };

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final filterColor = _presetFilters[_selectedPreset] ?? Colors.transparent;

    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Merope VSCO Filter Studio',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
              ),
              MeropeButton(
                text: 'Yayınla',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Fotoğraf $_selectedPreset filtresi ile galerinize yayınlandı!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: MeropeTokens.space16),
          // Photo Editing Canvas Surface
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
                border: Border.all(color: tokens.border.withValues(alpha: 0.3)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 280,
                      height: 340,
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(MeropeTokens.radiusMd),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(Icons.image,
                                size: 100,
                                color: tokens.textSecondary
                                    .withValues(alpha: 0.4)),
                          ),
                          // Filter Tint Overlay
                          Container(
                            decoration: BoxDecoration(
                              color: filterColor.withValues(
                                  alpha: 0.25 + (_exposure * 0.1)),
                              borderRadius:
                                  BorderRadius.circular(MeropeTokens.radiusMd),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius:
                            BorderRadius.circular(MeropeTokens.radiusSm),
                      ),
                      child: Text(
                        _selectedPreset,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: MeropeTokens.space16),
          // Filter Presets Horizontal Selector
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _presetFilters.keys.map((preset) {
                final isSelected = preset == _selectedPreset;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPreset = preset),
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? tokens.primary : tokens.surface,
                      borderRadius:
                          BorderRadius.circular(MeropeTokens.radiusSm),
                      border: Border.all(color: tokens.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          preset.split('/')[0].trim(),
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : tokens.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          preset.split('/')[1].trim(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white70
                                : tokens.textSecondary,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: MeropeTokens.space16),
          // Sliders Panel (Exposure, Grain, Contrast)
          Column(
            children: [
              _buildSliderRow('Pozlama (Exposure)', _exposure, -1.0, 1.0,
                  (v) => setState(() => _exposure = v), tokens),
              _buildSliderRow('Film Kumlanması (Grain)', _grain, 0.0, 1.0,
                  (v) => setState(() => _grain = v), tokens),
              _buildSliderRow('Kontrast (Contrast)', _contrast, -1.0, 1.0,
                  (v) => setState(() => _contrast = v), tokens),
              _buildSliderRow('Doygunluk (Saturation)', _saturation, -1.0, 1.0,
                  (v) => setState(() => _saturation = v), tokens),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(String label, double val, double min, double max,
      ValueChanged<double> onChange, MeropeColorTokens tokens) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(label,
              style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
        ),
        Expanded(
          child: Slider(
            value: val,
            min: min,
            max: max,
            activeColor: tokens.primary,
            inactiveColor: tokens.border,
            onChanged: onChange,
          ),
        ),
      ],
    );
  }
}
