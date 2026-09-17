import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../data/providers/orbit_provider.dart';
import '../widgets/merope_video_player.dart';

class OrbitStreamView extends ConsumerStatefulWidget {
  const OrbitStreamView({super.key});

  @override
  ConsumerState<OrbitStreamView> createState() => _OrbitStreamViewState();
}

class _OrbitStreamViewState extends ConsumerState<OrbitStreamView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initial prefetch for first items
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orbitFeedProvider.notifier).prefetch(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final feedAsync = ref.watch(orbitFeedProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: feedAsync.when(
        data: (videos) => PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          onPageChanged: (index) {
            ref.read(orbitFeedProvider.notifier).prefetch(index);
            setState(() => _currentIndex = index);
          },
          itemBuilder: (context, index) {
            return OrbitVideoItem(
              video: videos[index],
              tokens: tokens,
              isFocus: index == _currentIndex,
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
            child: Text('Error: $err',
                style: const TextStyle(color: Colors.white))),
      ),
    );
  }
}

class OrbitVideoItem extends ConsumerStatefulWidget {
  final OrbitVideo video;
  final MeropeColorTokens tokens;
  final bool isFocus;

  const OrbitVideoItem({
    super.key,
    required this.video,
    required this.tokens,
    this.isFocus = true,
  });

  @override
  ConsumerState<OrbitVideoItem> createState() => _OrbitVideoItemState();
}

class _OrbitVideoItemState extends ConsumerState<OrbitVideoItem> {
  bool _showHeart = false;
  Offset _heartPos = Offset.zero;
  double _volume = 0.5;
  double _brightness = 0.5;
  bool _showCaptions = true;
  bool _isFastForwarding = false;

  void _onDoubleTap(TapDownDetails details) {
    setState(() {
      _showHeart = true;
      _heartPos = details.localPosition;
    });
    if (!widget.video.isLiked) {
      ref.read(orbitFeedProvider.notifier).toggleLike(widget.video.id);
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  void _handleVerticalDrag(DragUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (details.localPosition.dx < screenWidth / 2) {
      // Left side: Brightness
      setState(() =>
          _brightness = (_brightness - details.delta.dy / 300).clamp(0.0, 1.0));
    } else {
      // Right side: Volume
      setState(
          () => _volume = (_volume - details.delta.dy / 300).clamp(0.0, 1.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _onDoubleTap,
      onVerticalDragUpdate: _handleVerticalDrag,
      onVerticalDragEnd: (details) {
        // Zenith: Swipe down to activate Mini-Player
        if (details.primaryVelocity != null &&
            details.primaryVelocity! > 1500) {
          ref.read(miniPlayerProvider.notifier).activate(widget.video);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Mini-Player Activated'),
                duration: Duration(seconds: 1)),
          );
        }
      },
      onLongPressStart: (_) => setState(() => _isFastForwarding = true),
      onLongPressEnd: (_) => setState(() => _isFastForwarding = false),
      child: Container(
        margin: widget.isFocus
            ? EdgeInsets.zero
            : const EdgeInsets.only(bottom: 16),
        height: widget.isFocus ? double.infinity : 400,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius:
              widget.isFocus ? BorderRadius.zero : BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // High-Performance Video Player
            Positioned.fill(
              child: MeropeVideoPlayer(
                videoId: widget.video.id,
                url: widget.video.videoUrl,
                autoPlay: widget.isFocus,
              ),
            ),
            // Brightness Overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                    color: Colors.black.withValues(alpha: 1.0 - _brightness)),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Auto-Captions
            if (_showCaptions && widget.isFocus)
              Positioned(
                bottom: 120,
                left: 40,
                right: 40,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text(
                    "AI Captions: Synchronizing neural frequency for global resonance...",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (_showHeart)
              Positioned(
                left: _heartPos.dx - 40,
                top: _heartPos.dy - 40,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, val, child) => Transform.scale(
                    scale: val * 1.5,
                    child: Opacity(
                      opacity: 1.0 - val,
                      child: const Icon(Icons.favorite,
                          color: Colors.white, size: 80),
                    ),
                  ),
                ),
              ),
            if (_isFastForwarding)
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fast_forward,
                            color: widget.tokens.primary, size: 16),
                        const SizedBox(width: 8),
                        const Text("2X RESONANCE",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            // Overlays
            Positioned(
              bottom: widget.isFocus ? 40 : 20,
              left: 16,
              right: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${widget.video.authorName}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.video.title,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: widget.isFocus ? 40 : 20,
              right: 16,
              child: Column(
                children: [
                  _SideAction(
                    icon: widget.video.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: '${widget.video.likes}',
                    color: widget.video.isLiked ? Colors.red : Colors.white,
                    onTap: () => ref
                        .read(orbitFeedProvider.notifier)
                        .toggleLike(widget.video.id),
                  ),
                  const SizedBox(height: 20),
                  _SideAction(
                    icon: Icons.chat_bubble_outline,
                    label: '45',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  _SideAction(
                    icon: Icons.repeat,
                    label: '${widget.video.echoes}',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  _SideAction(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SideAction({
    required this.icon,
    required this.label,
    this.color = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
