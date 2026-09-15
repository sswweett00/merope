import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import '../domain/models/bot_model.dart';
import '../logic/providers/developer_bots_provider.dart';
import 'widgets/skeleton_loader.dart';

class BotDashboardScreen extends ConsumerStatefulWidget {
  final String appId;

  const BotDashboardScreen({super.key, required this.appId});

  @override
  ConsumerState<BotDashboardScreen> createState() => _BotDashboardScreenState();
}

class _BotDashboardScreenState extends ConsumerState<BotDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'all';
  final Set<String> _selected = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final botsAsync = ref.watch(developerBotsProvider(widget.appId));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text('Developer Bots', style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
        actions: [
          if (_selected.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check_box, color: Colors.blue),
              tooltip: 'Selected (${_selected.length})',
              onPressed: () {},
            ),
          TextButton.icon(
            onPressed: () => _showCreateBotDialog(context),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create Bot'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(tokens),
          if (_selected.isNotEmpty) _buildBulkActions(tokens),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(developerBotsProvider(widget.appId).future),
              child: botsAsync.when(
                data: (bots) => _buildBotList(bots, tokens),
                loading: () => _buildLoadingList(),
                error: (error, _) => _buildError(error, tokens),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MeropeTokens.space16, vertical: MeropeTokens.space12),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: tokens.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search bots...',
              hintStyle: TextStyle(color: tokens.textSecondary.withValues(alpha: 0.5)),
              prefixIcon: Icon(Icons.search, color: tokens.textSecondary),
              filled: true,
              fillColor: tokens.background,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(MeropeTokens.radiusSm), borderSide: BorderSide(color: tokens.border)),
            ),
          ),
        ),
        const SizedBox(width: MeropeTokens.space12),
        _filterChip('all', 'All', tokens),
        _filterChip('active', 'Active', tokens),
        _filterChip('inactive', 'Inactive', tokens),
      ]),
    );
  }

  Widget _filterChip(String value, String label, MeropeColorTokens tokens) {
    final selected = _filter == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 11, color: selected ? tokens.onPrimary : tokens.textSecondary)),
        selected: selected,
        onSelected: (_) {
          setState(() => _filter = value);
          MeropeHaptics.selectionClick();
        },
        selectedColor: tokens.primary,
        backgroundColor: tokens.surfaceVariant,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildBulkActions(MeropeColorTokens tokens) {
    return Container(
      color: tokens.surfaceVariant,
      padding: const EdgeInsets.symmetric(horizontal: MeropeTokens.space16, vertical: MeropeTokens.space8),
      child: Row(children: [
        Text('${_selected.length} selected', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
        const Spacer(),
        TextButton.icon(onPressed: () => _bulkToggle(true), icon: const Icon(Icons.power, size: 14), label: const Text('Enable')),
        TextButton.icon(onPressed: () => _bulkToggle(false), icon: const Icon(Icons.power_off, size: 14), label: const Text('Disable')),
        TextButton.icon(onPressed: _confirmBulkDelete, icon: const Icon(Icons.delete, size: 14), label: const Text('Delete')),
      ]),
    );
  }

  void _bulkToggle(bool enable) async {
    for (final id in _selected) {
      final bots = await ref.read(developerBotsProvider(widget.appId).future);
      final bot = bots.firstWhere((b) => b.id == id, orElse: () => throw StateError('not found'));
      await ref.read(developerBotsProvider(widget.appId).notifier).updateBot(bot.copyWith(isActive: enable));
    }
    setState(() => _selected.clear());
  }

  void _confirmBulkDelete() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Delete Bots'),
      content: Text('Delete ${_selected.length} bot(s)? This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          for (final id in _selected) {
            ref.read(developerBotsProvider(widget.appId).notifier).deleteBot(id);
          }
          Navigator.pop(context);
          setState(() => _selected.clear());
        }, child: const Text('Delete')),
      ],
    ));
  }

  Widget _buildBotList(List<Bot> bots, MeropeColorTokens tokens) {
    final filtered = _applyFilter(bots);
    if (filtered.isEmpty) {
      return Center(child: Text('No bots match your filter', style: TextStyle(color: tokens.textSecondary)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(MeropeTokens.space16),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: MeropeTokens.space12),
      itemBuilder: (context, i) => _BotCard(
        bot: filtered[i],
        isSelected: _selected.contains(filtered[i].id),
        tokens: tokens,
        onTap: () => _selectBot(filtered[i]),
        onLongPress: () => setState(() => _toggleSelection(filtered[i].id)),
        onToggle: (v) => ref.read(developerBotsProvider(widget.appId).notifier).updateBot(filtered[i].copyWith(isActive: v)),
      ),
    );
  }

  List<Bot> _applyFilter(List<Bot> bots) {
    final query = _searchController.text.toLowerCase();
    var result = bots.where((b) => b.name.toLowerCase().contains(query)).toList();
    if (_filter == 'active') result = result.where((b) => b.isActive).toList();
    if (_filter == 'inactive') result = result.where((b) => !b.isActive).toList();
    return result;
  }

  void _selectBot(Bot bot) {
    if (_selected.isNotEmpty) {
      _toggleSelection(bot.id);
      return;
    }
    _showBotDetail(bot);
  }

  void _toggleSelection(String botId) {
    setState(() {
      if (_selected.contains(botId)) _selected.remove(botId);
      else _selected.add(botId);
    });
    MeropeHaptics.lightImpact();
  }

  void _showBotDetail(Bot bot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MeropeColorTokens.darkDefault().surface,
      isScrollControlled: true,
      builder: (context) => _BotDetailSheet(bot: bot),
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      padding: const EdgeInsets.all(MeropeTokens.space16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: MeropeTokens.space12),
      itemBuilder: (context, i) => const SkeletonLoader(width: double.infinity, height: 120),
    );
  }

  Widget _buildError(Object error, MeropeColorTokens tokens) {
    return Center(child: Text('Error: $error', style: TextStyle(color: tokens.error)));
  }
}

class _BotCard extends StatelessWidget {
  final Bot bot;
  final bool isSelected;
  final MeropeColorTokens tokens;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onToggle;

  const _BotCard({required this.bot, required this.isSelected, required this.tokens, required this.onTap, required this.onLongPress, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final stats = bot.stats;
    final successRate = stats != null && stats.messagesSent > 0 ? (100 - (stats.errorsOccurred / stats.messagesSent * 100).clamp(0, 100)).toStringAsFixed(1) : '100%';
    return RepaintBoundary(
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? tokens.primary.withValues(alpha: 0.1) : tokens.surface,
            borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
            border: Border.all(color: isSelected ? tokens.primary : tokens.border, width: isSelected ? 2 : 1),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(backgroundColor: tokens.primary.withValues(alpha: 0.1), child: Icon(Icons.smart_toy, color: tokens.primary)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(bot.name, style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 16))),
                    if (isSelected) Icon(Icons.check_circle, color: tokens.primary, size: 16),
                  ]),
                  Text('Client ID: ${bot.appId.substring(0, 8)}...', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
                ]),
              ),
              Switch(value: bot.isActive, onChanged: onToggle),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _BotStat(label: 'Req/s', value: '${stats?.messagesSent ?? 0}', tokens: tokens),
              _BotStat(label: 'Errors', value: '${stats?.errorsOccurred ?? 0}', tokens: tokens),
              _BotStat(label: 'Success', value: successRate, tokens: tokens),
              _BotStat(label: 'Lat', value: '${stats?.avgResponseTime.toStringAsFixed(0) ?? "0"}ms', tokens: tokens),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _BotStat extends StatelessWidget {
  final String label;
  final String value;
  final MeropeColorTokens tokens;

  const _BotStat({required this.label, required this.value, required this.tokens});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
    Text(label, style: TextStyle(color: tokens.textSecondary, fontSize: 10)),
  ]);
}

class _BotDetailSheet extends ConsumerWidget {
  final Bot bot;

  const _BotDetailSheet({required this.bot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = MeropeColorTokens.darkDefault();
    final stats = bot.stats;
    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bot.name, style: TextStyle(color: tokens.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: MeropeTokens.space12),
          _detailRow('Description', bot.description ?? '-', tokens),
          _detailRow('Capabilities', bot.capabilities.map((c) => c.type.name).join(', '), tokens),
          _detailRow('Created', bot.createdAt.toIso8601String(), tokens),
          _detailRow('Status', bot.isActive ? 'Active' : 'Inactive', tokens),
          const SizedBox(height: MeropeTokens.space12),
          Text('Analytics', style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: MeropeTokens.space8),
          _detailRow('Messages Sent', '${stats?.messagesSent ?? 0}', tokens),
          _detailRow('Commands Executed', '${stats?.commandsExecuted ?? 0}', tokens),
          _detailRow('Errors', '${stats?.errorsOccurred ?? 0}', tokens),
          _detailRow('Avg Response', '${stats?.avgResponseTime.toStringAsFixed(1) ?? "0"} ms', tokens),
          _detailRow('Uptime', '${(stats?.uptime ?? 0).toStringAsFixed(1)}%', tokens),
        ]),
    );
  }

  Widget _detailRow(String label, String value, MeropeColorTokens tokens) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(color: tokens.textSecondary)),
      Text(value, style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.w600)),
    ]),
  );
}

void _showCreateBotDialog(BuildContext context) {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Create Bot'),
      content: Form(
        key: formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Bot Name', hintText: 'e.g. MessageHandler'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Name required' : (v.length < 3 ? 'Min 3 chars' : null),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState?.validate() == true) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bot created — configure via API')));
              HapticFeedback.lightImpact();
            }
          },
          child: const Text('Create'),
        ),
      ],
    ),
  );
}
