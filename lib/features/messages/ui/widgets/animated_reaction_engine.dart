import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class AnimatedReactionEngine extends StatefulWidget {
  final String emoji;
  final VoidCallback? onComplete;

  const AnimatedReactionEngine({
    super.key,
    required this.emoji,
    this.onComplete,
  });

  @override
  State<AnimatedReactionEngine> createState() => _AnimatedReactionEngineState();
}

class _AnimatedReactionEngineState extends State<AnimatedReactionEngine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MeropeTokens.durationNormal,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: MeropeTokens.curveBounce,
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await MeropeHaptics.trigger(MeropeTokens.hapticMedium);
    await _controller.forward();
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Text(
          widget.emoji,
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}

/// A wrapper for Message Bubbles to show a reaction burst
class ReactionOverlayManager {
  static void showBurst(BuildContext context, Offset position, String emoji) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx - 24,
        top: position.dy - 48,
        child: IgnorePointer(
          child: AnimatedReactionEngine(
            emoji: emoji,
            onComplete: () => entry.remove(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(entry);
  }
}
