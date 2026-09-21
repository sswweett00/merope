import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_models/social/post_model.dart';
import './api_models.dart';
import './exceptions.dart';

class SearchResult {
  final List<UserProfile> users;
  final List<MeropeSignal> posts;
  final String? nextCursor;

  const SearchResult({
    required this.users,
    required this.posts,
    this.nextCursor,
  });
}

class SocialApiService {
  final ApiClient _apiClient;

  SocialApiService(this._apiClient);

  Future<SocialFeedState> getTimeline({String? cursor, int limit = 20}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (cursor != null) queryParams['cursor'] = cursor;
      queryParams['limit'] = limit;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/social/timeline',
        queryParameters: queryParams,
      );

      if (response.isError) {
        return SocialFeedState(error: _errorMessage(response.error));
      }
      final data = response.data;
      if (data == null) {
        return const SocialFeedState(error: 'Empty response from server');
      }

      final items = (data['items'] as List?)
              ?.map((e) => MeropeSignal.fromJson(e))
              .toList() ??
          [];

      return SocialFeedState(
        items: items,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? true,
      );
    } on MeropeAPIException catch (e) {
      return SocialFeedState(error: e.message);
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
        '/social/posts',
        data: {
          'content': content,
          'media_urls': mediaUrls ?? [],
          'title': title,
          'sub_community_id': subCommunityId,
          'layers': layers ?? [],
          'cards': cards ?? [],
        },
      );

      if (response.isError) {
        return SocialPostActionResult(
          success: false,
          error: _errorMessage(response.error),
        );
      }
      final data = response.data;
      if (data == null) {
        return SocialPostActionResult(
          success: false,
          error: 'No response from server',
        );
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
        '/social/posts/$postId',
        data: {
          'content': content,
          'media_urls': mediaUrls ?? [],
          'title': title,
        },
      );

      if (response.isError) {
        return SocialPostActionResult(
          success: false,
          error: _errorMessage(response.error),
        );
      }
      final data = response.data;
      if (data == null) {
        return SocialPostActionResult(
          success: false,
          error: 'No response from server',
        );
      }

      final post = MeropeSignal.fromJson(data);
      return SocialPostActionResult(success: true, post: post);
    } on MeropeAPIException catch (e) {
      return SocialPostActionResult(success: false, error: e.message);
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      final response = await _apiClient.delete<void>('/social/posts/$postId');
      return !response.isError;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  Future<SocialPostActionResult> likePost(String postId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/social/posts/$postId/like',
      );

      final data = response.data;
      if (data == null) {
        return SocialPostActionResult(
            success: false, error: 'No response from server');
      }

      final post = MeropeSignal.fromJson(data);
      return SocialPostActionResult(success: true, post: post);
    } on MeropeAPIException catch (e) {
      return SocialPostActionResult(success: false, error: e.message);
    }
  }

  Future<bool> unlikePost(String postId) async {
    try {
      final response = await _apiClient.delete<void>('/social/posts/$postId/like');
      return !response.isError;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  Future<SocialPostActionResult> repostPost(String postId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/social/posts/$postId/repost',
      );

      final data = response.data;
      if (data == null) {
        return SocialPostActionResult(
            success: false, error: 'No response from server');
      }

      final post = MeropeSignal.fromJson(data);
      return SocialPostActionResult(success: true, post: post);
    } on MeropeAPIException catch (e) {
      return SocialPostActionResult(success: false, error: e.message);
    }
  }

  Future<bool> bookmarkPost(String postId) async {
    throw UnsupportedError(
      'Bookmarking posts is not exposed by the active backend contract',
    );
  }

  Future<bool> unbookmarkPost(String postId) async {
    throw UnsupportedError(
      'Bookmarking posts is not exposed by the active backend contract',
    );
  }

  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/social/profile/$userId',
      );

      final data = response.data;
      if (data == null) {
        throw const MeropeAPIException(message: 'Failed to load user profile');
      }

      return UserProfile.fromJson(data);
    } on MeropeAPIException {
      rethrow;
    } catch (e) {
      throw MeropeAPIException(message: e.toString());
    }
  }

  Future<SearchResult> searchUsers(String query,
      {int limit = 20, String? cursor}) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        'limit': limit,
      };
      if (cursor != null) queryParams['cursor'] = cursor;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/social/search/users',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data == null) {
        return SearchResult(users: [], posts: []);
      }

      final users = (data['users'] as List?)
              ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      final postsJson = data['posts'] as List? ?? [];
      final posts = postsJson.map((e) => MeropeSignal.fromJson(e)).toList();

      return SearchResult(
        users: users,
        posts: posts,
        nextCursor: data['next_cursor'] as String?,
      );
    } on MeropeAPIException catch (e) {
      throw MeropeAPIException(message: e.message);
    }
  }

  Future<bool> followUser(String userId) async {
    try {
      final response = await _apiClient.post<void>('/social/follow/$userId');
      return !response.isError;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  Future<bool> unfollowUser(String userId) async {
    try {
      final response = await _apiClient.post<void>('/social/unfollow/$userId');
      return !response.isError;
    } on MeropeAPIException catch (_) {
      return false;
    }
  }

  Future<List<UserProfile>> getFollowers(String userId,
      {int limit = 20, String? cursor}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (cursor != null) queryParams['cursor'] = cursor;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/social/followers/$userId',
        queryParameters: queryParams,
      );

      if (response.isError) return [];
      final data = response.data;
      if (data == null) return [];

      final users = (data['users'] as List?)
              ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      return users;
    } on MeropeAPIException catch (_) {
      return [];
    }
  }

  Future<List<UserProfile>> getFollowing(String userId,
      {int limit = 20, String? cursor}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (cursor != null) queryParams['cursor'] = cursor;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/social/following/$userId',
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data == null) return [];

      final users = (data['users'] as List?)
              ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      return users;
    } on MeropeAPIException catch (_) {
      return [];
    }
  }

  Future<ApiResult<void>> tipSignal(String signalId, int amount) async {
    try {
      await _apiClient.post(
        '/lumia/tip',
        data: {'signal_id': signalId, 'amount': amount},
      );
      return const ApiResult.success(null);
    } on MeropeAPIException catch (e) {
      return ApiResult.error(e);
    }
  }
}

  String _errorMessage(dynamic error) {
    if (error is MeropeAPIException) return error.message;
    return error?.toString() ?? 'Request failed';
  }


final socialApiServiceProvider = Provider<SocialApiService>((ref) {
  return SocialApiService(ApiClient());
});
