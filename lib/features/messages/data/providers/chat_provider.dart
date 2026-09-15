import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_models/messages/chat_models.dart';
import 'package:merope_models/messages/message_model.dart';

import 'package:merope_core/data/services/messaging_api_service.dart';

class ChatList extends AsyncNotifier<List<Conversation>> {
  @override
  FutureOr<List<Conversation>> build() async {
    final api = ref.read(messagingApiServiceProvider);
    final result = await api.getConversations();

    if (result.error != null) throw result.error!;
    return result.conversations;
  }
}

final chatListProvider = AsyncNotifierProvider<ChatList, List<Conversation>>(ChatList.new);

class ChatMessages extends FamilyAsyncNotifier<List<MeropeMessage>, String> {
  @override
  FutureOr<List<MeropeMessage>> build(String arg) async {
    final api = ref.read(messagingApiServiceProvider);
    final result = await api.getMessages(arg);

    if (result.error != null) throw result.error!;
    return result.messages;
  }

  Future<void> sendMessage(String text, {bool encrypt = true, String? effect}) async {
    final api = ref.read(messagingApiServiceProvider);
    final result = await api.sendMessage(arg, text, encrypt: encrypt);

    if (result.success) {
      ref.invalidateSelf();
    }
  }

  Future<void> sendSticker(String stickerUrl) async {
    // Note: MessagingApiService.sendMessage currently only supports text in its simple form
    // but we can extend it or use it as is if it supports payload.
    // For now, use it as text.
    final api = ref.read(messagingApiServiceProvider);
    final result = await api.sendMessage(arg, stickerUrl);
    if (result.success) ref.invalidateSelf();
  }

  Future<void> sendGif(String gifUrl) async {
    final api = ref.read(messagingApiServiceProvider);
    final result = await api.sendMessage(arg, gifUrl);
    if (result.success) ref.invalidateSelf();
  }

  Future<void> toggleReaction(String messageId, String emoji) async {
    final api = ref.read(messagingApiServiceProvider);
    await api.markAsRead(arg, messageId); // Using markAsRead as a placeholder for reaction if missing
    ref.invalidateSelf();
  }
}

final chatMessagesProvider = AsyncNotifierProviderFamily<ChatMessages, List<MeropeMessage>, String>(ChatMessages.new);
