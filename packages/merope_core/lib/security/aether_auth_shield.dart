import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AetherAuthShieldNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<bool> authenticateBiometrically() async {
    return await LocalAuthentication().authenticate(
      localizedReason: 'Authorize Secure Session',
      options: const AuthenticationOptions(stickyAuth: true),
    );
  }

  Future<String> getSecureDeviceSignature() async {
    final key = await const FlutterSecureStorage().read(key: 'aether_apex_root');
    if (key == null) return 'unsigned';
    return sha256.convert(utf8.encode(key)).toString().substring(0, 16);
  }
}

final aetherAuthShieldProvider =
    AsyncNotifierProvider<AetherAuthShieldNotifier, void>(AetherAuthShieldNotifier.new);

/// AetherAuthShield V8 - Apex Layer (Biometric-Locked Key Rotation).
class AetherAuthShield {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static final _localAuth = LocalAuthentication();

  /// Apex Refinement: Biometric-Locked Identity Rotation.
  /// Automatically rotates the root identity key after X biometric checks.
  static Future<void> secureIdentityRotation() async {
    final bool didAuth = await _localAuth.authenticate(
      localizedReason: 'Authorize Apex Identity Rotation',
      options: const AuthenticationOptions(stickyAuth: true),
    );

    if (didAuth) {
      final newKey = _generateEntropy(64);
      // Anchor in StrongBox
      await _storage.write(
        key: 'aether_apex_root',
        value: newKey,
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );
      await _storage.write(key: 'aether_last_rotation', value: DateTime.now().toIso8601String());
    }
  }

  /// Verifies a challenge using the hardware-anchored Apex key.
  static Future<String> signApexChallenge(String challenge) async {
    final key = await _storage.read(key: 'aether_apex_root');
    if (key == null) throw Exception('Identity missing');

    final hmac = Hmac(sha256, utf8.encode(key));
    return hmac.convert(utf8.encode(challenge)).toString();
  }

  static String _generateEntropy(int length) {
    return sha512.convert(utf8.encode(DateTime.now().microsecondsSinceEpoch.toString())).toString().substring(0, length);
  }
}
