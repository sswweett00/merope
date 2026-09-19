import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merope_models/auth/auth_user.dart';

class SessionStorage {
  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  String? _cachedToken;
  AuthUser? _cachedUser;
  bool _tokenLoaded = false;
  bool _userLoaded = false;

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
    final writes = <Future<void>>[_storage.write(key: _tokenKey, value: token)];
    if (user != null) {
      writes
          .add(_storage.write(key: _userKey, value: jsonEncode(user.toJson())));
    }
    if (refreshToken != null) {
      writes.add(_storage.write(key: 'refresh_token', value: refreshToken));
    }
    if (expiresAt != null) {
      writes.add(
          _storage.write(key: 'session_expiry', value: expiresAt.toString()));
    }

    await Future.wait(writes);
    _cachedToken = token;
    _tokenLoaded = true;
    if (user != null) {
      _cachedUser = user;
      _userLoaded = true;
    }
  }

  Future<String?> getToken() async {
    if (_tokenLoaded) return _cachedToken;
    _cachedToken = await _storage.read(key: _tokenKey);
    _tokenLoaded = true;
    return _cachedToken;
  }

  Future<AuthUser?> getUser() async {
    if (_userLoaded) return _cachedUser;

    final userJson = await _storage.read(key: _userKey);
    _userLoaded = true;
    if (userJson == null) {
      _cachedUser = null;
      return null;
    }

    try {
      _cachedUser =
          AuthUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (_) {
      _cachedUser = null;
    }
    return _cachedUser;
  }

  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _userKey),
      _storage.delete(key: 'refresh_token'),
      _storage.delete(key: 'session_expiry'),
    ]);
    _cachedToken = null;
    _cachedUser = null;
    _tokenLoaded = true;
    _userLoaded = true;
  }

  Future<bool> hasSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
