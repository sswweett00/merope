import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:drift/drift.dart';
import 'package:merope_core/data/database/merope_database.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_core/security/biometric_provider.dart';
import 'package:merope_core/security/session_storage.dart';
import 'package:merope_models/auth/auth_user.dart';
import '../domain/repository/auth_repository_interface.dart';
import 'package:merope_core/data/services/exceptions.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  requiresMfa,
  requiresBiometric,
  locked,
  unauthenticated,
}

class AccountLockoutInfo {
  final bool isLocked;
  final int remainingAttempts;
  final DateTime? lockoutUntil;
  final int maxAttempts;

  AccountLockoutInfo({
    required this.isLocked,
    required this.remainingAttempts,
    this.lockoutUntil,
    this.maxAttempts = 5,
  });

  bool get canAttempt => !isLocked && remainingAttempts > 0;
}

class MfaChallenge {
  final String challengeId;
  final String method;
  final String? totpUri;
  final String? backupCode;
  final int expiresInSeconds;

  MfaChallenge({
    required this.challengeId,
    required this.method,
    this.totpUri,
    this.backupCode,
    required this.expiresInSeconds,
  });

  factory MfaChallenge.fromJson(Map<String, dynamic> json) {
    return MfaChallenge(
      challengeId: json['challenge_id'] as String,
      method: json['method'] as String? ?? 'totp',
      totpUri: json['totp_uri'] as String?,
      backupCode: json['backup_code'] as String?,
      expiresInSeconds: json['expires_in_seconds'] as int? ?? 300,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challenge_id': challengeId,
      'method': method,
      'totp_uri': totpUri,
      'backup_code': backupCode,
      'expires_in_seconds': expiresInSeconds,
    };
  }
}

class MfaVerificationResult {
  final bool success;
  final String? token;
  final String? refreshToken;
  final int? expiresIn;
  final AuthUser? user;
  final String? error;

  MfaVerificationResult({
    required this.success,
    this.token,
    this.refreshToken,
    this.expiresIn,
    this.user,
    this.error,
  });
}

class AuthRepository implements IAuthRepository {
  final ApiClient _apiClient;
  final SessionStorage _sessionStorage;
  final MeropeDatabase _database;
  final FlutterSecureStorage _secureStorage;
  final BiometricAuth _biometricAuth;

  AuthRepository({
    required ApiClient apiClient,
    required SessionStorage sessionStorage,
    required MeropeDatabase database,
    required BiometricAuth biometricAuth,
  })  : _apiClient = apiClient,
        _sessionStorage = sessionStorage,
        _database = database,
        _secureStorage = const FlutterSecureStorage(),
        _biometricAuth = biometricAuth {
    _apiClient.refreshCallback = () async {
      final user = await refreshSession();
      return user != null;
    };
  }

  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'device_info': _getDeviceInfo(),
        },
      );

      final data = response.data;
      if (data == null) return null;

      if (data['requires_mfa'] == true) {
        final challenge = MfaChallenge(
          challengeId: data['challenge_id'] as String,
          method: data['mfa_method'] as String? ?? 'totp',
          totpUri: data['totp_uri'] as String?,
          backupCode: data['backup_code'] as String?,
          expiresInSeconds: data['expires_in_seconds'] as int? ?? 300,
        );
        await _secureStorage.write(
          key: 'mfa_challenge',
          value: jsonEncode(challenge.toJson()),
        );
        return null;
      }

      return await _processAuthResponse(data);
    } on MeropeAPIException catch (e) {
      if (e.statusCode == 423) {
        throw MeropeAPIException(
          message: 'Account is locked due to too many failed attempts.',
          statusCode: 423,
        );
      }
      if (e.statusCode == 401) {
        throw MeropeAPIException(
          message: 'Invalid email or password.',
          statusCode: 401,
        );
      }
      rethrow;
    }
  }

  @override
  Future<AuthUser?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      if (data == null) return null;

      return await _processAuthResponse(data);
    } on MeropeAPIException catch (e) {
      if (e.statusCode == 409) {
        throw MeropeAPIException(
          message: 'An account with this email already exists.',
          statusCode: 409,
        );
      }
      rethrow;
    }
  }

  Future<MfaVerificationResult> verifyMfa({
    required String code,
    required String challengeId,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/mfa/verify',
        data: {
          'challenge_id': challengeId,
          'code': code,
        },
      );

      final data = response.data;
      if (data == null) {
        return MfaVerificationResult(success: false, error: 'No response from server');
      }

      if (data['success'] == true) {
        final user = await _processAuthResponse(data);
        return MfaVerificationResult(
          success: true,
          token: data['token'] as String?,
          refreshToken: data['refresh_token'] as String?,
          expiresIn: data['expires_in'] as int?,
          user: user,
        );
      }

      return MfaVerificationResult(
        success: false,
        error: data['message'] as String? ?? 'Invalid MFA code',
      );
    } on MeropeAPIException catch (e) {
      return MfaVerificationResult(success: false, error: e.message);
    }
  }

  Future<void> sendMfaCode(String email) async {
    await _apiClient.post(
      '/auth/mfa/send-code',
      data: {'email': email},
    );
  }

  Future<void> enableMfa(String userId, String password) async {
    await _apiClient.post(
      '/auth/mfa/enable',
      data: {
        'user_id': userId,
        'password': password,
      },
    );
  }

  Future<MfaChallenge> getMfaSetup(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/auth/mfa/setup/$userId',
    );
    final data = response.data;
    if (data == null) {
      throw const MeropeAPIException(message: 'Failed to get MFA setup');
    }
    return MfaChallenge.fromJson(data);
  }

  Future<AccountLockoutInfo> getAccountLockoutStatus(String email) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/auth/lockout-status',
      queryParameters: {'email': email},
    );
    final data = response.data;
    if (data == null) {
      return AccountLockoutInfo(isLocked: false, remainingAttempts: 5);
    }
    return AccountLockoutInfo(
      isLocked: data['is_locked'] as bool? ?? false,
      remainingAttempts: data['remaining_attempts'] as int? ?? 5,
      lockoutUntil: data['lockout_until'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lockout_until'] as int)
          : null,
      maxAttempts: data['max_attempts'] as int? ?? 5,
    );
  }

  Future<bool> authenticateWithBiometrics() async {
    final canAuthenticate = await _biometricAuth.canCheckBiometrics();
    if (!canAuthenticate) return false;

    final authenticated = await _biometricAuth.authenticate(
      reason: 'Authenticate to access your account',
    );
    return authenticated;
  }

  Future<AuthUser?> reAuthenticateForSensitiveOperation() async {
    final isBiometricAuth = await authenticateWithBiometrics();
    if (!isBiometricAuth) {
      throw const MeropeAPIException(message: 'Biometric authentication failed');
    }

    final user = await getCurrentUser();
    return user;
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (_) {
      // Continue with local logout even if server call fails
    } finally {
      await _sessionStorage.clearSession();
      await _secureStorage.delete(key: 'mfa_challenge');
      await _secureStorage.delete(key: 'mfa_backup_codes');
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final userJson = await _secureStorage.read(key: 'auth_user');
    if (userJson == null) return null;

    try {
      return AuthUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final hasSession = await _sessionStorage.hasSession();
    if (!hasSession) return false;

    final expiryStr = await _secureStorage.read(key: 'session_expiry');
    if (expiryStr != null) {
      final expiry = int.tryParse(expiryStr) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      // If token is about to expire (within 5 minutes), consider it "needs refresh" or handle it in interceptor
      if (now > expiry) {
        // Token expired, try refreshing
        try {
          final user = await refreshSession();
          return user != null;
        } catch (_) {
          return false;
        }
      }
    }
    return true;
  }

  Future<AuthUser?> refreshSession() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) return null;

    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      if (data == null) return null;

      return await _processAuthResponse(data);
    } catch (e) {
      await logout();
      return null;
    }
  }

  Future<AuthUser> _processAuthResponse(Map<String, dynamic> data) async {
    final userJson = data['user'] as Map<String, dynamic>? ?? {};
    final user = AuthUser.fromJson(userJson);

    final token = data['token'] as String? ?? '';
    final refreshToken = data['refresh_token'] as String?;
    final expiresIn = data['expires_in'] as int?;

    await _sessionStorage.saveSession(
      token: token,
      user: user,
    );

    await _secureStorage.write(key: 'auth_token', value: token);
    if (refreshToken != null) {
      await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    }
    if (expiresIn != null) {
      final expiryMs = DateTime.now().millisecondsSinceEpoch + expiresIn * 1000;
      await _secureStorage.write(
        key: 'session_expiry',
        value: expiryMs.toString(),
      );
    }

    await _syncUserToDatabase(user);

    return user;
  }

  Future<void> _syncUserToDatabase(AuthUser user) async {
    try {
      final existing = await (_database.select(_database.users)
            ..where((t) => t.id.equals(user.id)))
          .getSingleOrNull();

      if (existing != null) {
        await (_database.update(_database.users)..where((t) => t.id.equals(user.id))).write(
          UsersCompanion(
            username: Value(user.username),
            email: Value(user.email),
            avatarUrl: Value(user.avatarUrl),
          ),
        );
      } else {
        await _database.into(_database.users).insert(
              UsersCompanion.insert(
                id: user.id,
                username: user.username,
                email: user.email,
                passwordHash: 'PBKDF2:HIDDEN', // Placeholder for local vault
                avatarUrl: Value(user.avatarUrl),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
      }
    } catch (_) {
      // DB sync failure should not block auth flow
    }
  }

  Map<String, dynamic> _getDeviceInfo() {
    return {
      'platform': 'flutter',
      'version': '1.0.0',
    };
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ApiClient(),
    sessionStorage: SessionStorage(),
    database: MeropeDatabase(),
    biometricAuth: BiometricAuth(),
  );
});

final currentUserProvider = FutureProvider<AuthUser?>((ref) async {
  return ref.watch(authRepositoryProvider).getCurrentUser();
});
