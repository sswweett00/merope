import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../plugins/isolate_manager.dart';
import '../../security/aether_auth_shield.dart';
import '../../security/session_storage.dart';

class ApiClient {
  factory ApiClient() => _instance;
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();

  late final Dio dio;
  final SessionStorage _sessionStorage = SessionStorage();
  final IsolateManager _isolateManager = IsolateManager();
  Future<bool> Function()? refreshCallback;

  static const Duration _connectTimeout = Duration(seconds: 15);
  static const Duration _receiveTimeout = Duration(seconds: 20);

  Future<void> init({String? baseUrl, String? expectedCertSha256}) async {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? 'https://api.merope.enterprise:8443',
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Merope-Client-Version': '10.2.0-Apex',
        },
      ),
    );

    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient()
          ..connectionTimeout = _connectTimeout
          ..idleTimeout = const Duration(seconds: 30)
          ..maxConnectionsPerHost = 12;
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          if (expectedCertSha256 == null || expectedCertSha256.trim().isEmpty) {
            return false;
          }
          final fingerprint = sha256.convert(cert.der).toString().toLowerCase();
          return fingerprint == expectedCertSha256.trim().toLowerCase();
        };
        return client;
      };
    }

    dio.transformer = BackgroundTransformer(_isolateManager);
    dio.interceptors.add(ApiVersionInterceptor());
    dio.interceptors.add(IdempotencyInterceptor());
    dio.interceptors.add(
      AuthInterceptor(
        dio,
        _sessionStorage,
        onRefresh: () => refreshCallback?.call() ?? Future.value(false),
      ),
    );
    dio.interceptors.add(RetryInterceptor(dio));

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
        ),
      );
    }
  }

  Future<ApiResult<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return ApiResult.success(response.data as T, statusCode: response.statusCode);
    } catch (e) {
      return ApiResult.error(e, statusCode: _statusOf(e));
    }
  }

  Future<ApiResult<T>> post<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.post(path, data: data, queryParameters: queryParameters);
      return ApiResult.success(response.data as T, statusCode: response.statusCode);
    } catch (e) {
      return ApiResult.error(e, statusCode: _statusOf(e));
    }
  }

  Future<ApiResult<T>> put<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.put(path, data: data, queryParameters: queryParameters);
      return ApiResult.success(response.data as T, statusCode: response.statusCode);
    } catch (e) {
      return ApiResult.error(e, statusCode: _statusOf(e));
    }
  }

  Future<ApiResult<T>> patch<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.patch(path, data: data, queryParameters: queryParameters);
      return ApiResult.success(response.data as T, statusCode: response.statusCode);
    } catch (e) {
      return ApiResult.error(e, statusCode: _statusOf(e));
    }
  }

  Future<ApiResult<T>> delete<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.delete(path, data: data, queryParameters: queryParameters);
      return ApiResult.success(response.data as T, statusCode: response.statusCode);
    } catch (e) {
      return ApiResult.error(e, statusCode: _statusOf(e));
    }
  }

  Future<ApiResult<T>> uploadMultipart<T>(String path, FormData data,
      {ProgressCallback? onSendProgress}) async {
    try {
      final response = await dio.post(path, data: data, onSendProgress: onSendProgress);
      return ApiResult.success(response.data as T, statusCode: response.statusCode);
    } catch (e) {
      return ApiResult.error(e, statusCode: _statusOf(e));
    }
  }

  int? _statusOf(Object error) {
    if (error is DioException) return error.response?.statusCode;
    return null;
  }
}

class ApiVersionInterceptor extends Interceptor {
  static const _apiPrefix = '/api/v10/';
  static const _excludedPrefixes = <String>{'/api/', '/health/'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var path = options.path.trim();
    if (path.isEmpty) {
      handler.next(options);
      return;
    }

    final isAbsolute = path.startsWith('http://') || path.startsWith('https://');
    if (!isAbsolute && !path.startsWith('/')) {
      path = '/$path';
    }

    final isVersioned = path.startsWith(_apiPrefix);
    final isExcluded = _excludedPrefixes.any(path.startsWith);
    final isHealth = path == '/health' || path.startsWith('/health/');

    if (!isAbsolute && !isVersioned && !isExcluded && !isHealth) {
      options.path = '$_apiPrefix${path.substring(1)}';
    } else {
      options.path = path;
    }

    handler.next(options);
  }
}

class IdempotencyInterceptor extends Interceptor {
  static const _safeMethods = <String>{'GET', 'HEAD', 'OPTIONS'};
  static final Random _random = Random.secure();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();
    final current = options.headers['Idempotency-Key']?.toString().trim();
    final isApiRequest = options.path.startsWith('/api/v10/');

    if (isApiRequest && !_safeMethods.contains(method) &&
        (current == null || current.isEmpty)) {
      final nonce = _random.nextInt(1 << 32);
      options.headers['Idempotency-Key'] =
          '${DateTime.now().microsecondsSinceEpoch}-$nonce';
    }

    handler.next(options);
  }
}

class BackgroundTransformer extends SyncTransformer {
  BackgroundTransformer(this._isolateManager);
  final IsolateManager _isolateManager;

  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    final dynamic data = await super.transformResponse(options, responseBody);

    if (options.responseType == ResponseType.json && data is String) {
      return _isolateManager.parseJson(data);
    }
    return data;
  }
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio, this._sessionStorage, {this.onRefresh});
  final Dio _dio;
  final SessionStorage _sessionStorage;
  final Future<bool> Function()? onRefresh;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;
  String? _cachedToken;
  String? _cachedAetherSignature;
  Future<String>? _deviceSignatureFuture;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _sessionStorage.getToken();
    if (token != null && token.isNotEmpty) {
      final authValue = 'Bearer $token';
      options.headers['Authorization'] = authValue;

      try {
        String signature;
        if (_cachedToken == token && _cachedAetherSignature != null) {
          signature = _cachedAetherSignature!;
        } else {
          signature = await AetherAuthShield.signApexChallenge(authValue);
          _cachedToken = token;
          _cachedAetherSignature = signature;
        }
        options.headers['X-Aether-Signature'] = signature;

        _deviceSignatureFuture ??=
            AetherAuthShieldNotifier().getSecureDeviceSignature();
        options.headers['X-Merope-Device-Sig'] = await _deviceSignatureFuture!;
      } catch (_) {
        debugPrint('Security Shield: Failed to sign request');
      }
    } else {
      _cachedToken = null;
      _cachedAetherSignature = null;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final skipRefresh = err.requestOptions.extra['skipAuthRefresh'] == true;
    if (err.response?.statusCode == 401 && onRefresh != null && !skipRefresh) {
      if (_isRefreshing) {
        final success = await _refreshCompleter!.future;
        if (success) {
          return handler.resolve(await _retry(err.requestOptions));
        }
      } else {
        _isRefreshing = true;
        _refreshCompleter = Completer<bool>();

        try {
          final success = await onRefresh!();
          _refreshCompleter!.complete(success);
          _isRefreshing = false;

          if (success) {
            return handler.resolve(await _retry(err.requestOptions));
          }
        } catch (_) {
          _refreshCompleter!.complete(false);
          _isRefreshing = false;
        }
      }

      await _sessionStorage.clearSession();
      _cachedToken = null;
      _cachedAetherSignature = null;
    }
    handler.next(err);
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = await _sessionStorage.getToken();
    return _dio.fetch(
      requestOptions.copyWith(
        extra: {
          ...requestOptions.extra,
          'skipAuthRefresh': true,
        },
        headers: {
          ...requestOptions.headers,
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}

class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio);
  final Dio _dio;

  static const int _maxRetries = 2;
  static const _retryableMethods = <String>{'GET', 'HEAD', 'OPTIONS'};

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final method = err.requestOptions.method.toUpperCase();
      if (_retryableMethods.contains(method)) {
        final attempt = (err.requestOptions.extra['retryAttempt'] as int?) ?? 0;
        if (attempt < _maxRetries) {
          await Future<void>.delayed(Duration(milliseconds: 250 * (attempt + 1)));
          try {
            final response = await _dio.fetch(
              err.requestOptions.copyWith(
                extra: {
                  ...err.requestOptions.extra,
                  'retryAttempt': attempt + 1,
                },
              ),
            );
            handler.resolve(response);
            return;
          } catch (_) {
            // Continue the original error path.
          }
        }
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

class ApiResult<T> {
  const ApiResult.success(this.data, {this.statusCode}) : error = null;
  const ApiResult.error(this.error, {this.statusCode}) : data = null;

  final T? data;
  final dynamic error;
  final int? statusCode;

  bool get isSuccess => error == null;
  bool get isError => error != null;

  R fold<R>(R Function(T data) success, R Function(dynamic error) failure) {
    if (isSuccess) return success(data as T);
    return failure(error);
  }
}
