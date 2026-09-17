import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../../domain/models/developer_metrics_model.dart';

class MetricLineChart extends StatelessWidget {
  final List<MetricDataPoint> data;
  final Color? lineColor;
  final Color? areaColor;
  final bool showArea;
  final double height;
  final String? emptyLabel;

  const MetricLineChart({
    super.key,
    required this.data,
    this.lineColor,
    this.areaColor,
    this.showArea = true,
    this.height = 140,
    this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? MeropeColorTokens.darkDefault()
        : MeropeColorTokens.lightDefault();
    final resolvedLineColor = lineColor ?? tokens.primary;
    final resolvedAreaColor =
        areaColor ?? resolvedLineColor.withValues(alpha: 0.15);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: RepaintBoundary(
        child: CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: _MetricLineChartPainter(
            data: data,
            lineColor: resolvedLineColor,
            areaColor: resolvedAreaColor,
            showArea: showArea,
            axisColor: tokens.border,
            gridColor: tokens.border.withValues(alpha: 0.3),
            textColor: tokens.textSecondary,
          ),
          child: data.isEmpty
              ? Center(
                  child: Text(emptyLabel ?? 'No data',
                      style:
                          TextStyle(color: tokens.textSecondary, fontSize: 12)))
              : null,
        ),
      ),
    );
  }
}

class _MetricLineChartPainter extends CustomPainter {
  final List<MetricDataPoint> data;
  final Color lineColor;
  final Color areaColor;
  final bool showArea;
  final Color axisColor;
  final Color gridColor;
  final Color textColor;

  _MetricLineChartPainter({
    required this.data,
    required this.lineColor,
    required this.areaColor,
    required this.showArea,
    required this.axisColor,
    required this.gridColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final count = data.length;
    if (count < 2) {
      _drawEmpty(canvas, size);
      return;
    }

    final padding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    final chartWidth = size.width - padding.horizontal;
    final chartHeight = size.height - padding.top - 16;

    final values = data.map((d) => d.value).toList();
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal).isFinite && (maxVal - minVal) > 0
        ? maxVal - minVal
        : 1.0;

    final stepX = chartWidth / (count - 1);
    final scale = chartHeight / range;

    final points = <Offset>[];
    for (int i = 0; i < count; i++) {
      final x = padding.left + i * stepX;
      final y = padding.top + chartHeight - ((values[i] - minVal) * scale);
      points.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);

    if (showArea) {
      final areaPath = Path()..addPath(path, Offset.zero);
      areaPath.lineTo(points.last.dx, padding.top + chartHeight);
      areaPath.lineTo(points.first.dx, padding.top + chartHeight);
      areaPath.close();
      final areaPaint = Paint()
        ..color = areaColor
        ..style = PaintingStyle.fill;
      canvas.drawPath(areaPath, areaPaint);
    }

    for (var p in points) {
      canvas.drawCircle(p, 2.5, Paint()..color = lineColor);
    }

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    final textStyle =
        TextStyle(color: textColor.withValues(alpha: 0.5), fontSize: 9);
    final maxLabel = _formatValue(maxVal);
    final labelPainter = TextPainter(
      text: TextSpan(style: textStyle, text: maxLabel),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, Offset(padding.left, padding.top));
    canvas.drawLine(Offset(padding.left, padding.top),
        Offset(size.width - padding.right, padding.top), gridPaint);
    canvas.drawLine(
        Offset(padding.left, padding.top + chartHeight),
        Offset(size.width - padding.right, padding.top + chartHeight),
        gridPaint);

    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(padding.left, padding.top),
        Offset(padding.left, padding.top + chartHeight), axisPaint);
  }

  void _drawEmpty(Canvas canvas, Size size) {
    final textStyle =
        TextStyle(color: textColor.withValues(alpha: 0.5), fontSize: 11);
    final tp = TextPainter(
      text: TextSpan(style: textStyle, text: 'Awaiting data...'),
      textAlign: TextAlign.center,
    )..layout();
    tp.paint(canvas,
        Offset(size.width / 2 - tp.width / 2, size.height / 2 - tp.height / 2));
  }

  String _formatValue(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(v % 1 == 0 ? 0 : 1);
  }

  @override
  bool shouldRepaint(covariant _MetricLineChartPainter old) => old.data != data;
}
