import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeropeSettingsState {
  final bool ghostMode;
  final String lastSeenVisibility;
  final bool readReceipts;
  final bool is2FAEnabled;
  final bool isAppLockEnabled;
  final bool lowDataMode;
  final String currentLanguage;

  // Security Apex fields
  final String privacyLevel;
  final bool decoyEnabled;
  final bool cbrEnabled;
  final bool stegoEnabled;
  final String lastRotationDate;
  final int safetyScore;

  MeropeSettingsState({
    this.ghostMode = false,
    this.lastSeenVisibility = 'Everyone',
    this.readReceipts = true,
    this.is2FAEnabled = false,
    this.isAppLockEnabled = false,
    this.lowDataMode = false,
    this.currentLanguage = 'en',
    this.privacyLevel = 'Standard',
    this.decoyEnabled = false,
    this.cbrEnabled = false,
    this.stegoEnabled = false,
    this.lastRotationDate = 'Never',
    this.safetyScore = 85,
  });

  MeropeSettingsState copyWith({
    bool? ghostMode,
    String? lastSeenVisibility,
    bool? readReceipts,
    bool? is2FAEnabled,
    bool? isAppLockEnabled,
    bool? lowDataMode,
    String? currentLanguage,
    String? privacyLevel,
    bool? decoyEnabled,
    bool? cbrEnabled,
    bool? stegoEnabled,
    String? lastRotationDate,
    int? safetyScore,
  }) {
    return MeropeSettingsState(
      ghostMode: ghostMode ?? this.ghostMode,
      lastSeenVisibility: lastSeenVisibility ?? this.lastSeenVisibility,
      readReceipts: readReceipts ?? this.readReceipts,
      is2FAEnabled: is2FAEnabled ?? this.is2FAEnabled,
      isAppLockEnabled: isAppLockEnabled ?? this.isAppLockEnabled,
      lowDataMode: lowDataMode ?? this.lowDataMode,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      decoyEnabled: decoyEnabled ?? this.decoyEnabled,
      cbrEnabled: cbrEnabled ?? this.cbrEnabled,
      stegoEnabled: stegoEnabled ?? this.stegoEnabled,
      lastRotationDate: lastRotationDate ?? this.lastRotationDate,
      safetyScore: safetyScore ?? this.safetyScore,
    );
  }
}

class MeropeSettings extends Notifier<MeropeSettingsState> {
  @override
  MeropeSettingsState build() {
    return MeropeSettingsState();
  }

  void setGhostMode(bool val) => state = state.copyWith(ghostMode: val);
  void setLastSeen(String val) =>
      state = state.copyWith(lastSeenVisibility: val);
  void setReadReceipts(bool val) => state = state.copyWith(readReceipts: val);
  void set2FA(bool val) => state = state.copyWith(is2FAEnabled: val);
  void setAppLock(bool val) => state = state.copyWith(isAppLockEnabled: val);
  void setLowDataMode(bool val) => state = state.copyWith(lowDataMode: val);
  void setLanguage(String val) => state = state.copyWith(currentLanguage: val);

  void setDecoyEnabled(bool val) => state = state.copyWith(decoyEnabled: val);
  void setCbrEnabled(bool val) => state = state.copyWith(cbrEnabled: val);
  void setStegoEnabled(bool val) => state = state.copyWith(stegoEnabled: val);

  void rotateIdentity() {
    state = state.copyWith(
      lastRotationDate: DateTime.now().toString().substring(0, 16),
      safetyScore: 100,
    );
  }

  Future<void> clearCache() async {
    // Logic to clear local cache
    await Future.delayed(const Duration(seconds: 1));
  }
}

final meropeSettingsProvider =
    NotifierProvider<MeropeSettings, MeropeSettingsState>(MeropeSettings.new);
