import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VeritasIntegrityNotifier extends StateNotifier<bool> {
  VeritasIntegrityNotifier() : super(true);

  String digest(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }

  bool verify({required String value, required String expectedDigest}) {
    final actual = digest(value);
    final valid = actual == expectedDigest.toLowerCase();
    state = valid;
    return valid;
  }

  void markHealthy() {
    state = true;
  }
}

final veritasIntegrityProvider =
    StateNotifierProvider<VeritasIntegrityNotifier, bool>(
  (ref) => VeritasIntegrityNotifier(),
);
