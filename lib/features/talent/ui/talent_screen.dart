import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/talent_opportunity_card.dart';
import '../../auth/repository/auth_repository.dart';
import 'job_detail_screen.dart';

import '../data/providers/talent_provider.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import 'package:merope_ui/widgets/universal_view_controls.dart';
import 'package:merope_ui/layouts/dynamic_layout_engine.dart';

class TalentScreen extends ConsumerStatefulWidget {
  const TalentScreen({super.key});

  @override
  ConsumerState<TalentScreen> createState() => _TalentScreenState();
}

class _TalentScreenState extends ConsumerState<TalentScreen>
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Careers',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: tokens.primary,
                labelColor: tokens.primary,
                unselectedLabelColor: tokens.textSecondary,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Jobs'),
                  Tab(text: 'My Alignment'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOpportunitiesList(tokens),
          _buildMyResonance(tokens),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOpportunityDialog(context, ref),
        backgroundColor: tokens.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOpportunitiesList(MeropeColorTokens tokens) {
    final prefs = ref.watch(viewPreferencesProvider)['talent'] ??
        const ViewPreferences(mode: ViewMode.list, activeFilter: 'All');

    final jobsAsync = ref.watch(talentJobsProvider);

    return Column(
      children: [
        UniversalViewControls(
          domain: 'talent',
          filters: const ['All', 'Full-time', 'Contract', 'Remote'],
        ),
        Expanded(
          child: jobsAsync.when(
            data: (jobs) {
              final filtered = jobs.where((j) {
                if (prefs.activeFilter == 'All') return true;
                return j.type == prefs.activeFilter ||
                    (prefs.activeFilter == 'Remote' && j.location == 'Remote');
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                    child: Text('No opportunities found',
                        style: TextStyle(color: tokens.textSecondary)));
              }

              return DynamicLayoutEngine(
                items: filtered,
                mode: prefs.mode,
                padding: const EdgeInsets.all(24),
                itemBuilder: (context, index, job) {
                  if (prefs.mode == ViewMode.compact) {
                    return ListTile(
                      title: Text(job.title,
                          style: TextStyle(
                              color: tokens.textPrimary,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text('${job.company} • ${job.location}',
                          style: TextStyle(color: tokens.textSecondary)),
                      trailing: Text(job.compensation,
                          style: TextStyle(
                              color: tokens.primary,
                              fontWeight: FontWeight.bold)),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TalentOpportunityCard(
                      title: job.title,
                      company: job.company,
                      location: job.location,
                      type: job.type,
                      compensation: job.compensation,
                      tags: job.tags,
                      tokens: tokens,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => JobDetailScreen(job: job)),
                        );
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Talent Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildMyResonance(MeropeColorTokens tokens) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ResonanceRadialChart(tokens: tokens),
          const SizedBox(height: 32),
          Text(
            'Your Profile is Trending',
            style: TextStyle(
                color: tokens.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '8 companies are looking for someone like you',
            style: TextStyle(color: tokens.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 32),
          _buildResonanceBreakdown(tokens),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: tokens.primary,
              side: BorderSide(color: tokens.primary),
            ),
            child: const Text('View Detailed Insights'),
          ),
        ],
      ),
    );
  }

  Widget _buildResonanceBreakdown(MeropeColorTokens tokens) {
    final factors = [
      {'label': 'Technical Match', 'value': 0.95, 'color': tokens.primary},
      {'label': 'Creative Alignment', 'value': 0.78, 'color': tokens.secondary},
      {'label': 'Industry Impact', 'value': 0.62, 'color': Colors.amber},
    ];

    return Column(
      children: factors
          .map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(f['label'] as String,
                          style: TextStyle(
                              color: tokens.textSecondary, fontSize: 13)),
                    ),
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: f['value'] as double,
                          backgroundColor: tokens.surfaceVariant,
                          valueColor:
                              AlwaysStoppedAnimation(f['color'] as Color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${((f['value'] as double) * 100).toInt()}%',
                        style: TextStyle(
                            color: tokens.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  void _showCreateOpportunityDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final compensationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Opportunity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: compensationController,
              decoration: const InputDecoration(labelText: 'Compensation'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final user = await ref.read(currentUserProvider.future);
                final newJob = TalentJob(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  company: user?.username ?? 'Merope Node',
                  location: 'Remote',
                  type: 'Full-time',
                  compensation: compensationController.text,
                  tags: ['New'],
                );
                ref.read(talentJobsProvider.notifier).addJob(newJob);
                if (context.mounted) Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opportunity created!')),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _ResonanceRadialChart extends StatelessWidget {
  final MeropeColorTokens tokens;
  const _ResonanceRadialChart({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: 0.85,
              strokeWidth: 12,
              backgroundColor: tokens.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(tokens.primary),
            ),
          ),
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: 0.72,
              strokeWidth: 12,
              backgroundColor: tokens.secondary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(tokens.secondary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '85%',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: tokens.primary),
              ),
              Text(
                'Match',
                style: TextStyle(
                    fontSize: 12,
                    color: tokens.textSecondary,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
