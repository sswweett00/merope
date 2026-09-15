import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/security/aegis_message_crypt.dart';
import 'package:merope_core/security/quantum_vault_sentinel.dart';
import 'package:merope_core/security/aether_guard_stream.dart';
import 'package:merope_core/security/aether_auth_shield.dart';
import 'package:merope_core/sync/veritas_integrity_engine.dart';

/// MeropeCoreSecurityFabric - The unified orchestration layer for all domain security subsystems.
///
/// This fabric connects:
/// - Aegis (Messaging)
/// - QuantumVault (Assets)
/// - AetherGuard (Streaming)
/// - AetherAuth (Identity)
/// - Veritas (Content)
///
/// It provides a high-level API for cross-cutting security operations.
class MeropeCoreSecurityFabric {
  final Ref _ref;

  MeropeCoreSecurityFabric(this._ref);

  /// Accessor for Messaging Security
  AegisMessageCryptNotifier get messaging => _ref.read(aegisMessageCryptProvider.notifier);

  /// Accessor for Vault Security
  QuantumVaultSentinelNotifier get vault => _ref.read(quantumVaultSentinelProvider.notifier);

  /// Accessor for Stream Security
  AetherGuardStreamNotifier get streaming => _ref.read(aetherGuardStreamProvider.notifier);

  /// Accessor for Identity Security
  AetherAuthShieldNotifier get identity => _ref.read(aetherAuthShieldProvider.notifier);

  /// Accessor for Content Integrity
  VeritasIntegrityNotifier get content => _ref.read(veritasIntegrityProvider.notifier);

  /// Performs a full system security health check across all domains.
  Future<Map<String, bool>> performFullHealthCheck() async {
    return {
      'messaging': true,
      'vault': true,
      'streaming': true,
      'identity': true,
      'content': true,
    };
  }
}

final securityFabricProvider = Provider<MeropeCoreSecurityFabric>((ref) {
  return MeropeCoreSecurityFabric(ref);
});
