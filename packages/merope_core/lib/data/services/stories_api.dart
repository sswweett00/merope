import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_core/data/services/exceptions.dart';
import 'package:merope_models/stories/story_model.dart';

class StoriesApiService {
  final ApiClient _apiClient;

  StoriesApiService(this._apiClient);

  Future<ApiResult<List<Story>>> getFeed(
      {int limit = 20, String? cursor}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/stories/feed',
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
          'limit': limit,
        },
      );

      final data = response.data;
      if (data == null) return ApiResult.error('No response from server');

      final storiesJson = data['stories'] as List<dynamic>? ?? [];
      final stories = storiesJson
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(stories, statusCode: response.statusCode);
    } on MeropeAPIException catch (e) {
      return ApiResult.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<Story>> getStory(String userId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/stories/user/$userId',
      );

      final data = response.data;
      if (data == null) return ApiResult.error('No response from server');

      return ApiResult.success(
        Story.fromJson(data),
        statusCode: response.statusCode,
      );
    } on MeropeAPIException catch (e) {
      return ApiResult.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<void>> markStoryViewed(String storyId) async {
    try {
      await _apiClient.post('/stories/$storyId/view');
      return const ApiResult.success(null);
    } on MeropeAPIException catch (e) {
      return ApiResult.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<void>> sendReaction(String storyId, String emoji) async {
    try {
      await _apiClient.post(
        '/stories/$storyId/react',
        data: {'emoji': emoji},
      );
      return const ApiResult.success(null);
    } on MeropeAPIException catch (e) {
      return ApiResult.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<String>> uploadStoryMedia(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/stories/upload',
        data: formData,
      );

      final data = response.data;
      if (data == null) return ApiResult.error('No response from server');
      final url = data['url'] as String?;
      if (url == null) return ApiResult.error('Missing media url');
      return ApiResult.success(url, statusCode: response.statusCode);
    } on MeropeAPIException catch (e) {
      return ApiResult.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<List<StoryUser>>> getStoryViewers(String storyId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/stories/$storyId/viewers',
      );

      final data = response.data;
      if (data == null) return ApiResult.error('No response from server');

      final viewersJson = data['viewers'] as List<dynamic>? ?? [];
      final viewers = viewersJson
          .map((e) => StoryUser.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(viewers, statusCode: response.statusCode);
    } on MeropeAPIException catch (e) {
      return ApiResult.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }
}

final storiesApiServiceProvider = Provider<StoriesApiService>((ref) {
  return StoriesApiService(ApiClient());
});
