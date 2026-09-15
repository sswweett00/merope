import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'package:merope_ui/widgets/merope_text_field.dart';
import '../repository/auth_repository.dart';

const bool kIsDevMode = kDebugMode;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
  }

  void _fillTestData() {
    // High-quality test data
    const testEmail = 'test.user@merope.dev';
    const testPassword = 'TestP@ssw0rd123!#';

    _emailController.text = testEmail;
    _passwordController.text = testPassword;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test data filled'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_isSubmitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final authRepo = ref.read(authRepositoryProvider);
    try {
      final user = await authRepo.login(email: email, password: password);
      if (user != null && mounted) {
        context.go('/');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = MeropeColorTokens.darkDefault();

    return Scaffold(
      backgroundColor: tokens.background,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(MeropeTokens.space32),
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
            boxShadow: const [MeropeTokens.shadowMd],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: tokens.primary,
                  borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
                ),
                child: const Icon(Icons.bolt, color: Colors.white, size: 40),
              ),
              const SizedBox(height: MeropeTokens.space24),
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: MeropeTokens.fontSizeXl,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
              ),
              Text(
                "We're so excited to see you again!",
                style: TextStyle(
                  fontSize: MeropeTokens.fontSizeSm,
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(height: MeropeTokens.space32),
              MeropeTextField(
                controller: _emailController,
                label: 'Email address',
              ),
              const SizedBox(height: MeropeTokens.space16),
              MeropeTextField(
                controller: _passwordController,
                label: 'Password',
              ),
              const SizedBox(height: MeropeTokens.space24),
              SizedBox(
                width: double.infinity,
                child: MeropeButton(
                  onPressed: _isSubmitting ? null : _handleLogin,
                  text: _isSubmitting ? 'Signing in...' : 'Sign in',
                ),
              ),
              // Test button - only visible in development mode
              if (kIsDevMode) ...[
                const SizedBox(height: MeropeTokens.space16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _fillTestData,
                    icon: const Icon(Icons.science, size: 18),
                    label: const Text('Fill Test Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: tokens.textSecondary,
                      side: BorderSide(color: tokens.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
