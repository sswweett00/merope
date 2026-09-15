import 'dart:convert';
import 'package:uuid/uuid.dart';

enum OperationType { create, update, delete }

/// Represents an atomic client-side change for the Offline-First Sync Queue
class OperationLogEntry {
  final String id;
  final String entityType; // e.g., 'message', 'channel', 'user_profile'
  final String entityId;
  final OperationType type;
  final Map<String, dynamic> payload;
  final int timestamp;
  final int clientSequence;
  bool isSynced;

  OperationLogEntry({
    String? id,
    required this.entityType,
    required this.entityId,
    required this.type,
    required this.payload,
    required this.timestamp,
    required this.clientSequence,
    this.isSynced = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'entityType': entityType,
        'entityId': entityId,
        'type': type.name,
        'payload': payload,
        'timestamp': timestamp,
        'clientSequence': clientSequence,
        'isSynced': isSynced,
      };

  factory OperationLogEntry.fromJson(Map<String, dynamic> json) =>
      OperationLogEntry(
        id: json['id'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        type: OperationType.values.firstWhere(
          (e) => e.name == json['type'] as String,
          orElse: () => OperationType.create,
        ),
        payload: json['payload'] is String
            ? jsonDecode(json['payload'] as String) as Map<String, dynamic>
            : Map<String, dynamic>.from(json['payload'] as Map),
        timestamp: json['timestamp'] as int,
        clientSequence: json['clientSequence'] as int,
        isSynced: json['isSynced'] as bool? ?? false,
      );

  String serialize() => jsonEncode(toJson());
}
