import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class ModerationMetricChart extends StatelessWidget {
  final List<double> dataPoints;
  final Color lineColor;
  final Color fillColor;
  final String label;

  const ModerationMetricChart({
    super.key,
    required this.dataPoints,
    this.lineColor = const Color(0xFF5865F2),
    this.fillColor = const Color(0x1A5865F2),
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: const Size(double.infinity, 120),
        painter: _MetricChartPainter(
          dataPoints: dataPoints,
          lineColor: lineColor,
          fillColor: fillColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: MeropeColorTokens.darkDefault().textSecondary,
                  fontSize: MeropeTokens.fontSizeXs,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final Color lineColor;
  final Color fillColor;

  _MetricChartPainter({
    required this.dataPoints,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final points = dataPoints.map((value) {
      final x = (value / (dataPoints.isEmpty ? 1 : dataPoints.reduce((a, b) => a > b ? a : b))) * size.width;
      final y = size.height - (value.clamp(0.0, 1.0) * size.height);
      return Offset(x, y);
    }).toList();

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final midX = (previous.dx + current.dx) / 2;
      path.quadraticBezierTo(previous.dx, previous.dy, midX, (previous.dy + current.dy) / 2);
      path.quadraticBezierTo(midX, current.dy, current.dx, current.dy);
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MetricChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}
