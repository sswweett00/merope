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

Future<void> setScreenCaptureProtection(bool enabled) async {
  if (!Platform.isAndroid) return;
  try {
    if (enabled) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  } catch (error, stackTrace) {
    MeropeLogger.error(
      'Unable to update Android FLAG_SECURE',
      error: error,
      stack: stackTrace,
    );
  }
}
