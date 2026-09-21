import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final String? secret;
  final int expiresInSeconds;

  MfaChallenge({
    required this.challengeId,
    required this.method,
    this.totpUri,
    this.backupCode,
    this.secret,
    required this.expiresInSeconds,
  });

  factory MfaChallenge.fromJson(Map<String, dynamic> json) {
    return MfaChallenge(
      challengeId: json['challenge_id']?.toString() ?? '',
      method: json['method']?.toString() ?? 'totp',
      totpUri: json['totp_uri'] as String? ?? json['url'] as String?,
      backupCode: json['backup_code'] as String?,
      secret: json['secret'] as String?,
      expiresInSeconds: (json['expires_in_seconds'] as num?)?.toInt() ?? 300,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challenge_id': challengeId,
      'method': method,
      'totp_uri': totpUri,
      'backup_code': backupCode,
      'secret': secret,
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
  final FlutterSecureStorage _secureStorage;
  final BiometricAuth _biometricAuth;

  AuthRepository({
    required ApiClient apiClient,
    required SessionStorage sessionStorage,
    required BiometricAuth biometricAuth,
  })  : _apiClient = apiClient,
        _sessionStorage = sessionStorage,
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

      if (response.isError) throw _apiError(response);
      final data = response.data;
      if (data == null) return null;

      if (data['requires_mfa'] == true || data['mfa_required'] == true) {
        final challenge = MfaChallenge(
          challengeId: data['challenge_id'] as String,
          method: data['mfa_method'] as String? ?? 'totp',
          totpUri: data['totp_uri'] as String?,
          backupCode: data['backup_code'] as String?,
          secret: data['secret'] as String?,
          expiresInSeconds: (data['expires_in_seconds'] as num?)?.toInt() ?? 300,
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

      if (response.isError) {
        throw _apiError(response);
      }
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

      if (response.isError) {
        return MfaVerificationResult(
          success: false,
          error: _apiError(response).message,
        );
      }
      final data = response.data;
      if (data == null) {
        return MfaVerificationResult(
          success: false,
          error: 'No response from server',
        );
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
    throw UnsupportedError(
      'Email MFA code delivery is not exposed by the active backend contract.',
    );
  }

  Future<void> enableMfa(String userId, String password) async {
    throw UnsupportedError(
      'MFA enrollment is exposed through GET /auth/mfa/setup in the active backend contract.',
    );
  }

  Future<MfaChallenge> getMfaSetup(String _userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/auth/mfa/setup',
    );
    if (response.isError) throw _apiError(response);
    final data = response.data;
    if (data == null) {
      throw const MeropeAPIException(message: 'Failed to get MFA setup');
    }
    return MfaChallenge(
      challengeId: '',
      method: 'totp',
      totpUri: data['url'] as String? ?? data['totp_uri'] as String?,
      secret: data['secret'] as String?,
      expiresInSeconds: (data['expires_in_seconds'] as num?)?.toInt() ?? 0,
    );
  }

  Future<AccountLockoutInfo> getAccountLockoutStatus(String email) async {
    throw UnsupportedError(
      'The active backend contract does not expose a lockout-status endpoint.',
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
      throw const MeropeAPIException(
          message: 'Biometric authentication failed');
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
    return _sessionStorage.getUser();
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

  Future<bool> hasPendingMfaChallenge() async {
    return (await _secureStorage.read(key: 'mfa_challenge')) != null;
  }

  Future<MfaVerificationResult> verifyPendingMfa(String code) async {
    final raw = await _secureStorage.read(key: 'mfa_challenge');
    if (raw == null) {
      return MfaVerificationResult(
        success: false,
        error: 'MFA challenge expired or is missing.',
      );
    }
    try {
      final challenge = MfaChallenge.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/mfa/verify',
        data: {
          'challenge_id': challenge.challengeId,
          'code': code,
        },
      );
      if (response.isError) {
        return MfaVerificationResult(
          success: false,
          error: _apiError(response).message,
        );
      }
      final data = response.data;
      if (data == null || data['success'] != true) {
        return MfaVerificationResult(
          success: false,
          error: data?['message']?.toString() ?? 'Invalid MFA code',
        );
      }
      final user = await _processAuthResponse(data);
      await _secureStorage.delete(key: 'mfa_challenge');
      return MfaVerificationResult(
        success: true,
        token: data['token'] as String?,
        refreshToken: data['refresh_token'] as String?,
        expiresIn: data['expires_in'] as int?,
        user: user,
      );
    } on MeropeAPIException catch (e) {
      return MfaVerificationResult(success: false, error: e.message);
    } catch (e) {
      return MfaVerificationResult(success: false, error: e.toString());
    }
  }

  Future<AuthUser?> refreshSession() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) return null;

    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.isError) {
        throw _apiError(response);
      }
      final data = response.data;
      if (data == null) return null;

      return await _processAuthResponse(data);
    } catch (e) {
      await logout();
      return null;
    }
  }

  Future<AuthUser> _processAuthResponse(Map<String, dynamic> data) async {
    final token = data['token'] as String? ?? '';
    if (token.isEmpty) {
      throw const MeropeAPIException(message: 'Authentication token missing');
    }

    final rawUser = data['user'];
    final user = rawUser is Map<String, dynamic>
        ? AuthUser.fromJson(rawUser)
        : await getCurrentUser();
    if (user == null) {
      throw const MeropeAPIException(message: 'Authenticated user missing');
    }

    final refreshToken = data['refresh_token'] as String?;
    final expiresIn = _resolveExpiresIn(data, token);
    final expiresAt = expiresIn != null
        ? DateTime.now().millisecondsSinceEpoch + expiresIn * 1000
        : null;

    await _sessionStorage.saveSession(
      token: token,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      user: user,
    );

    await _secureStorage.write(key: 'auth_token', value: token);
    if (refreshToken != null) {
      await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    }
    if (expiresAt != null) {
      await _secureStorage.write(
        key: 'session_expiry',
        value: expiresAt.toString(),
      );
    }

    return user;
  }

  int? _resolveExpiresIn(Map<String, dynamic> data, String token) {
    final explicit = data['expires_in'];
    if (explicit is num) return explicit.toInt();

    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );
        if (payload is Map<String, dynamic> && payload['exp'] is num) {
          final exp = (payload['exp'] as num).toInt();
          final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          return exp > now ? exp - now : 0;
        }
      }
    } catch (_) {}

    return 900;
  }

  MeropeAPIException _apiError(ApiResult<dynamic> response) {
    final error = response.error;
    if (error is MeropeAPIException) return error;
    return MeropeAPIException(
      message: error?.toString() ?? 'Authentication request failed',
      statusCode: response.statusCode,
    );
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
    biometricAuth: BiometricAuth(),
  );
});

final currentUserProvider = FutureProvider<AuthUser?>((ref) async {
  return ref.watch(authRepositoryProvider).getCurrentUser();
});
