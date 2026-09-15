import 'dart:math' as math;
import 'package:flutter/material.dart';

class NeuralNode {
  final String id;
  final String label;
  final double x, y;
  final double radius;
  final Color color;

  NeuralNode({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
  });
}

class NeuralMapPainter extends CustomPainter {
  final List<NeuralNode> nodes;
  final double animationValue;
  final TextPainter _textPainter = TextPainter(textDirection: TextDirection.ltr);

  NeuralMapPainter({required this.nodes, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 1.0;

    final nodePaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Draw Connections
    for (var i = 0; i < nodes.length; i++) {
      final n1 = nodes[i];
      final p1 = Offset(n1.x * size.width, n1.y * size.height);

      for (var j = i + 1; j < nodes.length; j++) {
        final n2 = nodes[j];
        final dx = n1.x - n2.x;
        final dy = n1.y - n2.y;
        final distSq = dx * dx + dy * dy;

        if (distSq < 0.16) { // 0.4 * 0.4
          final dist = math.sqrt(distSq);
          final p2 = Offset(n2.x * size.width, n2.y * size.height);
          canvas.drawLine(
            p1,
            p2,
            linePaint..color = Colors.white.withValues(alpha: (1.0 - dist / 0.4) * 0.2),
          );
        }
      }
    }

    // Draw Nodes
    for (final node in nodes) {
      final pulse = math.sin(animationValue * 2 * math.pi + node.x * 10) * 2.0;
      final currentRadius = node.radius + pulse;
      final center = Offset(node.x * size.width, node.y * size.height);

      canvas.drawCircle(center, currentRadius + 4, glowPaint..color = node.color.withValues(alpha: 0.3));
      canvas.drawCircle(center, currentRadius, nodePaint..color = node.color);

      _textPainter.text = TextSpan(
        text: node.label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      );
      _textPainter.layout();
      _textPainter.paint(canvas, Offset(center.dx - _textPainter.width / 2, center.dy + currentRadius + 4));
    }
  }

  @override
  bool shouldRepaint(covariant NeuralMapPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.nodes != nodes;
  }
}
