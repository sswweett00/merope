import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/utils/merope_haptics.dart';
import '../../domain/models/api_key_model.dart';
import '../../logic/providers/developer_api_keys_provider.dart';
import '../widgets/skeleton_loader.dart';

class ApiKeysScreen extends ConsumerStatefulWidget {
  final String appId;

  const ApiKeysScreen({super.key, required this.appId});

  @override
  ConsumerState<ApiKeysScreen> createState() => _ApiKeysScreenState();
}

class _ApiKeysScreenState extends ConsumerState<ApiKeysScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final keysAsync = ref.watch(developerApiKeysProvider(widget.appId));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text('API Keys', style: TextStyle(color: tokens.textPrimary)),
        iconTheme: IconThemeData(color: tokens.textPrimary),
        actions: [
          TextButton.icon(onPressed: () => _showCreateDialog(context), icon: const Icon(Icons.add, size: 16), label: const Text('New Key')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(developerApiKeysProvider(widget.appId).future),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(MeropeTokens.space16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: tokens.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search keys...',
                hintStyle: TextStyle(color: tokens.textSecondary.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search, color: tokens.textSecondary),
                filled: true,
                fillColor: tokens.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(MeropeTokens.radiusSm), borderSide: BorderSide(color: tokens.border)),
              ),
            ),
          ),
          Expanded(
            child: keysAsync.when(
              data: (keys) => _buildKeyList(keys, tokens),
              loading: () => ListView.separated(padding: const EdgeInsets.all(MeropeTokens.space16), itemCount: 4, separatorBuilder: (_, __) => const SizedBox(height: MeropeTokens.space12), itemBuilder: (_, __) => const SkeletonLoader(width: double.infinity, height: 100)),
              error: (error, _) => Center(child: Text('Error: $error', style: TextStyle(color: tokens.error))),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildKeyList(List<ApiKey> keys, MeropeColorTokens tokens) {
    final filtered = keys.where((k) => k.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    if (filtered.isEmpty) {
      return Center(child: Text('No API keys found', style: TextStyle(color: tokens.textSecondary)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(MeropeTokens.space16),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: MeropeTokens.space12),
      itemBuilder: (context, i) {
        final key = filtered[i];
        return RepaintBoundary(child: _ApiKeyTile(apiKey: key, tokens: tokens, onRevoke: () => _confirmRevoke(key.id), onCopy: () => _copyKey(key)));
      },
    );
  }

  void _copyKey(ApiKey key) {
    if (key.rawKey != null) {
      Clipboard.setData(ClipboardData(text: key.rawKey!));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied ${key.keyPrefix}…'), backgroundColor: MeropeColorTokens.darkDefault().primary));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Raw key not available (fetched from list)')));
    }
    MeropeHaptics.lightImpact();
  }

  void _confirmRevoke(String keyId) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Revoke API Key'),
      content: const Text('This action cannot be undone. The key will become invalid immediately.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          Navigator.pop(context);
          ref.read(developerApiKeysProvider(widget.appId).notifier).revokeApiKey(keyId);
          MeropeHaptics.heavyImpact();
        }, style: ElevatedButton.styleFrom(backgroundColor: MeropeColorTokens.darkDefault().error), child: const Text('Revoke')),
      ],
    ));
  }

  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final scopesController = TextEditingController();
    final ttlController = TextEditingController(text: '30');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate API Key'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameController, decoration: InputDecoration(labelText: 'Key Name', hintText: 'Production Server')),
          const SizedBox(height: 12),
          TextField(controller: descController, decoration: InputDecoration(labelText: 'Description')),
          const SizedBox(height: 12),
          TextField(controller: scopesController, decoration: InputDecoration(labelText: 'Scopes (comma separated)', hintText: 'read,write')),
          const SizedBox(height: 12),
          TextField(controller: ttlController, decoration: InputDecoration(labelText: 'TTL (days)'), keyboardType: TextInputType.number),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) return;
            final scopes = scopesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
            final ttl = int.tryParse(ttlController.text) ?? 30;
            ref.read(developerApiKeysProvider(widget.appId).notifier).createApiKey(widget.appId, name, descController.text.trim(), scopes, ttl);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API key generated')));
            MeropeHaptics.lightImpact();
          }, child: const Text('Generate')),
        ],
      ),
    );
  }
}

class _ApiKeyTile extends StatelessWidget {
  final ApiKey apiKey;
  final MeropeColorTokens tokens;
  final VoidCallback onRevoke;
  final VoidCallback onCopy;

  const _ApiKeyTile({required this.apiKey, required this.tokens, required this.onRevoke, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final isExpired = apiKey.isExpired;
    final remaining = apiKey.expiresAt != null ? apiKey.expiresAt!.difference(DateTime.now()).inDays : null;
    final usage = apiKey.usageStats;
    final usageCount = usage?.totalRequests ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: tokens.surface, borderRadius: BorderRadius.circular(MeropeTokens.radiusMd), border: Border.all(color: tokens.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.key, color: tokens.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(apiKey.maskedDisplay, style: TextStyle(color: tokens.textPrimary, fontFamily: 'monospace', fontWeight: FontWeight.bold))),
          const SizedBox(width: 12),
          IconButton(icon: Icon(Icons.copy, color: tokens.textSecondary, size: 16), tooltip: 'Copy', onPressed: onCopy),
        ]),
        const SizedBox(height: 8),
          Text(apiKey.name, style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.w600)),
          if (apiKey.description != null) Text(apiKey.description!, style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
        const SizedBox(height: 12),
          Wrap(spacing: 6, runSpacing: 4, children: apiKey.scopes.map((s) => Chip(
          label: Text(s, style: TextStyle(color: tokens.onPrimary, fontSize: 10)),
          backgroundColor: tokens.primary.withValues(alpha: 0.2),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        )).toList()),
        const SizedBox(height: 8),
        Row(children: [
          Icon(Icons.schedule, color: isExpired ? tokens.error : tokens.textSecondary, size: 14),
          const SizedBox(width: 4),
          Text(
            remaining != null ? (isExpired ? 'Expired' : '$remaining days left') : 'No expiry',
            style: TextStyle(color: isExpired ? tokens.error : tokens.textSecondary, fontSize: 12),
          ),
          const SizedBox(width: 16),
          Icon(Icons.bar_chart, color: tokens.textSecondary, size: 14),
          const SizedBox(width: 4),
          Text('$usageCount requests', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
        ]),
      ]),
    );
  }
}
