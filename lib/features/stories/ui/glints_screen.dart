import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class GlintsScreen extends ConsumerStatefulWidget {
  const GlintsScreen({super.key});

  @override
  ConsumerState<GlintsScreen> createState() => _GlintsScreenState();
}

class _GlintsScreenState extends ConsumerState<GlintsScreen> {
  int _activeGlintIndex = 0;

  final List<Map<String, dynamic>> _glints = [
    {'name': 'My Glints', 'streak': 12, 'isMe': true, 'bursts': 3},
    {'name': 'Node Expert', 'streak': 45, 'isMe': false, 'bursts': 2},
    {'name': 'Prism Artist', 'streak': 89, 'isMe': false, 'bursts': 4},
  ];

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final currentGlint = _glints[_activeGlintIndex];

    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Merope Glints',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
              ),
              Row(
                children: [
                  const Text('⚡ ', style: TextStyle(fontSize: 18)),
                  Text(
                    '${currentGlint['streak']} Day Streak',
                    style: TextStyle(
                        color: tokens.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: MeropeTokens.space16),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _glints.length,
              itemBuilder: (context, index) {
                final glint = _glints[index];
                final isSelected = index == _activeGlintIndex;

                return GestureDetector(
                  onTap: () => setState(() => _activeGlintIndex = index),
                  child: Padding(
                    padding: const EdgeInsets.only(right: MeropeTokens.space16),
                    child: Column(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isSelected ? tokens.primary : tokens.border,
                              width: isSelected ? 3 : 1.5,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              glint['isMe'] == true
                                  ? Icons.add_a_photo
                                  : Icons.blur_on,
                              color: isSelected
                                  ? tokens.primary
                                  : tokens.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          glint['name'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: tokens.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome,
                            size: 80,
                            color: tokens.primary.withValues(alpha: 0.6)),
                        const SizedBox(height: 12),
                        Text(
                          '${currentGlint['name']} Burst',
                          style: TextStyle(
                              color: tokens.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: List.generate(
                        currentGlint['bursts'] as int,
                        (i) => Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: i == 0
                                  ? tokens.primary
                                  : tokens.border.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
