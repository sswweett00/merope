import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tokens/merope_tokens.dart';

enum ThemePreset {
  meropeDefault,
  cyberpunk,
  emerald,
  midnightBlue,
  amethyst,
  sunset,
  obsidian,
  arctic,
  sakura,
  gold,
  matrix;

  String get label {
    switch (this) {
      case ThemePreset.meropeDefault: return 'Merope Default';
      case ThemePreset.cyberpunk: return 'Cyberpunk 2077';
      case ThemePreset.emerald: return 'Emerald Zenith';
      case ThemePreset.midnightBlue: return 'Midnight Blue';
      case ThemePreset.amethyst: return 'Royal Amethyst';
      case ThemePreset.sunset: return 'Neon Sunset';
      case ThemePreset.obsidian: return 'Obsidian Dark';
      case ThemePreset.arctic: return 'Arctic Frost';
      case ThemePreset.sakura: return 'Sakura Blossom';
      case ThemePreset.gold: return 'Imperial Gold';
      case ThemePreset.matrix: return 'Matrix Rain';
    }
  }

  MeropeColorTokens get tokens {
    switch (this) {
      case ThemePreset.meropeDefault:
        return MeropeColorTokens.darkDefault();
      case ThemePreset.cyberpunk:
        return const MeropeColorTokens(
          background: Color(0xFF05050A),
          surface: Color(0xFF10101E),
          surfaceVariant: Color(0xFF1A1A32),
          primary: Color(0xFFFF007F),
          primaryVariant: Color(0xFFCC0066),
          onPrimary: Colors.white,
          secondary: Color(0xFF00FFFF),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFFFFFFF),
          textSecondary: Color(0xFFA0A0C0),
          border: Color(0xFF333366),
          onlineStatus: Color(0xFF00FF66),
          idleStatus: Color(0xFFFFCC00),
          dndStatus: Color(0xFFFF0033),
          error: Color(0xFFFF0033),
          onError: Colors.white,
          offlineStatus: Color(0xFF666688),
          glassTint: Color(0x33FF007F),
          auraPrimary: Color(0x26FF007F),
          auraSecondary: Color(0x2600FFFF),
          atmosphereDensity: 0.3,
        );
      case ThemePreset.emerald:
        return const MeropeColorTokens(
          background: Color(0xFF06150B),
          surface: Color(0xFF0C2414),
          surfaceVariant: Color(0xFF133820),
          primary: Color(0xFF10B981),
          primaryVariant: Color(0xFF059669),
          onPrimary: Colors.white,
          secondary: Color(0xFF34D399),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFECFDF5),
          textSecondary: Color(0xFF6EE7B7),
          border: Color(0xFF065F46),
          onlineStatus: Color(0xFF10B981),
          idleStatus: Color(0xFFFBBF24),
          dndStatus: Color(0xFFEF4444),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          offlineStatus: Color(0xFF4B5563),
          glassTint: Color(0x3310B981),
          auraPrimary: Color(0x2610B981),
          auraSecondary: Color(0x2634D399),
          atmosphereDensity: 0.2,
        );
      case ThemePreset.midnightBlue:
        return const MeropeColorTokens(
          background: Color(0xFF020617),
          surface: Color(0xFF0F172A),
          surfaceVariant: Color(0xFF1E293B),
          primary: Color(0xFF3B82F6),
          primaryVariant: Color(0xFF2563EB),
          onPrimary: Colors.white,
          secondary: Color(0xFF60A5FA),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFF8FAFC),
          textSecondary: Color(0xFF94A3B8),
          border: Color(0xFF334155),
          onlineStatus: Color(0xFF22C55E),
          idleStatus: Color(0xFFEAB308),
          dndStatus: Color(0xFFEF4444),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          offlineStatus: Color(0xFF64748B),
          glassTint: Color(0x333B82F6),
          auraPrimary: Color(0x263B82F6),
          auraSecondary: Color(0x2660A5FA),
          atmosphereDensity: 0.2,
        );
      case ThemePreset.amethyst:
        return const MeropeColorTokens(
          background: Color(0xFF0A0510),
          surface: Color(0xFF160D24),
          surfaceVariant: Color(0xFF231438),
          primary: Color(0xFFA855F7),
          primaryVariant: Color(0xFF9333EA),
          onPrimary: Colors.white,
          secondary: Color(0xFFC084FC),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFFAF5FF),
          textSecondary: Color(0xFFD8B4FE),
          border: Color(0xFF6B21A8),
          onlineStatus: Color(0xFF22C55E),
          idleStatus: Color(0xFFEAB308),
          dndStatus: Color(0xFFEF4444),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          offlineStatus: Color(0xFF6B7280),
          glassTint: Color(0x33A855F7),
          auraPrimary: Color(0x26A855F7),
          auraSecondary: Color(0x26C084FC),
          atmosphereDensity: 0.25,
        );
      case ThemePreset.sunset:
        return const MeropeColorTokens(
          background: Color(0xFF120404),
          surface: Color(0xFF240A0A),
          surfaceVariant: Color(0xFF3B1010),
          primary: Color(0xFFF97316),
          primaryVariant: Color(0xFFEA580C),
          onPrimary: Colors.white,
          secondary: Color(0xFFFB923C),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFFFF7ED),
          textSecondary: Color(0xFFFDBA74),
          border: Color(0xFF9A3412),
          onlineStatus: Color(0xFF22C55E),
          idleStatus: Color(0xFFEAB308),
          dndStatus: Color(0xFFEF4444),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          offlineStatus: Color(0xFF78716C),
          glassTint: Color(0x33F97316),
          auraPrimary: Color(0x26F97316),
          auraSecondary: Color(0x26FB923C),
          atmosphereDensity: 0.25,
        );
      case ThemePreset.obsidian:
        return const MeropeColorTokens(
          background: Color(0xFF000000),
          surface: Color(0xFF0A0A0A),
          surfaceVariant: Color(0xFF141414),
          primary: Color(0xFFFFFFFF),
          primaryVariant: Color(0xFFE5E5E5),
          onPrimary: Colors.black,
          secondary: Color(0xFFAFAFAF),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFFFFFFF),
          textSecondary: Color(0xFF888888),
          border: Color(0xFF262626),
          onlineStatus: Color(0xFF22C55E),
          idleStatus: Color(0xFFEAB308),
          dndStatus: Color(0xFFEF4444),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          offlineStatus: Color(0xFF525252),
          glassTint: Color(0x33FFFFFF),
          auraPrimary: Color(0x11FFFFFF),
          auraSecondary: Color(0x0AFFFFFF),
          atmosphereDensity: 0.1,
        );
      case ThemePreset.arctic:
        return const MeropeColorTokens(
          background: Color(0xFFF0F4F8),
          surface: Color(0xFFFFFFFF),
          surfaceVariant: Color(0xFFE2E8F0),
          primary: Color(0xFF0284C7),
          primaryVariant: Color(0xFF0369A1),
          onPrimary: Colors.white,
          secondary: Color(0xFF38BDF8),
          onSecondary: Colors.black,
          textPrimary: Color(0xFF0F172A),
          textSecondary: Color(0xFF64748B),
          border: Color(0xFFCBD5E1),
          onlineStatus: Color(0xFF16A34A),
          idleStatus: Color(0xFFCA8A04),
          dndStatus: Color(0xFFDC2626),
          error: Color(0xFFDC2626),
          onError: Colors.white,
          offlineStatus: Color(0xFF94A3B8),
          glassTint: Color(0x330284C7),
          auraPrimary: Color(0x1A0284C7),
          auraSecondary: Color(0x1A38BDF8),
          atmosphereDensity: 0.15,
        );
      case ThemePreset.sakura:
        return const MeropeColorTokens(
          background: Color(0xFF14080D),
          surface: Color(0xFF26101B),
          surfaceVariant: Color(0xFF3D1A2C),
          primary: Color(0xFFEC4899),
          primaryVariant: Color(0xFFDB2777),
          onPrimary: Colors.white,
          secondary: Color(0xFFF472B6),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFFDF2F8),
          textSecondary: Color(0xFFFBCFE8),
          border: Color(0xFF9D174D),
          onlineStatus: Color(0xFF22C55E),
          idleStatus: Color(0xFFEAB308),
          dndStatus: Color(0xFFEF4444),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          offlineStatus: Color(0xFF71717A),
          glassTint: Color(0x33EC4899),
          auraPrimary: Color(0x26EC4899),
          auraSecondary: Color(0x26F472B6),
          atmosphereDensity: 0.2,
        );
      case ThemePreset.gold:
        return const MeropeColorTokens(
          background: Color(0xFF0A0802),
          surface: Color(0xFF1A1505),
          surfaceVariant: Color(0xFF2B220A),
          primary: Color(0xFFEAB308),
          primaryVariant: Color(0xFFCA8A04),
          onPrimary: Colors.black,
          secondary: Color(0xFFFACC15),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFFEFCE8),
          textSecondary: Color(0xFFFEF08A),
          border: Color(0xFFA16207),
          onlineStatus: Color(0xFF22C55E),
          idleStatus: Color(0xFFEAB308),
          dndStatus: Color(0xFFEF4444),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          offlineStatus: Color(0xFF78716C),
          glassTint: Color(0x33EAB308),
          auraPrimary: Color(0x26EAB308),
          auraSecondary: Color(0x26FACC15),
          atmosphereDensity: 0.2,
        );
      case ThemePreset.matrix:
        return const MeropeColorTokens(
          background: Color(0xFF021002),
          surface: Color(0xFF042004),
          surfaceVariant: Color(0xFF0A360A),
          primary: Color(0xFF22C55E),
          primaryVariant: Color(0xFF16A34A),
          onPrimary: Colors.black,
          secondary: Color(0xFF4ADE80),
          onSecondary: Colors.black,
          textPrimary: Color(0xFFF0FDF4),
          textSecondary: Color(0xFF86EFAC),
          border: Color(0xFF15803D),
          onlineStatus: Color(0xFF22C55E),
          idleStatus: Color(0xFFEAB308),
          dndStatus: Color(0xFFEF4444),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          offlineStatus: Color(0xFF4B5563),
          glassTint: Color(0x3322C55E),
          auraPrimary: Color(0x2622C55E),
          auraSecondary: Color(0x264ADE80),
          atmosphereDensity: 0.25,
        );
    }
  }
}

class CustomThemeConfig {
  final ThemePreset preset;
  final double radiusMultiplier;
  final double fontScale;
  final Color? customPrimary;

  const CustomThemeConfig({
    required this.preset,
    this.radiusMultiplier = 1.0,
    this.fontScale = 1.0,
    this.customPrimary,
  });

  CustomThemeConfig copyWith({
    ThemePreset? preset,
    double? radiusMultiplier,
    double? fontScale,
    Color? customPrimary,
  }) {
    return CustomThemeConfig(
      preset: preset ?? this.preset,
      radiusMultiplier: radiusMultiplier ?? this.radiusMultiplier,
      fontScale: fontScale ?? this.fontScale,
      customPrimary: customPrimary ?? this.customPrimary,
    );
  }
}

class ThemeCustomizerNotifier extends StateNotifier<CustomThemeConfig> {
  ThemeCustomizerNotifier() : super(const CustomThemeConfig(preset: ThemePreset.meropeDefault));

  void setPreset(ThemePreset preset) {
    state = state.copyWith(preset: preset, customPrimary: null);
  }

  void setRadiusMultiplier(double value) {
    state = state.copyWith(radiusMultiplier: value);
  }

  void setFontScale(double value) {
    state = state.copyWith(fontScale: value);
  }

  void setCustomPrimary(Color color) {
    state = state.copyWith(customPrimary: color);
  }

  MeropeColorTokens get tokens {
    final base = state.preset.tokens;
    if (state.customPrimary != null) {
      return MeropeColorTokens(
        background: base.background,
        surface: base.surface,
        surfaceVariant: base.surfaceVariant,
        primary: state.customPrimary!,
        primaryVariant: state.customPrimary!.withValues(alpha: 0.8),
        onPrimary: base.onPrimary,
        secondary: base.secondary,
        onSecondary: base.onSecondary,
        textPrimary: base.textPrimary,
        textSecondary: base.textSecondary,
        border: base.border,
        onlineStatus: base.onlineStatus,
        idleStatus: base.idleStatus,
        dndStatus: base.dndStatus,
        error: base.error,
        onError: base.onError,
        offlineStatus: base.offlineStatus,
        glassTint: state.customPrimary!.withValues(alpha: 0.2),
        auraPrimary: state.customPrimary!.withValues(alpha: 0.15),
        auraSecondary: base.auraSecondary,
        atmosphereDensity: base.atmosphereDensity,
      );
    }
    return base;
  }
}

final themeCustomizerProvider = StateNotifierProvider<ThemeCustomizerNotifier, CustomThemeConfig>((ref) {
  return ThemeCustomizerNotifier();
});
