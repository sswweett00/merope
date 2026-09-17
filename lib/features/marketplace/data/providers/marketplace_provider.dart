import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeropeProduct {
  final String id;
  final String title;
  final String price;
  final String category;
  final double rating;
  final bool isAuction;
  final String? highestBid;

  MeropeProduct({
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
  @override
  FutureOr<List<MeropeProduct>> build() async {
    // Simulated API fetch
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      MeropeProduct(
        id: 'p1',
        title: 'Wave Runner Theme',
        price: '250 MRO',
        category: 'Digital',
        rating: 4.8,
      ),
      MeropeProduct(
        id: 'p2',
        title: 'API Access Key',
        price: '1.5k MRO',
        category: 'Services',
        rating: 4.9,
        isAuction: true,
        highestBid: '1.6k MRO',
      ),
      MeropeProduct(
        id: 'p3',
        title: 'Custom Engine Plugin',
        price: '5k MRO',
        category: 'Software',
        rating: 5.0,
      ),
      MeropeProduct(
        id: 'p4',
        title: 'Hardware Node v2',
        price: '120 MRO',
        category: 'Hardware',
        rating: 4.5,
      ),
    ];
  }

  Future<void> placeBid(String productId, String bidAmount) async {
    final previousState = state.value ?? [];
    state = AsyncValue.data(
      previousState.map((p) {
        if (p.id == productId) {
          return p.copyWith(highestBid: bidAmount);
        }
        return p;
      }).toList(),
    );
  }
}

final marketplaceListProvider =
    AsyncNotifierProvider<MarketplaceList, List<MeropeProduct>>(
        MarketplaceList.new);
