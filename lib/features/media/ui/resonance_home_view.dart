import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/universal_view_controls.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import 'widgets/playlist_gallery.dart';

class ResonanceHomeView extends ConsumerWidget {
  const ResonanceHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final prefs = ref.watch(viewPreferencesProvider)['media'] ??
        const ViewPreferences(mode: ViewMode.grid, activeFilter: 'All');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _AppBar(tokens: tokens),
          UniversalViewControls(
            domain: 'media',
            filters: const ['All', 'Electronic', 'Ambient', 'Lofi', 'Techno'],
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (prefs.mode != ViewMode.compact)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Curated Playlists',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tokens.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: PlaylistGallery(),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding for mini player
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _AppBar({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 24, right: 24, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Resonance',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: tokens.textPrimary,
              letterSpacing: -1,
            ),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.cast, color: tokens.textSecondary), onPressed: () {}),
              IconButton(icon: Icon(Icons.search, color: tokens.textSecondary), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
