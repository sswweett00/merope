import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

void configureDioHttpClient(
  Dio dio, {
  String? expectedCertSha256,
  Duration connectTimeout = const Duration(seconds: 15),
}) {
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient()
      ..connectionTimeout = connectTimeout
      ..idleTimeout = const Duration(seconds: 30)
      ..maxConnectionsPerHost = 12;

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      final expected = expectedCertSha256?.trim().toLowerCase();
      if (expected == null || expected.isEmpty) return false;
      final fingerprint = sha256.convert(cert.der).toString().toLowerCase();
      return fingerprint == expected;
    };
    return client;
  };
}
