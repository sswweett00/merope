import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import '../domain/models/developer_metrics_model.dart';
import '../logic/providers/developer_apps_provider.dart';
import '../logic/providers/developer_metrics_provider.dart';
import 'widgets/metric_line_chart.dart';
import 'screens/api_testing_screen.dart';
import 'screens/sdk_generator_screen.dart';
import 'screens/logs_viewer_screen.dart';

class ForgeStudioScreen extends ConsumerStatefulWidget {
  const ForgeStudioScreen({super.key});

  @override
  ConsumerState<ForgeStudioScreen> createState() => _ForgeStudioScreenState();
}

class _ForgeStudioScreenState extends ConsumerState<ForgeStudioScreen> {
  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final ownerId = ref.watch(developerOwnerIdProvider);
    final appsAsync = ref.watch(developerAppsProvider(ownerId));

    return Scaffold(
      backgroundColor: tokens.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: tokens.surface,
            pinned: true,
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Merope Forge Studio',
                  style: TextStyle(color: tokens.textPrimary)),
              background: _buildHero(tokens, appsAsync, ownerId),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.api, color: tokens.textPrimary),
                  tooltip: 'API Testing',
                  onPressed: () => _openApiTesting(context, ownerId, ref)),
              IconButton(
                  icon: Icon(Icons.code, color: tokens.textPrimary),
                  tooltip: 'SDK Generator',
                  onPressed: () => _openSdkGenerator(context, ownerId)),
              IconButton(
                  icon: Icon(Icons.terminal, color: tokens.textPrimary),
                  tooltip: 'Logs',
                  onPressed: () => _openLogs(context)),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: MeropeTokens.space24,
                  vertical: MeropeTokens.space12),
              child: Text('Content Crafting',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: tokens.textPrimary)),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: MeropeTokens.space24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (context, i) => _buildToolCard(i, tokens),
                  childCount: 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3),
            ),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(height: MeropeTokens.space24)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openApiTesting(context, ownerId, ref),
        backgroundColor: tokens.primary,
        icon: const Icon(Icons.bug_report),
        label: const Text('API Test Lab'),
      ),
    );
  }

  Widget _buildHero(MeropeColorTokens tokens,
      AsyncValue<List<dynamic>> appsAsync, String ownerId) {
    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: MeropeTokens.space16),
        Text('Analytics Pulse',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: tokens.textPrimary)),
        const SizedBox(height: MeropeTokens.space12),
        _buildMetricsHeader(tokens),
        const SizedBox(height: MeropeTokens.space16),
        StreamBuilder<DeveloperMetrics>(
          stream: ref.watch(developerMetricsProvider(ownerId).stream),
          builder: (context, snapshot) {
            final metrics = snapshot.data ??
                DeveloperMetrics(appId: ownerId, dataPoints: _samplePoints());
            return SizedBox(
              height: 120,
              child: MetricLineChart(
                  data: metrics.dataPoints,
                  lineColor: tokens.primary,
                  height: 120,
                  emptyLabel: 'Live traffic telemetry'),
            );
          },
        ),
      ]),
    );
  }

  Widget _buildMetricsHeader(MeropeColorTokens tokens) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _buildMetric('SYNC RATE', '99.9%', tokens),
      _buildMetric('LATENCY', '24ms', tokens),
      _buildMetric('LOAD', '12%', tokens),
    ]);
  }

  Widget _buildMetric(String label, String value, MeropeColorTokens tokens) {
    return Column(children: [
      Text(label,
          style: TextStyle(
              color: tokens.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(value,
          style: TextStyle(
              color: tokens.primary,
              fontSize: 20,
              fontWeight: FontWeight.w900)),
    ]);
  }

  List<MetricDataPoint> _samplePoints() {
    final now = DateTime.now();
    return List.generate(
        20,
        (i) => MetricDataPoint(
            timestamp: now.subtract(Duration(seconds: 19 - i * 2)),
            value: 10 + i * 2.3));
  }

  Widget _buildToolCard(int index, MeropeColorTokens tokens) {
    final tools = [
      ('Forge Orbit', Icons.video_call),
      ('Forge Resonance', Icons.mic_external_on),
      ('Forge Spark', Icons.bolt),
      ('Forge Prism', Icons.filter_b_and_w),
    ];
    final (label, icon) = tools[index];
    return MeropeCard(
      color: tokens.surface,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: tokens.primary, size: 32),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: tokens.textPrimary)),
      ]),
    );
  }

  void _openApiTesting(BuildContext context, String ownerId, WidgetRef ref) {
    final app = ref
        .read(developerAppsProvider(ownerId).future)
        .then((list) => list.isNotEmpty ? list.first : null);
    app.then((a) {
      if (a != null) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ApiTestingScreen(appId: a.id)));
      }
    });
  }

  void _openSdkGenerator(BuildContext context, String ownerId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SdkGeneratorScreen(ownerId: ownerId)));
  }

  void _openLogs(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LogsViewerScreen()));
  }
}
