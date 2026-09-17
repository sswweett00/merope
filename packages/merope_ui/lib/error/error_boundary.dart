import 'package:flutter/material.dart';
import 'package:merope_core/utils/enterprise_logger.dart';

class GlobalErrorBoundary extends StatefulWidget {
  final Widget child;

  const GlobalErrorBoundary({super.key, required this.child});

  @override
  State<GlobalErrorBoundary> createState() => _GlobalErrorBoundaryState();
}

class _GlobalErrorBoundaryState extends State<GlobalErrorBoundary> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      MeropeLogger.error('Flutter Error Caught',
          error: details.exception, stack: details.stack);
      // Enterprise refinement: Automatically report to telemetry
      _reportError(details.exception, details.stack);
    };
  }

  void _reportError(dynamic exception, StackTrace? stack) {
    // In production, this would send to Sentry/Crashlytics/Internal Logging API
    debugPrint('SENTINEL: Automatic bug report dispatched for $exception');
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text('A critical error occurred.'),
                ElevatedButton(
                  onPressed: () => setState(() => _hasError = false),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }

  @override
  void activate() {
    super.activate();
    ErrorWidget.builder = (details) {
      MeropeLogger.error('Build Error',
          error: details.exception, stack: details.stack);
      return const Center(child: Text('An error occurred in the UI.'));
    };
  }
}
