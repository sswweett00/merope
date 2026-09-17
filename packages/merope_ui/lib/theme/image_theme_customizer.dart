import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageThemeState {
  final String? primaryImagePath;
  final String? secondaryImagePath;
  final double blurIntensity;
  final double tintOpacity;
  final Color customAccent;

  const ImageThemeState({
    this.primaryImagePath,
    this.secondaryImagePath,
    this.blurIntensity = 16.0,
    this.tintOpacity = 0.35,
    this.customAccent = const Color(0xFF5865F2),
  });

  ImageThemeState copyWith({
    String? primaryImagePath,
    String? secondaryImagePath,
    double? blurIntensity,
    double? tintOpacity,
    Color? customAccent,
  }) {
    return ImageThemeState(
      primaryImagePath: primaryImagePath ?? this.primaryImagePath,
      secondaryImagePath: secondaryImagePath ?? this.secondaryImagePath,
      blurIntensity: blurIntensity ?? this.blurIntensity,
      tintOpacity: tintOpacity ?? this.tintOpacity,
      customAccent: customAccent ?? this.customAccent,
    );
  }
}

class ImageThemeNotifier extends StateNotifier<ImageThemeState> {
  ImageThemeNotifier() : super(const ImageThemeState());

  void setPrimaryImage(String? path) {
    state = state.copyWith(primaryImagePath: path);
  }

  void setSecondaryImage(String? path) {
    state = state.copyWith(secondaryImagePath: path);
  }

  void setBlurIntensity(double blur) {
    state = state.copyWith(blurIntensity: blur);
  }

  void setTintOpacity(double opacity) {
    state = state.copyWith(tintOpacity: opacity);
  }

  void setCustomAccent(Color color) {
    state = state.copyWith(customAccent: color);
  }
}

final imageThemeProvider =
    StateNotifierProvider<ImageThemeNotifier, ImageThemeState>((ref) {
  return ImageThemeNotifier();
});
