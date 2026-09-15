import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

import '../data/providers/follow_provider.dart';

class FollowListScreen extends ConsumerWidget {
  final String title;

  const FollowListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final followAsync = ref.watch(followListProvider(title));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: tokens.surface,
        elevation: 0,
      ),
      body: followAsync.when(
        data: (users) => users.isEmpty
            ? _EmptyFollowState(tokens: tokens)
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
            final user = users[index];
            final isSyncing = user['isSyncing'] as bool;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: tokens.primary.withValues(alpha: 0.1),
                child: Text(user['username'][0].toUpperCase(), style: TextStyle(color: tokens.primary)),
              ),
              title: Text(user['displayName'], style: TextStyle(color: tokens.textPrimary)),
              subtitle: Text('@${user['username']}', style: TextStyle(color: tokens.textSecondary)),
              trailing: OutlinedButton(
                onPressed: () => ref.read(followListProvider(title).notifier).toggleSync(user['id']),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSyncing ? tokens.primary : Colors.transparent,
                  side: BorderSide(color: tokens.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isSyncing ? 'Following' : 'Follow',
                  style: TextStyle(color: isSyncing ? tokens.onPrimary : tokens.primary),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _EmptyFollowState extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _EmptyFollowState({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: tokens.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            'Henüz kimse yok',
            style: TextStyle(color: tokens.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Bağlantı kurmak için keşfetmeye başlayın.',
            style: TextStyle(color: tokens.textSecondary.withValues(alpha: 0.6), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
