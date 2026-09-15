import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class SignalShaderWidget extends StatefulWidget {
  final Widget child;
  final bool isViral;
  final Color auraColor;

  const SignalShaderWidget({
    super.key,
    required this.child,
    this.isViral = false,
    required this.auraColor,
  });

  @override
  State<SignalShaderWidget> createState() => _SignalShaderWidgetState();
}

class _SignalShaderWidgetState extends State<SignalShaderWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (widget.isViral) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SignalShaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isViral && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isViral && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isViral) return widget.child;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _AuraPainter(
              rotation: _controller.value * 2 * math.pi,
              color: widget.auraColor,
            ),
            isComplex: false,
            willChange: true,
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0), // Space for aura
          child: widget.child,
        ),
      ),
    );
  }
}

class _AuraPainter extends CustomPainter {
  final double rotation;
  final Color color;

  _AuraPainter({required this.rotation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.5),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(rotation),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(MeropeTokens.radiusMd)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AuraPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.color != color;
}
