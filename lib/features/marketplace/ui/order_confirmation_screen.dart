import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  final String productId;
  const OrderConfirmationScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: tokens.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_outline, color: tokens.secondary, size: 48),
              ),
              const SizedBox(height: 32),
              Text(
                'Funds Locked in Escrow',
                style: TextStyle(color: tokens.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your transaction is secured. The seller has been notified to initiate transfer of the asset.',
                style: TextStyle(color: tokens.textSecondary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              MeropeButton(
                text: 'View Order Status',
                onPressed: () => context.go('/'),
                style: MeropeButtonStyle.primary,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                   MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funds released from Escrow.')));
                },
                icon: const Icon(Icons.verified_user_outlined),
                label: const Text('Confirm Delivery & Release Funds'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
