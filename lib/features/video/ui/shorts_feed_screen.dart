import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class ShortsFeedScreen extends ConsumerStatefulWidget {
  const ShortsFeedScreen({super.key});

  @override
  ConsumerState<ShortsFeedScreen> createState() => _ShortsFeedScreenState();
}

class _ShortsFeedScreenState extends ConsumerState<ShortsFeedScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> _shortsData = [
    {
      'author': '@cyber_creator',
      'caption': 'Merope Engine v1.0 ile 60fps dikey video performansı 🔥 #flutter #merope #cyber',
      'music': 'Cybernetic Beats - Merope Original',
      'likes': 14200,
      'comments': 842,
      'isLiked': false,
    },
    {
      'author': '@dev_expert',
      'caption': 'Tek tıkla e2ee şifreli dikey video yayını başlatma testi! 🚀 #security #crypto',
      'music': 'Decentralized Groove - CryptoBeats',
      'likes': 8920,
      'comments': 312,
      'isLiked': true,
    },
    {
      'author': '@design_pro',
      'caption': 'Merope Design Tokens ile cam (glassmorphism) efektli arayüzler ✨ #design',
      'music': 'Glassmorphism Theme Synth',
      'likes': 23400,
      'comments': 1205,
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _shortsData.length,
        itemBuilder: (context, index) {
          final item = _shortsData[index];
          final isLiked = item['isLiked'] as bool;

          return Stack(
            children: [
              // Simulated Fullscreen Video Container
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade900,
                      tokens.primary.withValues(alpha: 0.3),
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 90,
                    color: tokens.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              // Gradient Overlay at Bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Left Content (Author, Caption, Sound Tag)
              Positioned(
                left: 16,
                bottom: 24,
                right: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: tokens.primary,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item['author'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: tokens.primary,
                            borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
                          ),
                          child: const Text(
                            'Takip Et',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['caption'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.music_note, color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item['music'] as String,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Right Action Bar (Heart, Comment, Share, Spinning Sound Disk)
              Positioned(
                right: 12,
                bottom: 40,
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.redAccent : Colors.white,
                        size: 34,
                      ),
                      onPressed: () {
                        setState(() {
                          item['isLiked'] = !isLiked;
                          item['likes'] = (item['likes'] as int) + (isLiked ? -1 : 1);
                        });
                      },
                    ),
                    Text(
                      '${item['likes']}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 32),
                      onPressed: () {
                        _showCommentsModal(context, tokens);
                      },
                    ),
                    Text(
                      '${item['comments']}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 24),
                    // Vinyl Disk Placeholder
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.disc_full, color: tokens.primary, size: 28),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCommentsModal(BuildContext context, MeropeColorTokens tokens) {
    showModalBottomSheet(
      context: context,
      backgroundColor: tokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 400,
        child: Column(
          children: [
            Text(
              'Yorumlar (842)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: tokens.textPrimary),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tokens.primary,
                    child: Text('U$i', style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text('Kullanıcı #$i', style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold)),
                  subtitle: Text('Bu Merope Shorts harika olmuş!', style: TextStyle(color: tokens.textSecondary)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
