import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/progression_api.dart';

final progressionProfileProvider =
    FutureProvider.autoDispose<ProgressionProfile>((ref) {
  return ref.watch(progressionApiProvider).getProfile();
});

final dailyProgressionQuestsProvider =
    FutureProvider.autoDispose<List<ProgressionQuest>>((ref) {
  return ref.watch(progressionApiProvider).getQuests(cadence: 'daily');
});

final weeklyProgressionQuestsProvider =
    FutureProvider.autoDispose<List<ProgressionQuest>>((ref) {
  return ref.watch(progressionApiProvider).getQuests(cadence: 'weekly');
});

final progressionAchievementsProvider =
    FutureProvider.autoDispose<List<ProgressionAchievement>>((ref) {
  return ref.watch(progressionApiProvider).getAchievements();
});

final progressionLeaderboardProvider =
    FutureProvider.autoDispose<List<ProgressionLeaderboardEntry>>((ref) {
  return ref.watch(progressionApiProvider).getLeaderboard();
});

Future<void> recordProgressionEvent(
  WidgetRef ref,
  String action,
  String sourceId,
) async {
  await ref.read(progressionApiProvider).recordEvent(action, sourceId);
  ref.invalidate(progressionProfileProvider);
  ref.invalidate(dailyProgressionQuestsProvider);
  ref.invalidate(weeklyProgressionQuestsProvider);
  ref.invalidate(progressionAchievementsProvider);
  ref.invalidate(progressionLeaderboardProvider);
}
