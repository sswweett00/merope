import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/workspace/workspace_provider.dart';

class CorporateAuthScreen extends ConsumerWidget {
  const CorporateAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Force Corporate Workspace for this screen
    final tokens = ref.watch(workspaceThemeProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Row(
          children: [
            // Side Panel for Branding
            if (MediaQuery.of(context).size.width > 600)
              Expanded(
                flex: 2,
                child: Container(
                  color: tokens.primary.withValues(alpha: 0.05),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_center_rounded, size: 80, color: tokens.primary),
                        const SizedBox(height: 24),
                        Text(
                          'Merope Enterprise',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: tokens.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(MeropeTokens.space32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enterprise Portal', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: tokens.textPrimary)),
                    const SizedBox(height: 8),
                    Text('Manage your organization and team.', style: TextStyle(color: tokens.textSecondary)),
                    const SizedBox(height: 48),
                    _buildInput('Business Email', tokens),
                    const SizedBox(height: 16),
                    _buildInput('Corporate Password', tokens, isObscure: true),
                    const SizedBox(height: 16),
                    _buildInput('Tax ID / Registration Number', tokens),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(workspaceProvider.notifier).setLayer(WorkspaceLayer.work);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tokens.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MeropeTokens.radiusSm)),
                        ),
                        child: Text('Login to Workspace', style: TextStyle(color: tokens.onPrimary, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Switch to Personal Account', style: TextStyle(color: tokens.textSecondary)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, MeropeColorTokens tokens, {bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: tokens.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusXs),
            border: Border.all(color: tokens.border),
          ),
          child: TextField(
            obscureText: isObscure,
            style: TextStyle(color: tokens.textPrimary),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ),
      ],
    );
  }
}
