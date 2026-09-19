import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/security/biometric_provider.dart';
import 'package:merope_core/data/services/api_client.dart';

enum EscrowStage { created, funded, shipped, delivered, completed }

class EscrowParty {
  final String id;
  final String name;
  final String role;
  final String? avatarUrl;
  EscrowParty(
      {required this.id,
      required this.name,
      required this.role,
      this.avatarUrl});
}

class EscrowItem {
  final String id;
  final String title;
  final double price;
  final String? imageUrl;
  EscrowItem(
      {required this.id,
      required this.title,
      required this.price,
      this.imageUrl});
}

class EscrowHistoryEntry {
  final String id;
  final String action;
  final String performedBy;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  EscrowHistoryEntry(
      {required this.id,
      required this.action,
      required this.performedBy,
      required this.timestamp,
      this.metadata});
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

  @override
  FutureOr<MeropeEscrow> build(String arg) async {
    if (_cache.containsKey(arg)) return _cache[arg]!;
    final escrow = await _fetchFromApi(arg);
    _cache[arg] = escrow;
    _listenWebSocket(arg);
    return escrow;
  }

  Future<MeropeEscrow> _fetchFromApi(String id) async {
    final result = await ApiClient().get<dynamic>('/finance/escrow/$id');
    if (result.isError || result.data is! Map) {
      throw StateError('Failed to load escrow');
    }
    final map = Map<String, dynamic>.from(result.data as Map);
    final status = (map['Status'] ?? map['status'] ?? 'held').toString().toLowerCase();
    final stage = switch (status) {
      'created' => EscrowStage.created,
      'funded' || 'held' => EscrowStage.funded,
      'shipped' => EscrowStage.shipped,
      'delivered' => EscrowStage.delivered,
      'completed' || 'released' => EscrowStage.completed,
      _ => EscrowStage.funded,
    };
    final amount = map['Amount'] ?? map['amount'] ?? 0;
    final created = DateTime.tryParse('${map['CreatedAt'] ?? map['createdAt'] ?? ''}') ?? DateTime.now();
    final updated = DateTime.tryParse('${map['UpdatedAt'] ?? map['updatedAt'] ?? ''}') ?? created;
    return MeropeEscrow(
      id: (map['ID'] ?? map['id'] ?? id).toString(),
      amount: '${amount ?? 0}',
      currency: (map['Currency'] ?? map['currency'] ?? 'MRO').toString(),
      seller: (map['SellerID'] ?? map['sellerId'] ?? '').toString(),
      description: (map['Description'] ?? map['description'] ?? '').toString(),
      status: status,
      stage: stage,
      createdAt: created,
      updatedAt: updated,
      parties: [
        EscrowParty(id: (map['BuyerID'] ?? map['buyerId'] ?? '').toString(), name: 'Buyer', role: 'buyer'),
        EscrowParty(id: (map['SellerID'] ?? map['sellerId'] ?? '').toString(), name: 'Seller', role: 'seller'),
      ],
      items: const [],
      historyLog: const [],
      autoReleaseAt: DateTime.tryParse('${map['ReleaseAt'] ?? map['releaseAt'] ?? ''}'),
      receiptUrl: null,
    );
  }

  Future<void> releasePayment() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    final biometric = ref.read(biometricAuthProvider.notifier);
    final authenticated =
        await biometric.authenticate(reason: 'Confirm escrow payment release');
    if (!authenticated) {
      state = AsyncValue.data(current);
      return;
    }
    final result = await ApiClient().post<dynamic>(
      '/finance/escrow/${current.id}/release',
    );
    if (result.isError) {
      state = AsyncValue.data(current);
      throw StateError('Failed to release escrow');
    }
    final updated = await _fetchFromApi(current.id);
    _cache[current.id] = updated;
    state = AsyncValue.data(updated);
  }

  Future<void> refundPayment() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    final result = await ApiClient().post<dynamic>(
      '/finance/escrow/${current.id}/refund',
    );
    if (result.isError) {
      state = AsyncValue.data(current);
      throw StateError('Failed to refund escrow');
    }
    final updated = await _fetchFromApi(current.id);
    _cache[current.id] = updated;
    state = AsyncValue.data(updated);
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
      historyLog: [
        ...current.historyLog,
        EscrowHistoryEntry(
            id: 'disp_${DateTime.now().millisecondsSinceEpoch}',
            action: 'disputed',
            performedBy: 'me',
            timestamp: DateTime.now(),
            metadata: {'reason': reason, 'evidence': evidenceUrl})
      ],
      disputeReason: reason,
      autoReleaseAt: current.autoReleaseAt,
      receiptUrl: current.receiptUrl,
    );
    _cache[current.id] = newEscrow;
    state = AsyncValue.data(newEscrow);
  }
}

final escrowDetailsProvider =
    AsyncNotifierProviderFamily<EscrowDetails, MeropeEscrow, String>(
        EscrowDetails.new);

final disputeFlowProvider =
    StateNotifierProviderFamily<DisputeFlowNotifier, String, String>(
        (ref, arg) {
  return DisputeFlowNotifier();
});

class DisputeFlowNotifier extends StateNotifier<String> {
  DisputeFlowNotifier() : super('');
  void setReason(String reason) => state = reason;
  void setEvidence(String url) => state = url;
  void reset() => state = '';
}
