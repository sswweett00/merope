import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_core/utils/enterprise_logger.dart';
import 'core/security/platform_security.dart';

import 'app/merope_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await configurePlatformSecurity();

  const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
  final baseUrl = configuredBaseUrl.isNotEmpty
      ? configuredBaseUrl
      : (kIsWeb ? Uri.base.origin : 'https://api.merope.enterprise:8443');

  const certPin = String.fromEnvironment('SSL_CERT_SHA256');

  await ApiClient().init(
      baseUrl: baseUrl,
      expectedCertSha256: certPin.isNotEmpty ? certPin : null);
  runApp(const ProviderScope(child: MeropeApp()));
}
