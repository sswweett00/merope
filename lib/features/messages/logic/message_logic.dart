import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/realtime_client.dart';
import '../domain/models/message_model.dart';
import '../domain/models/chat_models.dart';
import '../repository/message_repository.dart';
import 'package:uuid/uuid.dart';
import 'aegis_message_crypt.dart';

final realtimeClientProvider = Provider<RealtimeClient>((ref) {
  return RealtimeClient();
});

final typingUsersProvider =
    StateProvider.family<List<String>, String>((ref, conversationId) => []);

class MessageController
    extends FamilyAsyncNotifier<List<MeropeMessage>, String> {
  StreamSubscription? _subscription;
  Timer? _typingTimer;
  final Set<String> _typingUsers = {};

  @override
  FutureOr<List<MeropeMessage>> build(String arg) async {
    final repo = ref.watch(messageRepositoryProvider);
    final realtime = ref.watch(realtimeClientProvider);

    // Subscribe to real-time updates
    _subscription = realtime.subscribeToChannel(arg).listen((event) {
      if (event['type'] == 'new_message') {
        ref.invalidateSelf();
      } else if (event['type'] == 'message_updated') {
        ref.invalidateSelf();
      } else if (event['type'] == 'message_deleted') {
        ref.invalidateSelf();
      } else if (event['type'] == 'typing') {
        _handleTypingIndicator(event);
      } else if (event['type'] == 'reaction_added') {
        ref.invalidateSelf();
      }
    });

    ref.onDispose(() {
      _subscription?.cancel();
      _typingTimer?.cancel();
    });

    return await repo.getMessages(arg);
  }

  void _handleTypingIndicator(Map<String, dynamic> event) {
    final userId = event['user_id'] as String;

    _typingUsers.add(userId);
    ref.read(typingUsersProvider(arg).notifier).state = _typingUsers.toList();

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      _typingUsers.remove(userId);
      ref.read(typingUsersProvider(arg).notifier).state = _typingUsers.toList();
    });
  }

  Future<void> sendTextMessage(String content, String authorId,
      {String? parentMessageId}) async {
    final aegis = ref.read(aegisMessageCryptProvider.notifier);

    // Encrypt message
    final encryptedPayload = await aegis.encrypt(
      conversationId: arg,
      message: content,
    );

    final message = MeropeMessage(
      id: const Uuid().v4(),
      channelId: arg,
      authorId: authorId,
      authorName: 'Current User',
      authorAvatar: '',
      blocks: [
        MessageBlock(
            type: MessageBlockType.text, content: '[Encrypted Aegis Message]'),
      ],
      encryptedPayload: jsonEncode(encryptedPayload.toJson()),
      isEncrypted: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      parentMessageId: parentMessageId,
    );

    final repo = ref.read(messageRepositoryProvider);
    await repo.sendMessage(message);

    _sendTypingIndicator(false);
    ref.invalidateSelf();
  }

  Future<void> sendMediaMessage(
      String fileUrl, String messageType, String authorId) async {
    final message = MeropeMessage(
      id: const Uuid().v4(),
      channelId: arg,
      authorId: authorId,
      authorName: 'Current User',
      authorAvatar: '',
      blocks: [
        MessageBlock(
            type: MessageBlockType.values.firstWhere(
              (type) => type.name == messageType,
              orElse: () => MessageBlockType.file,
            ),
            content: fileUrl),
      ],
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      messageType: messageType,
      fileUrl: fileUrl,
    );

    final repo = ref.read(messageRepositoryProvider);
    await repo.sendMessage(message);
    ref.invalidateSelf();
  }

  Future<void> editMessage(String messageId, String newContent) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.updateMessage(messageId, newContent);
    ref.invalidateSelf();
  }

  Future<void> deleteMessage(String messageId) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.deleteMessage(messageId);
    ref.invalidateSelf();
  }

  Future<void> addReaction(String messageId, String emoji) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.addReaction(messageId, emoji);
    ref.invalidateSelf();
  }

  Future<void> removeReaction(String messageId, String emoji) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.removeReaction(messageId, emoji);
    ref.invalidateSelf();
  }

  Future<void> pinMessage(String messageId) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.pinMessage(messageId);
    ref.invalidateSelf();
  }

  Future<void> markAsRead(String messageId) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.markAsRead(messageId);
  }

  Future<void> forwardMessage(String messageId, String toChannelId) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.forwardMessage(messageId, toChannelId);
  }

  void sendTypingIndicator(bool isTyping) {
    if (isTyping) {
      _sendTypingIndicator(true);
    } else {
      _sendTypingIndicator(false);
    }
  }

  void _sendTypingIndicator(bool isTyping) {
    final realtime = ref.read(realtimeClientProvider);
    realtime.sendTypingIndicator(arg, isTyping);
  }

  List<String> get typingUsers => _typingUsers.toList();
}

final messageControllerProvider =
    AsyncNotifierProviderFamily<MessageController, List<MeropeMessage>, String>(
        MessageController.new);

class ConversationController extends AsyncNotifier<List<Conversation>> {
  @override
  FutureOr<List<Conversation>> build() async {
    final repo = ref.watch(messageRepositoryProvider);
    return await repo.getConversations();
  }

  Future<void> createDirectChat(String otherUserId) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.createDirectChat(otherUserId);
    ref.invalidateSelf();
  }

  Future<void> createGroupChat(String name, List<String> participantIds) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.createGroupChat(name, participantIds);
    ref.invalidateSelf();
  }

  Future<void> archiveConversation(String conversationId, bool archived) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.archiveConversation(conversationId, archived);
    ref.invalidateSelf();
  }

  Future<void> muteConversation(
      String conversationId, int? durationMinutes) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.muteConversation(conversationId, durationMinutes);
    ref.invalidateSelf();
  }
}

final conversationControllerProvider =
    AsyncNotifierProvider<ConversationController, List<Conversation>>(
        ConversationController.new);

class ChatFolderController extends AsyncNotifier<List<ChatFolder>> {
  @override
  FutureOr<List<ChatFolder>> build() async {
    final repo = ref.watch(messageRepositoryProvider);
    return await repo.getFolders();
  }

  Future<void> createFolder(String name, List<String> conversationIds) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.createFolder(name, conversationIds);
    ref.invalidateSelf();
  }

  Future<void> updateFolder(
      String folderId, String name, List<String> conversationIds) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.updateFolder(folderId, name, conversationIds);
    ref.invalidateSelf();
  }

  Future<void> deleteFolder(String folderId) async {
    final repo = ref.read(messageRepositoryProvider);
    await repo.deleteFolder(folderId);
    ref.invalidateSelf();
  }
}

final chatFolderControllerProvider =
    AsyncNotifierProvider<ChatFolderController, List<ChatFolder>>(
        ChatFolderController.new);
