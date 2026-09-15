import 'dart:async';
import 'package:dio/dio.dart';
import '../models/suspicious_account.dart';
import '../models/moderation_action_request.dart';
import '../datasources/moderation_remote_datasource.dart';
import '../datasources/moderation_local_datasource.dart';
import '../repositories/moderation_repository.dart';

class ModerationRepositoryImpl implements IModerationRepository {
  final IModerationRemoteDataSource remoteDataSource;
  final IModerationLocalDataSource localDataSource;
  final CancelToken _cancelToken = CancelToken();

  ModerationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ModerationQueuePage> getQueuePage({
    String? cursor,
    int limit = 20,
    ModerationReason? reason,
    RiskLevel? riskLevel,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    bool forceRefresh = false,
  }) async {
    try {
      final page = await remoteDataSource.fetchQueuePage(
        cursor: cursor,
        limit: limit,
        reason: reason,
        riskLevel: riskLevel,
        searchQuery: searchQuery,
        startDate: startDate,
        endDate: endDate,
        cancelToken: _cancelToken,
      );

      if (page.items.isNotEmpty) {
        final existing = await localDataSource.getCachedQueue();
        final existingMap = {for (var e in existing) e.userId: e};

        for (final item in page.items) {
          existingMap[item.userId] = item;
        }

        await localDataSource.cacheQueue(existingMap.values.toList());
      }

      return page;
    } catch (e) {
      if (forceRefresh) rethrow;
      final cached = await localDataSource.getCachedQueue();
      if (cached.isEmpty) rethrow;
      return ModerationQueuePage(
        items: cached,
        nextCursor: null,
        hasMore: false,
        metrics: const {},
      );
    }
  }

  @override
  Future<void> banUser({
    required String userId,
    String? reason,
    int? durationDays,
    String? moderatorNote,
  }) async {
    await remoteDataSource.banUser(
      userId: userId,
      reason: reason,
      durationDays: durationDays,
      moderatorNote: moderatorNote,
      cancelToken: _cancelToken,
    );
    await localDataSource.logAction(userId, 'ban', 'current_moderator', note: moderatorNote, metadata: {'reason': reason, 'duration_days': durationDays});
    final cached = await localDataSource.getCachedItem(userId);
    if (cached != null) {
      await localDataSource.updateCachedItem(cached.copyWith(lastAction: LastAction.banned, moderatorNote: moderatorNote, updatedAt: DateTime.now()));
    }
  }

  @override
  Future<void> markSafe({
    required String userId,
    String? moderatorNote,
  }) async {
    await remoteDataSource.markSafe(userId: userId, moderatorNote: moderatorNote, cancelToken: _cancelToken);
    await localDataSource.logAction(userId, 'safe', 'current_moderator', note: moderatorNote);
    final cached = await localDataSource.getCachedItem(userId);
    if (cached != null) {
      await localDataSource.updateCachedItem(cached.copyWith(lastAction: LastAction.safe, moderatorNote: moderatorNote, updatedAt: DateTime.now()));
    }
  }

  @override
  Future<void> escalate({
    required String userId,
    String? target,
    String? moderatorNote,
  }) async {
    await remoteDataSource.escalate(userId: userId, target: target, moderatorNote: moderatorNote, cancelToken: _cancelToken);
    await localDataSource.logAction(userId, 'escalate', 'current_moderator', note: moderatorNote, metadata: {'target': target});
    final cached = await localDataSource.getCachedItem(userId);
    if (cached != null) {
      await localDataSource.updateCachedItem(cached.copyWith(lastAction: LastAction.escalated, moderatorNote: moderatorNote, updatedAt: DateTime.now()));
    }
  }

  @override
  Future<void> bulkAction({
    required ModerationActionType type,
    required List<String> userIds,
    String? reason,
    String? moderatorNote,
  }) async {
    await remoteDataSource.bulkAction(type: type, userIds: userIds, reason: reason, moderatorNote: moderatorNote, cancelToken: _cancelToken);
    await Future.forEach(userIds, (String userId) async {
      await localDataSource.logAction(userId, type.name, 'current_moderator', note: moderatorNote, metadata: {'bulk': true, 'reason': reason});
    });
  }

  @override
  Future<List<ModerationQueueItem>> getCachedQueue() => localDataSource.getCachedQueue();

  @override
  Future<void> cacheQueue(List<ModerationQueueItem> items) => localDataSource.cacheQueue(items);

  @override
  Future<void> clearCache() => localDataSource.clearCache();

  @override
  Future<List<ModerationActionLogEntry>> getActionLog({int limit = 50}) => localDataSource.getActionLog(limit: limit);

  @override
  Future<void> logAction(String userId, String actionType, String moderatorId, {String? note, Map<String, dynamic>? metadata}) =>
      localDataSource.logAction(userId, actionType, moderatorId, note: note, metadata: metadata);

  @override
  Future<List<ModerationSavedFilter>> getSavedFilters() => localDataSource.getSavedFilters();

  @override
  Future<void> saveFilter(String name, List<RiskLevel> riskLevels, List<ModerationReason> reasons, {String? dateRange, String? searchQuery}) =>
      localDataSource.saveFilter(name, riskLevels, reasons, dateRange: dateRange, searchQuery: searchQuery);

  void cancelAll() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel('Repository disposed');
    }
  }
}
