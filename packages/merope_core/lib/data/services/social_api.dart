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
    final author = json['author'] is Map
        ? Map<String, dynamic>.from(json['author'] as Map)
        : const <String, dynamic>{};
    final rawMedia = json['media'] as List<dynamic>?;
    final mediaUrls = <String>[];
    for (final item in rawMedia ?? const <dynamic>[]) {
      if (item is Map) {
        final url = item['url']?.toString();
        if (url != null && url.isNotEmpty) mediaUrls.add(url);
      } else if (item != null) {
        mediaUrls.add(item.toString());
      }
    }

    final rawResonances = json['resonances'] as List<dynamic>?;
    var resonanceCount = (json['resonance_count'] as num?)?.toInt() ?? 0;
    var isLiked = json['is_liked'] as bool? ?? false;
    if (rawResonances != null) {
      resonanceCount = rawResonances.length;
      isLiked = rawResonances
          .any((item) => item is Map && item['is_resonated'] == true);
    }

    final createdAt = json['created_at'];
    final createdAtValue = createdAt is num
        ? createdAt.toInt()
        : int.tryParse(createdAt?.toString() ?? '') ?? 0;

    return SignalModel(
      id: json['id']?.toString() ?? '',
      authorId: (json['author_id'] ?? author['id'])?.toString() ?? '',
      authorUsername:
          (json['author_username'] ?? author['username'])?.toString() ?? '',
      authorAvatarUrl:
          (json['author_avatar_url'] ?? author['avatar_url'])?.toString() ?? '',
      contentText: (json['content_text'] ?? json['content'])?.toString() ?? '',
      mediaUrls: (json['media_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          mediaUrls,
      hashtags: (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      likeCount: (json['like_count'] as num?)?.toInt() ??
          ((json['resonances'] as List<dynamic>?)?.length ?? 0),
      commentCount: (json['comment_count'] as num?)?.toInt() ??
          (json['node_count'] as num?)?.toInt() ??
          0,
      repostCount: (json['repost_count'] as num?)?.toInt() ??
          (json['amplification_count'] as num?)?.toInt() ??
          0,
      resonanceCount: resonanceCount,
      isLiked: isLiked,
      isReposted: json['is_reposted'] as bool? ?? false,
      isPinned: json['is_pinned'] as bool? ?? false,
      isOwned: json['is_owned'] as bool? ?? false,
      createdAt: createdAtValue,
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
        id: json['id']?.toString() ?? '',
        username: json['username']?.toString() ?? '',
        displayName: json['display_name']?.toString() ??
            json['username']?.toString() ??
            '',
        avatarUrl: json['avatar_url']?.toString(),
        bio: json['bio']?.toString(),
        followerCount: (json['follower_count'] as num?)?.toInt(),
        followingCount: (json['following_count'] as num?)?.toInt(),
        postCount: (json['post_count'] as num?)?.toInt(),
        isFollowing: json['is_following'] as bool? ?? false,
        isFollowedBy: json['is_followed_by'] as bool? ?? false,
        isVerified: json['is_verified'] as bool? ?? false,
        xp: (json['xp'] as num?)?.toInt() ?? 0,
        level: (json['level'] as num?)?.toInt() ?? 1,
        streak: (json['streak'] as num?)?.toInt() ?? 0,
        frequency: json['frequency']?.toString(),
        reputationTier: json['reputation_tier']?.toString() ?? 'Novice',
        createdAt: (json['created_at'] as num?)?.toInt() ??
            int.tryParse(json['created_at']?.toString() ?? '') ??
            0,
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
      final data = response.data['items'] as List<dynamic>? ?? const [];
      final signals = data
          .whereType<Map>()
          .map((e) => SignalModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return ApiResult.success(signals, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
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
          'text': contentText,
          'media': mediaUrls,
          if (hashtags.isNotEmpty) 'hashtags': hashtags,
          'visibility': _visibilityFor(privacy),
        },
      );
      if (response.statusCode == 201 && response.data is Map) {
        return ApiResult.success(
          SignalModel.fromJson(Map<String, dynamic>.from(response.data as Map)),
          statusCode: response.statusCode,
        );
      }
      return ApiResult.error('Failed to create post',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  Future<ApiResult<void>> likePost(String postId) async {
    try {
      final response = await _dio.post('/api/v10/content/posts/$postId/like');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to like post',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  Future<ApiResult<void>> unlikePost(String postId) async {
    try {
      final response = await _dio.delete('/api/v10/content/posts/$postId/like');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to unlike post',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  Future<ApiResult<void>> followUser(String userId) async {
    try {
      final response = await _dio.post('/api/v10/social/follow/$userId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to follow user',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  Future<ApiResult<void>> unfollowUser(String userId) async {
    try {
      final response = await _dio.post('/api/v10/social/unfollow/$userId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResult.success(null, statusCode: 200);
      }
      return ApiResult.error('Failed to unfollow user',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
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
        '/api/v10/social/search/users',
        queryParameters: {
          'q': query,
          'limit': limit,
          if (lat != null) 'lat': lat,
          if (lon != null) 'lon': lon,
        },
      );
      final data = response.data is Map
          ? response.data['users'] as List<dynamic>? ?? const []
          : response.data as List<dynamic>? ?? const [];
      final users = data
          .whereType<Map>()
          .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return ApiResult.success(users, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
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
        '/api/v10/search/nearby',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'radius': radius / 1000,
          'limit': limit,
        },
      );
      final raw = response.data is Map
          ? response.data['nearby'] as List<dynamic>? ?? const []
          : const <dynamic>[];
      final users = raw
          .whereType<Map>()
          .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return ApiResult.success(users, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(
        MeropeAPIException.fromDioError(e),
        statusCode: e.response?.statusCode,
      );
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
      return ApiResult.error('Failed to send energy wave',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  Future<ApiResult<UserModel>> getProfile(String userId) async {
    try {
      final response = await _dio.get('/api/v10/social/profile/$userId');
      return ApiResult.success(
        UserModel.fromJson(Map<String, dynamic>.from(response.data as Map)),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  Future<ApiResult<UserModel>> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/v10/auth/me');
      return ApiResult.success(
        UserModel.fromJson(Map<String, dynamic>.from(response.data as Map)),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResult.error(MeropeAPIException.fromDioError(e),
          statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}

String _visibilityFor(PostPrivacy privacy) {
  switch (privacy) {
    case PostPrivacy.public:
      return 'public';
    case PostPrivacy.private:
      return 'private';
    case PostPrivacy.friendsOnly:
    case PostPrivacy.circle:
      return 'followers';
  }
}

enum FeedType { explore, following, trending, forYou }

enum PostPrivacy { public, private, friendsOnly, circle }
