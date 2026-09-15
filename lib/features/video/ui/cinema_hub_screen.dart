import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

import '../data/providers/cinema_provider.dart';

class CinemaHubScreen extends ConsumerWidget {
  const CinemaHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final cinemaAsync = ref.watch(cinemaHubProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cinema',
          style: TextStyle(
            color: tokens.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: -1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.high_quality_outlined, color: tokens.primary),
            onPressed: () => _showQualitySwitcher(context, tokens),
          ),
          IconButton(icon: Icon(Icons.cast, color: tokens.textSecondary), onPressed: () {}),
          IconButton(icon: Icon(Icons.search, color: tokens.textSecondary), onPressed: () {}),
        ],
      ),
      body: cinemaAsync.when(
        data: (videos) {
          if (videos.isEmpty) return const Center(child: Text('No videos found'));

          final featured = videos.firstWhereOrNull((v) => v.isFeatured) ?? videos.first;
          final others = videos.where((v) => !v.isFeatured).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _buildFeaturedVideo(tokens, featured),
              const SizedBox(height: 24),
              _buildSectionHeader('Trending Now', tokens),
              _buildHorizontalVideoList(tokens, others),
              const SizedBox(height: 24),
              _buildSectionHeader('Popular Creators', tokens),
              _buildVerticalVideoList(tokens, others),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showQualitySwitcher(BuildContext context, MeropeColorTokens tokens) {
    showModalBottomSheet(
      context: context,
      backgroundColor: tokens.surface,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Auto (Adaptive)'), leading: Icon(Icons.bolt, color: tokens.primary), onTap: () => Navigator.pop(context)),
          ListTile(title: const Text('4K (Spatial)'), leading: const Icon(Icons.hd), onTap: () => Navigator.pop(context)),
          ListTile(title: const Text('1080p'), leading: const Icon(Icons.high_quality), onTap: () => Navigator.pop(context)),
          ListTile(title: const Text('720p (Data Saver)'), leading: const Icon(Icons.sd), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildFeaturedVideo(MeropeColorTokens tokens, CinemaVideo video) {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
        child: Stack(
          children: [
            Positioned.fill(
              child: MeropeImage(
                imageUrl: video.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: tokens.primary, borderRadius: BorderRadius.circular(4)),
                  child: const Text('FEATURED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text(
                  video.title,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _ChapterProgressBar(tokens: tokens),
                const SizedBox(height: 8),
                Text('${video.author} • ${video.views} Views', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: tokens.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          Text('See All', style: TextStyle(color: tokens.primary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildHorizontalVideoList(MeropeColorTokens tokens, List<CinemaVideo> videos) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MeropeImage(
                  imageUrl: video.thumbnailUrl,
                  height: 110,
                  width: 200,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 8),
                Text(
                  video.title,
                  style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('${video.author} • ${video.views} Views', style: TextStyle(color: tokens.textSecondary, fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalVideoList(MeropeColorTokens tokens, List<CinemaVideo> videos) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MeropeImage(
                imageUrl: video.thumbnailUrl,
                width: 160,
                height: 90,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text('${video.author} • ${video.views} Views • ${video.timestamp}', style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChapterProgressBar extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _ChapterProgressBar({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(3, (i) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: i == 0 ? tokens.primary : Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('04:12', style: TextStyle(color: Colors.white70, fontSize: 9)),
            Text('CH 1: NEURAL ORIGINS', style: TextStyle(color: tokens.primary, fontSize: 9, fontWeight: FontWeight.bold)),
            const Text('12:00', style: TextStyle(color: Colors.white70, fontSize: 9)),
          ],
        ),
      ],
    );
  }
}
