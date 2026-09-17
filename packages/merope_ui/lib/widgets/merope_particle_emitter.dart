import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class Particle {
  double x, y;
  double vx, vy;
  double life;
  double maxLife;
  double size;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    required this.size,
    required this.color,
  }) : maxLife = life;

  void update() {
    x += vx;
    y += vy;
    life -= 0.02;
    size *= 0.98;
  }
}

class MeropeParticleEmitter extends StatefulWidget {
  final Stream<Offset>? triggerStream;
  final Color color;

  const MeropeParticleEmitter({
    super.key,
    this.triggerStream,
    required this.color,
  });

  @override
  State<MeropeParticleEmitter> createState() => _MeropeParticleEmitterState();
}

class _MeropeParticleEmitterState extends State<MeropeParticleEmitter>
    with SingleTickerProviderStateMixin {
  final List<Particle> _particles = [];
  late final dynamic _ticker;
  final _random = math.Random();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    _subscription = widget.triggerStream?.listen(_onTrigger);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void _onTrigger(Offset position) {
    for (var i = 0; i < 15; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final speed = _random.nextDouble() * 4 + 2;
      _particles.add(Particle(
        x: position.dx,
        y: position.dy,
        vx: math.cos(angle) * speed,
        vy: math.sin(angle) * speed,
        life: 1.0,
        size: _random.nextDouble() * 4 + 2,
        color: widget.color,
      ));
    }
  }

  void _onTick(Duration elapsed) {
    if (!mounted || _particles.isEmpty) return;
    setState(() {
      for (var i = _particles.length - 1; i >= 0; i--) {
        _particles[i].update();
        if (_particles[i].life <= 0) {
          _particles.removeAt(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_particles.isEmpty) return const SizedBox.shrink();

    return ExcludeSemantics(
      child: CustomPaint(
        painter: _ParticlePainter(particles: _particles),
        size: Size.infinite,
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.life.clamp(0.0, 1.0))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
