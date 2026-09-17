import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'package:merope_ui/widgets/merope_glass_container.dart';

class EscrowPaymentSheet extends ConsumerWidget {
  final String productId;
  final String title;
  final String price;
  final MeropeColorTokens tokens;

  const EscrowPaymentSheet({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.tokens,
  });

  static Future<void> show(
    BuildContext context, {
    required String productId,
    required String title,
    required String price,
    required MeropeColorTokens tokens,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => EscrowPaymentSheet(
        productId: productId,
        title: title,
        price: price,
        tokens: tokens,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeropeGlassContainer(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      borderRadius: MeropeTokens.radiusLg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Secure Escrow Checkout',
                style: TextStyle(
                    color: tokens.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close, color: tokens.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _PaymentInfoRow(label: 'Product', value: title, tokens: tokens),
          _PaymentInfoRow(
              label: 'Price', value: price, tokens: tokens, isHighlight: true),
          _PaymentInfoRow(
              label: 'Escrow Fee (2%)', value: '5 MRO', tokens: tokens),
          const Divider(height: 32, color: Colors.white10),
          _PaymentInfoRow(
              label: 'Total to be Held',
              value: '255 MRO',
              tokens: tokens,
              isTotal: true),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
              border:
                  Border.all(color: tokens.secondary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: tokens.secondary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Funds will be held in a zero-knowledge escrow until you confirm delivery.',
                    style: TextStyle(color: tokens.textSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          MeropeButton(
            text: 'Authorize & Lock Funds',
            onPressed: () {
              Navigator.pop(context);
              context.push('/order-confirmation/$productId');
            },
            style: MeropeButtonStyle.primary,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PaymentInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final MeropeColorTokens tokens;
  final bool isHighlight;
  final bool isTotal;

  const _PaymentInfoRow({
    required this.label,
    required this.value,
    required this.tokens,
    this.isHighlight = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: tokens.textSecondary, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: isTotal
                  ? tokens.primary
                  : (isHighlight
                      ? tokens.textPrimary
                      : tokens.textPrimary.withValues(alpha: 0.8)),
              fontSize: isTotal ? 18 : 14,
              fontWeight:
                  isTotal || isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
