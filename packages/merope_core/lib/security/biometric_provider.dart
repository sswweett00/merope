import 'dart:async';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiometricAuth extends AsyncNotifier<bool> {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  FutureOr<bool> build() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  Future<bool> canCheckBiometrics() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      final available = await canCheckBiometrics();
      if (!available) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}

final biometricAuthProvider =
    AsyncNotifierProvider<BiometricAuth, bool>(BiometricAuth.new);
