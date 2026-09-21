import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_core/data/services/realtime_client.dart';
import 'package:merope_core/data/services/e2ee_crypto_service.dart';
import 'package:merope_core/data/services/exceptions.dart';
import 'package:merope_models/messages/chat_models.dart';
import 'package:merope_models/messages/message_model.dart';

class MessageListState {
  final List<MeropeMessage> messages;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? nextCursor;
  final String? error;

  const MessageListState({
    this.messages = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.nextCursor,
    this.error,
  });
}

class ConversationListState {
  final List<Conversation> conversations;
  final bool isLoading;
  final String? error;

  const ConversationListState({
    this.conversations = const [],
    this.isLoading = false,
    this.error,
  });
}

class SendMessageResult {
  final bool success;
  final MeropeMessage? message;
  final String? error;

  const SendMessageResult({
    required this.success,
    this.message,
    this.error,
  });
}

class MessagingApiService {
  final ApiClient _apiClient;
  final RealtimeClient? _realtimeClient;

  MessagingApiService({
    required ApiClient apiClient,
    RealtimeClient? realtimeClient,
  })  : _apiClient = apiClient,
        _realtimeClient = realtimeClient;

  Future<ConversationListState> getConversations({int limit = 20}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v10/messaging/rooms',
        queryParameters: {'limit': limit},
      );

      final data = response.data;
      if (data == null) {
        return const ConversationListState();
      }

      final conversations = (data['conversations'] as List?)
              ?.map((e) => Conversation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      return ConversationListState(conversations: conversations);
    } on MeropeAPIException catch (e) {
      return ConversationListState(error: e.message);
    }
  }

  Future<MessageListState> getMessages(
    String conversationId, {
    String? cursor,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (cursor != null) queryParams['cursor'] = cursor;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v10/messaging/rooms/$conversationId/history',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data == null) {
        return const MessageListState();
      }

      final messages = (data['messages'] as List?)
              ?.map((e) => _parseMessage(e as Map<String, dynamic>))
              .toList() ??
          [];

      return MessageListState(
        messages: messages,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? true,
      );
    } on MeropeAPIException catch (e) {
      return MessageListState(error: e.message);
    }
  }

  Future<SendMessageResult> sendMessage(
    String conversationId,
    String content, {
    bool encrypt = false,
  }) async {
    try {
      Map<String, dynamic> payload;

      if (encrypt && conversationId.isNotEmpty) {
        final key = await E2EECryptoService.deriveRoomKey(conversationId);
        final ciphertext = E2EECryptoService.encryptMessage(content, key);
        payload = {
          'encrypted_payload': ciphertext,
          'message_type': 'text',
          'is_encrypted': true,
        };
      } else {
        payload = {
          'content': content,
          'message_type': 'text',
          'is_encrypted': false,
        };
      }

      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v10/messaging/rooms/$conversationId/messages',
        data: payload,
      );

      final data = response.data;
      if (data == null) {
        return SendMessageResult(
            success: false, error: 'No response from server');
      }

      final message = _parseMessage(data);
      return SendMessageResult(success: true, message: message);
    } on MeropeAPIException catch (e) {
      return SendMessageResult(success: false, error: e.message);
    }
  }

  Future<bool> markAsRead(String conversationId, String messageId) async {
    try {
      await _apiClient.post(
        '/api/v10/messaging/rooms/$conversationId/read',
        data: {'message_id': messageId},
      );
      return true;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  Future<bool> markConversationAsRead(
    String conversationId, {
    required String messageId,
  }) {
    return markAsRead(conversationId, messageId);
  }

  Future<List<MeropeMessage>> getUnreadMessages(String conversationId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v10/messaging/rooms/$conversationId/unread',
      );

      final data = response.data;
      if (data == null) return [];

      final messages = (data['messages'] as List?)
              ?.map((e) => _parseMessage(e as Map<String, dynamic>))
              .toList() ??
          [];

      return messages;
    } on MeropeAPIException catch (_) {
      return [];
    }
  }

  Future<bool> sendTypingIndicator(
    String conversationId,
    bool isTyping,
  ) async {
    if (!isTyping) return true;

    try {
      await _apiClient.post<void>(
        '/api/v10/messaging/rooms/$conversationId/typing',
      );
      return true;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  void sendReadReceipt(String messageId) {
    _realtimeClient?.sendReadReceipt(messageId);
  }

  Future<String?> getE2eePublicKey(String userId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v10/messaging/e2ee/keys/$userId',
      );

      final data = response.data;
      if (data == null) return null;

      return data['public_key'] as String?;
    } on MeropeAPIException catch (_) {
      return null;
    }
  }

  Future<bool> uploadE2eePublicKey(String publicKey) async {
    try {
      await _apiClient.post(
        '/api/v10/messaging/e2ee/keys',
        data: {'public_key': publicKey},
      );
      return true;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  Future<String?> deriveRoomKey(String roomId) async {
    return E2EECryptoService.deriveRoomKey(roomId);
  }

  String encryptMessage(String plaintext, String keyHex) {
    return E2EECryptoService.encryptMessage(plaintext, keyHex);
  }

  String? decryptMessage(String encryptedHex, String keyHex) {
    return E2EECryptoService.decryptMessage(encryptedHex, keyHex);
  }

  MeropeMessage _parseMessage(Map<String, dynamic> json) {
    final blocksJson = json['blocks'] as List? ?? [];
    final blocks = blocksJson
        .whereType<Map>()
        .map((e) => MessageBlock.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    if (blocks.isEmpty) {
      final content = json['content']?.toString() ?? '';
      if (content.isNotEmpty) {
        blocks.add(
          MessageBlock(type: MessageBlockType.text, content: content),
        );
      }
    }

    return MeropeMessage(
      id: json['id'] as String? ?? '',
      channelId:
          json['room_id'] as String? ?? json['channel_id'] as String? ?? '',
      authorId: json['author_id'] as String? ?? '',
      authorName: json['author_name'] as String? ?? 'Explorer',
      authorAvatar: json['author_avatar'] as String? ?? '',
      blocks: blocks,
      createdAt: json['created_at'] as int? ?? json['timestamp'] as int? ?? 0,
      updatedAt: json['updated_at'] as int? ?? 0,
      version: (json['version'] as num?)?.toInt() ?? 1,
      reactions: (json['reactions'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isEncrypted: json['is_encrypted'] as bool? ?? false,
      threadId: json['thread_id'] as String?,
      messageType: (json['message_type'] ?? json['type'])?.toString(),
      fileUrl: json['file_url']?.toString(),
      encryptedPayload: json['encrypted_payload']?.toString(),
    );
  }
}

final messagingApiServiceProvider = Provider<MessagingApiService>((ref) {
  return MessagingApiService(
    apiClient: ApiClient(),
  );
});
