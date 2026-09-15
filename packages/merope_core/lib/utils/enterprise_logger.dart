import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warn, error, fatal }

class MeropeLogger {
  static void log(LogLevel level, String message, {Object? error, StackTrace? stack}) {
    if (kReleaseMode && level == LogLevel.debug) return;

    final timestamp = DateTime.now().toIso8601String();
    final logString = '[$timestamp] [${level.name.toUpperCase()}] $message';

    debugPrint(logString);
    if (error != null) debugPrint('Error: $error');
    if (stack != null) debugPrint('Stack: $stack');

    // In a real enterprise app, we'd send errors to a secure crash reporting sink here.
  }

  static void info(String msg) => log(LogLevel.info, msg);
  static void warn(String msg) => log(LogLevel.warn, msg);
  static void error(String msg, {Object? error, StackTrace? stack}) =>
      log(LogLevel.error, msg, error: error, stack: stack);
}
