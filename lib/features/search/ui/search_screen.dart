import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import '../data/providers/search_provider.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import 'package:merope_ui/widgets/universal_view_controls.dart';
import 'package:merope_ui/layouts/dynamic_layout_engine.dart';
import 'widgets/nearby_radar.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final discoverAsync = ref.watch(searchDiscoverProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          _SearchHeader(tokens: tokens),
          SliverToBoxAdapter(
            child: UniversalViewControls(
              domain: 'search',
              filters: const ['All', 'Talent', 'Market', 'Cinema', 'Groups'],
            ),
          ),
          discoverAsync.when(
            data: (data) {
              final prefs = ref.watch(viewPreferencesProvider)['search'] ??
                  const ViewPreferences(
                      mode: ViewMode.list, activeFilter: 'All');

              return SliverPadding(
                padding: const EdgeInsets.all(MeropeTokens.space24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                          title: 'Find People Nearby', tokens: tokens),
                      const SizedBox(height: MeropeTokens.space24),
                      const NearbyRadar(),
                      const SizedBox(height: MeropeTokens.space32),
                      if ((data['trending'] as List).isNotEmpty) ...[
                        _SectionHeader(title: 'Trending Now', tokens: tokens),
                        const SizedBox(height: MeropeTokens.space12),
                        _TrendingList(
                            tags: List<TrendingSignal>.from(
                                data['trending'] as List),
                            tokens: tokens),
                        const SizedBox(height: MeropeTokens.space32),
                      ],
                      if ((data['history'] as List).isNotEmpty) ...[
                        _SectionHeader(title: 'Recent Searches', tokens: tokens),
                        const SizedBox(height: MeropeTokens.space12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (data['history'] as List)
                              .whereType<String>()
                              .take(8)
                              .map((query) => Chip(label: Text(query)))
                              .toList(growable: false),
                        ),
                        const SizedBox(height: MeropeTokens.space32),
                      ],
                      _SectionHeader(
                          title: 'Suggested for You', tokens: tokens),
                      const SizedBox(height: MeropeTokens.space12),
                      DynamicLayoutEngine<SuggestedNode>(
                        items:
                            List<SuggestedNode>.from(data['suggested'] as List),
                        mode: prefs.mode,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index, node) => _NodeTile(
                            node: node,
                            tokens: tokens,
                            isCompact: prefs.mode == ViewMode.compact),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator())),
            error: (err, _) => SliverFillRemaining(
                child: Center(child: Text('Discover Error: $err'))),
          ),
        ],
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _SearchHeader({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: tokens.background,
      elevation: 0,
      floating: true,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
          border: Border.all(color: tokens.border, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: tokens.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search the Merope Network...',
                  hintStyle: TextStyle(
                      color: tokens.textSecondary.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final MeropeColorTokens tokens;
  const _SectionHeader({required this.title, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: tokens.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }
}

class _TrendingList extends StatelessWidget {
  final List<TrendingSignal> tags;
  final MeropeColorTokens tokens;
  const _TrendingList({required this.tags, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          tags.map((tag) => _TagChip(tag: tag.tag, tokens: tokens)).toList(),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  final MeropeColorTokens tokens;
  const _TagChip({required this.tag, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(MeropeTokens.radiusFull),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Text(
        tag,
        style: TextStyle(
            color: tokens.primary, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class _NodeTile extends StatelessWidget {
  final SuggestedNode node;
  final MeropeColorTokens tokens;
  final bool isCompact;
  const _NodeTile(
      {required this.node, required this.tokens, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: tokens.primary.withValues(alpha: 0.1),
          child: Text(node.name[0],
              style: TextStyle(color: tokens.primary, fontSize: 10)),
        ),
        title: Text(node.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: tokens.textPrimary,
                fontSize: 13)),
        trailing: Text('Follow',
            style: TextStyle(
                color: tokens.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12)),
        onTap: () {},
      );
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MeropeCard(
        color: tokens.surface,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: tokens.primary.withValues(alpha: 0.1),
            child: Text(node.name[0], style: TextStyle(color: tokens.primary)),
          ),
          title: Text(node.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: tokens.textPrimary)),
          subtitle: Text('Neural Influence: ${node.influence}',
              style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
          trailing: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connection request sent!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: tokens.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MeropeTokens.radiusFull)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text('Follow'),
          ),
        ),
      ),
    );
  }
}
