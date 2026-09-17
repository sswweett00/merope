import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/media/audio_player_engine.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/now_playing_screen.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    if (playerState.currentTrack == null) {
      return const SizedBox.shrink();
    }

    final track = playerState.currentTrack!;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const NowPlayingScreen(),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: tokens.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
          border: Border.all(color: tokens.border.withValues(alpha: 0.3)),
          boxShadow: const [MeropeTokens.shadowMd],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
              child: Container(
                width: 44,
                height: 44,
                color: tokens.primary.withValues(alpha: 0.2),
                child: Icon(Icons.music_note, color: tokens.primary),
              ),
            ),
            const SizedBox(width: MeropeTokens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: tokens.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${track.artist} • ${track.album}',
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                playerState.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: tokens.primary,
                size: 32,
              ),
              onPressed: () {
                ref.read(audioPlayerProvider.notifier).togglePlayPause();
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_next, color: tokens.textPrimary),
              onPressed: () {
                ref.read(audioPlayerProvider.notifier).nextTrack();
              },
            ),
          ],
        ),
      ),
    );
  }
}
