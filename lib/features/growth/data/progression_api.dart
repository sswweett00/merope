import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/api_client.dart';

class ProgressionProfile {
  final String userId;
  final int xp;
  final int level;
  final int nextLevelXp;
  final int reputation;
  final int energy;
  final int currentStreak;
  final int longestStreak;
  final int combo;
  final double comboMultiplier;
  final bool boostActive;
  final DateTime? boostUntil;
  final int streakShields;
  final String tier;
  final int seasonXp;
  final int seasonRank;

  const ProgressionProfile({
    required this.userId,
    required this.xp,
    required this.level,
    required this.nextLevelXp,
    required this.reputation,
    required this.energy,
    required this.currentStreak,
    required this.longestStreak,
    required this.combo,
    required this.comboMultiplier,
    required this.boostActive,
    required this.boostUntil,
    required this.streakShields,
    required this.tier,
    required this.seasonXp,
    required this.seasonRank,
  });

  factory ProgressionProfile.fromJson(Map<String, dynamic> json) =>
      ProgressionProfile(
        userId: json['user_id']?.toString() ?? '',
        xp: (json['xp'] as num?)?.toInt() ?? 0,
        level: (json['level'] as num?)?.toInt() ?? 1,
        nextLevelXp: (json['next_level_xp'] as num?)?.toInt() ?? 100,
        reputation: (json['reputation'] as num?)?.toInt() ?? 0,
        energy: (json['energy'] as num?)?.toInt() ?? 100,
        currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
        longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
        combo: (json['combo'] as num?)?.toInt() ?? 0,
        comboMultiplier:
            (json['combo_multiplier'] as num?)?.toDouble() ?? 1,
        boostActive: json['boost_active'] as bool? ?? false,
        boostUntil: json['boost_until'] != null
            ? DateTime.tryParse(json['boost_until'].toString())
            : null,
        streakShields: (json['streak_shields'] as num?)?.toInt() ?? 0,
        tier: json['tier']?.toString() ?? 'Seed',
        seasonXp: (json['season_xp'] as num?)?.toInt() ?? 0,
        seasonRank: (json['season_rank'] as num?)?.toInt() ?? 0,
      );
}

class ProgressionQuest {
  final String id;
  final String code;
  final String title;
  final String description;
  final String action;
  final int target;
  final int progress;
  final int xpReward;
  final int reputationReward;
  final String cadence;
  final bool claimed;
  final bool completed;

  const ProgressionQuest({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.action,
    required this.target,
    required this.progress,
    required this.xpReward,
    required this.reputationReward,
    required this.cadence,
    required this.claimed,
    required this.completed,
  });

  factory ProgressionQuest.fromJson(Map<String, dynamic> json) =>
      ProgressionQuest(
        id: json['id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        action: json['action']?.toString() ?? '',
        target: (json['target'] as num?)?.toInt() ?? 1,
        progress: (json['progress'] as num?)?.toInt() ?? 0,
        xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
        reputationReward: (json['reputation_reward'] as num?)?.toInt() ?? 0,
        cadence: json['cadence']?.toString() ?? 'daily',
        claimed: json['claimed'] as bool? ?? false,
        completed: json['completed'] as bool? ?? false,
      );
}

class ProgressionAchievement {
  final String id;
  final String code;
  final String name;
  final String description;
  final int xpReward;
  final int reputationReward;
  final bool unlocked;
  final DateTime? unlockedAt;

  const ProgressionAchievement({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.xpReward,
    required this.reputationReward,
    required this.unlocked,
    required this.unlockedAt,
  });

  factory ProgressionAchievement.fromJson(Map<String, dynamic> json) =>
      ProgressionAchievement(
        id: json['id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
        reputationReward: (json['reputation_reward'] as num?)?.toInt() ?? 0,
        unlocked: json['unlocked'] as bool? ?? false,
        unlockedAt: json['unlocked_at'] != null
            ? DateTime.tryParse(json['unlocked_at'].toString())
            : null,
      );
}

class ProgressionLeaderboardEntry {
  final int rank;
  final String userId;
  final int xp;

  const ProgressionLeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.xp,
  });

  factory ProgressionLeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      ProgressionLeaderboardEntry(
        rank: (json['rank'] as num?)?.toInt() ?? 0,
        userId: json['user_id']?.toString() ?? '',
        xp: (json['xp'] as num?)?.toInt() ?? 0,
      );
}

final progressionApiProvider = Provider<ProgressionApi>((ref) {
  return ProgressionApi(ApiClient());
});

class ProgressionApi {
  final ApiClient _api;
  ProgressionApi(this._api);

  Future<ProgressionProfile> getProfile() async {
    final response =
        await _api.get<Map<String, dynamic>>('/progression/profile');
    if (response.isError || response.data == null) {
      throw StateError(
        response.error?.toString() ?? 'Failed to load progression profile',
      );
    }
    return ProgressionProfile.fromJson(response.data!);
  }

  Future<List<ProgressionQuest>> getQuests({String cadence = 'daily'}) async {
    final response = await _api.get<List<dynamic>>(
      '/progression/quests',
      queryParameters: {'cadence': cadence},
    );
    if (response.isError || response.data == null) {
      throw StateError(response.error?.toString() ?? 'Failed to load quests');
    }
    return response.data!
        .whereType<Map>()
        .map((item) =>
            ProgressionQuest.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Map<String, dynamic>> recordEvent(
      String action, String sourceId) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/progression/events',
      data: {'action': action, 'source_id': sourceId},
    );
    if (response.isError || response.data == null) {
      throw StateError(
        response.error?.toString() ?? 'Failed to record progression event',
      );
    }
    return response.data!;
  }

  Future<ProgressionQuest> claimQuest(String questId) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/progression/quests/$questId/claim',
    );
    if (response.isError || response.data == null) {
      throw StateError(
        response.error?.toString() ?? 'Quest cannot be claimed',
      );
    }
    return ProgressionQuest.fromJson(response.data!);
  }

  Future<ProgressionProfile> activateBoost() async {
    final response =
        await _api.post<Map<String, dynamic>>('/progression/boost');
    if (response.isError || response.data == null) {
      throw StateError(
        response.error?.toString() ?? 'Boost cannot be activated',
      );
    }
    return ProgressionProfile.fromJson(response.data!);
  }

  Future<ProgressionProfile> useStreakShield() async {
    final response =
        await _api.post<Map<String, dynamic>>('/progression/streak-shield');
    if (response.isError || response.data == null) {
      throw StateError(
        response.error?.toString() ?? 'Streak shield cannot be used',
      );
    }
    return ProgressionProfile.fromJson(response.data!);
  }

  Future<List<ProgressionAchievement>> getAchievements() async {
    final response =
        await _api.get<List<dynamic>>('/progression/achievements');
    if (response.isError || response.data == null) {
      throw StateError(
        response.error?.toString() ?? 'Failed to load achievements',
      );
    }
    return response.data!
        .whereType<Map>()
        .map((item) => ProgressionAchievement.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }

  Future<List<ProgressionLeaderboardEntry>> getLeaderboard() async {
    final response =
        await _api.get<List<dynamic>>('/progression/leaderboard');
    if (response.isError || response.data == null) {
      throw StateError(
        response.error?.toString() ?? 'Failed to load leaderboard',
      );
    }
    return response.data!
        .whereType<Map>()
        .map((item) => ProgressionLeaderboardEntry.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }
}
