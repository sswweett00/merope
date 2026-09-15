import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/widgets/merope_card.dart';

class SynergyHubScreen extends ConsumerWidget {
  const SynergyHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;

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
                  Text('Synergy Hub', style: TextStyle(color: tokens.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
                  Text('Global trending topics and synchronized nodes', style: TextStyle(color: tokens.textSecondary, fontSize: 14)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => MeropeCard(
                  color: tokens.surface,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon([Icons.bolt, Icons.language, Icons.palette, Icons.radar][index % 4], color: tokens.primary),
                      const SizedBox(height: 8),
                      Text(['#nirvana', '#distributed', '#merope', '#zenith'][index % 4],
                        style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold)),
                      Text('${(index + 1) * 12}k signals', style: TextStyle(color: tokens.textSecondary, fontSize: 10)),
                    ],
                  ),
                ),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
