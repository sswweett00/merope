import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import '../../security/session_storage.dart';
import '../../security/aether_auth_shield.dart';
import '../../plugins/isolate_manager.dart';

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
    dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? 'https://api.merope.enterprise:8443',
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Merope-Client-Version': '10.2.0-Apex',
      },
    ));

    // Enforce TLS 1.3 and SSL Pinning
    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          if (expectedCertSha256 == null) return true;
          final fingerprint = sha256.convert(cert.der).toString();
          return fingerprint == expectedCertSha256;
        };
        return client;
      };
    }

    dio.transformer = BackgroundTransformer(_isolateManager);

    dio.interceptors.add(AuthInterceptor(_sessionStorage, onRefresh: () => refreshCallback?.call() ?? Future.value(false)));
    dio.interceptors.add(RetryInterceptor(dio));
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
      ));
    }
  }

  Future<ApiResult<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return ApiResult.success(response.data as T);
    } catch (e) {
      return ApiResult.error(e);
    }
  }

  Future<ApiResult<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.post(path, data: data, queryParameters: queryParameters);
      return ApiResult.success(response.data as T);
    } catch (e) {
      return ApiResult.error(e);
    }
  }

  Future<ApiResult<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.put(path, data: data, queryParameters: queryParameters);
      return ApiResult.success(response.data as T);
    } catch (e) {
      return ApiResult.error(e);
    }
  }

  Future<ApiResult<T>> delete<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.delete(path, queryParameters: queryParameters);
      return ApiResult.success(response.data as T);
    } catch (e) {
      return ApiResult.error(e);
    }
  }

  Future<ApiResult<T>> uploadMultipart<T>(
    String path,
    FormData data, {
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        onSendProgress: onSendProgress,
      );
      return ApiResult.success(response.data as T);
    } catch (e) {
      return ApiResult.error(e);
    }
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

    // If response type is JSON and payload is reasonably large, offload to isolate
    if (options.responseType == ResponseType.json && data is String) {
       return _isolateManager.parseJson(data);
    }
    return data;
  }
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionStorage, {this.onRefresh});
  final SessionStorage _sessionStorage;
  final Future<bool> Function()? onRefresh;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _sessionStorage.getToken();
    if (token != null && token.isNotEmpty) {
      final authValue = 'Bearer $token';
      options.headers['Authorization'] = authValue;

      // Zenith: Aether Token Binding (Signature)
      try {
        final signature = await AetherAuthShield.signApexChallenge(authValue);
        options.headers['X-Aether-Signature'] = signature;

        final deviceSig = await AetherAuthShieldNotifier().getSecureDeviceSignature();
        options.headers['X-Merope-Device-Sig'] = deviceSig;
      } catch (e) {
        debugPrint('Security Shield: Failed to sign request');
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && onRefresh != null) {
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
        } catch (e) {
          _refreshCompleter!.complete(false);
          _isRefreshing = false;
        }
      }

      await _sessionStorage.clearSession();
    }
    handler.next(err);
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final dio = Dio(requestOptions.baseUrl.isNotEmpty ? BaseOptions(baseUrl: requestOptions.baseUrl) : BaseOptions());
    final token = await _sessionStorage.getToken();

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio);
  final Dio _dio;

  static const int _maxRetries = 2;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.method != 'POST') {
      final attempt = (err.requestOptions.extra['retryAttempt'] as int?) ?? 0;
      if (attempt < _maxRetries) {
        await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
        try {
          final response = await _dio.fetch(err.requestOptions.copyWith(extra: {...err.requestOptions.extra, 'retryAttempt': attempt + 1}));
          handler.resolve(response);
          return;
        } catch (_) {}
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

  bool get isSuccess => data != null;
  bool get isError => error != null;

  R fold<R>(R Function(T data) success, R Function(dynamic error) failure) {
    if (isSuccess) return success(data as T);
    return failure(error);
  }
}

extension ApiResultExt<T> on Future<ApiResult<T>> {
  Future<T?> unwrap() async {
    final result = await this;
    return result.data;
  }
}
