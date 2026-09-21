import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/widgets/merope_card.dart';
import '../data/progression_api.dart';
import '../logic/progression_provider.dart';

class ProgressionScreen extends ConsumerStatefulWidget {
  const ProgressionScreen({super.key});

  @override
  ConsumerState<ProgressionScreen> createState() => _ProgressionScreenState();
}

class _ProgressionScreenState extends ConsumerState<ProgressionScreen> {
  int tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final day = DateTime.now().toIso8601String().substring(0, 10);
      try {
        await ref.read(progressionApiProvider).recordEvent('daily_login', day);
        ref.invalidate(progressionProfileProvider);
        ref.invalidate(dailyProgressionQuestsProvider);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;
    final profile = ref.watch(progressionProfileProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        title: Text('Pulse Center', style: TextStyle(color: tokens.textPrimary)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
        ),
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Progression error: ' + error.toString())),
        data: (p) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(progressionProfileProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _ProfileCard(profile: p),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: p.boostActive
                          ? null
                          : () async {
                              try {
                                await ref.read(progressionApiProvider).activateBoost();
                                ref.invalidate(progressionProfileProvider);
                              } catch (error) {
                                _show(context, error.toString());
                              }
                            },
                      icon: const Icon(Icons.bolt),
                      label: Text(p.boostActive ? '2x Active' : 'Pulse Boost'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: p.streakShields <= 0
                        ? null
                        : () async {
                            try {
                              await ref.read(progressionApiProvider).useStreakShield();
                              ref.invalidate(progressionProfileProvider);
                            } catch (error) {
                              _show(context, error.toString());
                            }
                          },
                    icon: const Icon(Icons.shield_outlined),
                    label: Text(p.streakShields.toString()),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Daily')),
                  ButtonSegment(value: 1, label: Text('Weekly')),
                  ButtonSegment(value: 2, label: Text('Badges')),
                  ButtonSegment(value: 3, label: Text('Season')),
                ],
                selected: <int>{tab},
                onSelectionChanged: (value) {
                  setState(() => tab = value.first);
                },
              ),
              const SizedBox(height: 16),
              if (tab == 0) const _QuestList(daily: true),
              if (tab == 1) const _QuestList(daily: false),
              if (tab == 2) const _AchievementList(),
              if (tab == 3) const _LeaderboardList(),
            ],
          ),
        ),
      ),
    );
  }

  void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final ProgressionProfile profile;
  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final progress = profile.nextLevelXp <= 0
        ? 0.0
        : (profile.xp / profile.nextLevelXp).clamp(0.0, 1.0);

    return MeropeCard(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 24, child: Text(profile.level.toString())),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.tier,
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                      Text(
                        profile.xp.toString() +
                            ' XP · ' +
                            profile.reputation.toString() +
                            ' REP · ' +
                            profile.seasonXp.toString() +
                            ' Season XP',
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.local_fire_department),
                    Text(profile.currentStreak.toString() + 'd'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(value: progress, minHeight: 8),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Next ' + profile.nextLevelXp.toString() + ' XP'),
                Text(profile.seasonRank == 0
                    ? 'Unranked'
                    : 'Rank #' + profile.seasonRank.toString()),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.flash_on, size: 16),
                  label: Text(
                    'Combo ' +
                        profile.comboMultiplier.toStringAsFixed(1) +
                        'x',
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.battery_full, size: 16),
                  label: Text(profile.energy.toString() + ' energy'),
                ),
                Chip(
                  avatar: const Icon(Icons.security, size: 16),
                  label: Text(profile.streakShields.toString() + ' shields'),
                ),
                if (profile.boostActive)
                  const Chip(
                    avatar: Icon(Icons.bolt, size: 16),
                    label: Text('2x boost'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestList extends ConsumerWidget {
  final bool daily;
  const _QuestList({required this.daily});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        daily ? dailyProgressionQuestsProvider : weeklyProgressionQuestsProvider;
    return ref.watch(provider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text(error.toString()),
          data: (quests) => Column(
            children: quests.map((quest) => _QuestTile(quest: quest)).toList(),
          ),
        );
  }
}

class _QuestTile extends ConsumerWidget {
  final ProgressionQuest quest;
  const _QuestTile({required this.quest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratio = (quest.progress / quest.target).clamp(0.0, 1.0);
    return MeropeCard(
      margin: const EdgeInsets.only(bottom: 10),
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        title: Text(quest.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quest.description),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: ratio),
            const SizedBox(height: 5),
            Text(
              quest.progress.toString() +
                  '/' +
                  quest.target.toString() +
                  ' · +' +
                  quest.xpReward.toString() +
                  ' XP',
            ),
          ],
        ),
        trailing: quest.completed && !quest.claimed
            ? FilledButton(
                onPressed: () async {
                  await ref.read(progressionApiProvider).claimQuest(quest.id);
                  ref.invalidate(progressionProfileProvider);
                  ref.invalidate(dailyProgressionQuestsProvider);
                  ref.invalidate(weeklyProgressionQuestsProvider);
                },
                child: const Text('Claim'),
              )
            : quest.claimed
                ? const Icon(Icons.check_circle)
                : null,
      ),
    );
  }
}

class _AchievementList extends ConsumerWidget {
  const _AchievementList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(progressionAchievementsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text(error.toString()),
          data: (items) => Column(
            children: items
                .map(
                  (achievement) => MeropeCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Theme.of(context).colorScheme.surface,
                    child: ListTile(
                      leading: Icon(
                        achievement.unlocked
                            ? Icons.workspace_premium
                            : Icons.lock_outline,
                      ),
                      title: Text(achievement.name),
                      subtitle: Text(achievement.description),
                      trailing: Text(
                        achievement.unlocked
                            ? 'Unlocked'
                            : '+' + achievement.xpReward.toString() + ' XP',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
  }
}

class _LeaderboardList extends ConsumerWidget {
  const _LeaderboardList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(progressionLeaderboardProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text(error.toString()),
          data: (items) => Column(
            children: items
                .map(
                  (entry) => ListTile(
                    leading: CircleAvatar(
                        child: Text(entry.rank.toString())),
                    title: Text(entry.userId),
                    trailing: Text(entry.xp.toString() + ' XP'),
                  ),
                )
                .toList(),
          ),
        );
  }
}
