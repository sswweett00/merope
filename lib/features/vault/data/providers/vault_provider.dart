import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/vault_models.dart';

class VaultContentNotifier extends AsyncNotifier<List<VaultItem>> {
  @override
  FutureOr<List<VaultItem>> build() async {
    // Simulated fetch from secure enclave
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      const VaultItem(
        id: 'f1',
        title: 'Project Merope Specs',
        type: VaultItemType.folder,
        protection: 'Biometric + RSA',
      ),
      const VaultItem(
        id: 'k1',
        title: 'Main API Key',
        type: VaultItemType.key,
        protection: 'Hardware Backed',
      ),
      const VaultItem(
        id: 's1',
        title: 'Master Recovery Phrase',
        type: VaultItemType.secret,
        protection: 'Deep Encryption',
      ),
    ];
  }
}

final vaultContentProvider =
    AsyncNotifierProvider<VaultContentNotifier, List<VaultItem>>(
        VaultContentNotifier.new);
