import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/security/privacy_guard.dart';
import 'package:merope_ui/widgets/resonance_background.dart';
import './router.dart';
import 'package:merope_ui/hud/hud_overlay.dart';
import 'package:merope_ui/error/error_boundary.dart';
import 'package:merope_core/i18n/merope_localization.dart';
import 'package:merope_core/data/services/connectivity_service.dart';
import 'package:merope_core/plugins/background_orchestrator.dart';
import 'package:merope_core/utils/enterprise_logger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:merope_ui/widgets/video_mini_player.dart';

class _ServerConnectionBanner extends ConsumerWidget {
  const _ServerConnectionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityProvider);
    if (status == ConnectivityStatus.online) return const SizedBox.shrink();
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.redAccent,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, color: Colors.white, size: 14),
              SizedBox(width: 8),
              Text(
                'SERVER CONNECTION LOST',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeropeApp extends ConsumerStatefulWidget {
  const MeropeApp({super.key});

  @override
  ConsumerState<MeropeApp> createState() => _MeropeAppState();
}

class _MeropeAppState extends ConsumerState<MeropeApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backgroundOrchestratorProvider).startDaemon();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      MeropeLogger.info('UBOS: App paused.');
    } else if (state == AppLifecycleState.resumed) {
      MeropeLogger.info('UBOS: App resumed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Merope',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: const [
        MeropeLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('tr', '')],
      builder: (context, child) {
        return GlobalErrorBoundary(
          child: HUDOverlay(
            child: PrivacyGuard(
              child: ResonanceBackground(
                child: Stack(
                  children: [
                    child ?? const SizedBox.shrink(),
                    const _ServerConnectionBanner(),
                    const VideoMiniPlayer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      theme: ThemeData(
        brightness: themeState.isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: tokens.background,
        colorScheme: ColorScheme(
          brightness: themeState.isDark ? Brightness.dark : Brightness.light,
          primary: tokens.primary,
          onPrimary: tokens.onPrimary,
          secondary: tokens.secondary,
          onSecondary: tokens.onSecondary,
          surface: tokens.surface,
          onSurface: tokens.textPrimary,
          error: tokens.error,
          onError: tokens.onError,
        ),
      ),
      themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
