import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:merope_core/data/database/merope_database.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/message_model.dart';
import '../domain/models/chat_models.dart';

abstract class IMessageRepository {
  Future<List<MeropeMessage>> getMessages(String channelId);
  Future<void> sendMessage(MeropeMessage message);
  Future<void> updateMessage(String messageId, String newContent);
  Future<void> deleteMessage(String messageId);
  Future<void> addReaction(String messageId, String emoji);
  Future<void> removeReaction(String messageId, String emoji);
  Future<void> pinMessage(String messageId);
  Future<void> markAsRead(String messageId);
  Future<void> forwardMessage(String messageId, String toChannelId);

  // Conversation management
  Future<List<Conversation>> getConversations();
  Future<void> createDirectChat(String otherUserId);
  Future<void> createGroupChat(String name, List<String> participantIds);
  Future<void> archiveConversation(String conversationId, bool archived);
  Future<void> muteConversation(String conversationId, int? durationMinutes);

  // Folder management
  Future<List<ChatFolder>> getFolders();
  Future<void> createFolder(String name, List<String> conversationIds);
  Future<void> updateFolder(
    String folderId,
    String name,
    List<String> conversationIds,
  );
  Future<void> deleteFolder(String folderId);
}

class DriftMessageRepository implements IMessageRepository {
  final MeropeDatabase _db;
  final _uuid = const Uuid();

  DriftMessageRepository(this._db);

  @override
  Future<List<MeropeMessage>> getMessages(String channelId) async {
    final query = _db.select(_db.messages)
      ..where((t) => t.channelId.equals(channelId))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    final rows = await query.get();

    return rows.map((row) {
      List<MessageBlock> blocks;
      try {
        final decoded = jsonDecode(row.content) as List;
        blocks = decoded
            .map((e) => MessageBlock.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        blocks = [
          MessageBlock(type: MessageBlockType.text, content: row.content),
        ];
      }

      return MeropeMessage(
        id: row.id,
        channelId: row.channelId,
        authorId: row.authorId,
        authorName: row.authorName ?? 'Unknown',
        authorAvatar: row.authorAvatar ?? '',
        blocks: blocks,
        createdAt: row.createdAt.millisecondsSinceEpoch,
        updatedAt: row.updatedAt.millisecondsSinceEpoch,
        isEncrypted: row.isEncrypted,
        reactions: (row.reactions != null)
            ? (jsonDecode(row.reactions!) as List<dynamic>? ?? [])
                .cast<String>()
            : [],
        threadId: row.threadId,
        version: row.version,
      );
    }).toList();
  }

  @override
  Future<void> sendMessage(MeropeMessage message) async {
    await _db.transaction(() async {
      // 1. Write to local database (Immediate UI Feedback)
      await _db.into(_db.messages).insert(MessagesCompanion.insert(
            id: message.id,
            channelId: message.channelId,
            authorId: message.authorId,
            authorName: Value(message.authorName),
            authorAvatar: Value(message.authorAvatar),
            content: jsonEncode(message.blocks.map((b) => b.toJson()).toList()),
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
            updatedAt:
                Value(DateTime.fromMillisecondsSinceEpoch(message.updatedAt)),
            isEncrypted: Value(message.isEncrypted),
            reactions: Value(jsonEncode(message.reactions)),
            threadId: Value(message.threadId),
            version: Value(message.version),
          ));

      // 2. Log operation for Chronos Sync Engine
      await _logOperation(
        entityType: 'message',
        entityId: message.id,
        operation: 'create',
        metadata: {
          'channel_id': message.channelId,
          'content': message.blocks.map((b) => b.toJson()).toList(),
          'is_encrypted': message.isEncrypted,
        },
      );
    });
  }

  @override
  Future<void> updateMessage(String messageId, String newContent) async {
    await _db.transaction(() async {
      await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
          .write(
        MessagesCompanion(
          content: Value(newContent),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _logOperation(
        entityType: 'message',
        entityId: messageId,
        operation: 'update',
        metadata: {'content': newContent},
      );
    });
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.messages)..where((m) => m.id.equals(messageId)))
          .go();

      await _logOperation(
        entityType: 'message',
        entityId: messageId,
        operation: 'delete',
      );
    });
  }

  Future<void> _logOperation({
    required String entityType,
    required String entityId,
    required String operation,
    Map<String, dynamic>? metadata,
  }) async {
    await _db.into(_db.operationLogs).insert(
          OperationLogsCompanion.insert(
            id: _uuid.v4(),
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            performedBy: 'current_user', // Placeholder
            performedAt: DateTime.now(),
            metadata: Value(metadata != null ? jsonEncode(metadata) : null),
          ),
        );
  }

  @override
  Future<void> addReaction(String messageId, String emoji) async {
    // Simplified reaction handling
  }

  @override
  Future<void> removeReaction(String messageId, String emoji) async {
    // Simplified reaction handling
  }

  @override
  Future<void> pinMessage(String messageId) async {
    // Simplified pin handling
  }

  @override
  Future<void> markAsRead(String messageId) async {
    // Simplified read handling
  }

  @override
  Future<void> forwardMessage(String messageId, String toChannelId) async {
    // Simplified forward handling
  }

  @override
  Future<List<Conversation>> getConversations() async {
    return [];
  }

  @override
  Future<void> createDirectChat(String otherUserId) async {
    // Simplified implementation
  }

  @override
  Future<void> createGroupChat(String name, List<String> participantIds) async {
    // Simplified implementation
  }

  @override
  Future<void> archiveConversation(String conversationId, bool archived) async {
    // Simplified implementation
  }

  @override
  Future<void> muteConversation(
    String conversationId,
    int? durationMinutes,
  ) async {
    // Simplified implementation
  }

  @override
  Future<List<ChatFolder>> getFolders() async {
    return [];
  }

  @override
  Future<void> createFolder(String name, List<String> conversationIds) async {
    // Simplified implementation
  }

  @override
  Future<void> updateFolder(
    String folderId,
    String name,
    List<String> conversationIds,
  ) async {
    // Simplified implementation
  }

  @override
  Future<void> deleteFolder(String folderId) async {
    // Simplified implementation
  }
}
