import 'dart:async';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merope_core/utils/enterprise_logger.dart';

/// Parameters for background decryption to avoid UI jank
class DecryptionParams {
  const DecryptionParams({
    required this.encryptedJson,
    required this.sessionKeyBase64,
  });
  final String encryptedJson;
  final String sessionKeyBase64;
}

/// Top-level function for Isolate-based decryption
String _decryptMessageTask(DecryptionParams params) {
  final data = jsonDecode(params.encryptedJson) as Map<String, dynamic>;
  final sessionKey = encrypt.Key.fromBase64(params.sessionKeyBase64);
  final encrypter = encrypt.Encrypter(encrypt.AES(sessionKey, mode: encrypt.AESMode.gcm));
  final iv = encrypt.IV.fromBase64(data['iv'] as String);

  return encrypter.decrypt64(data['content'] as String, iv: iv);
}

class E2EEController extends AsyncNotifier<void> {
  final _storage = const FlutterSecureStorage();

  /// In-memory cache for session keys to avoid repeated secure storage reads
  final Map<String, encrypt.Key> _sessionKeyCache = {};

  @override
  FutureOr<void> build() async {
    final key = await _storage.read(key: 'e2ee_identity_key');
    if (key == null) {
      await _generateNewIdentity();
    }
  }

  Future<void> _generateNewIdentity() async {
    final key = encrypt.Key.fromSecureRandom(32);
    await _storage.write(key: 'e2ee_identity_key', value: key.base64);
    MeropeLogger.info('E2EE: New identity key generated');
  }

  Future<String> encryptMessage(String conversationId, String plaintext) async {
    final sessionKey = await _getOrCreateSessionKey(conversationId);
    final encrypter = encrypt.Encrypter(encrypt.AES(sessionKey, mode: encrypt.AESMode.gcm));
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    return jsonEncode({
      'iv': iv.base64,
      'content': encrypted.base64,
    });
  }

  Future<String> decryptMessage(String conversationId, String encryptedJson) async {
    try {
      final sessionKey = await _getOrCreateSessionKey(conversationId);

      // Offload decryption to a background isolate for high performance
      return await compute(
        _decryptMessageTask,
        DecryptionParams(
          encryptedJson: encryptedJson,
          sessionKeyBase64: sessionKey.base64,
        ),
      );
    } on FormatException catch (e) {
      MeropeLogger.error('E2EE: Invalid encrypted payload format', error: e);
      return '[Decryption Error: Invalid payload format]';
    } on Exception catch (e) {
      MeropeLogger.error('E2EE: Decryption failed - key mismatch or tampered content', error: e);
      return '[Decryption Error: Key mismatch or tampered content]';
    }
  }

  Future<encrypt.Key> _getOrCreateSessionKey(String conversationId) async {
    // 1. Check memory cache first
    if (_sessionKeyCache.containsKey(conversationId)) {
      return _sessionKeyCache[conversationId]!;
    }

    // 2. Read from secure storage if not in cache
    final keyBase64 = await _storage.read(key: 'session_key_$conversationId');
    if (keyBase64 != null) {
      final key = encrypt.Key.fromBase64(keyBase64);
      _sessionKeyCache[conversationId] = key;
      return key;
    }

    // 3. Generate and store if none exists
    final newKey = encrypt.Key.fromSecureRandom(32);
    await _storage.write(key: 'session_key_$conversationId', value: newKey.base64);
    _sessionKeyCache[conversationId] = newKey;
    return newKey;
  }

  /// Clear cache on logout or security event
  void clearCache() {
    _sessionKeyCache.clear();
  }
}

final e2EEControllerProvider = AsyncNotifierProvider<E2EEController, void>(E2EEController.new);
