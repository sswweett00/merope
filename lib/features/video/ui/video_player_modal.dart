import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import '../widgets/merope_video_player.dart';
import '../logic/video_pool_manager.dart';

class VideoPlayerModal extends ConsumerStatefulWidget {
  final String title;
  final String videoId;
  final String videoUrl;
  final String category;

  const VideoPlayerModal({
    super.key,
    required this.title,
    required this.videoId,
    required this.videoUrl,
    required this.category,
  });

  @override
  ConsumerState<VideoPlayerModal> createState() => _VideoPlayerModalState();
}

class _VideoPlayerModalState extends ConsumerState<VideoPlayerModal> {
  bool _isPlaying = true;
  double _progress = 0.0;
  String _selectedQuality = '1080p 60fps';

  @override
  void initState() {
    super.initState();
    // Progress tracking could be added here by listening to the player from VideoPoolManager
  }

  void _togglePlay() {
    final resource = ref.read(videoPoolProvider.notifier).getResourceForVideo(widget.videoId);
    if (resource != null) {
      if (_isPlaying) {
        resource.player.pause();
      } else {
        resource.player.play();
      }
      setState(() => _isPlaying = !_isPlaying);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // High-Performance Video Surface
            Positioned.fill(
              child: MeropeVideoPlayer(
                videoId: widget.videoId,
                url: widget.videoUrl,
                autoPlay: true,
                fit: BoxFit.contain,
              ),
            ),
            // Top Bar Controls
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      dropdownColor: Colors.black87,
                      value: _selectedQuality,
                      underline: const SizedBox.shrink(),
                      icon: const Icon(Icons.high_quality, color: Colors.white),
                      items: ['4K UltraHD', '1080p 60fps', '720p', '480p']
                          .map((q) => DropdownMenuItem(value: q, child: Text(q, style: const TextStyle(color: Colors.white))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedQuality = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Controls Bar
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider(
                      value: _progress,
                      activeColor: tokens.primary,
                      inactiveColor: Colors.white24,
                      onChanged: (v) {
                        setState(() => _progress = v);
                        final resource = ref.read(videoPoolProvider.notifier).getResourceForVideo(widget.videoId);
                        if (resource != null) {
                          final duration = resource.player.state.duration;
                          resource.player.seek(duration * v);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                              onPressed: _togglePlay,
                            ),
                            const SizedBox(width: 8),
                            const Text('Live Stream', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(icon: const Icon(Icons.subtitles, color: Colors.white), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.volume_up, color: Colors.white), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.fullscreen, color: Colors.white), onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
