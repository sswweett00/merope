import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/media/audio_player_engine.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';

class AudioHomeView extends ConsumerWidget {
  const AudioHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    final initialTracks = [
      const AudioTrackInfo(
        id: '1',
        title: 'Cybernetic Horizon',
        artist: 'Merope Soundscapes',
        album: 'Neon Pulse Vol. 1',
        coverUrl: '',
        audioUrl: 'https://example.com/track1.mp3',
        duration: Duration(minutes: 3, seconds: 45),
        lyrics: const [
          'Into the digital twilight...',
          'Signals echo in the code...',
          'Merope nodes standing strong.',
        ],
      ),
      const AudioTrackInfo(
        id: '2',
        title: 'Decentralized Rhythm',
        artist: 'CryptoBeats',
        album: 'Blockchain Grooves',
        coverUrl: '',
        audioUrl: 'https://example.com/track2.mp3',
        duration: Duration(minutes: 4, seconds: 12),
        lyrics: const [
          'Peer to peer connection established',
          'Feel the decentralized beat flow',
        ],
      ),
      const AudioTrackInfo(
        id: '3',
        title: 'Quantum Synthwaves',
        artist: 'Aetheria',
        album: 'Starlight Odyssey',
        coverUrl: '',
        audioUrl: 'https://example.com/track3.mp3',
        duration: Duration(minutes: 2, seconds: 58),
        lyrics: const [
          'Crossing galaxy corridors',
          'Beyond speed of light',
        ],
      ),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MeropeTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Merope Audio & Müzik',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: MeropeTokens.space16),
            // Featured Playlists Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildPlaylistTile(
                    'Haftalık Keşif', Icons.auto_awesome, tokens),
                _buildPlaylistTile('Odaklanma & Kodlama', Icons.code, tokens),
                _buildPlaylistTile('Popüler Podcasting', Icons.mic, tokens),
                _buildPlaylistTile(
                    'Top 50 Merope Hits', Icons.bar_chart, tokens),
              ],
            ),
            const SizedBox(height: MeropeTokens.space24),
            Text(
              'Sizin İçin Önerilen Parçalar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: MeropeTokens.space12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: initialTracks.length,
              itemBuilder: (context, index) {
                final track = initialTracks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: MeropeTokens.space8),
                  child: MeropeCard(
                    color: tokens.surface,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: tokens.primary,
                        child:
                            const Icon(Icons.music_note, color: Colors.white),
                      ),
                      title: Text(track.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tokens.textPrimary)),
                      subtitle: Text('${track.artist} • ${track.album}',
                          style: TextStyle(color: tokens.textSecondary)),
                      trailing: IconButton(
                        icon: Icon(Icons.play_circle_fill,
                            color: tokens.primary, size: 32),
                        onPressed: () {
                          ref
                              .read(audioPlayerProvider.notifier)
                              .playTrack(track);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistTile(
      String title, IconData icon, MeropeColorTokens tokens) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
        border: Border.all(color: tokens.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            decoration: BoxDecoration(
              color: tokens.primary.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(MeropeTokens.radiusSm)),
            ),
            child: Icon(icon, color: tokens.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: tokens.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
