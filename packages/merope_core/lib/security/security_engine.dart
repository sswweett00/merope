import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:argon2/argon2.dart';
import 'package:crypto/crypto.dart';

class SecurityEngine {
  static Future<String> hashPasswordArgon2id({
    required String password,
    required String salt,
  }) async {
    return Isolate.run(() => _computeHash(password, salt));
  }

  static String _computeHash(String password, String salt) {
    final combined = '$password:$salt';
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      Uint8List.fromList(salt.codeUnits),
      version: Argon2Parameters.ARGON2_VERSION_13,
      iterations: 3,
      memoryPowerOf2: 12,
    );

    final argon2 = Argon2BytesGenerator();
    argon2.init(parameters);

    final result = Uint8List(32);
    argon2.generateBytes(Uint8List.fromList(combined.codeUnits), result, 0, result.length);

    return base64Encode(result);
  }

  static String calculateSHA256(List<int> bytes) {
    return sha256.convert(bytes).toString();
  }
}
