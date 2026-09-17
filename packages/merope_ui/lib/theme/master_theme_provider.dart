import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tokens/merope_tokens.dart';
import 'theme_customizer_provider.dart';
import 'image_theme_customizer.dart';

class MasterThemeState {
  final ThemePreset preset;
  final double radiusMultiplier;
  final double fontScale;
  final Color? customAccent;
  final String? primaryImagePath;
  final String? secondaryImagePath;
  final double blurIntensity;
  final double tintOpacity;

  const MasterThemeState({
    required this.preset,
    required this.radiusMultiplier,
    required this.fontScale,
    this.customAccent,
    this.primaryImagePath,
    this.secondaryImagePath,
    required this.blurIntensity,
    required this.tintOpacity,
  });

  MeropeColorTokens get tokens {
    final base = preset.tokens;
    if (customAccent != null) {
      return MeropeColorTokens(
        background: base.background,
        surface: base.surface,
        surfaceVariant: base.surfaceVariant,
        primary: customAccent!,
        primaryVariant: customAccent!.withValues(alpha: 0.8),
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
        glassTint: customAccent!.withValues(alpha: 0.2),
        auraPrimary: customAccent!.withValues(alpha: 0.15),
        auraSecondary: base.auraSecondary,
        atmosphereDensity: base.atmosphereDensity,
      );
    }
    return base;
  }
}

class MasterThemeNotifier extends StateNotifier<MasterThemeState> {
  final Ref ref;

  MasterThemeNotifier(this.ref)
      : super(const MasterThemeState(
          preset: ThemePreset.meropeDefault,
          radiusMultiplier: 1.0,
          fontScale: 1.0,
          blurIntensity: 16.0,
          tintOpacity: 0.35,
        )) {
    // Listen to changes in themeCustomizerProvider and imageThemeProvider
    ref.listen<CustomThemeConfig>(themeCustomizerProvider, (previous, next) {
      state = MasterThemeState(
        preset: next.preset,
        radiusMultiplier: next.radiusMultiplier,
        fontScale: next.fontScale,
        customAccent: next.customPrimary,
        primaryImagePath: state.primaryImagePath,
        secondaryImagePath: state.secondaryImagePath,
        blurIntensity: state.blurIntensity,
        tintOpacity: state.tintOpacity,
      );
    });

    ref.listen<ImageThemeState>(imageThemeProvider, (previous, next) {
      state = MasterThemeState(
        preset: state.preset,
        radiusMultiplier: state.radiusMultiplier,
        fontScale: state.fontScale,
        customAccent: state.customAccent,
        primaryImagePath: next.primaryImagePath,
        secondaryImagePath: next.secondaryImagePath,
        blurIntensity: next.blurIntensity,
        tintOpacity: next.tintOpacity,
      );
    });
  }
}

final masterThemeProvider =
    StateNotifierProvider<MasterThemeNotifier, MasterThemeState>((ref) {
  return MasterThemeNotifier(ref);
});
