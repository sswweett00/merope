import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrbitVideo {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String authorName;
  final String title;
  final int likes;
  final int echoes;
  final bool isLiked;

  const OrbitVideo({
    required this.id,
    required this.videoUrl,
    this.thumbnailUrl = '',
    this.authorName = '',
    this.title = '',
    this.likes = 0,
    this.echoes = 0,
    this.isLiked = false,
  });
}

class OrbitFeedNotifier extends AsyncNotifier<List<OrbitVideo>> {
  @override
  Future<List<OrbitVideo>> build() async {
    return const [];
  }

  Future<void> prefetch(int index) async {}

  Future<void> toggleLike(String videoId) async {}
}

final orbitFeedProvider =
    AsyncNotifierProvider<OrbitFeedNotifier, List<OrbitVideo>>(
        OrbitFeedNotifier.new);

class MiniPlayerState {
  final OrbitVideo? activeVideo;

  const MiniPlayerState({this.activeVideo});
}

class MiniPlayerNotifier extends StateNotifier<MiniPlayerState> {
  MiniPlayerNotifier() : super(const MiniPlayerState());

  void activate(OrbitVideo video) {
    state = MiniPlayerState(activeVideo: video);
  }
}

final miniPlayerProvider =
    StateNotifierProvider<MiniPlayerNotifier, MiniPlayerState>((ref) {
  return MiniPlayerNotifier();
});
