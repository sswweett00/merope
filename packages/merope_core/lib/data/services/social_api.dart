import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import 'exceptions.dart';

final socialApiServiceProvider = Provider<SocialApiService>((ref) {
  return SocialApiService(ApiClient().dio);
});

class ApiModels {
  static const String contentTypeSocial = 'social';
  static const String contentTypeVideo = 'video';
  static const String contentTypeStory = 'story';
}

class SignalModel {
  final String id;
  final String authorId;
  final String authorUsername;
  final String authorAvatarUrl;
  final String contentText;
  final List<String> mediaUrls;
  final List<String> hashtags;
  final int likeCount;
  final int commentCount;
  final int repostCount;
  final int resonanceCount;
  final bool isLiked;
  final bool isReposted;
  final bool isPinned;
  final bool isOwned;
  final int createdAt;

  const SignalModel({
    required this.id,
    required this.authorId,
    required this.authorUsername,
    this.authorAvatarUrl = '',
       required this.contentText,
    this.mediaUrls = const [],
    this.hashtags = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.repostCount = 0,
    this.resonanceCount = 0,
    this.isLiked = false,
    this.isReposted = false,
    this.isPinned = false,
    this.isOwned = false,
    required this.createdAt,
  });

  factory SignalModel.fromJson(Map<String, dynamic> json) {
    return SignalModel(
      id: json['id'] as String? ?? '',
      authorId: json['author_id'] as String? ?? '',
      authorUsername: json['author_username'] as String? ?? '',
      authorAvatarUrl: json['author_avatar_url'] as String? ?? '',
      contentText: json['content_text'] as String? ?? '',
      mediaUrls: (json['media_urls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      hashtags: (json['hashtags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      repostCount: json['repost_count'] as int? ?? 0,
      resonanceCount: json['resonance_count'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      isReposted: json['is_reposted'] as bool? ?? false,
      isPinned: json['is_pinned'] as bool? ?? false,
      isOwned: json['is_owned'] as bool? ?? false,
      createdAt: json['created_at'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'author_id': authorId,
    'author_username': authorUsername,
    'author_avatar_url': authorAvatarUrl,
          'content_text': contentText,
    'media_urls': mediaUrls,
    'hashtags': hashtags,
    'like_count': likeCount,
    'comment_count': commentCount,
    'repost_count': repostCount,
    'resonance_count': resonanceCount,
    'is_liked': isLiked,
    'is_reposted': isReposted,
    'is_pinned': isPinned,
    'is_owned': isOwned,
    'created_at': createdAt,
  };
}

class UserModel {
  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final int? followerCount;
  final int? followingCount;
  final int? postCount;
  final bool isFollowing;
  final bool isFollowedBy;
  final bool isVerified;

  // Gamification (v10.2)
  final int xp;
  final int level;
  final int streak;
  final String? frequency;
  final String? reputationTier;

  final int createdAt;

  const UserModel({
    required this.id,
    required this.username,
    this.displayName = '',
    this.avatarUrl,
    this.bio,
    this.followerCount,
    this.followingCount,
    this.postCount,
    this.isFollowing = false,
    this.isFollowedBy = false,
    this.isVerified = false,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.frequency,
    this.reputationTier = 'Novice',
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String? ?? '',
    username: json['username'] as String? ?? '',
    displayName: json['display_name'] as String? ?? json['username'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String?,
    bio: json['bio'] as String?,
    followerCount: json['follower_count'] as int?,
    followingCount: json['following_count'] as int?,
    postCount: json['post_count'] as int?,
    isFollowing: json['is_following'] as bool? ?? false,
    isFollowedBy: json['is_followed_by'] as bool? ?? false,
    isVerified: json['is_verified'] as bool? ?? false,
    xp: json['xp'] as int? ?? 0,
    level: json['level'] as int? ?? 1,
    streak: json['streak'] as int? ?? 0,
    frequency: json['frequency'] as String?,
    reputationTier: json['reputation_tier'] as String? ?? 'Novice',
    createdAt: json['created_at'] as int? ?? 0,
  );
}

class SocialApiService {
  final Dio _dio;

  SocialApiService(this._dio);

  Future<ApiResult<List<SignalModel>>> getTimeline({
    int limit = 20,
    String? before,
    String? after,
    FeedType type = FeedType.explore,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v10/content/feed',
        queryParameters: {
          'limit': limit,
          if (before != null) 'before': before,
          if (after != null) 'after': after,
          'feed_type': type.name,
        },
      );

      final data = response.data['items'] as List<dynamic>;
      final signals = data.map((e) => SignalModel.fromJson(e as Map<String, dynamic>)).toList();
      return ApiResult.success(signals, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<SignalModel>> createPost({
    required String contentText,
    List<String> mediaUrls = const [],
    List<String> hashtags = const [],
    PostPrivacy privacy = PostPrivacy.public,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v10/content/posts',
        data: {
          'content_text': contentText,
          'media_urls': mediaUrls,
          'hashtags': hashtags,
          'privacy': privacy.name,
        },
      );

      if (response.statusCode == 201) {
        final signal = SignalModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResult.success(signal, statusCode: response.statusCode);
      }
      return ApiResult.error('Failed to create post', statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<void>> likePost(String postId) async {
    try {
      final response = await _dio.post('/api/v10/content/posts/$postId/resonance', data: {'amplitude': 1});
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to like post', statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<void>> unlikePost(String postId) async {
    try {
      final response = await _dio.delete('/api/v10/content/posts/$postId/resonance');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to unlike post', statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<UserModel>> followUser(String userId) async {
    try {
      final response = await _dio.post('/api/v10/social/follow/$userId');
      if (response.statusCode == 200) {
        return ApiResult.success(UserModel.fromJson(response.data as Map<String, dynamic>), statusCode: response.statusCode);
      }
      return ApiResult.error('Failed to follow user', statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<void>> unfollowUser(String userId) async {
    try {
      final response = await _dio.delete('/api/v10/social/follow/$userId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to unfollow user', statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<List<UserModel>>> searchUsers({
    String query = '',
    int limit = 20,
    double? lat,
    double? lon,
  }) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'limit': limit,
          if (lat != null) 'lat': lat,
          if (lon != null) 'lon': lon,
        },
      );

      final data = response.data as List<dynamic>;
      final users = data.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
      return ApiResult.success(users, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<List<UserModel>>> getNearbyUsers({
    double lat = 0,
    double lon = 0,
    int radius = 5000,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/search/nearby',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'radius': radius,
          'limit': limit,
        },
      );

      final data = response.data as List<dynamic>;
      final users = data.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
      return ApiResult.success(users, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<void>> tipSignal(String signalId, int amount) async {
    try {
      final response = await _dio.post(
        '/api/v10/lumia/tip',
        data: {'signal_id': signalId, 'amount': amount},
      );
      if (response.statusCode == 200) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to send energy wave', statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString(), statusCode: null);
    }
  }

  Future<ApiResult<UserModel>> getProfile(String userId) async {
    try {
      final response = await _dio.get('/api/v10/social/profile/$userId');
      return ApiResult.success(UserModel.fromJson(response.data as Map<String, dynamic>));
    } catch (e) {
      return ApiResult.error(e);
    }
  }

  Future<ApiResult<UserModel>> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/v10/auth/me');
      return ApiResult.success(UserModel.fromJson(response.data as Map<String, dynamic>));
    } catch (e) {
      return ApiResult.error(e);
    }
  }
}

enum FeedType { explore, following, trending, forYou }
enum PostPrivacy { public, private, friendsOnly, circle }
