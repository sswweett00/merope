import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/realtime_client.dart';
import 'package:merope_core/data/services/e2ee_crypto_service.dart';
import 'package:uuid/uuid.dart';

enum ConnectionStatus { disconnected, connecting, connected, error }

class RealtimeChat extends StateNotifier<ConnectionStatus> {
  String? _roomId;
  String? _token;
  String? _baseUrl;

  RealtimeClient? _client;
  final List<Map<String, dynamic>> _messageBuffer = [];

  RealtimeChat(this._roomId, this._token, this._baseUrl)
      : super(ConnectionStatus.disconnected) {
    _client = null;
    _messageBuffer.clear();
  }

  Future<void> connect() async {
    if (_roomId == null || _token == null || _baseUrl == null) return;

    state = ConnectionStatus.connecting;

    _client?.disconnect();
    _client = RealtimeClient(
      baseUrl: _baseUrl!,
      token: _token!,
      roomId: _roomId!,
    );

    _client!.events.listen((msg) {
      if (msg.type == 'MESSAGE_SENT' || msg.type == 'E2EE_MESSAGE_SENT') {
        final messageData = Map<String, dynamic>.from(msg.payload);
        messageData['id'] = const Uuid().v4();
        messageData['is_local'] = false;
        _messageBuffer.add(messageData);
      }
    });

    state = ConnectionStatus.connected;
  }

  Future<void> disconnect() async {
    await _client?.disconnect();
    state = ConnectionStatus.disconnected;
  }

  Future<void> sendMessage(String content,
      {bool encrypt = false, String? encryptedPayload}) async {
    if (_client == null || !_client!.isConnected) return;

    if (encrypt && _roomId != null) {
      final key = await E2EECryptoService.deriveRoomKey(_roomId!);
      final ciphertext = E2EECryptoService.encryptMessage(content, key);
      _client!.sendEvent('MESSAGE_SENT', {
        'room_id': _roomId,
        'encrypted_payload': ciphertext,
        'message_type': 'text',
      });
    } else {
      _client!.sendEvent('MESSAGE_SENT', {
        'room_id': _roomId,
        'content': content,
        'message_type': 'text',
      });
    }

    _messageBuffer.add({
      'id': const Uuid().v4(),
      'room_id': _roomId,
      'content': content,
      'is_local': true,
      'is_encrypted': encrypt,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  void sendTyping() {
    if (_roomId != null && _client != null && _client!.isConnected) {
      _client!.sendTyping(_roomId!);
    }
  }

  void markRead(String messageId) {
    if (_client != null && _client!.isConnected) {
      _client!.sendReadReceipt(messageId);
    }
  }

  List<Map<String, dynamic>> get messages => List.unmodifiable(_messageBuffer);

  bool get isConnected => _client?.isConnected ?? false;
  Set<String> get typingUsers => _client?.typingUsers ?? {};
}
