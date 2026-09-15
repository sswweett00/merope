import 'package:merope_models/social/post_model.dart';

class SocialFeedState {
  final List<MeropeSignal> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? nextCursor;
  final String? error;

  const SocialFeedState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.nextCursor,
    this.error,
  });
}

class SocialPostActionResult {
  final bool success;
  final MeropeSignal? post;
  final String? error;

  const SocialPostActionResult({
    required this.success,
    this.post,
    this.error,
  });
}

class UserProfile {
  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isFollowing;
  final bool isVerified;
  final double influenceScore;
  final DateTime? joinedAt;

  const UserProfile({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isFollowing = false,
    this.isVerified = false,
    this.influenceScore = 0.0,
    this.joinedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String? ?? '',
    username: json['username'] as String? ?? '',
    displayName: json['display_name'] as String? ?? json['username'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String?,
    bio: json['bio'] as String?,
    followersCount: json['followers_count'] as int? ?? 0,
    followingCount: json['following_count'] as int? ?? 0,
    postsCount: json['posts_count'] as int? ?? 0,
    isFollowing: json['is_following'] as bool? ?? false,
    isVerified: json['is_verified'] as bool? ?? false,
    influenceScore: (json['influence_score'] as num?)?.toDouble() ?? 0.0,
    joinedAt: json['joined_at'] != null ? DateTime.parse(json['joined_at'] as String) : null,
  );
}
