import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'package:merope_ui/widgets/merope_button.dart';

class GrowthScreen extends ConsumerWidget {
  const GrowthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Growth & Resonance',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: tokens.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amplify the network, earn influence.',
                    style: TextStyle(color: tokens.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: MeropeCard(
                color: tokens.surface,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_graph, color: tokens.primary),
                          const SizedBox(width: 12),
                          Text('Viral Resonance Link',
                              style: TextStyle(
                                  color: tokens.textPrimary,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: tokens.background,
                          borderRadius:
                              BorderRadius.circular(MeropeTokens.radiusSm),
                          border: Border.all(color: tokens.border, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                                child: Text('merope.io/sync/invite/u_892k',
                                    style: TextStyle(color: Colors.white70))),
                            Icon(Icons.copy, color: tokens.primary, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      MeropeButton(
                        text: 'Share Resonance',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Influence Leaderboard',
                      style: TextStyle(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  const SizedBox(height: 16),
                  _LeaderboardTile(
                      rank: 1,
                      name: 'NeuralArch',
                      influence: 98.2,
                      tokens: tokens),
                  _LeaderboardTile(
                      rank: 2,
                      name: 'WaveRunner',
                      influence: 95.7,
                      tokens: tokens),
                  _LeaderboardTile(
                      rank: 3,
                      name: 'CyberRoot',
                      influence: 92.1,
                      tokens: tokens),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final double influence;
  final MeropeColorTokens tokens;

  const _LeaderboardTile(
      {required this.rank,
      required this.name,
      required this.influence,
      required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MeropeCard(
        color: tokens.surface,
        child: ListTile(
          leading: Text('#$rank',
              style: TextStyle(
                  color: tokens.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18)),
          title: Text(name,
              style: TextStyle(
                  color: tokens.textPrimary, fontWeight: FontWeight.bold)),
          subtitle: Text('Viral Multiplier: 1.${rank + 2}x',
              style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
          trailing: Text('${influence}k',
              style: TextStyle(
                  color: tokens.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
      ),
    );
  }
}
