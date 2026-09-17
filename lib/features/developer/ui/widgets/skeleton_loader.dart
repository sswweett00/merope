import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader(
      {super.key,
      required this.width,
      required this.height,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final tokens = MeropeColorTokens.darkDefault();
    return RepaintBoundary(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: tokens.border.withValues(alpha: 0.5),
          borderRadius:
              borderRadius ?? BorderRadius.circular(MeropeTokens.radiusXs),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class AuditLogList extends ConsumerWidget {
  final List<AuditLogEntry> entries;

  const AuditLogList({super.key, required this.entries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = MeropeColorTokens.darkDefault();
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(MeropeTokens.space24),
          child: Text('No audit events recorded',
              style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final entry = entries[index];
          return RepaintBoundary(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _statusColor(entry.status, tokens),
                radius: 14,
                child: Icon(_statusIcon(entry.status),
                    size: 14, color: tokens.onPrimary),
              ),
              title: Text(entry.action,
                  style: TextStyle(
                      color: tokens.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              subtitle: Text(
                  '${entry.actorId} • ${_formatTime(entry.timestamp)}',
                  style: TextStyle(color: tokens.textSecondary, fontSize: 11)),
              trailing: entry.details != null
                  ? Icon(Icons.info_outline,
                      size: 14,
                      color: tokens.textSecondary.withValues(alpha: 0.5))
                  : null,
            ),
          );
        },
        childCount: entries.length,
      ),
    );
  }

  Color _statusColor(AuditStatus status, MeropeColorTokens tokens) {
    switch (status) {
      case AuditStatus.success:
        return tokens.onlineStatus;
      case AuditStatus.failed:
        return tokens.dndStatus;
      case AuditStatus.warning:
        return tokens.idleStatus;
    }
  }

  IconData _statusIcon(AuditStatus status) {
    switch (status) {
      case AuditStatus.success:
        return Icons.check_circle;
      case AuditStatus.failed:
        return Icons.error;
      case AuditStatus.warning:
        return Icons.warning;
    }
  }

  String _formatTime(DateTime ts) {
    final now = DateTime.now();
    final diff = now.difference(ts);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

enum AuditStatus { success, failed, warning }

class AuditLogEntry {
  final String id;
  final String action;
  final String actorId;
  final AuditStatus status;
  final DateTime timestamp;
  final Map<String, dynamic>? details;

  const AuditLogEntry({
    required this.id,
    required this.action,
    required this.actorId,
    required this.status,
    required this.timestamp,
    this.details,
  });
}
