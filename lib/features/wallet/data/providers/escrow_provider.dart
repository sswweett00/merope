import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:merope_core/security/biometric_provider.dart';

enum EscrowStage { created, funded, shipped, delivered, completed }

class EscrowParty {
  final String id;
  final String name;
  final String role;
  final String? avatarUrl;
  EscrowParty({required this.id, required this.name, required this.role, this.avatarUrl});
}

class EscrowItem {
  final String id;
  final String title;
  final double price;
  final String? imageUrl;
  EscrowItem({required this.id, required this.title, required this.price, this.imageUrl});
}

class EscrowHistoryEntry {
  final String id;
  final String action;
  final String performedBy;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  EscrowHistoryEntry({required this.id, required this.action, required this.performedBy, required this.timestamp, this.metadata});
}

class MeropeEscrow {
  final String id;
  final String amount;
  final String currency;
  final String seller;
  final String description;
  final String status;
  final EscrowStage stage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<EscrowParty> parties;
  final List<EscrowItem> items;
  final List<EscrowHistoryEntry> historyLog;
  final String? disputeReason;
  final DateTime? autoReleaseAt;
  final String? receiptUrl;

  MeropeEscrow({
    required this.id,
    required this.amount,
    required this.currency,
    required this.seller,
    required this.description,
    required this.status,
    required this.stage,
    required this.createdAt,
    required this.updatedAt,
    required this.parties,
    required this.items,
    required this.historyLog,
    this.disputeReason,
    this.autoReleaseAt,
    this.receiptUrl,
  });
}

class EscrowDetails extends FamilyAsyncNotifier<MeropeEscrow, String> {
  final Map<String, MeropeEscrow> _cache = {};
  final Map<String, StreamController<MeropeEscrow>> _wsControllers = {};

  @override
  FutureOr<MeropeEscrow> build(String arg) async {
    if (_cache.containsKey(arg)) return _cache[arg]!;
    final escrow = await _fetchFromApi(arg);
    _cache[arg] = escrow;
    _listenWebSocket(arg);
    return escrow;
  }

  Future<MeropeEscrow> _fetchFromApi(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    return MeropeEscrow(
      id: id,
      amount: '250.00 MRO',
      currency: 'MRO',
      seller: 'CreativeNode_X',
      description: 'Digital Asset - Nebula Bundle',
      status: 'Held',
      stage: EscrowStage.funded,
      createdAt: now.subtract(const Duration(days: 2)),
      updatedAt: now,
      parties: [
        EscrowParty(id: 'me', name: 'CurrentUser', role: 'buyer'),
        EscrowParty(id: 'CreativeNode_X', name: 'CreativeNode_X', role: 'seller'),
      ],
      items: [EscrowItem(id: 'item_1', title: 'Nebula Bundle', price: 250.0, imageUrl: null)],
      historyLog: [
        EscrowHistoryEntry(id: 'h1', action: 'created', performedBy: 'me', timestamp: now.subtract(const Duration(days: 2))),
        EscrowHistoryEntry(id: 'h2', action: 'funded', performedBy: 'me', timestamp: now.subtract(const Duration(days: 1))),
      ],
      autoReleaseAt: now.add(const Duration(days: 7)),
      receiptUrl: null,
    );
  }

  void _listenWebSocket(String arg) {
    final wsUrl = const String.fromEnvironment('ESCROW_WS_URL', defaultValue: 'wss://api.merope.app/ws/escrow');
    final channel = WebSocketChannel.connect(Uri.parse('$wsUrl/$arg'));
    final controller = StreamController<MeropeEscrow>();
    _wsControllers[arg] = controller;
    channel.stream.listen(
      (data) {
        try {
          final updated = _cache[arg];
          if (updated != null) {
            final newEscrow = MeropeEscrow(
              id: updated.id,
              amount: updated.amount,
              currency: updated.currency,
              seller: updated.seller,
              description: updated.description,
              status: 'Updated',
              stage: updated.stage,
              createdAt: updated.createdAt,
              updatedAt: DateTime.now(),
              parties: updated.parties,
              items: updated.items,
              historyLog: [...updated.historyLog, EscrowHistoryEntry(id: 'ws_${DateTime.now().millisecondsSinceEpoch}', action: 'updated', performedBy: 'system', timestamp: DateTime.now())],
              disputeReason: updated.disputeReason,
              autoReleaseAt: updated.autoReleaseAt,
              receiptUrl: updated.receiptUrl,
            );
            _cache[arg] = newEscrow;
            controller.add(newEscrow);
          }
        } catch (_) {}
      },
      onError: (e) => controller.addError(e),
      onDone: () => controller.close(),
    );
  }

  Future<void> releasePayment() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    final biometric = ref.read(biometricAuthProvider.notifier);
    final authenticated = await biometric.authenticate(reason: 'Confirm escrow payment release');
    if (!authenticated) {
      state = AsyncValue.data(current);
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    final newEscrow = MeropeEscrow(
      id: current.id,
      amount: current.amount,
      currency: current.currency,
      seller: current.seller,
      description: current.description,
      status: 'Released',
      stage: EscrowStage.completed,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
      parties: current.parties,
      items: current.items,
      historyLog: [...current.historyLog, EscrowHistoryEntry(id: 'rel_${DateTime.now().millisecondsSinceEpoch}', action: 'released', performedBy: 'me', timestamp: DateTime.now())],
      disputeReason: current.disputeReason,
      autoReleaseAt: current.autoReleaseAt,
      receiptUrl: current.receiptUrl,
    );
    _cache[current.id] = newEscrow;
    state = AsyncValue.data(newEscrow);
  }

  Future<void> openDispute(String reason, {String? evidenceUrl}) async {
    final current = state.value;
    if (current == null) return;
    await Future.delayed(const Duration(milliseconds: 800));
    final newEscrow = MeropeEscrow(
      id: current.id,
      amount: current.amount,
      currency: current.currency,
      seller: current.seller,
      description: current.description,
      status: 'Disputed',
      stage: EscrowStage.funded,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
      parties: current.parties,
      items: current.items,
      historyLog: [...current.historyLog, EscrowHistoryEntry(id: 'disp_${DateTime.now().millisecondsSinceEpoch}', action: 'disputed', performedBy: 'me', timestamp: DateTime.now(), metadata: {'reason': reason, 'evidence': evidenceUrl})],
      disputeReason: reason,
      autoReleaseAt: current.autoReleaseAt,
      receiptUrl: current.receiptUrl,
    );
    _cache[current.id] = newEscrow;
    state = AsyncValue.data(newEscrow);
  }
}

final escrowDetailsProvider = AsyncNotifierProviderFamily<EscrowDetails, MeropeEscrow, String>(EscrowDetails.new);

final disputeFlowProvider = StateNotifierProviderFamily<DisputeFlowNotifier, String, String>((ref, arg) {
  return DisputeFlowNotifier();
});

class DisputeFlowNotifier extends StateNotifier<String> {
  DisputeFlowNotifier() : super('');
  void setReason(String reason) => state = reason;
  void setEvidence(String url) => state = url;
  void reset() => state = '';
}
