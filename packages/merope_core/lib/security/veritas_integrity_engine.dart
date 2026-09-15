import 'package:flutter_riverpod/flutter_riverpod.dart';

enum VeritasIntegrityState { unknown, verified, serverAuthoritative }

class VeritasIntegrityNotifier extends StateNotifier<VeritasIntegrityState> {
  VeritasIntegrityNotifier() : super(VeritasIntegrityState.serverAuthoritative);

  Future<void> refresh() async {
    // Client-side integrity is advisory only. Authoritative validation stays
    // on the Merope backend and is never replaced by a local trust decision.
    state = VeritasIntegrityState.serverAuthoritative;
  }
}

final veritasIntegrityProvider = StateNotifierProvider<VeritasIntegrityNotifier, VeritasIntegrityState>((ref) {
  return VeritasIntegrityNotifier();
});
