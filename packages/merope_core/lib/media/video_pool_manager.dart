import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerResource {
  final Player player;
  final VideoController controller;
  String? currentVideoId;

  VideoPlayerResource({
    required this.player,
    required this.controller,
  });

  void dispose() {
    player.dispose();
  }
}

class VideoPoolManager extends Notifier<void> {
  static const int poolSize = 4; // Increased for prefetching (prev, current, next, next+1)
  late final List<VideoPlayerResource> _resources;

  @override
  void build() {
    _resources = List.generate(poolSize, (index) {
      final player = Player(
        configuration: const PlayerConfiguration(
          bufferSize: 1024 * 1024 * 32, // 32MB buffer
        ),
      );
      return VideoPlayerResource(
        player: player,
        controller: VideoController(player),
      );
    });

    ref.onDispose(() {
      for (var resource in _resources) {
        resource.dispose();
      }
    });
  }

  VideoPlayerResource? getResourceForVideo(String videoId) {
    for (final resource in _resources) {
      if (resource.currentVideoId == videoId) return resource;
    }
    return null;
  }

  VideoPlayerResource acquire(String videoId, String url) {
    final existing = getResourceForVideo(videoId);
    if (existing != null) return existing;

    // Find an idle resource
    for (final resource in _resources) {
      if (resource.currentVideoId == null) {
        resource.currentVideoId = videoId;
        resource.player.open(Media(url), play: false);
        return resource;
      }
    }

    // Eviction: In a real Orbit feed, we'd evict the resource furthest from current index.
    // For now, we reuse the first resource as a fallback.
    final resource = _resources.first;
    resource.player.stop();
    resource.currentVideoId = videoId;
    resource.player.open(Media(url), play: false);
    return resource;
  }

  void release(String videoId) {
    final resource = getResourceForVideo(videoId);
    if (resource != null) {
      resource.player.stop();
      resource.currentVideoId = null;
    }
  }

  /// Releases all resources that are not in the provided [keepVideoIds] list.
  void managePool(List<String> keepVideoIds) {
    for (final resource in _resources) {
      if (resource.currentVideoId != null && !keepVideoIds.contains(resource.currentVideoId)) {
        resource.player.stop();
        resource.currentVideoId = null;
      }
    }
  }
}

final videoPoolProvider = NotifierProvider<VideoPoolManager, void>(VideoPoolManager.new);
