import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SoundscapeProfile {
  silent,
  cyberpunkClick,
  softResonance,
  heavyEnterprise;

  String get label {
    switch (this) {
      case SoundscapeProfile.silent:
        return 'Sessiz / Yok';
      case SoundscapeProfile.cyberpunkClick:
        return 'Cyberpunk Tıklama';
      case SoundscapeProfile.softResonance:
        return 'Yumuşak Rezonans';
      case SoundscapeProfile.heavyEnterprise:
        return 'Kurumsal Mekanik';
    }
  }

  void playFeedback() {
    switch (this) {
      case SoundscapeProfile.silent:
        break;
      case SoundscapeProfile.cyberpunkClick:
        HapticFeedback.lightImpact();
        break;
      case SoundscapeProfile.softResonance:
        HapticFeedback.selectionClick();
        break;
      case SoundscapeProfile.heavyEnterprise:
        HapticFeedback.heavyImpact();
        break;
    }
  }
}

class SoundscapeNotifier extends StateNotifier<SoundscapeProfile> {
  SoundscapeNotifier() : super(SoundscapeProfile.softResonance);

  void setProfile(SoundscapeProfile profile) {
    state = profile;
    profile.playFeedback();
  }
}

final soundscapeProvider =
    StateNotifierProvider<SoundscapeNotifier, SoundscapeProfile>((ref) {
  return SoundscapeNotifier();
});
