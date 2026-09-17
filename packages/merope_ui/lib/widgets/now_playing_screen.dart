import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/media/audio_player_engine.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class _NeuralWaveVisualizer extends StatelessWidget {
  const _NeuralWaveVisualizer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(32, (i) => _WaveBar(index: i)),
      ),
    );
  }
}

class _WaveBar extends StatefulWidget {
  final int index;
  const _WaveBar({required this.index});

  @override
  State<_WaveBar> createState() => _WaveBarState();
}

class _WaveBarState extends State<_WaveBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final duration = Duration(milliseconds: 300 + (widget.index % 8) * 150);
    _controller = AnimationController(vsync: this, duration: duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final height =
            10 + (_controller.value * (40 + (widget.index % 5) * 20));
        return Container(
          width: 3,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.4),
                Colors.white.withValues(alpha: 0.1)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      },
    );
  }
}

class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    if (playerState.currentTrack == null) {
      return Scaffold(
        backgroundColor: tokens.background,
        body: const Center(child: Text('Çalan parça yok')),
      );
    }

    final track = playerState.currentTrack!;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down,
              color: tokens.textPrimary, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'MEROPE AUDIO PLAYER',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: tokens.textSecondary,
              letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
                    boxShadow: const [MeropeTokens.shadowLg],
                    gradient: LinearGradient(
                      colors: [tokens.primary, tokens.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.graphic_eq,
                      size: 100, color: Colors.white),
                ),
                if (playerState.isPlaying) const _NeuralWaveVisualizer(),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: tokens.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${track.artist} • ${track.album}',
                        style: TextStyle(
                            fontSize: 16, color: tokens.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: tokens.primary, size: 28),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Slider(
              value: playerState.position.inSeconds
                  .toDouble()
                  .clamp(0, playerState.duration.inSeconds.toDouble()),
              max: playerState.duration.inSeconds > 0
                  ? playerState.duration.inSeconds.toDouble()
                  : 100,
              activeColor: tokens.primary,
              inactiveColor: tokens.border,
              onChanged: (val) {
                ref
                    .read(audioPlayerProvider.notifier)
                    .seek(Duration(seconds: val.toInt()));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${playerState.position.inMinutes}:${(playerState.position.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: tokens.textSecondary, fontSize: 12),
                ),
                Text(
                  '${playerState.duration.inMinutes}:${(playerState.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: tokens.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ControlLabel(label: '1.0x', tokens: tokens, onTap: () {}),
                IconButton(
                  icon: const Icon(Icons.replay_10_rounded),
                  color: tokens.textPrimary,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.skip_previous,
                      color: tokens.textPrimary, size: 36),
                  onPressed: () {
                    ref.read(audioPlayerProvider.notifier).previousTrack();
                  },
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: tokens.primary,
                  child: IconButton(
                    icon: Icon(
                      playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: () {
                      ref.read(audioPlayerProvider.notifier).togglePlayPause();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next,
                      color: tokens.textPrimary, size: 36),
                  onPressed: () {
                    ref.read(audioPlayerProvider.notifier).nextTrack();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.forward_30_rounded),
                  color: tokens.textPrimary,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.repeat, color: tokens.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
            const Spacer(),
            ExpansionTile(
              title: Text('Şarkı Sözleri (Lyrics)',
                  style: TextStyle(
                      color: tokens.primary, fontWeight: FontWeight.bold)),
              children: track.lyrics
                  .map(
                    (line) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(line,
                          style: TextStyle(
                              color: tokens.textPrimary, fontSize: 14)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ControlLabel extends StatelessWidget {
  final String label;
  final MeropeColorTokens tokens;
  final VoidCallback onTap;
  const _ControlLabel(
      {required this.label, required this.tokens, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label,
          style: TextStyle(
              color: tokens.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }
}
