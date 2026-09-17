import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MeropeNotificationType { pulse, echo, sync, system }

class MeropeNotification {
  final String id;
  final String authorName;
  final String message;
  final String timestamp;
  final MeropeNotificationType type;

  MeropeNotification({
    required this.id,
    required this.authorName,
    required this.message,
    required this.timestamp,
    required this.type,
  });
}

class NotificationsList extends AsyncNotifier<List<MeropeNotification>> {
  @override
  FutureOr<List<MeropeNotification>> build() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      MeropeNotification(
        id: '1',
        authorName: 'Signal Architect',
        message: 'pulsed your signal.',
        timestamp: '2 hours ago',
        type: MeropeNotificationType.pulse,
      ),
      MeropeNotification(
        id: '2',
        authorName: 'VanguardTech',
        message: 'echoed your signal.',
        timestamp: '4 hours ago',
        type: MeropeNotificationType.echo,
      ),
      MeropeNotification(
        id: '3',
        authorName: 'NeuralPulse',
        message: 'synced with your node.',
        timestamp: '5 hours ago',
        type: MeropeNotificationType.sync,
      ),
      MeropeNotification(
        id: '4',
        authorName: 'Merope System',
        message: 'notified you of a neural update.',
        timestamp: '1 day ago',
        type: MeropeNotificationType.system,
      ),
    ];
  }

  Future<void> clearAll() async {
    state = const AsyncValue.data([]);
  }
}

final notificationsListProvider =
    AsyncNotifierProvider<NotificationsList, List<MeropeNotification>>(
        NotificationsList.new);
