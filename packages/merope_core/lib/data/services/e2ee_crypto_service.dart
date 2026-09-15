import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class E2EECryptoService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  static const _roomPrefix = 'e2ee_room_';

  static Future<String?> getStoredKey(String roomId) async {
    return await _storage.read(key: _roomPrefix + roomId);
  }

  static Future<String> deriveRoomKey(String roomId) async {
    final String? existing = await _storage.read(key: _roomPrefix + roomId);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final randomKey = _generateRandomKey(32);
    await _storage.write(key: _roomPrefix + roomId, value: randomKey);
    return randomKey;
  }

  static Future<void> cleanupRoomKey(String roomId) async {
    await _storage.delete(key: _roomPrefix + roomId);
  }

  static String encryptMessage(String plaintext, String keyHex) {
    final keyBytes = Uint8List.fromList(_hexToBytes(keyHex));
    final iv = Uint8List.fromList(_generateRandomBytes(12));
    final aesKey = encrypt.Key(keyBytes);
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.gcm));
    final encrypted = encrypter.encrypt(plaintext, iv: encrypt.IV(iv));

    final combined = Uint8List.fromList(iv.toList() + encrypted.bytes.toList());
    return bytesToHex(combined);
  }

  static String? decryptMessage(String encryptedHex, String keyHex) {
    try {
      final combined = _hexToBytes(encryptedHex);
      if (combined.length < 13) return null;

      final iv = Uint8List.fromList(combined.sublist(0, 12));
      final encryptedBytes = combined.sublist(12);

      final keyBytes = Uint8List.fromList(_hexToBytes(keyHex));
      final aesKey = encrypt.Key(keyBytes);
      final encrypter = encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.gcm));

      final decrypted = encrypter.decrypt(
        encrypt.Encrypted(Uint8List.fromList(encryptedBytes)),
        iv: encrypt.IV(iv),
      );

      return decrypted;
    } catch (e) {
      return null;
    }
  }

  static String _generateRandomKey(int length) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return bytesToHex(bytes);
  }

  static List<int> _generateRandomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }

  static List<int> _hexToBytes(String hex) {
    final result = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      final byte = int.parse(hex.substring(i, i + 2), radix: 16);
      result.add(byte);
    }
    return result;
  }

  static String bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static String hashForVerification(String data) {
    final bytes = utf8.encode(data);
    return bytesToHex(sha256.convert(bytes).bytes);
  }
}
