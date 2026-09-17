import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class EscrowTimelineWidget extends ConsumerWidget {
  final String currentStatus; // held, dispatched, delivered, released

  const EscrowTimelineWidget({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;

    final steps = ['held', 'dispatched', 'delivered', 'released'];
    final labels = [
      'Ödeme Güvencede',
      'Kargoya Verildi',
      'Teslim Edildi',
      'Onaylandı & Aktarıldı'
    ];
    final currentIndex = steps.indexOf(currentStatus.toLowerCase());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Emanet (Escrow) Güvence Durumu',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary)),
          const SizedBox(height: 20),
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final isPassed = stepIndex <= currentIndex;
                final isCurrent = stepIndex == currentIndex;

                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isPassed ? tokens.primary : tokens.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color:
                            isCurrent ? tokens.secondary : Colors.transparent,
                        width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      isPassed
                          ? Icons.check_rounded
                          : Icons.fiber_manual_record,
                      size: 16,
                      color: isPassed ? tokens.onPrimary : tokens.textSecondary,
                    ),
                  ),
                );
              } else {
                final lineIndex = index ~/ 2;
                final isPassed = lineIndex < currentIndex;

                return Expanded(
                  child: Container(
                    height: 3,
                    color: isPassed ? tokens.primary : tokens.border,
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              final isCurrent = index == currentIndex;
              return SizedBox(
                width: 70,
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? tokens.primary : tokens.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
