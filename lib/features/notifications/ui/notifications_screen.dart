import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';

import '../data/providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final notificationsAsync = ref.watch(notificationsListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _Header(tokens: tokens, onClear: () => ref.read(notificationsListProvider.notifier).clearAll()),
          Expanded(
            child: notificationsAsync.when(
              data: (notifications) => notifications.isEmpty
                ? _EmptyNotifications(tokens: tokens)
                : ListView.builder(
                    padding: const EdgeInsets.all(MeropeTokens.space24),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return _NotificationItem(notification: notifications[index], tokens: tokens);
                    },
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Signals Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final MeropeColorTokens tokens;
  final VoidCallback onClear;
  const _Header({required this.tokens, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Signal Center',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: tokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          TextButton(
            onPressed: onClear,
            child: Text('Clear All', style: TextStyle(color: tokens.primary)),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _EmptyNotifications({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: tokens.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text('No new signals', style: TextStyle(color: tokens.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final MeropeNotification notification;
  final MeropeColorTokens tokens;

  const _NotificationItem({required this.notification, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: MeropeTokens.space12),
      child: MeropeCard(
        color: tokens.surface,
        child: ListTile(
          leading: _NotificationIcon(type: notification.type, tokens: tokens),
          title: RichText(
            text: TextSpan(
              style: TextStyle(color: tokens.textPrimary, fontSize: 14),
              children: [
                TextSpan(text: '${notification.authorName} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: notification.message),
              ],
            ),
          ),
          subtitle: Text(notification.timestamp, style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
          trailing: notification.type == MeropeNotificationType.sync
              ? TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Syncing...')),
                    );
                  },
                  child: const Text('Sync Back'),
                )
              : null,
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final MeropeNotificationType type;
  final MeropeColorTokens tokens;

  const _NotificationIcon({required this.type, required this.tokens});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case MeropeNotificationType.pulse:
        icon = Icons.flash_on;
        color = Colors.amber;
        break;
      case MeropeNotificationType.echo:
        icon = Icons.bubble_chart;
        color = tokens.primary;
        break;
      case MeropeNotificationType.sync:
        icon = Icons.sync;
        color = tokens.secondary;
        break;
      case MeropeNotificationType.system:
        icon = Icons.sensors;
        color = tokens.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
