import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:merope_core/media/video_pool_manager.dart';

class MeropeVideoPlayer extends ConsumerStatefulWidget {
  final String videoId;
  final String url;
  final bool autoPlay;
  final bool loop;
  final BoxFit fit;
  final Widget? overlay;

  const MeropeVideoPlayer({
    super.key,
    required this.videoId,
    required this.url,
    this.autoPlay = false,
    this.loop = true,
    this.fit = BoxFit.cover,
    this.overlay,
  });

  @override
  ConsumerState<MeropeVideoPlayer> createState() => _MeropeVideoPlayerState();
}

class _MeropeVideoPlayerState extends ConsumerState<MeropeVideoPlayer> {
  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final resource = ref
          .read(videoPoolProvider.notifier)
          .acquire(widget.videoId, widget.url);
      if (widget.loop) {
        resource.player.setPlaylistMode(PlaylistMode.loop);
      }
      if (widget.autoPlay) {
        resource.player.play();
      }
    });
  }

  @override
  void didUpdateWidget(MeropeVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      _initPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    // We watch the provider to rebuild when pool state changes (though resource mapping is stable until eviction)
    ref.watch(videoPoolProvider);
    final resource = ref
        .read(videoPoolProvider.notifier)
        .getResourceForVideo(widget.videoId);

    if (resource == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Video(
            controller: resource.controller,
            fit: widget.fit,
            controls: NoVideoControls,
          ),
          if (widget.overlay != null) widget.overlay!,
        ],
      ),
    );
  }
}
