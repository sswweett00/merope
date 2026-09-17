import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:merope_core/utils/enterprise_logger.dart';

/// Apex Security: State representation of the Biometric Lock
class BiometricAuthState {
  final bool isEnrolled;
  final bool isAuthenticated;
  final List<BiometricType> availableBiometrics;

  const BiometricAuthState({
    this.isEnrolled = false,
    this.isAuthenticated = false,
    this.availableBiometrics = const [],
  });

  BiometricAuthState copyWith({
    bool? isEnrolled,
    bool? isAuthenticated,
    List<BiometricType>? availableBiometrics,
  }) {
    return BiometricAuthState(
      isEnrolled: isEnrolled ?? this.isEnrolled,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      availableBiometrics: availableBiometrics ?? this.availableBiometrics,
    );
  }
}

/// BiometricAuthNotifier: Manages the hardware-level security layer
class BiometricAuthNotifier extends StateNotifier<BiometricAuthState> {
  final LocalAuthentication _auth = LocalAuthentication();

  BiometricAuthNotifier() : super(const BiometricAuthState()) {
    _checkHardwareSupport();
  }

  Future<void> _checkHardwareSupport() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      final available = await _auth.getAvailableBiometrics();

      state = state.copyWith(
        isEnrolled: canCheck && isSupported && available.isNotEmpty,
        availableBiometrics: available,
      );
    } on PlatformException catch (e) {
      MeropeLogger.error('Security: Biometric hardware check failed', error: e);
    }
  }

  /// Attempts to unlock using FaceID/Fingerprint/Iris
  Future<bool> authenticate({required String reason}) async {
    if (!state.isEnrolled) {
      MeropeLogger.warn(
          'Security: Biometric auth attempted but not supported/enrolled');
      return false;
    }

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );

      state = state.copyWith(isAuthenticated: authenticated);
      if (authenticated) {
        MeropeLogger.info('Security: Biometric authentication successful');
      }
      return authenticated;
    } on PlatformException catch (e) {
      MeropeLogger.error('Security: Biometric authentication runtime error',
          error: e);
      return false;
    }
  }

  /// Locks the app (usually called when backgrounded)
  Future<void> lock() async {
    state = state.copyWith(isAuthenticated: false);
  }

  Future<void> reset() async {
    state = const BiometricAuthState();
    await _checkHardwareSupport();
  }
}

final biometricAuthProvider =
    StateNotifierProvider<BiometricAuthNotifier, BiometricAuthState>(
  (ref) => BiometricAuthNotifier(),
);
