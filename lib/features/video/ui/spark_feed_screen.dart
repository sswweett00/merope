import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class SparkFeedScreen extends ConsumerStatefulWidget {
  const SparkFeedScreen({super.key});

  @override
  ConsumerState<SparkFeedScreen> createState() => _SparkFeedScreenState();
}

class _SparkFeedScreenState extends ConsumerState<SparkFeedScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> _sparks = [
    {
      'author': '@orbit_explorer',
      'caption': 'Merope Spark ile 60fps akıcı dikey yörünge! 🔥 #merope #spark #neural',
      'audioTag': 'Neural Pulse - Merope Original',
      'pulses': 15200,
      'echoes': 942,
      'isActivated': false,
    },
    {
      'author': '@dev_nexus',
      'caption': 'Nexus timelines üzerinde dikey veri senkronizasyonu testi. 🚀 #nexus #dev',
      'audioTag': 'Grid Rhythm - NodeBeats',
      'pulses': 9200,
      'echoes': 412,
      'isActivated': true,
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
        itemCount: _sparks.length,
        itemBuilder: (context, index) {
          final spark = _sparks[index];
          final isActivated = spark['isActivated'] as bool;

          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade900,
                      tokens.secondary.withValues(alpha: 0.2),
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.flash_on,
                    size: 90,
                    color: tokens.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
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
                          spark['author'] as String,
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
                            'Sync',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      spark['caption'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.blur_linear, color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            spark['audioTag'] as String,
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
              Positioned(
                right: 12,
                bottom: 40,
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isActivated ? Icons.favorite : Icons.favorite_border,
                        color: isActivated ? tokens.primary : Colors.white,
                        size: 34,
                      ),
                      onPressed: () {
                        setState(() {
                          spark['isActivated'] = !isActivated;
                          spark['pulses'] = (spark['pulses'] as int) + (isActivated ? -1 : 1);
                        });
                      },
                    ),
                    Text(
                      '${spark['pulses']}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: const Icon(Icons.bubble_chart, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                    Text(
                      '${spark['echoes']}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: const Icon(Icons.ios_share, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tokens.primary.withValues(alpha: 0.3),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.stream, color: tokens.primary, size: 28),
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
}
