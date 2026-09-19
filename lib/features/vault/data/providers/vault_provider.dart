import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/api_client.dart';
import '../../domain/models/vault_models.dart';
import '../../domain/models/vault_models.dart';

class VaultContentNotifier extends AsyncNotifier<List<VaultItem>> {
  static final ApiClient _api = ApiClient();

  @override
  FutureOr<List<VaultItem>> build() async {
    final result = await _api.get<dynamic>('/vault/items');
    if (result.isError) {
      throw StateError('Failed to load vault items');
    }
    final data = result.data;
    if (data is! Map) return const <VaultItem>[];
    final raw = data['items'];
    if (raw is! List) return const <VaultItem>[];
    return raw.whereType<Map>().map((entry) {
      final item = Map<String, dynamic>.from(entry);
      final itemType = (item['itemType'] ?? item['item_type'] ?? 'file').toString();
      return VaultItem(
        id: (item['id'] ?? '').toString(),
        title: (item['title'] ?? '').toString(),
        type: VaultItemType.values.firstWhere(
          (type) => type.name == itemType,
          orElse: () => VaultItemType.file,
        ),
        protection: item['protection']?.toString() ?? 'Encrypted',
        lastAccessed: DateTime.tryParse(
          item['updatedAt']?.toString() ?? item['updated_at']?.toString() ?? '',
        ),
      );
    }).where((item) => item.id.isNotEmpty).toList(growable: false);
  }
}

final vaultContentProvider =
    AsyncNotifierProvider<VaultContentNotifier, List<VaultItem>>(
        VaultContentNotifier.new);
