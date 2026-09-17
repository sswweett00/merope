import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'widgets/escrow_payment_sheet.dart';
import 'package:merope_ui/utils/merope_haptics.dart';

import '../data/providers/marketplace_provider.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import 'package:merope_ui/widgets/universal_view_controls.dart';
import 'package:merope_ui/layouts/dynamic_layout_engine.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final prefs = ref.watch(viewPreferencesProvider)['market'] ??
        const ViewPreferences(mode: ViewMode.grid, activeFilter: 'All');

    final marketplaceAsync = ref.watch(marketplaceListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marketplace',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                _MarketplaceSearchBar(tokens: tokens),
              ],
            ),
          ),
          const UniversalViewControls(
            domain: 'market',
            filters: const [
              'All',
              'Hardware',
              'Software',
              'Digital',
              'Services'
            ],
          ),
          Expanded(
            child: marketplaceAsync.when(
              data: (products) {
                final filtered = products.where((p) {
                  if (prefs.activeFilter == 'All') return true;
                  return p.category == prefs.activeFilter;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                      child: Text('No items found',
                          style: TextStyle(color: tokens.textSecondary)));
                }

                return DynamicLayoutEngine(
                  items: filtered,
                  mode: prefs.mode,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (context, index, product) => _ProductCard(
                    id: product.id,
                    title: product.title,
                    price: product.price,
                    category: product.category,
                    rating: product.rating,
                    tokens: tokens,
                    isCompact: prefs.mode == ViewMode.compact,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Market Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketplaceSearchBar extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _MarketplaceSearchBar({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: tokens.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: TextStyle(color: tokens.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search the ecosystem...',
                hintStyle: TextStyle(color: tokens.textSecondary, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.filter_list, color: tokens.primary, size: 20),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  final String category;
  final double rating;
  final MeropeColorTokens tokens;
  final bool isCompact;

  const _ProductCard({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
    required this.tokens,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = 'product_$id';

    if (isCompact) {
      return ListTile(
        onTap: () => EscrowPaymentSheet.show(context,
            productId: id, title: title, price: price, tokens: tokens),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: heroTag,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tokens.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.shopping_bag_outlined,
                color: tokens.primary, size: 20),
          ),
        ),
        title: Text(title,
            style: TextStyle(
                color: tokens.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        subtitle: Text(category,
            style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
        trailing: Text(price,
            style:
                TextStyle(color: tokens.primary, fontWeight: FontWeight.bold)),
      );
    }

    return MeropeCard(
      color: tokens.surface,
      onTap: () => EscrowPaymentSheet.show(context,
          productId: id, title: title, price: price, tokens: tokens),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: heroTag,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: tokens.primary.withValues(alpha: 0.05),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(MeropeTokens.radiusMd)),
                    ),
                    child: Icon(Icons.shopping_bag_outlined,
                        color: tokens.primary, size: 40),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                              color: tokens.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              rating.toString(),
                              style: TextStyle(
                                  color: tokens.textSecondary, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                              color: tokens.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: tokens.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.favorite_border, size: 20),
              onPressed: () {
                MeropeHaptics.trigger(MeropeTokens.hapticLight);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites!')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
