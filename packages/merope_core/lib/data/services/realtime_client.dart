import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:merope_core/security/session_storage.dart';
import 'package:web_socket_channel/status.dart' as status;

enum ConnectionStatus { disconnected, connecting, connected, error }

class RealtimeMessage {
  final String type;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  RealtimeMessage({
    required this.type,
    required this.payload,
    required this.timestamp,
  });

  factory RealtimeMessage.fromJson(Map<String, dynamic> json) {
    return RealtimeMessage(
      type: json['type'] as String,
      payload: Map<String, dynamic>.from(json['payload'] as Map),
      timestamp: json['timestamp'] == null
          ? DateTime.now().toUtc()
          : DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class RealtimeClient {
  static const Duration _reconnectBaseDelay = Duration(milliseconds: 500);
  static const Duration _reconnectMaxDelay = Duration(seconds: 10);

  final String baseUrl;
  final String? _providedToken;
  String _token;
  final List<RealtimeMessage> _messageBuffer = [];
  final StreamController<RealtimeMessage> _eventController;
  final String _roomId;
  final Map<String, String> _presence = {};
  final Map<String, DateTime> _typingUsers = {};

  RealtimeClient._internal({
    required this.baseUrl,
    required this.token,
    required String roomId,
    required StreamController<RealtimeMessage> eventController,
  })  : _providedToken = token,
        _token = token ?? '',
        _roomId = roomId,
        _eventController = eventController {
    events = _eventController.stream.asBroadcastStream();
    onMessage = events.where(
        (msg) => msg.type == 'MESSAGE_SENT' || msg.type == 'E2EE_MESSAGE_SENT');
    onTyping = events.where((msg) => msg.type == 'TYPING');
    onPresence = events
        .where((msg) => msg.type == 'PRESENCE')
        .map((msg) => Map<String, String>.from(msg.payload));
    onConnected = Stream.fromFuture(Future.value(null));
    onDisconnected = Stream.fromFuture(Future.value(null));

    unawaited(connect());
  }

  factory RealtimeClient({
    String? baseUrl,
    String? token,
    String? roomId,
  }) {
    return RealtimeClient._internal(
      baseUrl: baseUrl ?? _defaultRealtimeBaseUrl(),
      token: token ?? '',
      roomId: roomId ?? '',
      eventController: StreamController<RealtimeMessage>.broadcast(),
    );
  }

  static String _defaultRealtimeBaseUrl() {
    const configured = String.fromEnvironment('API_BASE_URL');
    if (configured.isNotEmpty) return configured;
    if (kIsWeb) return Uri.base.origin;
    return 'https://api.merope.enterprise:8443';
  }

  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _isConnected = false;
  bool _isDisposed = false;

  late final Stream<RealtimeMessage> events;
  late final Stream<RealtimeMessage> onMessage;
  late final Stream<RealtimeMessage> onTyping;
  late final Stream<Map<String, String>> onPresence;
  late final Stream<void> onConnected;
  late final Stream<void> onDisconnected;

  bool get isConnected => _isConnected;
  Map<String, String> get presence => Map.unmodifiable(_presence);
  Set<String> get typingUsers {
    final now = DateTime.now();
    return _typingUsers.entries
        .where((e) => now.difference(e.value).inSeconds < 4)
        .map((e) => e.key)
        .toSet();
  }

  Future<void> connect() async {
    if (_isDisposed || _isConnected) return;

    _token = _providedToken ?? await SessionStorage().getToken() ?? '';
    if (_token.isEmpty) return;

    WebSocketChannel? channel;
    try {
      final wsUrl = _buildWsUrl();
      channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      await channel.ready.timeout(const Duration(seconds: 10));
      if (_isDisposed) {
        await channel.sink.close(status.goingAway);
        return;
      }

      _channel = channel;
      _isConnected = true;
      _reconnectAttempts = 0;

      channel.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (_) {
      await channel?.sink.close(status.goingAway);
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  String _buildWsUrl() {
    final uri = Uri.parse(baseUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final wsUri =
        Uri.parse('$wsScheme://${uri.host}:${uri.port}/ws?token=$token');
    return wsUri.toString();
  }

  void _onData(dynamic data) {
    try {
      final json = jsonDecode(data as String) as Map<String, dynamic>;
      final msg = RealtimeMessage.fromJson(json);

      if (msg.payload['room_id'] != null && msg.payload['room_id'] != _roomId)
        return;

      switch (msg.type) {
        case 'MESSAGE_SENT':
        case 'E2EE_MESSAGE_SENT':
        case 'MESSAGE_EDITED':
        case 'MESSAGE_DELETED':
        case 'REACTION_ADDED':
        case 'READ_RECEIPT':
          break;
        case 'TYPING':
          if (msg.payload['room_id'] != null) {
            _typingUsers[msg.payload['room_id']] = DateTime.now();
          }
          break;
        case 'PRESENCE':
          final userId = msg.payload['user_id'] as String?;
          final status = msg.payload['status'] as String? ?? 'offline';
          if (userId != null) {
            _presence[userId] = status;
          }
          break;
        case 'NOTIFICATION':
          break;
      }

      _messageBuffer.add(msg);
      if (_messageBuffer.length > 100) {
        _messageBuffer.removeAt(0);
      }
      _eventController.add(msg);
    } catch (e) {
      // ignore parse errors
    }
  }

  void _onError(dynamic error) {
    _scheduleReconnect();
  }

  void _onDone() {
    _isConnected = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;

    final delay = _reconnectBaseDelay * (1 << _reconnectAttempts);
    final cappedDelay = delay > _reconnectMaxDelay ? _reconnectMaxDelay : delay;

    _reconnectAttempts++;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(cappedDelay, () {
      if (!_isConnected && !_isDisposed) {
        unawaited(connect());
      }
    });
  }

  void sendEvent(String type, Map<String, dynamic> payload) {
    _send(type, payload);
  }

  void sendTyping(String roomId) {
    _send('TYPING', {'room_id': roomId, 'user_id': ''});
  }

  void sendTypingIndicator(String roomId, bool isTyping) {
    _send('TYPING', {
      'room_id': roomId,
      'user_id': '',
      'is_typing': isTyping,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void sendReadReceipt(String messageId) {
    _send('READ_RECEIPT', {'message_id': messageId, 'user_id': ''});
  }

  Stream<Map<String, dynamic>> subscribeToChannel(String channelId) {
    return events.where((msg) {
      final payloadRoomId = msg.payload['room_id'] as String?;
      final payloadChannelId = msg.payload['channel_id'] as String?;
      return payloadRoomId == channelId || payloadChannelId == channelId;
    }).map((msg) => msg.payload);
  }

  void _send(String type, Map<String, dynamic> payload) {
    if (!_isConnected || _channel == null) return;

    try {
      final message = jsonEncode({'type': type, 'payload': payload});
      _channel!.sink.add(message);
    } catch (e) {
      // ignore
    }
  }

  Future<void> disconnect() async {
    _isDisposed = true;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    await _channel?.sink.close(status.goingAway);
    _channel = null;
    _isConnected = false;
    await _eventController.close();
  }

  void flushTypingHistory() {
    _typingUsers.clear();
  }

  RealtimeMessage? getLastMessage() {
    if (_messageBuffer.isEmpty) return null;
    return _messageBuffer.last;
  }
}
