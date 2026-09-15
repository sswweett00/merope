import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

enum BreakerState { closed, open, halfOpen }

class CircuitBreakerEvent {
  final String id;
  final String name;
  final BreakerState state;
  final DateTime timestamp;
  final int failureCount;
  final int? resetAt;
  final String? triggeredBy;

  const CircuitBreakerEvent({
    required this.id,
    required this.name,
    required this.state,
    required this.timestamp,
    required this.failureCount,
    this.resetAt,
    this.triggeredBy,
  });
}

class CircuitBreakerTimeline extends StatelessWidget {
  final List<CircuitBreakerEvent> events;
  final double height;

  const CircuitBreakerTimeline({super.key, required this.events, this.height = 120});

  @override
  Widget build(BuildContext context) {
    final tokens = MeropeColorTokens.darkDefault();
    final now = DateTime.now();
    final windowStart = now.subtract(const Duration(minutes: 30));

    return SizedBox(
      height: height,
      width: double.infinity,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _CircuitBreakerTimelinePainter(
            events: events,
            windowStart: windowStart,
            now: now,
            closedColor: tokens.onlineStatus,
            openColor: tokens.dndStatus,
            halfOpenColor: tokens.secondary,
            axisColor: tokens.border,
            gridColor: tokens.border.withValues(alpha: 0.25),
            textColor: tokens.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _CircuitBreakerTimelinePainter extends CustomPainter {
  final List<CircuitBreakerEvent> events;
  final DateTime windowStart;
  final DateTime now;
  final Color closedColor;
  final Color openColor;
  final Color halfOpenColor;
  final Color axisColor;
  final Color gridColor;
  final Color textColor;

  _CircuitBreakerTimelinePainter({
    required this.events,
    required this.windowStart,
    required this.now,
    required this.closedColor,
    required this.openColor,
    required this.halfOpenColor,
    required this.axisColor,
    required this.gridColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    final chartW = size.width - padding.horizontal;
    final chartH = size.height - padding.vertical;
    final totalMs = now.difference(windowStart).inMilliseconds;
    if (totalMs <= 0) return;

    final gridPaint = Paint()..color = gridColor..strokeWidth = 0.5;
    canvas.drawLine(Offset(padding.left, padding.top), Offset(size.width - padding.right, padding.top), gridPaint);
    canvas.drawLine(Offset(padding.left, padding.top + chartH), Offset(size.width - padding.right, padding.top + chartH), gridPaint);

    for (final event in events) {
      if (event.timestamp.isBefore(windowStart) || event.timestamp.isAfter(now)) continue;
      final x = padding.left + (event.timestamp.difference(windowStart).inMilliseconds / totalMs) * chartW;
      final color = switch (event.state) {
        BreakerState.closed => closedColor,
        BreakerState.open => openColor,
        BreakerState.halfOpen => halfOpenColor,
      };
      canvas.drawCircle(Offset(x, padding.top + chartH / 2), 4, Paint()..color = color);
      if (event.state == BreakerState.open) {
        canvas.drawLine(Offset(x, padding.top), Offset(x, padding.top + chartH), Paint()..color = openColor.withValues(alpha: 0.4)..strokeWidth = 1);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CircuitBreakerTimelinePainter old) => old.events != events;
}
