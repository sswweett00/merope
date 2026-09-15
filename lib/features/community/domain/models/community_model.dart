enum CommunityRole { admin, moderator, contributor, member, guest, owner }
enum EventStatus { draft, published, cancelled, completed }
enum SubscriptionStatus { active, cancelled, expired, pastDue }
enum ProposalStatus { active, accepted, rejected, expired }

class CommunityProposal {
  final String id;
  final String communityId;
  final String title;
  final String description;
  final ProposalStatus status;
  final int votesYes;
  final int votesNo;
  final DateTime endsAt;
  final DateTime createdAt;

  const CommunityProposal({
    required this.id,
    required this.communityId,
    required this.title,
    required this.description,
    required this.status,
    this.votesYes = 0,
    this.votesNo = 0,
    required this.endsAt,
    required this.createdAt,
  });

  factory CommunityProposal.fromJson(Map<String, dynamic> json) => CommunityProposal(
    id: json['id'] as String,
    communityId: json['communityId'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    status: ProposalStatus.values.firstWhere(
      (e) => e.name == (json['status'] as String? ?? 'active'),
      orElse: () => ProposalStatus.active,
    ),
    votesYes: json['votesYes'] as int? ?? 0,
    votesNo: json['votesNo'] as int? ?? 0,
    endsAt: DateTime.parse(json['endsAt'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

class CommunitySettings {
  final bool allowGuestPosts;
  final bool requireModeration;
  final bool enableVoiceChat;
  final bool enableVideoChat;
  final bool enableScreenShare;
  final int maxMembers;
  final int autoDeleteAfterDays;
  final String contentFilterLevel;
  final String language;
  final String timezone;

  const CommunitySettings({
    this.allowGuestPosts = false,
    this.requireModeration = false,
    this.enableVoiceChat = true,
    this.enableVideoChat = true,
    this.enableScreenShare = true,
    this.maxMembers = 10000,
    this.autoDeleteAfterDays = 0,
    this.contentFilterLevel = 'medium',
    this.language = 'en',
    this.timezone = 'UTC',
  });

  factory CommunitySettings.fromJson(Map<String, dynamic> json) => CommunitySettings(
    allowGuestPosts: json['allowGuestPosts'] as bool? ?? false,
    requireModeration: json['requireModeration'] as bool? ?? false,
    enableVoiceChat: json['enableVoiceChat'] as bool? ?? true,
    enableVideoChat: json['enableVideoChat'] as bool? ?? true,
    enableScreenShare: json['enableScreenShare'] as bool? ?? true,
    maxMembers: json['maxMembers'] as int? ?? 10000,
    autoDeleteAfterDays: json['autoDeleteAfterDays'] as int? ?? 0,
    contentFilterLevel: json['contentFilterLevel'] as String? ?? 'medium',
    language: json['language'] as String? ?? 'en',
    timezone: json['timezone'] as String? ?? 'UTC',
  );

  Map<String, dynamic> toJson() => {
    'allowGuestPosts': allowGuestPosts,
    'requireModeration': requireModeration,
    'enableVoiceChat': enableVoiceChat,
    'enableVideoChat': enableVideoChat,
    'enableScreenShare': enableScreenShare,
    'maxMembers': maxMembers,
    'autoDeleteAfterDays': autoDeleteAfterDays,
    'contentFilterLevel': contentFilterLevel,
    'language': language,
    'timezone': timezone,
  };
}

class CommunityStats {
  final int dailyActiveUsers;
  final int weeklyActiveUsers;
  final int monthlyActiveUsers;
  final int totalPosts;
  final int totalComments;
  final int totalEvents;
  final double avgEngagementScore;
  final int reportCount;
  final int warningCount;

  const CommunityStats({
    this.dailyActiveUsers = 0,
    this.weeklyActiveUsers = 0,
    this.monthlyActiveUsers = 0,
    this.totalPosts = 0,
    this.totalComments = 0,
    this.totalEvents = 0,
    this.avgEngagementScore = 0.0,
    this.reportCount = 0,
    this.warningCount = 0,
  });

  factory CommunityStats.fromJson(Map<String, dynamic> json) => CommunityStats(
    dailyActiveUsers: json['dailyActiveUsers'] as int? ?? 0,
    weeklyActiveUsers: json['weeklyActiveUsers'] as int? ?? 0,
    monthlyActiveUsers: json['monthlyActiveUsers'] as int? ?? 0,
    totalPosts: json['totalPosts'] as int? ?? 0,
    totalComments: json['totalComments'] as int? ?? 0,
    totalEvents: json['totalEvents'] as int? ?? 0,
    avgEngagementScore: (json['avgEngagementScore'] as num?)?.toDouble() ?? 0.0,
    reportCount: json['reportCount'] as int? ?? 0,
    warningCount: json['warningCount'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'dailyActiveUsers': dailyActiveUsers,
    'weeklyActiveUsers': weeklyActiveUsers,
    'monthlyActiveUsers': monthlyActiveUsers,
    'totalPosts': totalPosts,
    'totalComments': totalComments,
    'totalEvents': totalEvents,
    'avgEngagementScore': avgEngagementScore,
    'reportCount': reportCount,
    'warningCount': warningCount,
  };
}

class CommunityMember {
  final String id;
  final String communityId;
  final String userId;
  final String username;
  final String? avatarUrl;
  final CommunityRole role;
  final DateTime joinedAt;
  final bool isActive;
  final DateTime lastActiveAt;
  final int postCount;
  final int commentCount;
  final int reputation;
  final List<String> badges;

  const CommunityMember({
    required this.id,
    required this.communityId,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
    required this.isActive,
    required this.lastActiveAt,
    this.postCount = 0,
    this.commentCount = 0,
    this.reputation = 0,
    this.badges = const [],
  });

  factory CommunityMember.fromJson(Map<String, dynamic> json) => CommunityMember(
    id: json['id'] as String,
    communityId: json['communityId'] as String,
    userId: json['userId'] as String,
    username: json['username'] as String,
    avatarUrl: json['avatarUrl'] as String?,
    role: CommunityRole.values.firstWhere(
      (e) => e.name == (json['role'] as String? ?? 'member'),
      orElse: () => CommunityRole.member,
    ),
    joinedAt: DateTime.parse(json['joinedAt'] as String),
    isActive: json['isActive'] as bool? ?? false,
    lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
    postCount: json['postCount'] as int? ?? 0,
    commentCount: json['commentCount'] as int? ?? 0,
    reputation: json['reputation'] as int? ?? 0,
    badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'communityId': communityId,
    'userId': userId,
    'username': username,
    'avatarUrl': avatarUrl,
    'role': role.name,
    'joinedAt': joinedAt.toIso8601String(),
    'isActive': isActive,
    'lastActiveAt': lastActiveAt.toIso8601String(),
    'postCount': postCount,
    'commentCount': commentCount,
    'reputation': reputation,
    'badges': badges,
  };
}

class EventTicketInfo {
  final bool isRequired;
  final double price;
  final String currency;
  final int availableTickets;
  final int soldTickets;
  final DateTime? earlyBirdUntil;

  const EventTicketInfo({
    this.isRequired = false,
    this.price = 0.0,
    this.currency = 'USD',
    this.availableTickets = 0,
    this.soldTickets = 0,
    this.earlyBirdUntil,
  });

  factory EventTicketInfo.fromJson(Map<String, dynamic> json) => EventTicketInfo(
    isRequired: json['isRequired'] as bool? ?? false,
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    currency: json['currency'] as String? ?? 'USD',
    availableTickets: json['availableTickets'] as int? ?? 0,
    soldTickets: json['soldTickets'] as int? ?? 0,
    earlyBirdUntil: json['earlyBirdUntil'] != null ? DateTime.parse(json['earlyBirdUntil'] as String) : null,
  );

  Map<String, dynamic> toJson() => {
    'isRequired': isRequired,
    'price': price,
    'currency': currency,
    'availableTickets': availableTickets,
    'soldTickets': soldTickets,
    'earlyBirdUntil': earlyBirdUntil?.toIso8601String(),
  };
}

class CommunityEvent {
  final String id;
  final String creatorId;
  final String? communityId;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String locationName;
  final double? latitude;
  final double? longitude;
  final String locationUrl;
  final int maxAttendees;
  final int currentAttendees;
  final bool isPublic;
  final bool isRecurring;
  final String recurrencePattern;
  final String imageUrl;
  final EventStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EventTicketInfo ticketInfo;

  const CommunityEvent({
    required this.id,
    required this.creatorId,
    this.communityId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.locationName,
    this.latitude,
    this.longitude,
    this.locationUrl = '',
    this.maxAttendees = 0,
    this.currentAttendees = 0,
    this.isPublic = true,
    this.isRecurring = false,
    this.recurrencePattern = '',
    this.imageUrl = '',
    this.status = EventStatus.draft,
    required this.createdAt,
    required this.updatedAt,
    required this.ticketInfo,
  });

  factory CommunityEvent.fromJson(Map<String, dynamic> json) => CommunityEvent(
    id: json['id'] as String,
    creatorId: json['creatorId'] as String,
    communityId: json['communityId'] as String?,
    title: json['title'] as String,
    description: json['description'] as String,
    startTime: DateTime.parse(json['startTime'] as String),
    endTime: DateTime.parse(json['endTime'] as String),
    locationName: json['locationName'] as String,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    locationUrl: json['locationUrl'] as String? ?? '',
    maxAttendees: json['maxAttendees'] as int? ?? 0,
    currentAttendees: json['currentAttendees'] as int? ?? 0,
    isPublic: json['isPublic'] as bool? ?? true,
    isRecurring: json['isRecurring'] as bool? ?? false,
    recurrencePattern: json['recurrencePattern'] as String? ?? '',
    imageUrl: json['imageUrl'] as String? ?? '',
    status: EventStatus.values.firstWhere(
      (e) => e.name == (json['status'] as String? ?? 'draft'),
      orElse: () => EventStatus.draft,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    ticketInfo: EventTicketInfo.fromJson(json['ticketInfo'] as Map<String, dynamic>? ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'creatorId': creatorId,
    'communityId': communityId,
    'title': title,
    'description': description,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'locationName': locationName,
    'latitude': latitude,
    'longitude': longitude,
    'locationUrl': locationUrl,
    'maxAttendees': maxAttendees,
    'currentAttendees': currentAttendees,
    'isPublic': isPublic,
    'isRecurring': isRecurring,
    'recurrencePattern': recurrencePattern,
    'imageUrl': imageUrl,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'ticketInfo': ticketInfo.toJson(),
  };
}

class CollectiveStats {
  final int totalThreads;
  final int totalReplies;
  final int activeMembers;
  final int weeklyActivity;

  const CollectiveStats({
    this.totalThreads = 0,
    this.totalReplies = 0,
    this.activeMembers = 0,
    this.weeklyActivity = 0,
  });

  factory CollectiveStats.fromJson(Map<String, dynamic> json) => CollectiveStats(
    totalThreads: json['totalThreads'] as int? ?? 0,
    totalReplies: json['totalReplies'] as int? ?? 0,
    activeMembers: json['activeMembers'] as int? ?? 0,
    weeklyActivity: json['weeklyActivity'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'totalThreads': totalThreads,
    'totalReplies': totalReplies,
    'activeMembers': activeMembers,
    'weeklyActivity': weeklyActivity,
  };
}

class Collective {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String icon;
  final String bannerUrl;
  final int nodeCount;
  final double influence;
  final int memberCount;
  final bool isOfficial;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CollectiveStats stats;
  final CommunityRole userRole;

  const Collective({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.icon,
    this.bannerUrl = '',
    this.nodeCount = 0,
    this.influence = 0.0,
    this.memberCount = 0,
    this.isOfficial = false,
    this.category = 'general',
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
    this.userRole = CommunityRole.member,
  });

  factory Collective.fromJson(Map<String, dynamic> json) => Collective(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
    description: json['description'] as String,
    icon: json['icon'] as String,
    bannerUrl: json['bannerUrl'] as String? ?? '',
    nodeCount: json['nodeCount'] as int? ?? 0,
    influence: (json['influence'] as num?)?.toDouble() ?? 0.0,
    memberCount: json['memberCount'] as int? ?? 0,
    isOfficial: json['isOfficial'] as bool? ?? false,
    category: json['category'] as String? ?? 'general',
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    stats: CollectiveStats.fromJson(json['stats'] as Map<String, dynamic>? ?? {}),
    userRole: CommunityRole.values.firstWhere(
      (e) => e.name == (json['userRole'] as String? ?? 'member'),
      orElse: () => CommunityRole.member,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'icon': icon,
    'bannerUrl': bannerUrl,
    'nodeCount': nodeCount,
    'influence': influence,
    'memberCount': memberCount,
    'isOfficial': isOfficial,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'stats': stats.toJson(),
    'userRole': userRole.name,
  };
}

class ThreadReply {
  final String id;
  final String threadId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final int resonance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEdited;
  final String? parentId;

  const ThreadReply({
    required this.id,
    required this.threadId,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.resonance = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isEdited = false,
    this.parentId,
  });

  factory ThreadReply.fromJson(Map<String, dynamic> json) => ThreadReply(
    id: json['id'] as String,
    threadId: json['threadId'] as String,
    authorId: json['authorId'] as String,
    authorName: json['authorName'] as String,
    authorAvatar: json['authorAvatar'] as String?,
    content: json['content'] as String,
    resonance: json['resonance'] as int? ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    isEdited: json['isEdited'] as bool? ?? false,
    parentId: json['parentId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'threadId': threadId,
    'authorId': authorId,
    'authorName': authorName,
    'authorAvatar': authorAvatar,
    'content': content,
    'resonance': resonance,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isEdited': isEdited,
    'parentId': parentId,
  };
}

class CollectiveThread {
  final String id;
  final String collectiveId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String title;
  final String content;
  final int resonance;
  final int viewCount;
  final int replyCount;
  final bool isPinned;
  final bool isLocked;
  final bool isAnnouncement;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String category;

  const CollectiveThread({
    required this.id,
    required this.collectiveId,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.title,
    required this.content,
    this.resonance = 0,
    this.viewCount = 0,
    this.replyCount = 0,
    this.isPinned = false,
    this.isLocked = false,
    this.isAnnouncement = false,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.category = 'general',
  });

  factory CollectiveThread.fromJson(Map<String, dynamic> json) => CollectiveThread(
    id: json['id'] as String,
    collectiveId: json['collectiveId'] as String,
    authorId: json['authorId'] as String,
    authorName: json['authorName'] as String,
    authorAvatar: json['authorAvatar'] as String?,
    title: json['title'] as String,
    content: json['content'] as String,
    resonance: json['resonance'] as int? ?? 0,
    viewCount: json['viewCount'] as int? ?? 0,
    replyCount: json['replyCount'] as int? ?? 0,
    isPinned: json['isPinned'] as bool? ?? false,
    isLocked: json['isLocked'] as bool? ?? false,
    isAnnouncement: json['isAnnouncement'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    category: json['category'] as String? ?? 'general',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'collectiveId': collectiveId,
    'authorId': authorId,
    'authorName': authorName,
    'authorAvatar': authorAvatar,
    'title': title,
    'content': content,
    'resonance': resonance,
    'viewCount': viewCount,
    'replyCount': replyCount,
    'isPinned': isPinned,
    'isLocked': isLocked,
    'isAnnouncement': isAnnouncement,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'tags': tags,
    'category': category,
  };
}

class Subscription {
  final String id;
  final String creatorId;
  final String subscriberId;
  final String tier;
  final double amount;
  final String currency;
  final SubscriptionStatus status;
  final DateTime startedAt;
  final DateTime expiresAt;
  final bool autoRenew;
  final List<String> benefits;

  const Subscription({
    required this.id,
    required this.creatorId,
    required this.subscriberId,
    required this.tier,
    required this.amount,
    required this.currency,
    required this.status,
    required this.startedAt,
    required this.expiresAt,
    this.autoRenew = true,
    this.benefits = const [],
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json['id'] as String,
    creatorId: json['creatorId'] as String,
    subscriberId: json['subscriberId'] as String,
    tier: json['tier'] as String,
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    currency: json['currency'] as String,
    status: SubscriptionStatus.values.firstWhere(
      (e) => e.name == (json['status'] as String? ?? 'active'),
      orElse: () => SubscriptionStatus.active,
    ),
    startedAt: DateTime.parse(json['startedAt'] as String),
    expiresAt: DateTime.parse(json['expiresAt'] as String),
    autoRenew: json['autoRenew'] as bool? ?? true,
    benefits: (json['benefits'] as List<dynamic>?)?.cast<String>() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'creatorId': creatorId,
    'subscriberId': subscriberId,
    'tier': tier,
    'amount': amount,
    'currency': currency,
    'status': status.name,
    'startedAt': startedAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'autoRenew': autoRenew,
    'benefits': benefits,
  };
}

class ContentReport {
  final String id;
  final String reporterId;
  final String reporterName;
  final String contentType;
  final String contentId;
  final String reason;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String resolution;

  const ContentReport({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.contentType,
    required this.contentId,
    required this.reason,
    required this.description,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.resolvedBy,
    this.resolution = '',
  });

  factory ContentReport.fromJson(Map<String, dynamic> json) => ContentReport(
    id: json['id'] as String,
    reporterId: json['reporterId'] as String,
    reporterName: json['reporterName'] as String,
    contentType: json['contentType'] as String,
    contentId: json['contentId'] as String,
    reason: json['reason'] as String,
    description: json['description'] as String,
    status: json['status'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt'] as String) : null,
    resolvedBy: json['resolvedBy'] as String?,
    resolution: json['resolution'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'reporterId': reporterId,
    'reporterName': reporterName,
    'contentType': contentType,
    'contentId': contentId,
    'reason': reason,
    'description': description,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'resolvedAt': resolvedAt?.toIso8601String(),
    'resolvedBy': resolvedBy,
    'resolution': resolution,
  };
}

class CommunityGuideline {
  final String id;
  final String communityId;
  final String title;
  final String description;
  final int order;
  final bool isActive;
  final DateTime createdAt;

  const CommunityGuideline({
    required this.id,
    required this.communityId,
    required this.title,
    required this.description,
    required this.order,
    this.isActive = true,
    required this.createdAt,
  });

  factory CommunityGuideline.fromJson(Map<String, dynamic> json) => CommunityGuideline(
    id: json['id'] as String,
    communityId: json['communityId'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    order: json['order'] as int,
    isActive: json['isActive'] as bool? ?? true,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'communityId': communityId,
    'title': title,
    'description': description,
    'order': order,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };
}

class CommunityAnalytics {
  final String communityId;
  final String period;
  final int memberCount;
  final int newMembers;
  final int activeMembers;
  final int postCount;
  final int commentCount;
  final int eventCount;
  final double engagementRate;
  final double avgSessionTime;
  final List<String> topContent;

  const CommunityAnalytics({
    required this.communityId,
    required this.period,
    required this.memberCount,
    required this.newMembers,
    required this.activeMembers,
    required this.postCount,
    required this.commentCount,
    required this.eventCount,
    required this.engagementRate,
    required this.avgSessionTime,
    this.topContent = const [],
  });

  factory CommunityAnalytics.fromJson(Map<String, dynamic> json) => CommunityAnalytics(
    communityId: json['communityId'] as String,
    period: json['period'] as String,
    memberCount: json['memberCount'] as int,
    newMembers: json['newMembers'] as int,
    activeMembers: json['activeMembers'] as int,
    postCount: json['postCount'] as int,
    commentCount: json['commentCount'] as int,
    eventCount: json['eventCount'] as int,
    engagementRate: (json['engagementRate'] as num?)?.toDouble() ?? 0.0,
    avgSessionTime: (json['avgSessionTime'] as num?)?.toDouble() ?? 0.0,
    topContent: (json['topContent'] as List<dynamic>?)?.cast<String>() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'communityId': communityId,
    'period': period,
    'memberCount': memberCount,
    'newMembers': newMembers,
    'activeMembers': activeMembers,
    'postCount': postCount,
    'commentCount': commentCount,
    'eventCount': eventCount,
    'engagementRate': engagementRate,
    'avgSessionTime': avgSessionTime,
    'topContent': topContent,
  };
}

class Community {
  final String id;
  final String ownerId;
  final String name;
  final String slug;
  final String description;
  final String avatarUrl;
  final String bannerUrl;
  final bool isPrivate;
  final bool isVerified;
  final int memberCount;
  final int postCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final List<String> tags;
  final List<String> rules;
  final CommunitySettings settings;
  final CommunityStats stats;
  final bool isJoined;
  final CommunityRole userRole;

  const Community({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.slug,
    required this.description,
    this.avatarUrl = '',
    this.bannerUrl = '',
    this.isPrivate = false,
    this.isVerified = false,
    this.memberCount = 0,
    this.postCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.category = 'general',
    this.tags = const [],
    this.rules = const [],
    required this.settings,
    required this.stats,
    this.isJoined = false,
    this.userRole = CommunityRole.member,
  });

  factory Community.fromJson(Map<String, dynamic> json) => Community(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
    description: json['description'] as String,
    avatarUrl: json['avatarUrl'] as String? ?? '',
    bannerUrl: json['bannerUrl'] as String? ?? '',
    isPrivate: json['isPrivate'] as bool? ?? false,
    isVerified: json['isVerified'] as bool? ?? false,
    memberCount: json['memberCount'] as int? ?? 0,
    postCount: json['postCount'] as int? ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    category: json['category'] as String? ?? 'general',
    tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    rules: (json['rules'] as List<dynamic>?)?.cast<String>() ?? [],
    settings: CommunitySettings.fromJson(json['settings'] as Map<String, dynamic>? ?? {}),
    stats: CommunityStats.fromJson(json['stats'] as Map<String, dynamic>? ?? {}),
    isJoined: json['isJoined'] as bool? ?? false,
    userRole: CommunityRole.values.firstWhere(
      (e) => e.name == (json['userRole'] as String? ?? 'member'),
      orElse: () => CommunityRole.member,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'ownerId': ownerId,
    'name': name,
    'slug': slug,
    'description': description,
    'avatarUrl': avatarUrl,
    'bannerUrl': bannerUrl,
    'isPrivate': isPrivate,
    'isVerified': isVerified,
    'memberCount': memberCount,
    'postCount': postCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'category': category,
    'tags': tags,
    'rules': rules,
    'settings': settings.toJson(),
    'stats': stats.toJson(),
    'isJoined': isJoined,
    'userRole': userRole.name,
  };
}
