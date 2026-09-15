import 'package:flutter_riverpod/flutter_riverpod.dart';

class VeritasIntegrityState {
  const VeritasIntegrityState();
}

class VeritasIntegrityNotifier extends StateNotifier<VeritasIntegrityState> {
  VeritasIntegrityNotifier() : super(const VeritasIntegrityState());

  void signPost({
    required String userId,
    required String content,
    required List<String> mediaIds,
  }) {
    // Stub: integrity signing is a no-op for compile-only stubs.
  }
}

final veritasIntegrityProvider =
    StateNotifierProvider<VeritasIntegrityNotifier, VeritasIntegrityState>((ref) {
  return VeritasIntegrityNotifier();
});
