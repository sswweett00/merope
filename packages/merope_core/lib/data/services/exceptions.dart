import 'package:dio/dio.dart';

class MeropeAPIException implements Exception {
  final int? statusCode;
  final String message;
  final String? code;

  const MeropeAPIException({
    this.statusCode,
    required this.message,
    this.code,
  });

  factory MeropeAPIException.fromDioError(DioException e) {
    return MeropeAPIException(
      statusCode: e.response?.statusCode,
      message: e.response?.data?['error'] ?? e.message ?? 'Unknown error',
      code: e.response?.data?['code'],
    );
  }

  @override
  String toString() => 'MeropeAPIException(${statusCode ?? 'N/A'}): $message';

  bool get isUnauthorized => statusCode == 401 || statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isNetworkError => statusCode == null;
}

class AuthRequiredException extends MeropeAPIException {
  const AuthRequiredException()
      : super(statusCode: 401, message: 'Authentication required');
}

class NetworkTimeoutException extends MeropeAPIException {
  const NetworkTimeoutException() : super(message: 'Request timed out');
}
