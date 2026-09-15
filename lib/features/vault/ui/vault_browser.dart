import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class VaultBrowser extends ConsumerStatefulWidget {
  final String url;
  const VaultBrowser({super.key, required this.url});

  @override
  ConsumerState<VaultBrowser> createState() => _VaultBrowserState();
}

class _VaultBrowserState extends ConsumerState<VaultBrowser> {
  bool _isLoading = true;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: tokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_rounded, size: 14, color: tokens.secondary),
                const SizedBox(width: 4),
                Text('Vault Isolated Browser', style: TextStyle(fontSize: 12, color: tokens.textPrimary)),
              ],
            ),
            Text(widget.url, style: TextStyle(fontSize: 10, color: tokens.textSecondary), overflow: TextOverflow.ellipsis),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: _progress < 1.0
              ? LinearProgressIndicator(value: _progress, backgroundColor: Colors.transparent, color: tokens.primary)
              : const SizedBox.shrink(),
        ),
      ),
      body: Stack(
        children: [
          // In a real implementation, we would use WebViewWidget
          Container(
            color: tokens.background,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.privacy_tip_rounded, size: 48, color: tokens.textSecondary.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  Text(
                    'Sandboxed Environment Active',
                    style: TextStyle(color: tokens.textSecondary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cookies, Tracking & Local Storage are isolated.',
                    style: TextStyle(color: tokens.textSecondary.withValues(alpha: 0.5), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
