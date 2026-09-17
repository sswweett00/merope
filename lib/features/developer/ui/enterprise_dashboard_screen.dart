import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../domain/models/developer_metrics_model.dart';
import '../logic/providers/developer_metrics_provider.dart';
import 'widgets/circuit_breaker_timeline.dart';
import 'widgets/metric_line_chart.dart';
import 'widgets/skeleton_loader.dart';

class EnterpriseDashboardScreen extends ConsumerStatefulWidget {
  final String appId;

  const EnterpriseDashboardScreen({super.key, required this.appId});

  @override
  ConsumerState<EnterpriseDashboardScreen> createState() =>
      _EnterpriseDashboardScreenState();
}

class _EnterpriseDashboardScreenState
    extends ConsumerState<EnterpriseDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final metricsAsync = ref.watch(developerMetricsProvider(widget.appId));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text('Enterprise Governance',
            style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Metrics',
            onPressed: metricsAsync.hasValue
                ? () => _exportMetrics(context, metricsAsync.value!)
                : null,
          ),
          TextButton.icon(
            onPressed: () =>
                ref.refresh(developerMetricsProvider(widget.appId)),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Refresh'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.refresh(developerMetricsProvider(widget.appId)),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(MeropeTokens.space24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        if (isWide) {
                          return Row(
                            children: [
                              Expanded(child: _healthCard(tokens)),
                              const SizedBox(width: MeropeTokens.space16),
                              Expanded(child: _breakerCard(tokens)),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            _healthCard(tokens),
                            const SizedBox(height: MeropeTokens.space12),
                            _breakerCard(tokens),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: MeropeTokens.space24),
                    Text('System Telemetry & Resource Load',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tokens.textPrimary)),
                    const SizedBox(height: MeropeTokens.space12),
                    _telemetryCard(metricsAsync, tokens),
                    const SizedBox(height: MeropeTokens.space24),
                    Text('Real-time Metrics',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tokens.textPrimary)),
                    const SizedBox(height: MeropeTokens.space12),
                    _metricsChart(metricsAsync, tokens),
                    const SizedBox(height: MeropeTokens.space24),
                    Text('Historical Uptime',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tokens.textPrimary)),
                    const SizedBox(height: MeropeTokens.space12),
                    _uptimeSparkline(tokens),
                    const SizedBox(height: MeropeTokens.space24),
                    Text('Circuit Breaker History',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tokens.textPrimary)),
                    const SizedBox(height: MeropeTokens.space12),
                    _circuitBreakerTimeline(tokens),
                    const SizedBox(height: MeropeTokens.space24),
                    Text('Compliance Audit Log',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tokens.textPrimary)),
                    const SizedBox(height: MeropeTokens.space12),
                    _auditLogList(tokens),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _healthCard(MeropeColorTokens tokens) {
    return _MetricCard(
      title: 'System Health',
      value: '99.999%',
      subtitle: 'Optimal Uptime',
      icon: Icons.favorite,
      color: tokens.secondary,
      tokens: tokens,
    );
  }

  Widget _breakerCard(MeropeColorTokens tokens) {
    return _MetricCard(
      title: 'Circuit Breaker',
      value: 'CLOSED',
      subtitle: 'Zero Failures',
      icon: Icons.power_settings_new,
      color: tokens.onlineStatus,
      tokens: tokens,
    );
  }

  Widget _telemetryCard(
      AsyncValue<DeveloperMetrics> metricsAsync, MeropeColorTokens tokens) {
    return MeropeCard(
      color: tokens.surface,
      child: metricsAsync.when(
        data: (m) => Column(
          children: [
            _buildInfoRow('Active Goroutines', '42', tokens),
            const Divider(height: 1),
            _buildInfoRow('Heap Allocation', '18.4 MB', tokens),
            const Divider(height: 1),
            _buildInfoRow('DB Pool Connections', '12 / 50', tokens),
            const Divider(height: 1),
            _buildInfoRow('Sync Rate',
                '${m.syncRate?.toStringAsFixed(1) ?? "99.9"}%', tokens),
            const Divider(height: 1),
            _buildInfoRow(
                'Avg Latency', '${m.avgLatency.toStringAsFixed(0)} ms', tokens),
            const Divider(height: 1),
            _buildInfoRow(
                'Success Rate', '${m.successRate.toStringAsFixed(2)}%', tokens),
          ],
        ),
        loading: () => Padding(
          padding: const EdgeInsets.all(MeropeTokens.space12),
          child: Column(
              children: List.generate(
                  4,
                  (i) => const SkeletonLoader(
                      width: double.infinity, height: 40))),
        ),
        error: (_, __) => Padding(
          padding: const EdgeInsets.all(MeropeTokens.space12),
          child: Text('Failed to load telemetry',
              style: TextStyle(color: tokens.error)),
        ),
      ),
    );
  }

  Widget _metricsChart(
      AsyncValue<DeveloperMetrics> metricsAsync, MeropeColorTokens tokens) {
    final metrics = metricsAsync.valueOrNull ??
        DeveloperMetrics(appId: widget.appId, dataPoints: _samplePoints());
    return RepaintBoundary(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
            border: Border.all(color: tokens.border)),
        child: MetricLineChart(
          data: metrics.dataPoints,
          lineColor: tokens.primary,
          height: 160,
          emptyLabel: 'Awaiting real-time telemetry...',
        ),
      ),
    );
  }

  Widget _uptimeSparkline(MeropeColorTokens tokens) {
    final history = List<double>.generate(30, (i) => 99.5 + (i % 3) * 0.15);
    return RepaintBoundary(
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(MeropeTokens.space12),
        decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
            border: Border.all(color: tokens.border)),
        child: Row(
          children: [
            Expanded(
                child:
                    SparklineCustom(values: history, color: tokens.secondary)),
            const SizedBox(width: MeropeTokens.space12),
            Text('99.998%',
                style: TextStyle(
                    color: tokens.textPrimary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _circuitBreakerTimeline(MeropeColorTokens tokens) {
    final events = List.generate(
        8,
        (i) => CircuitBreakerEvent(
            id: 'cb_$i',
            name: 'Circuit-$i',
            state: i == 0
                ? BreakerState.open
                : (i == 1 ? BreakerState.halfOpen : BreakerState.closed),
            timestamp: DateTime.now().subtract(Duration(minutes: 28 - i * 4)),
            failureCount: i == 0 ? 42 : i,
            resetAt: null,
            triggeredBy: i == 0 ? 'rate_limit' : null));
    return RepaintBoundary(
      child: Container(
        height: 120,
        decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
            border: Border.all(color: tokens.border)),
        child: CircuitBreakerTimeline(events: events),
      ),
    );
  }

  Widget _auditLogList(MeropeColorTokens tokens) {
    final entries = List.generate(
        12,
        (i) => AuditLogEntry(
            id: 'a_$i',
            action: i.isEven ? 'API_RATE_LIMITED' : 'TOKEN_REFRESHED',
            actorId: 'nx_${1000 + i}',
            status: i % 3 == 0
                ? AuditStatus.warning
                : (i % 3 == 1 ? AuditStatus.success : AuditStatus.failed),
            timestamp: DateTime.now().subtract(Duration(minutes: 30 - i * 3))));
    return Container(
      constraints: const BoxConstraints(maxHeight: 420),
      decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          border: Border.all(color: tokens.border)),
      child: CustomScrollView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [AuditLogList(entries: entries)],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: tokens.textSecondary)),
        Text(value,
            style: TextStyle(
                color: tokens.textPrimary, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  List<MetricDataPoint> _samplePoints() {
    final now = DateTime.now();
    return List.generate(
        12,
        (i) => MetricDataPoint(
            timestamp: now.subtract(Duration(minutes: 11 - i)),
            value: 20 + i * 3.5));
  }

  void _exportMetrics(BuildContext context, DeveloperMetrics metrics) {
    final csv = _metricsToCsv(metrics);
    final jsonStr = jsonEncode(metrics.toJson());
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).canvasColor,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(MeropeTokens.space16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Export Metrics',
              style: TextStyle(
                  color: MeropeColorTokens.darkDefault().textPrimary,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: MeropeTokens.space12),
          ListTile(
            leading: Icon(Icons.table_chart,
                color: MeropeColorTokens.darkDefault().primary),
            title: const Text('Export as CSV'),
            onTap: () => _share(context, csv, 'metrics.csv', 'text/csv'),
          ),
          ListTile(
            leading: Icon(Icons.document_scanner,
                color: MeropeColorTokens.darkDefault().primary),
            title: const Text('Export as JSON'),
            onTap: () =>
                _share(context, jsonStr, 'metrics.json', 'application/json'),
          ),
        ]),
      ),
    );
  }

  void _share(
      BuildContext context, String content, String filename, String mimeType) {
    Clipboard.setData(ClipboardData(text: content));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$filename copied to clipboard'),
        backgroundColor: MeropeColorTokens.darkDefault().primary));
  }

  String _metricsToCsv(DeveloperMetrics metrics) {
    final buffer = StringBuffer();
    buffer.writeln('metric,value');
    buffer.writeln('api_requests,${metrics.apiRequests}');
    buffer.writeln('errors,${metrics.errors}');
    buffer.writeln('avg_latency,${metrics.avgLatency}');
    buffer.writeln('p95_latency,${metrics.p95Latency}');
    buffer.writeln('success_rate,${metrics.successRate}');
    buffer.writeln('unique_users,${metrics.uniqueUsers}');
    buffer.writeln('bandwidth_used,${metrics.bandwidthUsed}');
    for (final ep in metrics.topEndpoints) {
      buffer.writeln('${ep.method}_${ep.path},${ep.requestCount}');
    }
    return buffer.toString();
  }
}

class SparklineCustom extends StatelessWidget {
  final List<double> values;
  final Color color;

  const SparklineCustom({super.key, required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: RepaintBoundary(
        child: CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: _SparkCustomPainter(values: values, color: color),
        ),
      ),
    );
  }
}

class _SparkCustomPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _SparkCustomPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) > 0 ? maxVal - minVal : 1.0;
    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - ((values[i] - minVal) / range) * size.height;
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant _SparkCustomPainter old) => old.values != values;
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final MeropeColorTokens tokens;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
          border: Border.all(color: tokens.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: tokens.textSecondary, size: 14),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(color: tokens.textSecondary, fontSize: 12))
        ]),
        const SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: TextStyle(
                color: tokens.textSecondary.withValues(alpha: 0.7),
                fontSize: 10)),
      ]),
    );
  }
}
