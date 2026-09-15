import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import '../../data/models/suspicious_account.dart';

class ModerationDetailScreen extends ConsumerWidget {
  final ModerationQueueItem item;

  const ModerationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.background,
        foregroundColor: tokens.textPrimary,
        title: Text(item.username, style: TextStyle(color: tokens.textPrimary)),
      ),
      body: Center(
        child: Text(
          item.displayName,
          style: TextStyle(color: tokens.textPrimary),
        ),
      ),
    );
  }
}
