import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';

import '../domain/models/vault_models.dart';
import '../data/providers/vault_provider.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

class _ZeroKnowledgeToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;
  final MeropeColorTokens tokens;

  const _ZeroKnowledgeToggle(
      {required this.isActive, required this.onChanged, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.enhanced_encryption, color: tokens.primary, size: 18),
              const SizedBox(width: 12),
              Text('Zero-Knowledge Mode',
                  style: TextStyle(
                      color: tokens.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Switch(
            value: isActive,
            onChanged: onChanged,
            activeThumbColor: tokens.primary,
          ),
        ],
      ),
    );
  }
}

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  bool _isUnlocked = false;
  bool _isZeroKnowledge = false;
  String? _currentPath;

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final vaultAsync = ref.watch(vaultContentProvider);

    if (!_isUnlocked) {
// ... existing locked state ...
    }

    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Folder',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: tokens.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                  if (_currentPath != null)
                    GestureDetector(
                      onTap: () => setState(() => _currentPath = null),
                      child: Row(
                        children: [
                          Icon(Icons.chevron_left,
                              size: 14, color: tokens.primary),
                          Text('Back to Root',
                              style: TextStyle(
                                  color: tokens.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: Icon(_isZeroKnowledge ? Icons.security : Icons.lock_reset,
                    color: _isZeroKnowledge
                        ? tokens.secondary
                        : tokens.textSecondary),
                onPressed: () {
                  MeropeHaptics.trigger(MeropeTokens.hapticSelection);
                  setState(() {
                    if (_isZeroKnowledge) {
                      _isZeroKnowledge = false;
                    } else {
                      _isUnlocked = false;
                      _currentPath = null;
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ZeroKnowledgeToggle(
            isActive: _isZeroKnowledge,
            onChanged: (val) {
              MeropeHaptics.trigger(MeropeTokens.hapticSelection);
              setState(() => _isZeroKnowledge = val);
            },
            tokens: tokens,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: vaultAsync.when(
              data: (items) {
                final displayItems = _currentPath == null
                    ? items
                    : items
                        .where((i) => i.type != VaultItemType.folder)
                        .toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: displayItems.length,
                  itemBuilder: (context, index) {
                    final item = displayItems[index];
                    IconData icon;
                    switch (item.type) {
                      case VaultItemType.folder:
                        icon = Icons.folder_outlined;
                        break;
                      case VaultItemType.key:
                        icon = Icons.vpn_key_outlined;
                        break;
                      case VaultItemType.secret:
                        icon = Icons.visibility_off_outlined;
                        break;
                      case VaultItemType.file:
                        icon = Icons.insert_drive_file_outlined;
                        break;
                    }

                    return MeropeCard(
                      color: tokens.surface,
                      onTap: () {
                        MeropeHaptics.trigger(MeropeTokens.hapticLight);
                        if (item.type == VaultItemType.folder) {
                          setState(() => _currentPath = item.title);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Decrypting ${item.title}...')));
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 32, color: tokens.primary),
                          const SizedBox(height: 12),
                          Text(
                            item.title,
                            style: TextStyle(
                                color: tokens.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            item.protection,
                            style: TextStyle(
                                color: tokens.textSecondary, fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Vault Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
