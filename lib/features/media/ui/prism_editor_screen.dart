import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_button.dart';

class PrismEditorScreen extends ConsumerStatefulWidget {
  const PrismEditorScreen({super.key});

  @override
  ConsumerState<PrismEditorScreen> createState() => _PrismEditorScreenState();
}

class _PrismEditorScreenState extends ConsumerState<PrismEditorScreen> {
  String _selectedSpectrum = 'A4 / Neural Warmth';
  double _exposure = 0.0;
  double _interference = 0.2;

  final Map<String, Color> _spectrums = {
    'A4 / Neural Warmth': const Color(0xFFE8D3A7),
    'C1 / Grid Cyan': const Color(0xFFA7E8E3),
    'B1 / Mono Static': const Color(0xFF888888),
    'M5 / Cyber Shadow': const Color(0xFF332211),
  };

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final prismColor = _spectrums[_selectedSpectrum] ?? Colors.transparent;

    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Merope Prism Studio',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
              ),
              MeropeButton(
                text: 'Refract',
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: MeropeTokens.space16),
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
                        color: tokens.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(MeropeTokens.radiusMd),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(Icons.blur_on,
                                size: 100,
                                color: tokens.textSecondary
                                    .withValues(alpha: 0.2)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: prismColor.withValues(
                                  alpha: 0.2 + (_exposure * 0.1)),
                              borderRadius:
                                  BorderRadius.circular(MeropeTokens.radiusMd),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _spectrums.keys.map((s) {
                final isSelected = s == _selectedSpectrum;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSpectrum = s),
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? tokens.primary : tokens.surface,
                      borderRadius:
                          BorderRadius.circular(MeropeTokens.radiusSm),
                      border: Border.all(color: tokens.border),
                    ),
                    child: Center(
                      child: Text(
                        s,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : tokens.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildSlider('Luminance', _exposure, -1.0, 1.0,
                  (v) => setState(() => _exposure = v), tokens),
              _buildSlider('Interference', _interference, 0.0, 1.0,
                  (v) => setState(() => _interference = v), tokens),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String l, double v, double min, double max,
      ValueChanged<double> o, MeropeColorTokens t) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(l,
                style: TextStyle(color: t.textSecondary, fontSize: 12))),
        Expanded(
          child: Slider(
            value: v,
            min: min,
            max: max,
            activeColor: t.primary,
            onChanged: o,
          ),
        ),
      ],
    );
  }
}
