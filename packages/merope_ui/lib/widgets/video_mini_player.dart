import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/media/orbit_provider.dart';
import 'package:merope_ui/widgets/merope_video_player.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class VideoMiniPlayer extends ConsumerStatefulWidget {
  const VideoMiniPlayer({super.key});

  @override
  ConsumerState<VideoMiniPlayer> createState() => _VideoMiniPlayerState();
}

class _VideoMiniPlayerState extends ConsumerState<VideoMiniPlayer> {
  Offset _position = const Offset(20, 100);

  @override
  Widget build(BuildContext context) {
    final miniPlayer = ref.watch(miniPlayerProvider);
    if (!miniPlayer.isVisible || miniPlayer.activeVideo == null) {
      return const SizedBox.shrink();
    }

    final tokens = ref.watch(themeProvider).currentTokens;
    final video = miniPlayer.activeVideo!;

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Colors.black,
          child: Container(
            width: 160,
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(color: tokens.primary.withValues(alpha: 0.5), width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Real Video Player in Mini-View
                MeropeVideoPlayer(
                  videoId: 'mini_${video.id}',
                  url: video.videoUrl,
                  autoPlay: true,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => ref.read(miniPlayerProvider.notifier).dismiss(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '@${video.authorName}',
                        style: const TextStyle(color: Colors.white70, fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
