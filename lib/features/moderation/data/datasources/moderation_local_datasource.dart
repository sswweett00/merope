import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/moderation_database.dart';
import '../models/suspicious_account.dart';

abstract class IModerationLocalDataSource {
  Future<List<ModerationQueueItem>> getCachedQueue();
  Future<ModerationQueueItem?> getCachedItem(String userId);
  Future<void> cacheQueue(List<ModerationQueueItem> items);
  Future<void> updateCachedItem(ModerationQueueItem item);
  Future<void> clearCache();
  Future<void> logAction(String userId, String actionType, String moderatorId, {String? note, Map<String, dynamic>? metadata});
  Future<List<ModerationActionLogEntry>> getActionLog({int limit = 50});
  Future<void> saveFilter(String name, List<RiskLevel> riskLevels, List<ModerationReason> reasons, {String? dateRange, String? searchQuery});
  Future<List<ModerationSavedFilter>> getSavedFilters();
}

class ModerationActionLogEntry {
  final String id;
  final String userId;
  final String actionType;
  final String moderatorId;
  final String? moderatorNote;
  final Map<String, dynamic>? metadata;
  final DateTime performedAt;

  ModerationActionLogEntry({
    required this.id,
    required this.userId,
    required this.actionType,
    required this.moderatorId,
    this.moderatorNote,
    this.metadata,
    required this.performedAt,
  });

  factory ModerationActionLogEntry.fromJson(Map<String, dynamic> json) =>
      ModerationActionLogEntry(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        actionType: json['action_type'] as String,
        moderatorId: json['moderator_id'] as String,
        moderatorNote: json['moderator_note'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
        performedAt: DateTime.parse(json['performed_at'] as String),
      );
}

class ModerationSavedFilter {
  final String id;
  final String name;
  final List<RiskLevel> riskLevels;
  final List<ModerationReason> reasons;
  final String? dateRange;
  final String? searchQuery;
  final DateTime createdAt;

  ModerationSavedFilter({
    required this.id,
    required this.name,
    required this.riskLevels,
    required this.reasons,
    this.dateRange,
    this.searchQuery,
    required this.createdAt,
  });
}

class ModerationLocalDataSourceImpl implements IModerationLocalDataSource {
  final ModerationDatabase db;

  ModerationLocalDataSourceImpl(this.db);

  @override
  Future<List<ModerationQueueItem>> getCachedQueue() async {
    final rows = await db.select(db.moderationQueueCache).get();
    return rows.map(_mapRowToItem).toList();
  }

  @override
  Future<ModerationQueueItem?> getCachedItem(String userId) async {
    final row = await (db.select(db.moderationQueueCache)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
    return row != null ? _mapRowToItem(row) : null;
  }

  @override
  Future<void> cacheQueue(List<ModerationQueueItem> items) async {
    await db.delete(db.moderationQueueCache).go();
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.moderationQueueCache, items.map(_mapItemToRow));
    });
  }

  @override
  Future<void> updateCachedItem(ModerationQueueItem item) async {
    await db.update(db.moderationQueueCache).replace(_mapItemToRow(item));
  }

  @override
  Future<void> clearCache() async {
    await db.delete(db.moderationQueueCache).go();
  }

  @override
  Future<void> logAction(String userId, String actionType, String moderatorId, {String? note, Map<String, dynamic>? metadata}) async {
    await db.into(db.moderationActionLog).insert(
      ModerationActionLogCompanion.insert(
        id: '${DateTime.now().millisecondsSinceEpoch}_$userId',
        userId: userId,
        actionType: actionType,
        moderatorId: moderatorId,
        moderatorNote: Value(note),
        metadata: Value(metadata != null ? const JsonEncoder().convert(metadata) : null),
        performedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<ModerationActionLogEntry>> getActionLog({int limit = 50}) async {
    final rows = await (db.select(db.moderationActionLog)
          ..orderBy([(t) => OrderingTerm.desc(t.performedAt)])
          ..limit(limit))
        .get();
    return rows.map(_mapLogRowToEntry).toList();
  }

  @override
  Future<void> saveFilter(String name, List<RiskLevel> riskLevels, List<ModerationReason> reasons, {String? dateRange, String? searchQuery}) async {
    await db.into(db.moderationSavedFilter).insert(
      ModerationSavedFilterCompanion.insert(
        id: name.toLowerCase().replaceAll(' ', '_'),
        name: name,
        riskLevels: riskLevels.map((r) => r.name).join(','),
        reasons: reasons.map((r) => r.name).join(','),
        dateRange: Value(dateRange),
        searchQuery: Value(searchQuery),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<ModerationSavedFilter>> getSavedFilters() async {
    final rows = await db.select(db.moderationSavedFilter).get();
    return rows.map(_mapFilterRowToFilter).toList();
  }

  ModerationQueueCacheCompanion _mapItemToRow(ModerationQueueItem item) {
    return ModerationQueueCacheCompanion.insert(
      id: item.userId,
      userId: item.userId,
      username: item.username,
      displayName: item.displayName,
      avatarUrl: Value(item.avatarUrl),
      reason: item.reason.name,
      riskLevel: item.riskLevel.name,
      botProbability: item.botProbability,
      trustScore: item.trustScore,
      reportCount: item.reportCount,
      reporterIds: const JsonEncoder().convert(item.reporterIds),
      contentSampleIds: const JsonEncoder().convert(item.contentSampleIds),
      evidenceUrls: const JsonEncoder().convert(item.evidenceUrls),
      lastAction: Value(item.lastAction?.name),
      moderatorNote: Value(item.moderatorNote),
      isAppealed: item.isAppealed,
      appealStatus: Value(item.appealStatus?.name),
      appealReason: Value(item.appealReason),
      behavioralScore: item.behavioralScore,
      networkScore: item.networkScore,
      contentScore: item.contentScore,
      compositeScore: item.compositeScore,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      isSynced: const Value(false),
    );
  }

  ModerationQueueItem _mapRowToItem(ModerationQueueCacheData row) {
    return ModerationQueueItem(
      userId: row.userId,
      username: row.username,
      displayName: row.displayName,
      avatarUrl: row.avatarUrl,
      reason: ModerationReason.values.firstWhere((r) => r.name == row.reason, orElse: () => ModerationReason.bot),
      riskLevel: RiskLevel.values.firstWhere((r) => r.name == row.riskLevel, orElse: () => RiskLevel.low),
      botProbability: row.botProbability,
      trustScore: row.trustScore,
      reportCount: row.reportCount,
      reporterIds: _decodeJsonList(row.reporterIds),
      contentSampleIds: _decodeJsonList(row.contentSampleIds),
      evidenceUrls: _decodeJsonList(row.evidenceUrls),
      lastAction: row.lastAction != null ? LastAction.values.firstWhere((a) => a.name == row.lastAction) : null,
      moderatorNote: row.moderatorNote,
      isAppealed: row.isAppealed,
      appealStatus: row.appealStatus != null ? AppealStatus.values.firstWhere((a) => a.name == row.appealStatus) : null,
      appealReason: row.appealReason,
      behavioralScore: row.behavioralScore,
      networkScore: row.networkScore,
      contentScore: row.contentScore,
      compositeScore: row.compositeScore,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ModerationActionLogEntry _mapLogRowToEntry(ModerationActionLogData row) {
    return ModerationActionLogEntry(
      id: row.id,
      userId: row.userId,
      actionType: row.actionType,
      moderatorId: row.moderatorId,
      moderatorNote: row.moderatorNote,
      metadata: row.metadata != null ? Map<String, dynamic>.from(jsonDecode(row.metadata!)) : null,
      performedAt: row.performedAt,
    );
  }

  ModerationSavedFilter _mapFilterRowToFilter(ModerationSavedFilterData row) {
    final riskLevels = (row.riskLevels)
            .split(',')
            .where((s) => s.isNotEmpty)
            .map((s) => RiskLevel.values.firstWhere((r) => r.name == s, orElse: () => RiskLevel.low))
            .toList();
    final reasons = (row.reasons)
            .split(',')
            .where((s) => s.isNotEmpty)
            .map((s) => ModerationReason.values.firstWhere((r) => r.name == s, orElse: () => ModerationReason.bot))
            .toList();
    return ModerationSavedFilter(
      id: row.id,
      name: row.name,
      riskLevels: riskLevels,
      reasons: reasons,
      dateRange: row.dateRange,
      searchQuery: row.searchQuery,
      createdAt: row.createdAt,
    );
  }

  List<String> _decodeJsonList(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded.map((e) => e.toString()).toList();
    } catch (_) {
      return const <String>[];
    }
  }
}
