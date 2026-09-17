import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merope_models/auth/auth_user.dart';

class SessionStorage {
  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  String? _cachedToken;
  bool _tokenLoaded = false;

  SessionStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  Future<void> saveSession({
    required String token,
    String? refreshToken,
    int? expiresAt,
    AuthUser? user,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    _cachedToken = token;
    _tokenLoaded = true;

    if (user != null) {
      await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
    }
    if (refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
    if (expiresAt != null) {
      await _storage.write(key: 'session_expiry', value: expiresAt.toString());
    }
  }

  Future<String?> getToken() async {
    if (_tokenLoaded) return _cachedToken;
    _cachedToken = await _storage.read(key: _tokenKey);
    _tokenLoaded = true;
    return _cachedToken;
  }

  Future<AuthUser?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null;
    try {
      return AuthUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _userKey),
      _storage.delete(key: 'refresh_token'),
      _storage.delete(key: 'session_expiry'),
    ]);
    _cachedToken = null;
    _tokenLoaded = true;
  }

  Future<bool> hasSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
