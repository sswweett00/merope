import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoPoolManagerState {
  const VideoPoolManagerState();
}

class VideoPoolManagerNotifier extends StateNotifier<VideoPoolManagerState> {
  VideoPoolManagerNotifier() : super(const VideoPoolManagerState());

  // Returns a resource with a `player` field (pause/play/state/seek).
  // Typed as dynamic for compile-only stubs so callers' chained access compiles.
  dynamic getResourceForVideo(String videoId) => null;
}

final videoPoolProvider =
    StateNotifierProvider<VideoPoolManagerNotifier, VideoPoolManagerState>(
        (ref) {
  return VideoPoolManagerNotifier();
});
