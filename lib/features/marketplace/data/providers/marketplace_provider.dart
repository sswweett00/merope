import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/api_client.dart';

class MeropeProduct {
  final String id;
  final String title;
  final String price;
  final String category;
  final double rating;
  final bool isAuction;
  final String? highestBid;

  const MeropeProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
    this.isAuction = false,
    this.highestBid,
  });

  MeropeProduct copyWith({String? highestBid}) {
    return MeropeProduct(
      id: id,
      title: title,
      price: price,
      category: category,
      rating: rating,
      isAuction: isAuction,
      highestBid: highestBid ?? this.highestBid,
    );
  }
}

class MarketplaceList extends AsyncNotifier<List<MeropeProduct>> {
  static final ApiClient _api = ApiClient();

  @override
  FutureOr<List<MeropeProduct>> build() => _load();

  Future<List<MeropeProduct>> _load({String? query}) async {
    final path = query == null || query.trim().isEmpty
        ? '/marketplace/products'
        : '/marketplace/products?q=${Uri.encodeQueryComponent(query.trim())}';
    final result = await _api.get<dynamic>(path);
    if (result.isError) {
      throw StateError(
          'Failed to load marketplace (${result.statusCode ?? 0})');
    }

    final payload = result.data;
    if (payload is! Map<String, dynamic>) {
      throw StateError('Invalid marketplace response');
    }

    final raw = payload['products'];
    if (raw is! List) return const <MeropeProduct>[];

    return raw
        .whereType<Map>()
        .map((entry) {
          final item = Map<String, dynamic>.from(entry);
          final rawPrice = item['price'];
          final rawRating = item['rating'];
          final price = rawPrice is num
              ? rawPrice.toString()
              : (rawPrice?.toString() ?? '0');
          final currency = (item['currency'] ?? 'MRO').toString();
          final rating = rawRating is num
              ? rawRating.toDouble()
              : (double.tryParse(rawRating?.toString() ?? '') ?? 0);

          return MeropeProduct(
            id: (item['id'] ?? '').toString(),
            title: (item['name'] ?? '').toString(),
            price: '$price $currency',
            category: (item['category'] ?? 'general').toString(),
            rating: rating,
            isAuction: false,
            highestBid: null,
          );
        })
        .where((product) => product.id.isNotEmpty)
        .toList(growable: false);
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(query: query));
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load());
  }

  Future<void> placeBid(String productId, String bidAmount) async {
    throw UnsupportedError(
      'Marketplace bidding is not exposed by the server contract yet.',
    );
  }
}

final marketplaceListProvider =
    AsyncNotifierProvider<MarketplaceList, List<MeropeProduct>>(
  MarketplaceList.new,
);
