import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'package:merope_ui/widgets/merope_button.dart';
import 'video_player_modal.dart';

class OrbitStreamView extends ConsumerWidget {
  const OrbitStreamView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    final categories = [
      {'title': 'Trend Orbitleri', 'count': 6},
      {'title': 'Merope Orijinal Akışları', 'count': 5},
      {'title': 'Sibernetik Frekanslar', 'count': 4},
      {'title': 'Global Senkronizasyon', 'count': 4},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MeropeTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Featured Orbit Banner
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
                gradient: LinearGradient(
                  colors: [tokens.primary, tokens.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [MeropeTokens.shadowLg],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: tokens.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'MEROPE ORBIT EXCLUSIVE',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Merope: The Neural Singularity',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: tokens.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Merope Orbit ağı üzerinde çalışan hibrit video mimarisi.',
                          style: TextStyle(color: tokens.onPrimary.withValues(alpha: 0.85)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            MeropeButton(
                              text: 'Akışı Başlat',
                              icon: Icons.play_arrow,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => VideoPlayerModal(
                                    title: 'Merope: Neural Singularity',
                                    videoId: '',
                                    videoUrl: '',
                                    category: 'Exclusive Orbit',
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            MeropeButton(
                              text: '+ Orbit Listeme Ekle',
                              style: MeropeButtonStyle.secondary,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Yörüngemize eklendi!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: MeropeTokens.space32),
            // Video Rows by Category
            ...categories.map((cat) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cat['title'] as String,
                      style: TextStyle(
                        fontSize: MeropeTokens.fontSizeLg,
                        fontWeight: FontWeight.bold,
                        color: tokens.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Tümünü Gör', style: TextStyle(color: tokens.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: MeropeTokens.space12),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cat['count'] as int,
                    itemBuilder: (context, idx) {
                      final videoTitle = '${cat['title']} - Bölüm ${idx + 1}';
                      return Container(
                        width: 220,
                        margin: const EdgeInsets.only(right: MeropeTokens.space16),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => VideoPlayerModal(
                                title: videoTitle,
                                videoId: '',
                                videoUrl: '',
                                category: cat['title'] as String,
                              ),
                            );
                          },
                          child: MeropeCard(
                            color: tokens.surface,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: tokens.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
                                    ),
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor: tokens.primary,
                                        child: const Icon(Icons.play_arrow, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  videoTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: tokens.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '4K UltraHD • 12.4K İzlenme',
                                  style: TextStyle(fontSize: 11, color: tokens.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: MeropeTokens.space24),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
