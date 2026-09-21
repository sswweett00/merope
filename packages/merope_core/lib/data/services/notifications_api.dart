import 'package:dio/dio.dart';
import '../services/exceptions.dart';
import '../services/api_client.dart';

class NotificationModel {
  final String id;
  final String type;
  final String? actorId;
  final String? actorName;
  final String? actorAvatar;
  final String? targetId;
  final String? targetType;
  final String? content;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final bool isSeen;
  final int createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    this.actorId,
    this.actorName,
    this.actorAvatar,
    this.targetId,
    this.targetType,
    this.content,
    this.metadata,
    this.isRead = false,
    this.isSeen = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt = json['created_at'] ?? json['createdAt'];
    final createdAt = rawCreatedAt is num
        ? rawCreatedAt.toInt()
        : int.tryParse(rawCreatedAt?.toString() ?? '') ??
            (DateTime.tryParse(rawCreatedAt?.toString() ?? '')
                    ?.millisecondsSinceEpoch ??
                0);

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'generic',
      actorId: (json['actor_id'] ?? json['senderId'])?.toString(),
      actorName: (json['actor_name'] ?? json['senderUsername'])?.toString(),
      actorAvatar: (json['actor_avatar'] ?? json['senderAvatar'])?.toString(),
      targetId: (json['target_id'] ?? json['entityId'])?.toString(),
      targetType: (json['target_type'] ?? json['entityType'])?.toString(),
      content: (json['content'] ?? json['body'] ?? json['title'])?.toString(),
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : json['data'] is Map
              ? Map<String, dynamic>.from(json['data'] as Map)
              : null,
      isRead: (json['is_read'] ?? json['isRead']) as bool? ?? false,
      isSeen: (json['is_seen'] ?? json['isSeen']) as bool? ?? false,
      createdAt: createdAt,
    );
  }
}

class NotificationApiService {
  final Dio _dio;

  NotificationApiService(this._dio);

  Future<ApiResult<List<NotificationModel>>> getNotifications({
    int limit = 20,
    int offset = 0,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v10/notifications/activity',
        queryParameters: {
          'page': offset ~/ limit,
          if (unreadOnly) 'unread_only': true,
        },
      );

      final raw = response.data;
      final data = raw is Map<String, dynamic>
          ? (raw['notifications'] as List<dynamic>? ?? const [])
          : (raw as List<dynamic>? ?? const []);
      final notifications = data
          .whereType<Map>()
          .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return ApiResult.success(notifications, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<void>> markNotificationRead(String notificationId) async {
    try {
      final response =
          await _dio.post('/api/v10/notifications/$notificationId/read');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to mark as read',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<int>> getUnreadCount() async {
    try {
      final response = await _dio.get('/api/v10/notifications/unread-count');
      if (response.statusCode == 200) {
        return ApiResult.success(response.data['count'] as int,
            statusCode: response.statusCode);
      }
      return ApiResult.error('Failed to get unread count',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }
}

class AnalyticsApiService {
  final Dio _dio;

  AnalyticsApiService(this._dio);

  Future<ApiResult<List<dynamic>>> getUserAnalytics({int days = 7}) async {
    try {
      final response = await _dio
          .get('/api/v10/analytics/dashboard', queryParameters: {'days': days});
      if (response.statusCode == 200) {
        return ApiResult.success(response.data as List<dynamic>,
            statusCode: response.statusCode);
      }
      return ApiResult.error('Failed to get analytics',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }
}
