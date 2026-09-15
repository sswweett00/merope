import '../models/suspicious_account.dart';
import '../models/moderation_action_request.dart';
import '../datasources/moderation_remote_datasource.dart';
import '../datasources/moderation_local_datasource.dart';

abstract class IModerationRepository {
  Future<ModerationQueuePage> getQueuePage({
    String? cursor,
    int limit = 20,
    ModerationReason? reason,
    RiskLevel? riskLevel,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    bool forceRefresh = false,
  });

  Future<void> banUser({
    required String userId,
    String? reason,
    int? durationDays,
    String? moderatorNote,
  });

  Future<void> markSafe({
    required String userId,
    String? moderatorNote,
  });

  Future<void> escalate({
    required String userId,
    String? target,
    String? moderatorNote,
  });

  Future<void> bulkAction({
    required ModerationActionType type,
    required List<String> userIds,
    String? reason,
    String? moderatorNote,
  });

  Future<List<ModerationQueueItem>> getCachedQueue();
  Future<void> cacheQueue(List<ModerationQueueItem> items);
  Future<void> clearCache();
  Future<List<ModerationActionLogEntry>> getActionLog({int limit = 50});
  Future<void> logAction(String userId, String actionType, String moderatorId, {String? note, Map<String, dynamic>? metadata});
  Future<List<ModerationSavedFilter>> getSavedFilters();
  Future<void> saveFilter(String name, List<RiskLevel> riskLevels, List<ModerationReason> reasons, {String? dateRange, String? searchQuery});
}
