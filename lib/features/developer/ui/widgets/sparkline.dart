import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class Sparkline extends StatelessWidget {
  final List<double> values;
  final Color? color;
  final double height;
  final double width;

  const Sparkline({
    super.key,
    required this.values,
    this.color,
    this.height = 32,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = MeropeColorTokens.darkDefault();
    final resolvedColor = color ?? tokens.secondary;
    return SizedBox(
      height: height,
      width: width,
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size(width, height),
          painter: _SparklinePainter(values: values, color: resolvedColor),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal).isFinite && (maxVal - minVal) > 0
        ? maxVal - minVal
        : 1.0;
    final padding = 2.0;
    final chartW = size.width - padding * 2;
    final chartH = size.height - padding * 2;
    final stepX = values.length > 1 ? chartW / (values.length - 1) : 0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = padding + i * stepX;
      final y = padding + chartH - ((values[i] - minVal) / range) * chartH;
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) => old.values != values;
}
