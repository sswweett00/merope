import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'package:merope_ui/widgets/merope_text_field.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class MFAScreen extends ConsumerStatefulWidget {
  const MFAScreen({super.key});

  @override
  ConsumerState<MFAScreen> createState() => _MFAScreenState();
}

class _MFAScreenState extends ConsumerState<MFAScreen> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(MeropeTokens.space32),
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.security, size: 48, color: tokens.primary),
              const SizedBox(height: MeropeTokens.space16),
              Text(
                'Enter Security Code',
                style: TextStyle(
                  fontSize: MeropeTokens.fontSizeLg,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: MeropeTokens.space8),
              Text(
                'Enter the 6-digit code from your authenticator app.',
                textAlign: TextAlign.center,
                style: TextStyle(color: tokens.textSecondary),
              ),
              const SizedBox(height: MeropeTokens.space32),
              MeropeTextField(
                label: 'SIX-DIGIT CODE',
                controller: _codeController,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MeropeTokens.space24),
              MeropeButton(
                text: 'Verify and Sync',
                onPressed: () {
                  if (_codeController.text.length == 6) {
                    MeropeHaptics.trigger(MeropeTokens.hapticHeavy);
                    context.go('/');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Invalid code sequence.')));
                  }
                },
                style: MeropeButtonStyle.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
