import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class PrivacyShieldWrapper extends StatefulWidget {
  final Widget child;

  const PrivacyShieldWrapper({super.key, required this.child});

  @override
  State<PrivacyShieldWrapper> createState() => _PrivacyShieldWrapperState();
}

class _PrivacyShieldWrapperState extends State<PrivacyShieldWrapper> with WidgetsBindingObserver {
  bool _isBackgrounded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isBackgrounded = state == AppLifecycleState.inactive || state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isBackgrounded)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: MeropeTokens.blurHigh, sigmaY: MeropeTokens.blurHigh),
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        "MEROPE PRIVACY SHIELD",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
