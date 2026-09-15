import 'package:flutter/material.dart';
import 'dart:math';

class EnergyDropOverlay extends StatefulWidget {
  final Stream<int>? dropStream;
  const EnergyDropOverlay({super.key, this.dropStream});

  @override
  State<EnergyDropOverlay> createState() => _EnergyDropOverlayState();
}

class _EnergyDropOverlayState extends State<EnergyDropOverlay> with TickerProviderStateMixin {
  final List<_EnergyParticle> _particles = [];
  late AnimationController _cleanupController;

  @override
  void initState() {
    super.initState();
    widget.dropStream?.listen(_addParticles);
    _cleanupController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    _cleanupController.addListener(_cleanup);
  }

  void _addParticles(int amount) {
    final random = Random();
    for (int i = 0; i < amount.clamp(5, 50); i++) {
      if (mounted) {
        setState(() {
          _particles.add(_EnergyParticle(
            x: 0.5 + (random.nextDouble() - 0.5) * 0.2,
            y: 0.8,
            vx: (random.nextDouble() - 0.5) * 0.05,
            vy: -random.nextDouble() * 0.1,
            color: i % 2 == 0 ? Colors.amber : Colors.orange,
            life: 1.0,
          ));
        });
      }
    }
  }

  void _cleanup() {
    if (_particles.isEmpty) return;
    if (mounted) {
      setState(() {
        _particles.removeWhere((p) {
          p.x += p.vx;
          p.y += p.vy;
          p.vy += 0.002; // Gravity
          p.life -= 0.015;
          return p.life <= 0;
        });
      });
    }
  }

  @override
  void dispose() {
    _cleanupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(particles: _particles),
        size: Size.infinite,
      ),
    );
  }
}

class _EnergyParticle {
  double x, y, vx, vy, life;
  final Color color;
  _EnergyParticle({required this.x, required this.y, required this.vx, required this.vy, required this.color, required this.life});
}

class _ParticlePainter extends CustomPainter {
  final List<_EnergyParticle> particles;
  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      paint.color = p.color.withValues(alpha: p.life);
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), 6 * p.life, paint);

      // Secondary glow
      paint.color = p.color.withValues(alpha: p.life * 0.3);
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), 12 * p.life, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
