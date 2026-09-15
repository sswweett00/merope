import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class SparkDiscoveryScreen extends ConsumerStatefulWidget {
  const SparkDiscoveryScreen({super.key});

  @override
  ConsumerState<SparkDiscoveryScreen> createState() => _SparkDiscoveryScreenState();
}

class _SparkDiscoveryScreenState extends ConsumerState<SparkDiscoveryScreen> {
  bool _isSearching = false;

  void _startMatching() {
    setState(() => _isSearching = true);
    // Simulate finding a match after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isSearching = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background - Search or Result
          Positioned.fill(
            child: _isSearching
              ? _buildSearchingView(tokens)
              : _buildMatchView(tokens),
          ),

          // Header
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MATCH',
                  style: TextStyle(
                    color: tokens.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: 4,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bolt, color: tokens.primary, size: 16),
                      const SizedBox(width: 4),
                      const Text('12 Tokens', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Controls
          if (!_isSearching)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SparkAction(
                    icon: Icons.close,
                    label: 'Skip',
                    color: Colors.red,
                    onTap: _startMatching,
                  ),
                  _SparkAction(
                    icon: Icons.flash_on,
                    label: 'Spark!',
                    color: tokens.primary,
                    onTap: () {},
                    isLarge: true,
                  ),
                  _SparkAction(
                    icon: Icons.chat_bubble,
                    label: 'Message',
                    color: Colors.blue,
                    onTap: () {},
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchingView(MeropeColorTokens tokens) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RippleAnimation(color: tokens.primary),
          const SizedBox(height: 40),
          const Text(
            'Searching for new connections...',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Text(
             'Finding your perfect match',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchView(MeropeColorTokens tokens) {
    return Stack(
      children: [
        Positioned.fill(
          child: MeropeImage(
            imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1964&auto=format&fit=crop',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Elena Wave, 24',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.verified, color: tokens.primary, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Digital Artist • Compatibility 98%',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _InterestTag(label: 'Digital Synthesis', tokens: tokens),
                  _InterestTag(label: 'Crypto Art', tokens: tokens),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SparkAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isLarge;

  const _SparkAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 80.0 : 64.0;
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            ),
            child: Icon(icon, color: color, size: size * 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _InterestTag extends StatelessWidget {
  final String label;
  final MeropeColorTokens tokens;

  const _InterestTag({required this.label, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: tokens.primary, fontSize: 12)),
    );
  }
}

class _RippleAnimation extends StatefulWidget {
  final Color color;
  const _RippleAnimation({required this.color});

  @override
  State<_RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<_RippleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...List.generate(3, (index) {
              final progress = (_controller.value + index / 3) % 1.0;
              return Container(
                width: 100 + progress * 200,
                height: 100 + progress * 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.color.withValues(alpha: 1.0 - progress), width: 2),
                ),
              );
            }),
            CircleAvatar(
              radius: 50,
              backgroundColor: widget.color,
              child: const Icon(Icons.flash_on, color: Colors.white, size: 40),
            ),
          ],
        );
      },
    );
  }
}
