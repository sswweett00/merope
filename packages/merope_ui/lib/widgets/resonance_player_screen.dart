import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/media/audio_player_engine.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class ResonancePlayerScreen extends ConsumerWidget {
  const ResonancePlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    if (playerState.currentTrack == null) {
      return Scaffold(
        backgroundColor: tokens.background,
        body: const Center(child: Text('Resonans yok')),
      );
    }

    final wave = playerState.currentTrack!;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.expand_more, color: tokens.textPrimary, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'MEROPE RESONANCE',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: tokens.textSecondary,
              letterSpacing: 2.0),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
                boxShadow: const [MeropeTokens.shadowLg],
                gradient: LinearGradient(
                  colors: [tokens.secondary, tokens.primary],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child:
                  const Icon(Icons.vibration, size: 100, color: Colors.white),
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
                        wave.title,
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
                        '${wave.artist} • ${wave.album}',
                        style: TextStyle(
                            fontSize: 16, color: tokens.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon:
                      Icon(Icons.bubble_chart, color: tokens.primary, size: 28),
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
                IconButton(
                  icon: Icon(Icons.sync, color: tokens.textSecondary),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.fast_rewind,
                      color: tokens.textPrimary, size: 36),
                  onPressed: () {
                    ref.read(audioPlayerProvider.notifier).previousTrack();
                  },
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.primary,
                  ),
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
                  icon: Icon(Icons.fast_forward,
                      color: tokens.textPrimary, size: 36),
                  onPressed: () {
                    ref.read(audioPlayerProvider.notifier).nextTrack();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.repeat_one, color: tokens.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
            const Spacer(),
            ExpansionTile(
              title: Text('Neural Lyrics',
                  style: TextStyle(
                      color: tokens.primary, fontWeight: FontWeight.bold)),
              children: wave.lyrics
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
