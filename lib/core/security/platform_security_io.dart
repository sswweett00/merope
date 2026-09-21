import 'dart:io';

import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:merope_core/utils/enterprise_logger.dart';

Future<void> configurePlatformSecurity() async {
  if (!Platform.isAndroid) return;
  try {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  } catch (error, stackTrace) {
    MeropeLogger.error(
      'Unable to enable Android FLAG_SECURE',
      error: error,
      stack: stackTrace,
    );
  }
}
