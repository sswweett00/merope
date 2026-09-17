import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/logic/auth_logic.dart';
import 'package:merope_core/data/services/social_api.dart';
import 'package:merope_ui/merope_ui.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import '../logic/timeline_provider.dart';
import '../logic/post_filter_provider.dart';
import './widgets/post_filter_bar.dart';
import './widgets/resonance_streak_widget.dart';
import './nexus_timeline_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;
    final timelineAsync = ref.watch(nexusTimelineProvider);

    final effectiveUserId = widget.userId == 'me'
        ? (ref.watch(authControllerProvider).user?.id ?? 'me')
        : widget.userId;

    final userAsync = ref.watch(userProfileProvider(effectiveUserId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: userAsync.when(
        data: (user) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: _ProfileHeader(tokens: tokens, user: user)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: 4,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: tokens.border, width: 2),
                            ),
                            child: Icon(Icons.star,
                                color: tokens.primary.withValues(alpha: 0.5)),
                          ),
                          const SizedBox(height: 4),
                          Text('Highlight ${index + 1}',
                              style: TextStyle(
                                  fontSize: 10, color: tokens.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: tokens.border, width: 0.5)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: tokens.primary,
                  labelColor: tokens.primary,
                  unselectedLabelColor: tokens.textSecondary,
                  tabs: const [
                    Tab(
                        text: 'Posts',
                        icon: Icon(Icons.feed_outlined, size: 20)),
                    Tab(
                        text: 'Activity',
                        icon: Icon(Icons.auto_graph_outlined, size: 20)),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNexusTab(timelineAsync),
                  _buildResonanceTab(tokens),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Profile Error: $err')),
      ),
    );
  }

  Widget _buildNexusTab(AsyncValue timelineAsync) {
    final filteredPostsAsync =
        ref.watch(filteredProfilePostsProvider(widget.userId));

    return filteredPostsAsync.when(
      data: (userSignals) {
        return Column(
          children: [
            const PostFilterBar(),
            Expanded(
              child: userSignals.isEmpty
                  ? const Center(
                      child: Text('No posts found',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: MeropeTokens.space24, vertical: 16),
                      itemCount: userSignals.length,
                      itemBuilder: (context, index) =>
                          NexusTimelineCard(signal: userSignals[index]),
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
          child: Text('Resonance Error: $err',
              style: const TextStyle(color: Colors.red))),
    );
  }

  Widget _buildResonanceTab(MeropeColorTokens tokens) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        _buildResonanceSection(
          title: 'Experience',
          subtitle: 'Professional journey and milestones',
          icon: Icons.alt_route,
          tokens: tokens,
          children: [
            _ProfessionalEntry(
              title: 'Lead Architect',
              subtitle: 'Merope Core Team • 2024 - Present',
              description: 'Designing high-performance decentralized systems.',
              tokens: tokens,
            ),
            _ProfessionalEntry(
              title: 'Senior Systems Engineer',
              subtitle: 'Neural Waves Inc. • 2021 - 2024',
              description: 'Optimized real-time data sync protocols.',
              tokens: tokens,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildResonanceSection(
          title: 'Skills',
          subtitle: 'Core competencies and expertise',
          icon: Icons.radar,
          tokens: tokens,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SkillChip(label: 'Distributed Systems', tokens: tokens),
                _SkillChip(label: 'Rust/Go', tokens: tokens),
                _SkillChip(label: 'Flutter Architecture', tokens: tokens),
                _SkillChip(label: 'NATS/JetStream', tokens: tokens),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildResonanceSection(
          title: 'Achievements',
          subtitle: 'Validations and certifications',
          icon: Icons.workspace_premium,
          tokens: tokens,
          children: [
            _ProfessionalEntry(
              title: 'System Architect Certification',
              subtitle: 'Global Tech Alliance • Issued May 2025',
              tokens: tokens,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildResonanceSection(
          title: 'Neural Activity',
          subtitle: 'Synergy contribution over time',
          icon: Icons.grid_on_rounded,
          tokens: tokens,
          children: [
            const _NeuralHeatmap(),
          ],
        ),
      ],
    );
  }

  Widget _buildResonanceSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required MeropeColorTokens tokens,
    required List<Widget> children,
  }) {
    return MeropeCard(
      color: tokens.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: tokens.primary, size: 24),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: tokens.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    Text(subtitle,
                        style: TextStyle(
                            color: tokens.textSecondary, fontSize: 13)),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                  height: 1, color: tokens.border.withValues(alpha: 0.1)),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _NeuralHeatmap extends ConsumerWidget {
  const _NeuralHeatmap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          width: double.infinity,
          child: CustomPaint(
            painter: NeuralActivityPainter(
              color: tokens.primary,
              activityData: List.generate(
                  91,
                  (index) => (index % 5 == 0)
                      ? 0.8
                      : (index % 3 == 0)
                          ? 0.4
                          : 0.1),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Last 90 days of neural contributions',
                style: TextStyle(fontSize: 10, color: Colors.grey)),
            Row(
              children: [
                Text('Less',
                    style: TextStyle(fontSize: 9, color: tokens.textSecondary)),
                const SizedBox(width: 4),
                ...List.generate(
                    5,
                    (i) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                              color: tokens.primary
                                  .withValues(alpha: 0.1 + i * 0.2),
                              borderRadius: BorderRadius.circular(1)),
                        )),
                const SizedBox(width: 4),
                Text('More',
                    style: TextStyle(fontSize: 9, color: tokens.textSecondary)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class NeuralActivityPainter extends CustomPainter {
  final Color color;
  final List<double> activityData;

  NeuralActivityPainter({required this.color, required this.activityData});

  @override
  void paint(Canvas canvas, Size size) {
    const double spacing = 3.0;
    const int rows = 7;
    final double itemSize = (size.height - (rows - 1) * spacing) / rows;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < activityData.length; i++) {
      final col = i ~/ rows;
      final row = i % rows;

      final x = col * (itemSize + spacing);
      final y = row * (itemSize + spacing);

      paint.color = color.withValues(alpha: activityData[i]);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, itemSize, itemSize), const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ProfessionalEntry extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? description;
  final MeropeColorTokens tokens;

  const _ProfessionalEntry({
    required this.title,
    required this.subtitle,
    this.description,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          Text(subtitle,
              style: TextStyle(color: tokens.textSecondary, fontSize: 13)),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(description!,
                style: TextStyle(
                    color: tokens.textPrimary.withValues(alpha: 0.8),
                    fontSize: 14)),
          ],
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final MeropeColorTokens tokens;

  const _SkillChip({required this.label, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: tokens.primary, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final MeropeColorTokens tokens;
  final UserModel user;
  const _ProfileHeader({required this.tokens, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [tokens.primary, tokens.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Opacity(
                opacity: 0.3,
                child: MeropeImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1964&auto=format&fit=crop',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: 24,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: tokens.background,
                  shape: BoxShape.circle,
                ),
                child: Hero(
                  tag: 'avatar_${user.id}',
                  child: MeropeImage.avatar(
                    imageUrl: user.avatarUrl,
                    radius: 50,
                    initials: user.username,
                    enableViewer: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.displayName.isNotEmpty
                                ? user.displayName
                                : user.username,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: tokens.textPrimary,
                            ),
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.verified,
                                color: tokens.primary, size: 20),
                          ],
                        ],
                      ),
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                            color: tokens.textSecondary, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ResonanceStreakWidget(
                          streak: user.streak, tokens: tokens),
                      const SizedBox(height: 12),
                      _ReputationBar(
                        level: user.level,
                        xp: user.xp,
                        nextLevelXp: user.level * 1000 + 1000,
                        tier: user.reputationTier ?? 'Novice',
                        tokens: tokens,
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () => context.push('/settings/edit-profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: tokens.primary,
                      side: BorderSide(color: tokens.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(MeropeTokens.radiusMd)),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
              const SizedBox(height: MeropeTokens.space16),
              Text(
                user.bio ?? 'No bio yet.',
                style: TextStyle(
                    color: tokens.textPrimary, fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: MeropeTokens.space16),
              Row(
                children: [
                  InkWell(
                    onTap: () => context.push('/following'),
                    child: _StatItem(
                        label: 'Following',
                        value: '${user.followingCount ?? 0}',
                        tokens: tokens),
                  ),
                  const SizedBox(width: 24),
                  InkWell(
                    onTap: () => context.push('/followers'),
                    child: _StatItem(
                        label: 'Followers',
                        value: '${user.followerCount ?? 0}',
                        tokens: tokens),
                  ),
                  const SizedBox(width: 24),
                  _StatItem(
                      label: 'Reputation',
                      value: '${user.xp / 1000}',
                      tokens: tokens,
                      isInfluence: true),
                ],
              ),
              const SizedBox(height: MeropeTokens.space16),
              _MutualsPreview(tokens: tokens),
            ],
          ),
        ),
      ],
    );
  }
}

class _MutualsPreview extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _MutualsPreview({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Stack(
            children: [
              _CircularMutual(offset: 0, color: Colors.blue),
              _CircularMutual(offset: 15, color: Colors.orange),
              _CircularMutual(offset: 30, color: Colors.green),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '12 mutual friends including @alpha and @beta',
          style: TextStyle(color: tokens.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _CircularMutual extends StatelessWidget {
  final double offset;
  final Color color;
  const _CircularMutual({required this.offset, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}

class _ReputationBar extends StatefulWidget {
  final int level;
  final int xp;
  final int nextLevelXp;
  final String tier;
  final MeropeColorTokens tokens;

  const _ReputationBar({
    required this.level,
    required this.xp,
    required this.nextLevelXp,
    required this.tier,
    required this.tokens,
  });

  @override
  State<_ReputationBar> createState() => _ReputationBarState();
}

class _ReputationBarState extends State<_ReputationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.xp % 1000) / 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.tokens.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'LVL ${widget.level}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.tier} Tier',
              style: TextStyle(
                  color: widget.tokens.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              width: 200,
              decoration: BoxDecoration(
                color: widget.tokens.border.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Container(
                  height: 6,
                  width: 200 * progress,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.tokens.primary,
                        widget.tokens.secondary,
                        widget.tokens.primary
                      ],
                      stops: [
                        _controller.value - 0.2,
                        _controller.value,
                        _controller.value + 0.2
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: widget.tokens.primary.withValues(alpha: 0.5),
                          blurRadius: 4)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.xp} / ${widget.nextLevelXp} XP',
          style: TextStyle(color: widget.tokens.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final MeropeColorTokens tokens;
  final bool isInfluence;

  const _StatItem({
    required this.label,
    required this.value,
    required this.tokens,
    this.isInfluence = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isInfluence ? tokens.primary : tokens.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: tokens.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}
