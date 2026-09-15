import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/vault_models.dart';
import '../../data/providers/vault_provider.dart';

class SecretVaultList extends ConsumerWidget {
  const SecretVaultList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaultAsync = ref.watch(vaultContentProvider);

    return vaultAsync.when(
      data: (items) {
        final secrets = items.where((i) => i.type == VaultItemType.secret || i.type == VaultItemType.key).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: secrets.length,
          itemBuilder: (context, index) {
            final item = secrets[index];
            return ListTile(
              leading: Icon(
                item.type == VaultItemType.key ? Icons.vpn_key_outlined : Icons.visibility_off_outlined,
                color: const Color(0xFF5865F2),
              ),
              title: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(item.protection, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
              onTap: () {},
            );
          },
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (err, _) => Text('Error: $err'),
    );
  }
}
