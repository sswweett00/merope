import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import 'widgets/neural_map_painter.dart';
import '../logic/community_logic.dart';
import '../data/providers/community_provider.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import 'package:merope_ui/widgets/universal_view_controls.dart';
import 'package:merope_ui/layouts/dynamic_layout_engine.dart';
import '../../../features/community/domain/models/community_model.dart';

class SynergyCollectiveScreen extends ConsumerStatefulWidget {
  const SynergyCollectiveScreen({super.key});

  @override
  ConsumerState<SynergyCollectiveScreen> createState() => _SynergyCollectiveScreenState();
}

class _SynergyCollectiveScreenState extends ConsumerState<SynergyCollectiveScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final collectivesAsync = ref.watch(collectiveListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: collectivesAsync.when(
              data: (collectives) => _NeuralMapHeader(
                controller: _controller,
                tokens: tokens,
                nodes: collectives.take(6).map((c) {
                  final hash = c.id.hashCode;
                  return NeuralNode(
                    id: c.id,
                    label: c.name,
                    x: (hash % 80) / 100 + 0.1,
                    y: ((hash ~/ 100) % 80) / 100 + 0.1,
                    radius: 10.0 + (c.memberCount % 10),
                    color: tokens.primary,
                  );
                }).toList(),
              ),
              loading: () => const SizedBox(height: 300),
              error: (_, __) => const SizedBox(height: 300),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Communities',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: tokens.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Join and discuss with like-minded people.',
                    style: TextStyle(color: tokens.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          collectivesAsync.when(
            data: (collectives) {
              final prefs = ref.watch(viewPreferencesProvider)['collectives'] ??
                  const ViewPreferences(mode: ViewMode.list, activeFilter: 'All');

              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    UniversalViewControls(
                      domain: 'collectives',
                      filters: const ['All', 'Technology', 'Creative', 'Social'],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: DynamicLayoutEngine(
                        items: collectives,
                        mode: prefs.mode,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index, c) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _CollectiveCard(
                              name: c.name,
                              nodes: '${(c.memberCount / 1000).toStringAsFixed(1)}k',
                              description: c.description,
                              icon: Icons.hub,
                              tokens: tokens,
                              isCompact: prefs.mode == ViewMode.compact,
                              role: c.userRole,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (err, _) => SliverToBoxAdapter(child: Center(child: Text('Collectives Error: $err'))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final nameController = TextEditingController();
          final descriptionController = TextEditingController();
          final categoryController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create Collective'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      final collective = Collective(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text,
                        description: descriptionController.text,
                        category: categoryController.text,
                        memberCount: 0,
                        influence: 0.0,
                        isOfficial: false,
                        icon: '',
                        slug: nameController.text.toLowerCase().replaceAll(' ', '-'),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        stats: const CollectiveStats(totalThreads: 0, totalReplies: 0, weeklyActivity: 0),
                      );
                      ref.read(collectiveControllerProvider.notifier).createCollective(collective);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          );
        },
        label: const Text('Create Collective', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: tokens.primary,
      ),
    );
  }
}

class _NeuralMapHeader extends StatelessWidget {
  final AnimationController controller;
  final MeropeColorTokens tokens;
  final List<NeuralNode> nodes;

  const _NeuralMapHeader({
    required this.controller,
    required this.tokens,
    required this.nodes,
  });

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: tokens.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
        border: Border.all(color: tokens.border.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MeropeTokens.radiusLg),
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return CustomPaint(
                painter: NeuralMapPainter(nodes: nodes, animationValue: controller.value),
                isComplex: true,
                willChange: true,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CollectiveCard extends StatelessWidget {
  final String name;
  final String nodes;
  final String description;
  final IconData icon;
  final MeropeColorTokens tokens;
  final bool isCompact;
  final CommunityRole role;

  const _CollectiveCard({
    required this.name,
    required this.nodes,
    required this.description,
    required this.icon,
    required this.tokens,
    this.isCompact = false,
    this.role = CommunityRole.member,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: tokens.primary),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: tokens.textPrimary)),
        subtitle: Text(nodes, style: TextStyle(color: tokens.textSecondary, fontSize: 12)),
        trailing: _buildRoleChip(),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing $name')),
          );
        },
      );
    }
    return MeropeCard(
      color: tokens.surface,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tokens.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
              ),
              child: Icon(icon, color: tokens.primary, size: 28),
            ),
            title: Row(
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: tokens.textPrimary, fontSize: 18)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: tokens.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(nodes, style: TextStyle(color: tokens.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                _buildRoleChip(),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(description, style: TextStyle(color: tokens.textSecondary, fontSize: 14)),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing $name')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip() {
    Color color = Colors.grey;
    if (role == CommunityRole.admin) color = const Color(0xFF5865F2);
    if (role == CommunityRole.moderator) color = Colors.teal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        role.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }
}
