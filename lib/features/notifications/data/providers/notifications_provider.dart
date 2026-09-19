import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/api_client.dart';

enum MeropeNotificationType { pulse, echo, sync, system }

class MeropeNotification {
  final String id;
  final String authorName;
  final String message;
  final String timestamp;
  final MeropeNotificationType type;

  const MeropeNotification({
    required this.id,
    required this.authorName,
    required this.message,
    required this.timestamp,
    required this.type,
  });
}

class NotificationsList extends AsyncNotifier<List<MeropeNotification>> {
  static final ApiClient _api = ApiClient();

  @override
  FutureOr<List<MeropeNotification>> build() async {
    final result = await _api.get<dynamic>('/notifications/activity');
    if (result.isError) {
      throw StateError(
          'Failed to load notifications (${result.statusCode ?? 0})');
    }

    final payload = result.data;
    if (payload is! Map<String, dynamic>) {
      throw StateError('Invalid notification response');
    }

    final raw = payload['notifications'];
    if (raw is! List) {
      return const <MeropeNotification>[];
    }

    return raw.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      final type = _parseType(map['type']?.toString());
      final sender = (map['senderUsername'] ?? '').toString().trim();
      final body = _messageFor(map, type);
      final createdAt = DateTime.tryParse(map['createdAt']?.toString() ?? '');

      return MeropeNotification(
        id: (map['id'] ?? '').toString(),
        authorName: sender.isEmpty ? 'Merope System' : sender,
        message: body,
        timestamp: _relativeTime(createdAt),
        type: type,
      );
    }).toList(growable: false);
  }

  Future<void> clearAll() async {
    final result = await _api.delete<dynamic>('/notifications');
    if (result.isError) {
      throw StateError(
          'Failed to clear notifications (${result.statusCode ?? 0})');
    }
    state = const AsyncValue.data(<MeropeNotification>[]);
  }

  static MeropeNotificationType _parseType(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'like':
      case 'reaction':
      case 'pulse':
        return MeropeNotificationType.pulse;
      case 'comment':
      case 'repost':
      case 'echo':
        return MeropeNotificationType.echo;
      case 'follow':
      case 'sync':
        return MeropeNotificationType.sync;
      default:
        return MeropeNotificationType.system;
    }
  }

  static String _messageFor(
    Map<String, dynamic> map,
    MeropeNotificationType type,
  ) {
    final data = map['data'];
    if (data is Map) {
      final message = data['message'] ?? data['body'] ?? data['text'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }

    switch (type) {
      case MeropeNotificationType.pulse:
        return 'reacted to your signal.';
      case MeropeNotificationType.echo:
        return 'interacted with your signal.';
      case MeropeNotificationType.sync:
        return 'connected with your node.';
      case MeropeNotificationType.system:
        return 'sent you a system notification.';
    }
  }

  static String _relativeTime(DateTime? createdAt) {
    if (createdAt == null) return 'Just now';
    final delta = DateTime.now().difference(createdAt.toLocal());
    if (delta.isNegative || delta.inSeconds < 60) return 'Just now';
    if (delta.inMinutes < 60) return '${delta.inMinutes}m ago';
    if (delta.inHours < 24) return '${delta.inHours}h ago';
    if (delta.inDays < 7) return '${delta.inDays}d ago';
    return '${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year}';
  }
}

final notificationsListProvider =
    AsyncNotifierProvider<NotificationsList, List<MeropeNotification>>(
  NotificationsList.new,
);
