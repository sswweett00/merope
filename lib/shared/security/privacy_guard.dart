import 'dart:io';
import 'dart:ui';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/biometric_provider.dart';
import '../../core/theme/tokens/merope_tokens.dart';

class PrivacyGuard extends ConsumerStatefulWidget {
  final Widget child;
  final bool preventScreenshots;
  final bool biometricLockEnabled;

  const PrivacyGuard({
    super.key,
    required this.child,
    this.preventScreenshots = true,
    this.biometricLockEnabled = true,
  });

  @override
  ConsumerState<PrivacyGuard> createState() => _PrivacyGuardState();
}

class _PrivacyGuardState extends ConsumerState<PrivacyGuard> with WidgetsBindingObserver {
  bool _isPaused = false;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.preventScreenshots) {
      _enablePrivacy();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.preventScreenshots) {
      _disablePrivacy();
    }
    super.dispose();
  }

  Future<void> _enablePrivacy() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  Future<void> _disablePrivacy() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isLocked) {
      _requestUnlock();
    }

    setState(() {
      _isPaused = state == AppLifecycleState.inactive || state == AppLifecycleState.paused;
      if (state == AppLifecycleState.paused && widget.biometricLockEnabled) {
        _isLocked = true;
      }
    });
  }

  Future<void> _requestUnlock() async {
    final success = await ref.read(biometricAuthProvider.notifier).authenticate(
          reason: 'Merope verilerinizi korumak için doğrulama yapın.',
        );
    if (success) {
      setState(() => _isLocked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isPaused || _isLocked)
          Positioned.fill(
            child: RepaintBoundary(
              child: GestureDetector(
                onTap: _isLocked ? _requestUnlock : null,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: MeropeTokens.blurHigh, sigmaY: MeropeTokens.blurHigh),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_person_rounded,
                            size: 64,
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _isLocked ? 'IDENTITY VERIFICATION REQUIRED' : 'NEURAL CORE PROTECTED',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                          if (_isLocked) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Tap to unlock secure session',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
