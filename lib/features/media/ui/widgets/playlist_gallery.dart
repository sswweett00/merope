import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/layouts/dynamic_layout_engine.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import '../../domain/models/media_models.dart';
import '../../logic/audio_player_provider.dart';

class PlaylistGallery extends ConsumerWidget {
  const PlaylistGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsProvider);
    final prefs = ref.watch(viewPreferencesProvider)['media'] ??
        const ViewPreferences(mode: ViewMode.grid, activeFilter: 'All');

    return playlistsAsync.when(
      data: (playlists) {
        if (playlists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.playlist_play,
                    size: 64, color: Colors.white.withValues(alpha: 0.2)),
                const SizedBox(height: 16),
                const Text(
                  'No playlists found',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return DynamicLayoutEngine<MeropePlaylist>(
          items: playlists,
          mode: prefs.mode,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index, playlist) => _PlaylistCard(
            playlist: playlist,
            isCompact: prefs.mode == ViewMode.compact,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  final MeropePlaylist playlist;
  final bool isCompact;

  const _PlaylistCard({required this.playlist, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return ListTile(
        leading: MeropeImage(
          imageUrl: playlist.coverUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(4),
        ),
        title: Text(playlist.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: const Text('Curated by Merope',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        onTap: () {},
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MeropeImage(
              imageUrl: playlist.coverUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(MeropeTokens.radiusMd)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Curated by Merope',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
