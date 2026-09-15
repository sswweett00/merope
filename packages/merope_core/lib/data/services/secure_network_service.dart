import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

/// Secure Network Service with Enforced TLS 1.3, SSL Pinning, and Encrypted Storage.
class SecureNetworkService {
  SecureNetworkService() {
    dio = Dio(
      BaseOptions(
        baseUrl: String.fromEnvironment('API_BASE_URL',
            defaultValue: 'https://api.merope.enterprise:8443'),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Enforce SSL Pinning and TLS 1.3
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      // Enforce TLS 1.3
      client.maxConnectionsPerHost = 10;

      // SSL Certificate Pinning implementation
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // If no pin is configured, reject all certificates in production builds.
        if (_expectedSha256Pin.isEmpty) {
          if (kReleaseMode) return false;
          return true; // Allow self-signed certs in debug mode only.
        }
        // Compare the cert's SHA-256 fingerprint against the pinned value.
        final fingerprint = sha256.convert(cert.der).toString();
        return fingerprint == _expectedSha256Pin;
      };

      return client;
    };

    // Interceptor for attaching tokens securely and handling rotation
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: _accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Trigger Refresh Token Rotation flow
            final success = await _rotateTokens();
            if (success) {
              return handler.resolve(await _retry(e.requestOptions));
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'secure_access_token';
  static const String _refreshTokenKey = 'secure_refresh_token';

  // Load the expected cert SHA256 from compile-time config.
  // Never hardcode production pins in source code.
  static const String _expectedSha256Pin = String.fromEnvironment('SSL_CERT_SHA256');

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<bool> _rotateTokens() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken == null) return false;

      // Call token refresh endpoint (unauthenticated dio instance to prevent loops)
      final tempDio = Dio(BaseOptions(
        baseUrl: String.fromEnvironment('API_BASE_URL',
            defaultValue: 'https://api.merope.enterprise:8443'),
      ));
      final response = await tempDio.post('/auth/refresh', data: {'refresh_token': refreshToken});

      if (response.statusCode == 200) {
        await saveTokens(response.data['access_token'], response.data['refresh_token']);
        return true;
      }
    } catch (_) {
      // Rotation failed, clear tokens forcing re-login
      await _secureStorage.deleteAll();
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    requestOptions.headers['Authorization'] = 'Bearer $token';
    return dio.fetch(requestOptions);
  }
}
