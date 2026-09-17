import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/orbit_provider.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import 'package:merope_ui/widgets/universal_view_controls.dart';
import 'package:merope_ui/layouts/dynamic_layout_engine.dart';
import 'orbit_stream_view.dart';
import 'spark_discovery_screen.dart';

class OrbitScreen extends ConsumerStatefulWidget {
  const OrbitScreen({super.key});

  @override
  ConsumerState<OrbitScreen> createState() => _OrbitScreenState();
}

class _OrbitScreenState extends ConsumerState<OrbitScreen> {
  int _viewMode = 0; // 0: Clips, 1: Match

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final prefs = ref.watch(viewPreferencesProvider)['orbit'] ??
        const ViewPreferences(mode: ViewMode.focus, activeFilter: 'All');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _viewMode == 0
                ? _buildClipsContent(prefs, tokens)
                : const SparkDiscoveryScreen(),
          ),
          if (prefs.mode != ViewMode.focus || _viewMode == 1)
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ToggleButton(
                        label: 'CLIPS',
                        isSelected: _viewMode == 0,
                        onTap: () => setState(() => _viewMode = 0),
                        tokens: tokens,
                      ),
                      _ToggleButton(
                        label: 'MATCH',
                        isSelected: _viewMode == 1,
                        onTap: () => setState(() => _viewMode = 1),
                        tokens: tokens,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_viewMode == 0)
            Positioned(
              top: prefs.mode == ViewMode.focus ? 100 : 120,
              left: 0,
              right: 0,
              child: UniversalViewControls(
                domain: 'orbit',
                filters: const ['All', 'Tech', 'Art', 'Gaming', 'Life'],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClipsContent(ViewPreferences prefs, MeropeColorTokens tokens) {
    if (prefs.mode == ViewMode.focus) {
      return const OrbitStreamView();
    }

    final feedAsync = ref.watch(orbitFeedProvider);

    return feedAsync.when(
      data: (videos) {
        final filtered = videos.where((v) {
          if (prefs.activeFilter == 'All') return true;
          return v.title
              .contains(prefs.activeFilter); // Simplified matching for mock
        }).toList();

        if (filtered.isEmpty) {
          return const Center(
              child: Text('No clips found',
                  style: TextStyle(color: Colors.white70)));
        }

        return DynamicLayoutEngine(
          items: filtered,
          mode: prefs.mode,
          padding: prefs.mode == ViewMode.focus
              ? EdgeInsets.zero
              : const EdgeInsets.only(top: 200, left: 16, right: 16),
          itemBuilder: (context, index, video) {
            if (prefs.mode == ViewMode.grid || prefs.mode == ViewMode.masonry) {
              return _VideoPreviewCard(video: video, tokens: tokens);
            }
            return OrbitVideoItem(
                video: video,
                tokens: tokens,
                isFocus: prefs.mode == ViewMode.focus);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
          child:
              Text('Error: $err', style: const TextStyle(color: Colors.white))),
    );
  }
}

class _VideoPreviewCard extends StatelessWidget {
  final OrbitVideo video;
  final MeropeColorTokens tokens;
  const _VideoPreviewCard({required this.video, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MeropeImage(
            imageUrl: video.thumbnailUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Text('@${video.authorName}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
          const Center(
              child: Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 32)),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final MeropeColorTokens tokens;

  const _ToggleButton(
      {required this.label,
      required this.isSelected,
      required this.onTap,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? tokens.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
