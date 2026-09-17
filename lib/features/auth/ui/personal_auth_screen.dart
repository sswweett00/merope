import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class PersonalAuthScreen extends ConsumerWidget {
  const PersonalAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MeropeTokens.space24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: MeropeTokens.space48),
              Text(
                'Merope Personal',
                style: TextStyle(
                  fontSize: MeropeTokens.fontSizeXxl,
                  fontWeight: FontWeight.bold,
                  color: tokens.primary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: MeropeTokens.space8),
              Text(
                'High-performance social OS for you.',
                style: TextStyle(
                    fontSize: MeropeTokens.fontSizeMd,
                    color: tokens.textSecondary),
              ),
              const Spacer(),
              _buildInput('Username', tokens),
              const SizedBox(height: MeropeTokens.space16),
              _buildInput('Password', tokens, isObscure: true),
              const SizedBox(height: MeropeTokens.space32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(MeropeTokens.radiusMd)),
                  ),
                  child: Text('Get Started',
                      style: TextStyle(
                          color: tokens.onPrimary,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: MeropeTokens.space24),
              Center(
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/auth/corporate'),
                  child: Text('Switch to Corporate Account',
                      style: TextStyle(color: tokens.textSecondary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, MeropeColorTokens tokens,
      {bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: tokens.textSecondary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: tokens.surfaceVariant,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
            border: Border.all(color: tokens.border),
          ),
          child: TextField(
            obscureText: isObscure,
            style: TextStyle(color: tokens.textPrimary),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
