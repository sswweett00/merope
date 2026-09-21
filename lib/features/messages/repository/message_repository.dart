import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_core/data/services/messaging_api_service.dart';
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
  Future<void> markAsRead(String channelId, String messageId);
  Future<void> forwardMessage(String messageId, String toChannelId);
  Future<List<Conversation>> getConversations();
  Future<void> createDirectChat(String otherUserId);
  Future<void> createGroupChat(String name, List<String> participantIds);
  Future<void> archiveConversation(String conversationId, bool archived);
  Future<void> muteConversation(String conversationId, int? durationMinutes);
  Future<List<ChatFolder>> getFolders();
  Future<void> createFolder(String name, List<String> conversationIds);
  Future<void> updateFolder(String folderId, String name, List<String> conversationIds);
  Future<void> deleteFolder(String folderId);
}

/// Server-authoritative message repository. Local Drift storage is not used
/// for message mutations; the API is the source of truth.
class RemoteMessageRepository implements IMessageRepository {
  RemoteMessageRepository(this._api, this._messaging);

  final ApiClient _api;
  final MessagingApiService _messaging;

  Never _unsupported(String operation) =>
      throw UnsupportedError('$operation is not supported by the active server API');

  @override
  Future<List<MeropeMessage>> getMessages(String channelId) async {
    final result = await _messaging.getMessages(channelId);
    if (result.error != null) throw StateError(result.error!);
    return result.messages;
  }

  @override
  Future<void> sendMessage(MeropeMessage message) async {
    final content = message.blocks
        .where((block) => block.type == MessageBlockType.text)
        .map((block) => block.content)
        .join('\n');
    final response = await _api.post<Map<String, dynamic>>(
      '/messaging/rooms/${message.channelId}/messages',
      data: {
        'content': content,
        'message_type': message.messageType ?? 'text',
        'is_encrypted': message.isEncrypted,
        if (message.encryptedPayload != null) 'encrypted_payload': message.encryptedPayload,
        if (message.parentMessageId != null) 'parent_id': message.parentMessageId,
        if (message.fileUrl != null) 'file_url': message.fileUrl,
      },
    );
    if (response.isError || response.data == null) {
      throw StateError('Failed to send message');
    }
  }

  @override
  Future<void> updateMessage(String messageId, String newContent) async {
    final response = await _api.put<Map<String, dynamic>>(
      '/messaging/messages/$messageId',
      data: {'content': newContent},
    );
    if (response.isError) throw StateError('Failed to update message');
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    final response = await _api.delete<Map<String, dynamic>>(
      '/messaging/messages/$messageId',
    );
    if (response.isError) throw StateError('Failed to delete message');
  }

  @override
  Future<void> addReaction(String messageId, String emoji) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/messaging/messages/$messageId/react',
      data: {'emoji': emoji},
    );
    if (response.isError) throw StateError('Failed to react to message');
  }

  @override
  Future<void> removeReaction(String messageId, String emoji) =>
      _unsupported('Removing message reactions');

  @override
  Future<void> pinMessage(String messageId) =>
      _unsupported('Pinning messages');

  @override
  Future<void> markAsRead(String channelId, String messageId) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/messaging/rooms/$channelId/read',
      data: {'message_id': messageId},
    );
    if (response.isError) throw StateError('Failed to mark message as read');
  }

  @override
  Future<void> forwardMessage(String messageId, String toChannelId) =>
      _unsupported('Forwarding messages');

  @override
  Future<List<Conversation>> getConversations() async {
    final result = await _messaging.getConversations();
    if (result.error != null) throw StateError(result.error!);
    return result.conversations;
  }

  @override
  Future<void> createDirectChat(String otherUserId) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/messaging/rooms',
      data: {'user_id': otherUserId},
    );
    if (response.isError) throw StateError('Failed to create direct chat');
  }

  @override
  Future<void> createGroupChat(String name, List<String> participantIds) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/messaging/rooms/group',
      data: {'name': name, 'user_ids': participantIds},
    );
    if (response.isError) throw StateError('Failed to create group chat');
  }

  @override
  Future<void> archiveConversation(String conversationId, bool archived) =>
      _unsupported('Archiving conversations');

  @override
  Future<void> muteConversation(
      String conversationId, int? durationMinutes) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/messaging/rooms/$conversationId/mute',
      data: {'minutes': durationMinutes ?? 0},
    );
    if (response.isError) throw StateError('Failed to update mute state');
  }

  @override
  Future<List<ChatFolder>> getFolders() async => const [];

  @override
  Future<void> createFolder(String name, List<String> conversationIds) =>
      _unsupported('Creating chat folders');

  @override
  Future<void> updateFolder(
      String folderId, String name, List<String> conversationIds) =>
      _unsupported('Updating chat folders');

  @override
  Future<void> deleteFolder(String folderId) =>
      _unsupported('Deleting chat folders');
}

final messageRepositoryProvider = Provider<IMessageRepository>((ref) {
  return RemoteMessageRepository(
    ApiClient(),
    ref.watch(messagingApiServiceProvider),
  );
});
