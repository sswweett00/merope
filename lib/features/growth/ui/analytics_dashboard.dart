import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../../moderation/logic/moderation_provider.dart';
import 'package:merope_core/sync/sync_provider.dart';

class AnalyticsDashboard extends ConsumerWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text("Insights", style: TextStyle(color: tokens.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricGrid(tokens),
            const SizedBox(height: 32),
            _buildSyncTelemetry(ref, tokens),
            const SizedBox(height: 32),
            Text(
              "Synergy Impact Vector",
              style: TextStyle(
                  color: tokens.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _SynergyImpactChart(tokens: tokens),
            const SizedBox(height: 32),
            _buildSuspiciousList(ref, tokens),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncTelemetry(WidgetRef ref, MeropeColorTokens tokens) {
    final telemetryAsync = ref.watch(syncTelemetryControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Network Sync Status",
          style: TextStyle(
              color: tokens.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        telemetryAsync.when(
          data: (t) => Row(
            children: [
              Expanded(
                  child: _TelemetryCard(
                      label: "Pending Ops",
                      value: "${t.pendingOperations}",
                      tokens: tokens)),
              const SizedBox(width: 12),
              Expanded(
                  child: _TelemetryCard(
                      label: "Avg Latency",
                      value: "${t.averageLatencyMs.toInt()}ms",
                      tokens: tokens)),
              const SizedBox(width: 12),
              Expanded(
                  child: _TelemetryCard(
                      label: "Total Synced",
                      value: "${t.totalSynced}",
                      tokens: tokens)),
            ],
          ),
          loading: () => const Center(child: LinearProgressIndicator()),
          error: (err, _) => Text("Telemetry Offline: $err"),
        ),
      ],
    );
  }

  Widget _buildSuspiciousList(WidgetRef ref, MeropeColorTokens tokens) {
    final suspiciousAsync = ref.watch(suspiciousAccountsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Suspicious Activity",
          style: TextStyle(
              color: tokens.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        suspiciousAsync.when(
          data: (accounts) => Column(
            children: accounts
                .map((acc) => _SuspiciousTile(acc: acc, tokens: tokens))
                .toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text("Error loading activity: $err"),
        ),
      ],
    );
  }

  Widget _buildMetricGrid(MeropeColorTokens tokens) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _MetricCard(
            label: "Active Users",
            value: "14.2k",
            trend: "+12%",
            tokens: tokens),
        _MetricCard(
            label: "Bot Probability",
            value: "3.4%",
            trend: "-2%",
            tokens: tokens,
            isWarning: true),
        _MetricCard(
            label: "Data Synced",
            value: "2.8 TB",
            trend: "+5%",
            tokens: tokens),
        _MetricCard(
            label: "Avg Latency", value: "32ms", trend: "-8%", tokens: tokens),
      ],
    );
  }
}

class _SynergyImpactChart extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _SynergyImpactChart({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 1; i <= 4; i++)
            Container(
              width: 50.0 * i,
              height: 50.0 * i,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: tokens.primary.withValues(alpha: 0.1)),
              ),
            ),
          CustomPaint(
            size: const Size(200, 200),
            painter: _RadarPainter(color: tokens.primary),
          ),
          Positioned(
            bottom: 0,
            child: Text('Resonance Depth: 82%',
                style: TextStyle(
                    color: tokens.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Color color;
  _RadarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 20)
      ..lineTo(size.width - 40, size.height / 3)
      ..lineTo(size.width - 20, size.height - 40)
      ..lineTo(size.width / 2, size.height - 10)
      ..lineTo(20, size.height - 50)
      ..lineTo(40, size.height / 3)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(
        path,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TelemetryCard extends StatelessWidget {
  final String label;
  final String value;
  final MeropeColorTokens tokens;

  const _TelemetryCard(
      {required this.label, required this.value, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: tokens.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: TextStyle(color: tokens.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}

class _SuspiciousTile extends ConsumerWidget {
  final dynamic acc;
  final MeropeColorTokens tokens;

  const _SuspiciousTile({required this.acc, required this.tokens});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            child:
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(acc.userId,
                    style: TextStyle(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.bold)),
                Text(acc.reason,
                    style:
                        TextStyle(color: tokens.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            children: [
              Text("${(acc.botProbability * 100).toInt()}%",
                  style: const TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold)),
              const Text("Risk",
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 16),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: tokens.textSecondary),
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'ban',
                  child:
                      Text('Ban Account', style: TextStyle(color: Colors.red))),
              const PopupMenuItem(value: 'safe', child: Text('Mark as Safe')),
            ],
            onSelected: (val) {
              if (val == 'ban') {
                ref
                    .read(suspiciousAccountsControllerProvider.notifier)
                    .banAccount(acc.userId);
              } else {
                ref
                    .read(suspiciousAccountsControllerProvider.notifier)
                    .markAsSafe(acc.userId);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final MeropeColorTokens tokens;
  final bool isWarning;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.trend,
    required this.tokens,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isWarning ? Colors.orange.withValues(alpha: 0.05) : tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isWarning
                ? Colors.orange.withValues(alpha: 0.3)
                : tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: TextStyle(
                  color: isWarning ? Colors.orange : tokens.textSecondary,
                  fontSize: 12,
                  fontWeight: isWarning ? FontWeight.bold : FontWeight.normal)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(value,
                  style: TextStyle(
                      color: tokens.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(trend,
                  style: TextStyle(
                      color: trend.startsWith('+')
                          ? (isWarning ? Colors.red : Colors.green)
                          : (isWarning ? Colors.green : Colors.red),
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
