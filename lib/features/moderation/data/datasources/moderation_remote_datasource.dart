import 'dart:async';
import 'package:dio/dio.dart';
import '../models/suspicious_account.dart';
import '../models/moderation_action_request.dart';

abstract class IModerationRemoteDataSource {
  Future<ModerationQueuePage> fetchQueuePage({
    String? cursor,
    int limit = 20,
    ModerationReason? reason,
    RiskLevel? riskLevel,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  });

  Future<void> banUser({
    required String userId,
    String? reason,
    int? durationDays,
    String? moderatorNote,
    CancelToken? cancelToken,
  });

  Future<void> markSafe({
    required String userId,
    String? moderatorNote,
    CancelToken? cancelToken,
  });

  Future<void> escalate({
    required String userId,
    String? target,
    String? moderatorNote,
    CancelToken? cancelToken,
  });

  Future<void> bulkAction({
    required ModerationActionType type,
    required List<String> userIds,
    String? reason,
    String? moderatorNote,
    CancelToken? cancelToken,
  });
}

class ModerationQueuePage {
  final List<ModerationQueueItem> items;
  final String? nextCursor;
  final bool hasMore;
  final Map<String, int> metrics;

  ModerationQueuePage({
    required this.items,
    this.nextCursor,
    required this.hasMore,
    required this.metrics,
  });
}

class ModerationRemoteDataSourceImpl implements IModerationRemoteDataSource {
  final Dio dio;
  static const String _basePath = '/api/v10/moderation';
  static const Duration _timeout = Duration(seconds: 15);

  ModerationRemoteDataSourceImpl({required this.dio});

  @override
  Future<ModerationQueuePage> fetchQueuePage({
    String? cursor,
    int limit = 20,
    ModerationReason? reason,
    RiskLevel? riskLevel,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '$_basePath/queue',
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
          'limit': limit,
          if (reason != null) 'reason': reason.name,
          if (riskLevel != null) 'risk_level': riskLevel.name,
          if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
        },
        options: Options(
          receiveTimeout: _timeout,
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>?)
              ?.map((e) =>
                  ModerationQueueItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      final metrics = (data['metrics'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as int))) ??
          const {};

      return ModerationQueuePage(
        items: items,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? false,
        metrics: metrics,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ModerationException('Failed to fetch moderation queue: $e');
    }
  }

  @override
  Future<void> banUser({
    required String userId,
    String? reason,
    int? durationDays,
    String? moderatorNote,
    CancelToken? cancelToken,
  }) async {
    try {
      await dio.post(
        '$_basePath/queue/$userId/ban',
        data: {
          if (reason != null) 'reason': reason,
          if (durationDays != null) 'duration_days': durationDays,
          if (moderatorNote != null) 'moderator_note': moderatorNote,
        },
        options: Options(
          receiveTimeout: _timeout,
        ),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ModerationException('Failed to ban user: $e');
    }
  }

  @override
  Future<void> markSafe({
    required String userId,
    String? moderatorNote,
    CancelToken? cancelToken,
  }) async {
    try {
      await dio.post(
        '$_basePath/queue/$userId/safe',
        data: {
          if (moderatorNote != null) 'moderator_note': moderatorNote,
        },
        options: Options(
          receiveTimeout: _timeout,
        ),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ModerationException('Failed to mark safe: $e');
    }
  }

  @override
  Future<void> escalate({
    required String userId,
    String? target,
    String? moderatorNote,
    CancelToken? cancelToken,
  }) async {
    try {
      await dio.post(
        '$_basePath/queue/$userId/escalate',
        data: {
          if (target != null) 'target': target,
          if (moderatorNote != null) 'moderator_note': moderatorNote,
        },
        options: Options(
          receiveTimeout: _timeout,
        ),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ModerationException('Failed to escalate: $e');
    }
  }

  @override
  Future<void> bulkAction({
    required ModerationActionType type,
    required List<String> userIds,
    String? reason,
    String? moderatorNote,
    CancelToken? cancelToken,
  }) async {
    try {
      await dio.post(
        '$_basePath/queue/bulk',
        data: {
          'action': type.name,
          'user_ids': userIds,
          if (reason != null) 'reason': reason,
          if (moderatorNote != null) 'moderator_note': moderatorNote,
        },
        options: Options(
          receiveTimeout: _timeout,
        ),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ModerationException('Failed to perform bulk action: $e');
    }
  }

  ModerationException _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const ModerationException('Connection timeout', code: 'TIMEOUT');
    }
    if (e.response?.statusCode == 429) {
      return const ModerationException('Rate limited', code: 'RATE_LIMITED');
    }
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return const ModerationException('Unauthorized', code: 'UNAUTHORIZED');
    }
    final message = e.response?.data?['error'] ?? e.message ?? 'Unknown error';
    return ModerationException(message, code: 'API_ERROR');
  }
}

class ModerationException implements Exception {
  final String message;
  final String? code;

  const ModerationException(this.message, {this.code});

  @override
  String toString() => 'ModerationException(${code ?? 'N/A'}): $message';

  bool get isUnauthorized => code == 'UNAUTHORIZED';
  bool get isTimeout => code == 'TIMEOUT';
  bool get isRateLimited => code == 'RATE_LIMITED';
}
