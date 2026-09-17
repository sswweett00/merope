import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/resonance_frequency_provider.dart';
import 'package:merope_ui/theme/master_theme_provider.dart';

class ResonanceBackground extends ConsumerStatefulWidget {
  final Widget child;
  const ResonanceBackground({super.key, required this.child});

  @override
  ConsumerState<ResonanceBackground> createState() =>
      _ResonanceBackgroundState();
}

class _ResonanceBackgroundState extends ConsumerState<ResonanceBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final masterTheme = ref.watch(masterThemeProvider);
    final tokens = masterTheme.tokens;
    final frequency = ref.watch(resonanceFrequencyProvider);

    return Stack(
      children: [
        // Base Background Color
        Positioned.fill(
          child: Container(color: tokens.background),
        ),
        // Primary Custom Image Layer
        if (masterTheme.primaryImagePath != null)
          Positioned.fill(
            child: Image.file(
              File(masterTheme.primaryImagePath!),
              fit: BoxFit.cover,
            ),
          ),
        // Secondary Atmosphere Image Layer
        if (masterTheme.secondaryImagePath != null)
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.file(
                File(masterTheme.secondaryImagePath!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        // Blur & Tint Overlay
        if (masterTheme.primaryImagePath != null ||
            masterTheme.secondaryImagePath != null)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: masterTheme.blurIntensity,
                sigmaY: masterTheme.blurIntensity,
              ),
              child: Container(
                color: tokens.background
                    .withValues(alpha: masterTheme.tintOpacity),
              ),
            ),
          ),
        // Wave Animation
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _WavePainter(
                    progress: _controller.value,
                    frequency: frequency,
                    primaryColor: tokens.primary.withValues(alpha: 0.05),
                    secondaryColor: tokens.secondary.withValues(alpha: 0.05),
                  ),
                  isComplex: true,
                  willChange: true,
                );
              },
            ),
          ),
        ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final double frequency;
  final Color primaryColor;
  final Color secondaryColor;

  _WavePainter({
    required this.progress,
    required this.frequency,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    _drawWave(canvas, size, paint, primaryColor, 1.0 * frequency,
        0.5 * frequency, 0.0);
    _drawWave(canvas, size, paint, secondaryColor, 0.8 * frequency,
        0.4 * frequency, math.pi / 2);
    _drawWave(
        canvas,
        size,
        paint,
        primaryColor.withValues(alpha: 0.02 * frequency),
        1.2 * frequency,
        0.6 * frequency,
        math.pi);
  }

  void _drawWave(Canvas canvas, Size size, Paint paint, Color color,
      double amplitudeMult, double speedMult, double phaseShift) {
    paint.color = color;
    final path = Path();

    final amplitude = 40.0 * amplitudeMult;
    final wavelength = size.width;
    final yBase = size.height * 0.5;

    path.moveTo(0, yBase);

    for (double x = 0; x <= size.width; x += 2) {
      final angle = (x / wavelength) * 2 * math.pi +
          (progress * 2 * math.pi * speedMult) +
          phaseShift;
      final y = yBase + math.sin(angle) * amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.frequency != frequency;
}
