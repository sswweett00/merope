import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CinemaVideo {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;
  final String views;
  final String timestamp;
  final bool isFeatured;

  CinemaVideo({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.views,
    required this.timestamp,
    this.isFeatured = false,
  });
}

class CinemaHub extends AsyncNotifier<List<CinemaVideo>> {
  @override
  FutureOr<List<CinemaVideo>> build() async {
    // Simulated API fetch
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      CinemaVideo(
        id: 'v1',
        title: 'The Future of Neural Networks in 2026',
        author: 'HyperWave Tech',
        thumbnailUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=2072&auto=format&fit=crop',
        views: '1.2M',
        timestamp: '2 days ago',
        isFeatured: true,
      ),
      CinemaVideo(
        id: 'v2',
        title: 'Node Architecture Deep Dive #1',
        author: 'Distributed Core',
        thumbnailUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=2070&auto=format&fit=crop',
        views: '45k',
        timestamp: '5 hours ago',
      ),
      CinemaVideo(
        id: 'v3',
        title: 'How to build a wave protocol in 10 minutes',
        author: 'Wave Academy',
        thumbnailUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=2070&auto=format&fit=crop',
        views: '890k',
        timestamp: '3 days ago',
      ),
    ];
  }
}

final cinemaHubProvider = AsyncNotifierProvider<CinemaHub, List<CinemaVideo>>(CinemaHub.new);
