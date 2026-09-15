import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_models/social/post_model.dart';
import './api_models.dart';
import './exceptions.dart';

class ContentFeedState {
  final List<MeropeSignal> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? nextCursor;
  final String? error;

  const ContentFeedState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.nextCursor,
    this.error,
  });
}

class ContentAnalytics {
  final int totalViews;
  final int totalLikes;
  final int totalComments;
  final int totalShares;
  final int totalBookmarks;
  final double engagementRate;
  final List<ContentMetric> dailyMetrics;

  const ContentAnalytics({
    required this.totalViews,
    required this.totalLikes,
    required this.totalComments,
    required this.totalShares,
    required this.totalBookmarks,
    required this.engagementRate,
    required this.dailyMetrics,
  });

  factory ContentAnalytics.fromJson(Map<String, dynamic> json) => ContentAnalytics(
    totalViews: json['totalViews'] as int? ?? 0,
    totalLikes: json['totalLikes'] as int? ?? 0,
    totalComments: json['totalComments'] as int? ?? 0,
    totalShares: json['totalShares'] as int? ?? 0,
    totalBookmarks: json['totalBookmarks'] as int? ?? 0,
    engagementRate: (json['engagementRate'] as num?)?.toDouble() ?? 0.0,
    dailyMetrics: (json['dailyMetrics'] as List?)?.map((e) => ContentMetric.fromJson(e)).toList() ?? [],
  );
}

class ContentMetric {
  final String date;
  final int views;
  final int likes;
  final int comments;
  final int shares;

  const ContentMetric({
    required this.date,
    required this.views,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  factory ContentMetric.fromJson(Map<String, dynamic> json) => ContentMetric(
    date: json['date'] as String? ?? '',
    views: json['views'] as int? ?? 0,
    likes: json['likes'] as int? ?? 0,
    comments: json['comments'] as int? ?? 0,
    shares: json['shares'] as int? ?? 0,
  );
}

class MediaUploadResult {
  final bool success;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? mediaId;
  final String? error;

  const MediaUploadResult({
    required this.success,
    this.mediaUrl,
    this.thumbnailUrl,
    this.mediaId,
    this.error,
  });
}

class CommentResult {
  final bool success;
  final Map<String, dynamic>? comment;
  final String? error;

  const CommentResult({
    required this.success,
    this.comment,
    this.error,
  });
}

class ContentApiService {
  final ApiClient _apiClient;

  ContentApiService(this._apiClient);

  Future<ContentFeedState> getFeed({
    String? cursor,
    int limit = 20,
    String? feedType,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (cursor != null) queryParams['cursor'] = cursor;
      if (feedType != null) queryParams['feed_type'] = feedType;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v10/content/feed',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data == null) {
        return const ContentFeedState();
      }

      final items = (data['items'] as List?)
              ?.map((e) => MeropeSignal.fromJson(e))
              .toList() ??
          [];

      return ContentFeedState(
        items: items,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? true,
      );
    } on MeropeAPIException catch (e) {
      return ContentFeedState(error: e.message);
    }
  }

  Future<ContentFeedState> getPostComments(
    String postId, {
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (cursor != null) queryParams['cursor'] = cursor;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v10/content/posts/$postId/comments',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data == null) {
        return const ContentFeedState();
      }

      final items = (data['comments'] as List?)
              ?.map((e) => MeropeSignal.fromJson(e))
              .toList() ??
          [];

      return ContentFeedState(
        items: items,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? true,
      );
    } on MeropeAPIException catch (e) {
      return ContentFeedState(error: e.message);
    }
  }

  Future<CommentResult> addComment(String postId, String content) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v10/content/posts/$postId/comments',
        data: {'content': content},
      );

      final data = response.data;
      if (data == null) {
        return CommentResult(success: false, error: 'No response from server');
      }

      return CommentResult(success: true, comment: data);
    } on MeropeAPIException catch (e) {
      return CommentResult(success: false, error: e.message);
    }
  }

  Future<bool> deleteComment(String postId, String commentId) async {
    try {
      await _apiClient.delete('/api/v10/content/posts/$postId/comments/$commentId');
      return true;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  Future<SocialPostActionResult> likePost(String postId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v10/content/posts/$postId/like',
      );

      final data = response.data;
      if (data == null) {
        return SocialPostActionResult(success: false, error: 'No response from server');
      }

      final post = MeropeSignal.fromJson(data);
      return SocialPostActionResult(success: true, post: post);
    } on MeropeAPIException catch (e) {
      return SocialPostActionResult(success: false, error: e.message);
    }
  }

  Future<bool> unlikePost(String postId) async {
    try {
      await _apiClient.delete('/api/v10/content/posts/$postId/like');
      return true;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  Future<SocialPostActionResult> repostPost(String postId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v10/content/posts/$postId/repost',
      );

      final data = response.data;
      if (data == null) {
        return SocialPostActionResult(success: false, error: 'No response from server');
      }

      final post = MeropeSignal.fromJson(data);
      return SocialPostActionResult(success: true, post: post);
    } on MeropeAPIException catch (e) {
      return SocialPostActionResult(success: false, error: e.message);
    }
  }

  Future<ContentAnalytics> getContentAnalytics(String postId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v10/content/posts/$postId/analytics',
      );

      final data = response.data;
      if (data == null) {
        throw const MeropeAPIException(message: 'Failed to load analytics');
      }

      return ContentAnalytics.fromJson(data);
    } on MeropeAPIException catch (_) {
      rethrow;
    } catch (e) {
      throw MeropeAPIException(message: e.toString());
    }
  }

  Future<MediaUploadResult> uploadMedia(
    String filePath, {
    String? mediaType,
    Function(int sent, int total)? onProgress,
  }) async {
    try {
      final fileName = filePath.split('/').last;
      final mimeType = mediaType ?? _getMimeType(fileName);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: http_parser.MediaType.parse(mimeType),
        ),
      });

      final response = await _apiClient.uploadMultipart(
        '/api/v10/content/media/upload',
        formData,
        onSendProgress: onProgress,
      );

      final data = response.data;
      if (data == null) {
        return MediaUploadResult(success: false, error: 'No response from server');
      }

      return MediaUploadResult(
        success: true,
        mediaUrl: data['url'] as String?,
        thumbnailUrl: data['thumbnail_url'] as String?,
        mediaId: data['media_id'] as String?,
      );
    } on MeropeAPIException catch (e) {
      return MediaUploadResult(success: false, error: e.message);
    }
  }

  Future<MediaUploadResult> uploadMediaFromBytes(
    Uint8List bytes, {
    required String fileName,
    String? mediaType,
    Function(int sent, int total)? onProgress,
  }) async {
    try {
      final mimeType = mediaType ?? _getMimeType(fileName);

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: http_parser.MediaType.parse(mimeType),
        ),
      });

      final response = await _apiClient.uploadMultipart(
        '/api/v10/content/media/upload',
        formData,
        onSendProgress: onProgress,
      );

      final data = response.data;
      if (data == null) {
        return MediaUploadResult(success: false, error: 'No response from server');
      }

      return MediaUploadResult(
        success: true,
        mediaUrl: data['url'] as String?,
        thumbnailUrl: data['thumbnail_url'] as String?,
        mediaId: data['media_id'] as String?,
      );
    } on MeropeAPIException catch (e) {
      return MediaUploadResult(success: false, error: e.message);
    }
  }

  Future<SocialPostActionResult> createPost({
    required String content,
    List<String>? mediaUrls,
    String? title,
    String? subCommunityId,
    List<Map<String, dynamic>>? layers,
    List<Map<String, dynamic>>? cards,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v10/content/posts',
        data: {
          'content': content,
          'media_urls': mediaUrls ?? [],
          'title': title,
          'sub_community_id': subCommunityId,
          'layers': layers ?? [],
          'cards': cards ?? [],
        },
      );

      final data = response.data;
      if (data == null) {
        return SocialPostActionResult(success: false, error: 'No response from server');
      }

      final post = MeropeSignal.fromJson(data);
      return SocialPostActionResult(success: true, post: post);
    } on MeropeAPIException catch (e) {
      return SocialPostActionResult(success: false, error: e.message);
    }
  }

  Future<SocialPostActionResult> updatePost({
    required String postId,
    required String content,
    List<String>? mediaUrls,
    String? title,
  }) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/api/v10/content/posts/$postId',
        data: {
          'content': content,
          'media_urls': mediaUrls ?? [],
          'title': title,
        },
      );

      final data = response.data;
      if (data == null) {
        return SocialPostActionResult(success: false, error: 'No response from server');
      }

      final post = MeropeSignal.fromJson(data);
      return SocialPostActionResult(success: true, post: post);
    } on MeropeAPIException catch (e) {
      return SocialPostActionResult(success: false, error: e.message);
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      await _apiClient.delete('/api/v10/content/posts/$postId');
      return true;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  String _getMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'webm':
        return 'video/webm';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}

final contentApiServiceProvider = Provider<ContentApiService>((ref) {
  return ContentApiService(ApiClient());
});
