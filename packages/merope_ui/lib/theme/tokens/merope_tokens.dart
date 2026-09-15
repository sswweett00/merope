import 'package:flutter/material.dart';

/// Merope Design System Tokens
/// Completely independent of Material 3 component defaults.
abstract class MeropeTokens {
  // Spacing Tokens
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;

  // Radius Tokens
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 9999.0;

  // Motion & Animation Tokens
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);

  static const Curve curveStandard = Curves.easeInOutCubic;
  static const Curve curveDecelerate = Curves.easeOutCubic;
  static const Curve curveBounce = Curves.elasticOut;

  // Blur Tokens for Glassmorphism
  static const double blurLow = 8.0;
  static const double blurMedium = 16.0;
  static const double blurHigh = 32.0;

  // Typography Tokens
  static const double fontHeightTight = 1.1;
  static const double fontHeightNormal = 1.4;
  static const double fontHeightRelaxed = 1.6;

  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 20.0;
  static const double fontSizeXl = 28.0;
  static const double fontSizeXxl = 40.0;

  // Elevation & Shadow Tokens
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x66000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  // Motion Curves (120 FPS Optimized)
  static const Curve curveMeropeStandard = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve curveMeropeEntrance = Cubic(0.0, 0.0, 0.2, 1.0);
  static const Curve curveMeropeExit = Cubic(0.4, 0.0, 1.0, 1.0);
  static const Curve curveMeropeSharp = Cubic(0.4, 0.0, 0.6, 1.0);

  // Haptic Feedback Tokens
  static const int hapticSoft = 1;
  static const int hapticLight = 2;
  static const int hapticMedium = 3;
  static const int hapticHeavy = 4;
  static const int hapticSelection = 5;

  // Atmosphere & Aura Tokens
  static const double auraIntensityLow = 0.2;
  static const double auraIntensityMedium = 0.5;
  static const double auraIntensityHigh = 0.8;

  // Neural Grid Layout Tokens
  static const int gridColumnsMobile = 4;
  static const int gridColumnsTablet = 12;
  static const double gridGutter = 16.0;
  static const double gridMargin = 20.0;

  // Atmosphere Shift Ranges
  static const double atmosphereMinAlpha = 0.05;
  static const double atmosphereMaxAlpha = 0.4;

  // Zenith Design Tokens (v11.0)
  static const double glassElevation = 24.0;
  static const double auraRadius = 120.0;
  static const double neuralFriction = 0.85; // Custom physics
}

/// Dynamic Merope Color Tokens
class MeropeColorTokens {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color onlineStatus;
  final Color idleStatus;
  final Color dndStatus;
  final Color error;
  final Color onError;
  final Color offlineStatus;
  final Color glassTint;

  // Atmosphere Tokens
  final Color auraPrimary;
  final Color auraSecondary;
  final double atmosphereDensity;

  const MeropeColorTokens({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.onlineStatus,
    required this.idleStatus,
    required this.dndStatus,
    required this.error,
    required this.onError,
    required this.offlineStatus,
    required this.glassTint,
    required this.auraPrimary,
    required this.auraSecondary,
    required this.atmosphereDensity,
  });

  factory MeropeColorTokens.darkDefault() {
    return const MeropeColorTokens(
      background: Color(0xFF0F1117),
      surface: Color(0xFF161922),
      surfaceVariant: Color(0xFF1E2230),
      primary: Color(0xFF5865F2),
      primaryVariant: Color(0xFF4752C4),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF3BA55D),
      onSecondary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFFF2F3F5),
      textSecondary: Color(0xFF949BA4),
      border: Color(0xFF2B2D31),
      onlineStatus: Color(0xFF23A55A),
      idleStatus: Color(0xFFF0B232),
      dndStatus: Color(0xFFF23F43),
      error: Color(0xFFF23F43),
      onError: Color(0xFFFFFFFF),
      offlineStatus: Color(0xFF80848E),
      glassTint: Color(0x330F1117),
      auraPrimary: Color(0x1A5865F2),
      auraSecondary: Color(0x1A3BA55D),
      atmosphereDensity: 0.15,
    );
  }

  factory MeropeColorTokens.lightDefault() {
    return const MeropeColorTokens(
      background: Color(0xFFF2F3F5),
      surface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFECEEF0),
      primary: Color(0xFF5865F2),
      primaryVariant: Color(0xFF4752C4),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF3BA55D),
      onSecondary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF1A1A2E),
      textSecondary: Color(0xFF6B7280),
      border: Color(0xFFD1D5DB),
      onlineStatus: Color(0xFF23A55A),
      idleStatus: Color(0xFFF0B232),
      dndStatus: Color(0xFFF23F43),
      error: Color(0xFFF23F43),
      onError: Color(0xFFFFFFFF),
      offlineStatus: Color(0xFF80848E),
      glassTint: Color(0x33F2F3F5),
      auraPrimary: Color(0x0D5865F2),
      auraSecondary: Color(0x0D3BA55D),
      atmosphereDensity: 0.1,
    );
  }
}
