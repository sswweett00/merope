import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import '../../domain/models/webhook_model.dart';
import '../../logic/providers/developer_webhooks_provider.dart';
import '../widgets/skeleton_loader.dart';

class WebhooksScreen extends ConsumerStatefulWidget {
  final String appId;

  const WebhooksScreen({super.key, required this.appId});

  @override
  ConsumerState<WebhooksScreen> createState() => _WebhooksScreenState();
}

class _WebhooksScreenState extends ConsumerState<WebhooksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final hooksAsync = ref.watch(developerWebhooksProvider(widget.appId));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text('Webhooks', style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
        actions: [
          TextButton.icon(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('New Webhook')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.refresh(developerWebhooksProvider(widget.appId).future),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(MeropeTokens.space16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: tokens.textPrimary),
              decoration: InputDecoration(
                hintText: 'Filter webhooks...',
                hintStyle: TextStyle(
                    color: tokens.textSecondary.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search, color: tokens.textSecondary),
                filled: true,
                fillColor: tokens.background,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
                    borderSide: BorderSide(color: tokens.border)),
              ),
            ),
          ),
          Expanded(
            child: hooksAsync.when(
              data: (hooks) => _buildWebhookList(hooks, tokens),
              loading: () => ListView.separated(
                  padding: const EdgeInsets.all(MeropeTokens.space16),
                  itemCount: 4,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: MeropeTokens.space12),
                  itemBuilder: (_, __) => const SkeletonLoader(
                      width: double.infinity, height: 120)),
              error: (error, _) => Center(
                  child: Text('Error: $error',
                      style: TextStyle(color: tokens.error))),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildWebhookList(List<Webhook> hooks, MeropeColorTokens tokens) {
    final filtered = hooks
        .where((w) =>
            w.name.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();
    if (filtered.isEmpty) {
      return Center(
          child: Text('No webhooks registered',
              style: TextStyle(color: tokens.textSecondary)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(MeropeTokens.space16),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: MeropeTokens.space12),
      itemBuilder: (context, i) {
        final hook = filtered[i];
        return RepaintBoundary(
            child: _WebhookTile(
                hook: hook,
                tokens: tokens,
                onTest: () => _testDelivery(hook.id),
                onEdit: () => _showRetryEditor(context, hook),
                onToggle: () => ref
                    .read(developerWebhooksProvider(widget.appId).notifier)
                    .toggleWebhook(hook.id, !hook.isActive)));
      },
    );
  }

  void _testDelivery(String webhookId) {
    HapticFeedback.lightImpact();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Testing Webhook'),
              content:
                  const Text('Sending test payload to the webhook endpoint...'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Test delivery sent')));
                    },
                    child: const Text('OK'))
              ],
            ));
    ref
        .read(developerWebhooksProvider(widget.appId).notifier)
        .testDelivery(webhookId);
  }

  void _showRetryEditor(BuildContext context, Webhook hook) {
    final retryCtrl =
        TextEditingController(text: '${hook.retryPolicy?.maxRetries ?? 3}');
    final intervalCtrl =
        TextEditingController(text: '${hook.retryPolicy?.retryInterval ?? 60}');
    final timeoutCtrl =
        TextEditingController(text: '${hook.retryPolicy?.timeout ?? 30}');
    String strategy = hook.retryPolicy?.backoffStrategy.name ?? 'exponential';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Retry Policy — ${hook.name}'),
        content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: retryCtrl,
              decoration:
                  InputDecoration(labelText: 'Max Retries', hintText: '3'),
              keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(
              controller: intervalCtrl,
              decoration: InputDecoration(labelText: 'Retry Interval (s)'),
              keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(
              controller: timeoutCtrl,
              decoration: InputDecoration(labelText: 'Timeout (s)'),
              keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
              value: strategy,
              items: const [
                DropdownMenuItem(value: 'linear', child: Text('Linear')),
                DropdownMenuItem(
                    value: 'exponential', child: Text('Exponential')),
              ],
              onChanged: (v) => strategy = v ?? strategy,
              decoration: InputDecoration(labelText: 'Backoff Strategy')),
          const SizedBox(height: 12),
          _buildDeliveryLog(hook, tokens: null),
        ])),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final updated = hook.copyWith(
                    retryPolicy: WebhookRetryPolicy(
                  maxRetries: int.tryParse(retryCtrl.text) ?? 3,
                  retryInterval: int.tryParse(intervalCtrl.text) ?? 60,
                  backoffStrategy: strategy == 'linear'
                      ? WebhookRetryStrategy.linear
                      : WebhookRetryStrategy.exponential,
                  timeout: int.tryParse(timeoutCtrl.text) ?? 30,
                ));
                ref
                    .read(developerWebhooksProvider(widget.appId).notifier)
                    .updateWebhook(updated);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Retry policy updated')));
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

  Widget _buildDeliveryLog(Webhook hook, {required MeropeColorTokens? tokens}) {
    final t = tokens ?? MeropeColorTokens.darkDefault();
    final logs = hook.deliveryLogs;
    if (logs.isEmpty) {
      return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('No delivery logs',
              style: TextStyle(color: t.textSecondary, fontSize: 12)));
    }
    return Container(
      margin: const EdgeInsets.only(top: 16),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
          color: t.background,
          borderRadius: BorderRadius.circular(MeropeTokens.radiusSm)),
      child: ListView.separated(
        itemCount: logs.length,
        separatorBuilder: (_, __) => Divider(color: t.border, height: 1),
        itemBuilder: (context, i) {
          final log = logs[i];
          return ListTile(
            leading: Icon(log.success ? Icons.check_circle : Icons.error,
                color: log.success ? t.onlineStatus : t.dndStatus, size: 16),
            title: Text('${log.statusCode} • ${_formatTime(log.deliveredAt)}',
                style: TextStyle(color: t.textPrimary, fontSize: 12)),
            subtitle: log.errorMessage != null
                ? Text(log.errorMessage!,
                    style: TextStyle(color: t.error, fontSize: 11))
                : null,
          );
        },
      ),
    );
  }

  String _formatTime(DateTime ts) {
    final diff = DateTime.now().difference(ts);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    return '${diff.inHours}h';
  }

  void _showCreateDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final eventsCtrl =
        TextEditingController(text: 'message.created,user.joined');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Webhook'),
        content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                  labelText: 'Webhook Name',
                  hintText: 'e.g. Delivery Notifier')),
          const SizedBox(height: 12),
          TextField(
              controller: urlCtrl,
              decoration: InputDecoration(
                  labelText: 'Target URL',
                  hintText: 'https://your-app.com/webhook')),
          const SizedBox(height: 12),
          TextField(
              controller: eventsCtrl,
              decoration:
                  InputDecoration(labelText: 'Events (comma separated)')),
        ])),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final url = urlCtrl.text.trim();
                if (name.isEmpty || url.isEmpty) return;
                final events = eventsCtrl.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                ref
                    .read(developerWebhooksProvider(widget.appId).notifier)
                    .createWebhook(widget.appId, name, url, events);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Webhook created')));
                MeropeHaptics.lightImpact();
              },
              child: const Text('Create')),
        ],
      ),
    );
  }
}

class _WebhookTile extends StatelessWidget {
  final Webhook hook;
  final MeropeColorTokens tokens;
  final VoidCallback onTest;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const _WebhookTile(
      {required this.hook,
      required this.tokens,
      required this.onTest,
      required this.onEdit,
      required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final stats = hook.stats;
    final hasFailure = stats != null && stats.failureCount > 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        border: Border.all(
            color: hasFailure
                ? tokens.error.withValues(alpha: 0.5)
                : tokens.onlineStatus.withValues(alpha: 0.3),
            width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.public, color: tokens.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(hook.name,
                  style: TextStyle(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15))),
          Switch(
              value: hook.isActive,
              onChanged: (_) => onToggle(),
              activeColor: tokens.onlineStatus),
        ]),
        const SizedBox(height: 8),
        Text(hook.targetUrl,
            style: TextStyle(
                color: tokens.textSecondary,
                fontSize: 12,
                fontFamily: 'monospace')),
        const SizedBox(height: 12),
        Wrap(
            spacing: 6,
            runSpacing: 4,
            children: hook.events
                .map((e) => Chip(
                      label: Text(e,
                          style: TextStyle(
                              color: tokens.onPrimary.withValues(alpha: 0.9),
                              fontSize: 10)),
                      backgroundColor: tokens.primary.withValues(alpha: 0.15),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList()),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if (stats != null)
            Text(
                '${stats.totalDeliveries} deliveries • ${stats.successCount} ok • ${stats.failureCount} failed',
                style: TextStyle(color: tokens.textSecondary, fontSize: 11)),
          Row(children: [
            TextButton.icon(
                onPressed: onTest,
                icon: Icon(Icons.send, color: tokens.textSecondary, size: 14),
                label: Text('Test',
                    style:
                        TextStyle(color: tokens.textSecondary, fontSize: 11))),
            TextButton.icon(
                onPressed: onEdit,
                icon: Icon(Icons.tune, color: tokens.textSecondary, size: 14),
                label: Text('Policy',
                    style:
                        TextStyle(color: tokens.textSecondary, fontSize: 11))),
          ]),
        ]),
        if (hasFailure)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('⚠ ${stats!.failureCount} delivery failures detected',
                  style: TextStyle(color: tokens.error, fontSize: 11))),
      ]),
    );
  }
}
