import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import '../data/providers/shared_memory_provider.dart';
import '../domain/models/shared_memory_model.dart';

class SharedMemoryScreen extends ConsumerWidget {
  final String memoryId;
  const SharedMemoryScreen({super.key, required this.memoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final memoriesAsync = ref.watch(sharedMemoryListProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: memoriesAsync.when(
        data: (memories) {
          final memory = memories.firstWhereOrNull((m) => m.id == memoryId);
          if (memory == null)
            return const Center(child: Text("Memory not found"));

          return CustomScrollView(
            slivers: [
              _buildHeader(memory, tokens),
              SliverToBoxAdapter(
                child: _ContributorList(tokens: tokens),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = memory.timeline[index];
                      return _TimelineItem(
                        item: item,
                        tokens: tokens,
                        isLast: index == memory.timeline.length - 1,
                      );
                    },
                    childCount: memory.timeline.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Memory Sync Error: $err')),
      ),
    );
  }

  Widget _buildHeader(SharedMemory memory, MeropeColorTokens tokens) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: tokens.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          memory.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            MeropeImage(
              imageUrl: memory.coverUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [tokens.background, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContributorList extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _ContributorList({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 4,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: tokens.primary.withValues(alpha: 0.1),
            child: Text('${index + 1}',
                style: TextStyle(
                    color: tokens.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final SharedMemoryItem item;
  final MeropeColorTokens tokens;
  final bool isLast;

  const _TimelineItem({
    required this.item,
    required this.tokens,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(item.timestamp);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIndicator(),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.authorName,
                        style: TextStyle(
                            color: tokens.primary, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                            color: tokens.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.content,
                    style: TextStyle(color: tokens.textPrimary, fontSize: 15),
                  ),
                  if (item.mediaUrl != null) ...[
                    const SizedBox(height: 12),
                    MeropeImage(
                      imageUrl: item.mediaUrl,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(12),
                      enableViewer: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: tokens.primary,
            shape: BoxShape.circle,
            border: Border.all(color: tokens.background, width: 2),
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: tokens.primary.withValues(alpha: 0.2),
            ),
          ),
      ],
    );
  }
}
