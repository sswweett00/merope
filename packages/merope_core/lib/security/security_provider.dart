import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecuritySettings extends Notifier<bool> {
  @override
  bool build() {
    return true; // Default E2EE enabled
  }

  void toggleE2EE() {
    state = !state;
  }
}

final securitySettingsProvider = NotifierProvider<SecuritySettings, bool>(SecuritySettings.new);
