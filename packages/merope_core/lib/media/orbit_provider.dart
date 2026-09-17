import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/media/video_pool_manager.dart';

class OrbitVideo {
  final String id;
  final String title;
  final String authorName;
  final String videoUrl;
  final String thumbnailUrl;
  final int likes;
  final int echoes;
  final bool isLiked;

  const OrbitVideo({
    required this.id,
    required this.title,
    required this.authorName,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.likes = 0,
    this.echoes = 0,
    this.isLiked = false,
  });

  OrbitVideo copyWith({
    String? id,
    String? title,
    String? authorName,
    String? videoUrl,
    String? thumbnailUrl,
    int? likes,
    int? echoes,
    bool? isLiked,
  }) {
    return OrbitVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      likes: likes ?? this.likes,
      echoes: echoes ?? this.echoes,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class OrbitFeed extends AsyncNotifier<List<OrbitVideo>> {
  @override
  FutureOr<List<OrbitVideo>> build() async {
    return [
      const OrbitVideo(
        id: 'v1',
        title: 'Neural Singularity: Phase 1',
        authorName: 'Merope Core',
        videoUrl:
            'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1614850523296-d8c1af93d400?q=80&w=2070&auto=format&fit=crop',
        likes: 12500,
        echoes: 450,
      ),
      const OrbitVideo(
        id: 'v2',
        title: 'Resonance Waves in Motion',
        authorName: 'WaveMaster',
        videoUrl:
            'https://test-videos.co.uk/vids/jellyfish/mp4/h264/720/Jellyfish_720_10s_1MB.mp4',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1964&auto=format&fit=crop',
        likes: 8400,
        echoes: 120,
      ),
    ];
  }

  void toggleLike(String videoId) {
    state.whenData((videos) {
      state = AsyncValue.data(videos.map((v) {
        if (v.id == videoId) {
          return v.copyWith(
            likes: v.isLiked ? v.likes - 1 : v.likes + 1,
            isLiked: !v.isLiked,
          );
        }
        return v;
      }).toList());
    });
  }

  void prefetch(int index) {
    state.whenData((videos) {
      final pool = ref.read(videoPoolProvider.notifier);

      // We want to keep: [index-1, index, index+1, index+2]
      final start = (index - 1).clamp(0, videos.length - 1);
      final end = (index + 2).clamp(0, videos.length - 1);

      final keepIds = <String>[];
      for (int i = start; i <= end; i++) {
        final v = videos[i];
        keepIds.add(v.id);
        pool.acquire(v.id, v.videoUrl);
      }

      pool.managePool(keepIds);
    });
  }
}

final orbitFeedProvider =
    AsyncNotifierProvider<OrbitFeed, List<OrbitVideo>>(OrbitFeed.new);

class MiniPlayerState {
  final OrbitVideo? activeVideo;
  final bool isVisible;

  const MiniPlayerState({this.activeVideo, this.isVisible = false});
}

class MiniPlayerNotifier extends Notifier<MiniPlayerState> {
  @override
  MiniPlayerState build() => const MiniPlayerState();

  void activate(OrbitVideo video) {
    state = MiniPlayerState(activeVideo: video, isVisible: true);
  }

  void dismiss() {
    state = const MiniPlayerState(isVisible: false);
  }
}

final miniPlayerProvider =
    NotifierProvider<MiniPlayerNotifier, MiniPlayerState>(
        MiniPlayerNotifier.new);
