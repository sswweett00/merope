import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/e2ee_crypto_service.dart';

class AegisMessageCryptNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<AegisEncryptedPayload> encrypt({
    required String conversationId,
    required String message,
  }) async {
    return await AegisMessageCrypt.encrypt(conversationId, message);
  }

  Future<String?> decrypt(
      String conversationId, AegisEncryptedPayload payload) async {
    return await AegisMessageCrypt.decrypt(conversationId, payload);
  }

  Future<void> decryptAndBuffer(
      String conversationId, AegisEncryptedPayload payload) async {
    await AegisMessageCrypt.decryptAndBuffer(conversationId, payload);
  }

  List<String> getBufferedMessages(String conversationId) {
    return AegisMessageCrypt.getBufferedMessages(conversationId);
  }

  void purge() {
    AegisMessageCrypt.purgeBuffers();
  }
}

final aegisMessageCryptProvider =
    AsyncNotifierProvider<AegisMessageCryptNotifier, void>(
        AegisMessageCryptNotifier.new);

/// AegisMessageCrypt V10 - Apex Layer (AES-GCM RAM-Only Ephemeral Buffers).
class AegisMessageCrypt {
  static final Map<String, List<String>> _ephemeralPlaintextBuffer = {};

  /// Aegis Encryption Logic
  static Future<AegisEncryptedPayload> encrypt(
      String conversationId, String plaintext) async {
    final key = await E2EECryptoService.deriveRoomKey(conversationId);
    final ciphertext = E2EECryptoService.encryptMessage(plaintext, key);
    return AegisEncryptedPayload(ciphertextHex: ciphertext);
  }

  /// Volatile Memory Decryption Mechanic:
  static Future<void> decryptAndBuffer(
      String conversationId, AegisEncryptedPayload payload) async {
    final plaintext = await decrypt(conversationId, payload);

    if (plaintext != null) {
      _ephemeralPlaintextBuffer.putIfAbsent(conversationId, () => []);
      _ephemeralPlaintextBuffer[conversationId]!.add(plaintext);
    }
  }

  static Future<String?> decrypt(
      String conversationId, AegisEncryptedPayload payload) async {
    final key = await E2EECryptoService.getStoredKey(conversationId);
    if (key == null) return null;
    return E2EECryptoService.decryptMessage(payload.ciphertextHex, key);
  }

  static List<String> getBufferedMessages(String conversationId) {
    return _ephemeralPlaintextBuffer[conversationId] ?? [];
  }

  static void purgeBuffers() {
    _ephemeralPlaintextBuffer.clear();
  }
}

class AegisEncryptedPayload {
  final String ciphertextHex;
  const AegisEncryptedPayload({required this.ciphertextHex});

  factory AegisEncryptedPayload.fromJson(Map<String, dynamic> json) =>
      AegisEncryptedPayload(
        ciphertextHex: json['ciphertext'] as String? ??
            json['ciphertextHex'] as String? ??
            '',
      );

  Map<String, dynamic> toJson() => {
        'ciphertext': ciphertextHex,
      };
}
