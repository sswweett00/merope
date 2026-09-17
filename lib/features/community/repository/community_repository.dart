import 'package:drift/drift.dart';
import 'package:merope_core/data/database/merope_database.dart' as db;
import '../domain/models/community_model.dart';

abstract class ICommunityRepository {
  // Communities
  Future<List<Community>> getCommunities({int limit = 20, int offset = 0});
  Future<Community?> getCommunity(String communityId);
  Future<void> createCommunity(Community community);
  Future<void> joinCommunity(String communityId);
  Future<void> leaveCommunity(String communityId);
  Future<void> updateCommunitySettings(
      String communityId, CommunitySettings settings);
  Future<void> updateCommunityGuidelines(
      String communityId, List<CommunityGuideline> guidelines);

  // Events
  Future<List<CommunityEvent>> getCommunityEvents(String communityId,
      {int limit = 10, int offset = 0});
  Future<List<CommunityEvent>> getUpcomingEvents(
      {int limit = 10, int offset = 0});
  Future<void> createEvent(CommunityEvent event);
  Future<void> rsvpEvent(String eventId, String status);
  Future<void> cancelEvent(String eventId);

  // Collectives
  Future<List<Collective>> getCollectives({int limit = 20, int offset = 0});
  Future<void> createCollective(Collective collective);
  Future<void> joinCollective(String collectiveId);

  // Threads
  Future<List<CollectiveThread>> getThreads(String collectiveId,
      {int limit = 20, int offset = 0});
  Future<void> createThread(CollectiveThread thread);
  Future<void> resonateThread(String threadId, int delta);
  Future<void> createThreadReply(ThreadReply reply);
  Future<void> pinThread(String threadId, bool pinned);
  Future<void> lockThread(String threadId, bool locked);

  // Members
  Future<List<CommunityMember>> getCommunityMembers(String communityId,
      {int limit = 50, int offset = 0});
  Future<void> updateMemberRole(
      String communityId, String memberId, String role);
  Future<void> banMember(String communityId, String memberId, String reason);
  Future<void> unbanMember(String communityId, String memberId);

  // Subscriptions
  Future<List<Subscription>> getUserSubscriptions();
  Future<void> createSubscription(String creatorId, String tier);
  Future<void> cancelSubscription(String subscriptionId);
  Future<void> updateSubscriptionTier(String subscriptionId, String tier);

  // Analytics
  Future<CommunityAnalytics?> getCommunityAnalytics(
      String communityId, String period);
}

class DriftCommunityRepository implements ICommunityRepository {
  final db.MeropeDatabase _db;
  final String _userId;

  DriftCommunityRepository(this._db, {String userId = 'me'}) : _userId = userId;

  @override
  Future<List<Community>> getCommunities(
      {int limit = 20, int offset = 0}) async {
    final rows = await (_db.select(_db.subCommunities)
          ..limit(limit, offset: offset))
        .get();

    return rows
        .map((row) => Community(
              id: row.id,
              ownerId: row.ownerId,
              name: row.name,
              slug: row.slug,
              description: row.description,
              avatarUrl: row.avatarUrl ?? '',
              bannerUrl: row.bannerUrl ?? '',
              isPrivate: row.isPrivate,
              isVerified: row.isVerified,
              memberCount: 0,
              postCount: 0,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              settings: const CommunitySettings(),
              stats: const CommunityStats(),
              isJoined: true,
              userRole: CommunityRole.member,
            ))
        .toList();
  }

  @override
  Future<Community?> getCommunity(String communityId) async {
    final row = await (_db.select(_db.subCommunities)
          ..where((t) => t.id.equals(communityId)))
        .getSingleOrNull();
    if (row == null) return null;

    return Community(
      id: row.id,
      ownerId: row.ownerId,
      name: row.name,
      slug: row.slug,
      description: row.description,
      avatarUrl: row.avatarUrl ?? '',
      bannerUrl: row.bannerUrl ?? '',
      isPrivate: row.isPrivate,
      isVerified: row.isVerified,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      settings: const CommunitySettings(),
      stats: const CommunityStats(),
    );
  }

  @override
  Future<void> createCommunity(Community community) async {
    await _db.into(_db.subCommunities).insert(
          db.SubCommunitiesCompanion.insert(
            id: community.id,
            name: community.name,
            description: community.description,
            slug: community.slug,
            ownerId: community.ownerId,
            avatarUrl: Value(community.avatarUrl),
            bannerUrl: Value(community.bannerUrl),
            isPrivate: Value(community.isPrivate),
            isVerified: Value(community.isVerified),
            createdAt: community.createdAt,
            updatedAt: community.updatedAt,
          ),
        );
  }

  @override
  Future<void> joinCommunity(String communityId) async {
    await _db.into(_db.communityMembers).insert(
          db.CommunityMembersCompanion.insert(
            id: '${communityId}_$_userId',
            communityId: communityId,
            userId: _userId,
            role: 'member',
            joinedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> leaveCommunity(String communityId) async {
    await (_db.delete(_db.communityMembers)
          ..where((t) =>
              t.communityId.equals(communityId) & t.userId.equals(_userId)))
        .go();
  }

  @override
  Future<void> updateCommunitySettings(
      String communityId, CommunitySettings settings) async {
    // Placeholder for settings persistence if needed
  }

  @override
  Future<void> updateCommunityGuidelines(
      String communityId, List<CommunityGuideline> guidelines) async {
    // Guidelines persistence logic
  }

  @override
  Future<List<CommunityEvent>> getCommunityEvents(String communityId,
      {int limit = 10, int offset = 0}) async {
    final rows = await (_db.select(_db.communityEvents)
          ..where((t) => t.communityId.equals(communityId))
          ..limit(limit, offset: offset))
        .get();
    return rows
        .map((row) => CommunityEvent(
              id: row.id,
              creatorId: row.creatorId,
              communityId: row.communityId ?? '',
              title: row.title,
              description: row.description,
              startTime: row.startTime,
              endTime: row.endTime,
              locationName: row.locationName ?? '',
              latitude: row.latitude,
              longitude: row.longitude,
              status: EventStatus.values.firstWhere((e) => e.name == row.status,
                  orElse: () => EventStatus.draft),
              createdAt: row.createdAt,
              updatedAt: row.createdAt,
              ticketInfo: const EventTicketInfo(),
            ))
        .toList();
  }

  @override
  Future<List<CommunityEvent>> getUpcomingEvents(
      {int limit = 10, int offset = 0}) async {
    final rows = await (_db.select(_db.communityEvents)
          ..where((t) => t.startTime.isBiggerThanValue(DateTime.now()))
          ..limit(limit, offset: offset))
        .get();
    return rows
        .map((row) => CommunityEvent(
              id: row.id,
              creatorId: row.creatorId,
              communityId: row.communityId ?? '',
              title: row.title,
              description: row.description,
              startTime: row.startTime,
              endTime: row.endTime,
              locationName: row.locationName ?? '',
              status: EventStatus.values.firstWhere((e) => e.name == row.status,
                  orElse: () => EventStatus.draft),
              createdAt: row.createdAt,
              updatedAt: row.createdAt,
              ticketInfo: const EventTicketInfo(),
            ))
        .toList();
  }

  @override
  Future<void> createEvent(CommunityEvent event) async {
    await _db.into(_db.communityEvents).insert(
          db.CommunityEventsCompanion.insert(
            id: event.id,
            communityId: Value(event.communityId),
            creatorId: event.creatorId,
            title: event.title,
            description: event.description,
            startTime: event.startTime,
            endTime: event.endTime,
            locationName: Value(event.locationName),
            latitude: Value(event.latitude),
            longitude: Value(event.longitude),
            status: event.status.name,
            createdAt: event.createdAt,
          ),
        );
  }

  @override
  Future<void> rsvpEvent(String eventId, String status) async {
    // RSVP persistence
  }

  @override
  Future<void> cancelEvent(String eventId) async {
    await (_db.update(_db.communityEvents)..where((t) => t.id.equals(eventId)))
        .write(db.CommunityEventsCompanion(
            status: Value(EventStatus.cancelled.name)));
  }

  @override
  Future<List<Collective>> getCollectives(
      {int limit = 20, int offset = 0}) async {
    final rows =
        await (_db.select(_db.collectives)..limit(limit, offset: offset)).get();
    return rows
        .map((row) => Collective(
              id: row.id,
              name: row.name,
              slug: row.slug,
              description: row.description,
              icon: row.icon ?? '',
              category: row.category,
              createdAt: row.createdAt,
              updatedAt: row.createdAt,
              stats: const CollectiveStats(),
            ))
        .toList();
  }

  @override
  Future<void> createCollective(Collective collective) async {
    await _db.into(_db.collectives).insert(
          db.CollectivesCompanion.insert(
            id: collective.id,
            name: collective.name,
            slug: collective.slug,
            description: collective.description,
            icon: Value(collective.icon),
            category: collective.category,
            createdAt: collective.createdAt,
          ),
        );
  }

  @override
  Future<void> joinCollective(String collectiveId) async {
    // Join collective logic
  }

  @override
  Future<List<CollectiveThread>> getThreads(String collectiveId,
      {int limit = 20, int offset = 0}) async {
    final rows = await (_db.select(_db.collectiveThreads)
          ..where((t) => t.collectiveId.equals(collectiveId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ])
          ..limit(limit, offset: offset))
        .get();
    return rows
        .map((row) => CollectiveThread(
              id: row.id,
              collectiveId: row.collectiveId,
              authorId: row.authorId,
              authorName: row.authorName,
              authorAvatar: row.authorAvatar ?? '',
              title: row.title,
              content: row.content,
              resonance: row.resonance,
              isPinned: row.isPinned,
              isLocked: row.isLocked,
              createdAt: row.createdAt,
              updatedAt: row.createdAt,
            ))
        .toList();
  }

  @override
  Future<void> createThread(CollectiveThread thread) async {
    await _db.into(_db.collectiveThreads).insert(
          db.CollectiveThreadsCompanion.insert(
            id: thread.id,
            collectiveId: thread.collectiveId,
            authorId: thread.authorId,
            authorName: thread.authorName,
            authorAvatar: Value(thread.authorAvatar),
            title: thread.title,
            content: thread.content,
            resonance: Value(thread.resonance),
            isPinned: Value(thread.isPinned),
            isLocked: Value(thread.isLocked),
            createdAt: thread.createdAt,
          ),
        );
  }

  @override
  Future<void> resonateThread(String threadId, int delta) async {
    final thread = await (_db.select(_db.collectiveThreads)
          ..where((t) => t.id.equals(threadId)))
        .getSingleOrNull();
    if (thread != null) {
      await (_db.update(_db.collectiveThreads)
            ..where((t) => t.id.equals(threadId)))
          .write(db.CollectiveThreadsCompanion(
              resonance: Value(thread.resonance + delta)));
    }
  }

  @override
  Future<void> createThreadReply(ThreadReply reply) async {
    await _db.into(_db.threadReplies).insert(
          db.ThreadRepliesCompanion.insert(
            id: reply.id,
            threadId: reply.threadId,
            authorId: reply.authorId,
            authorName: reply.authorName,
            authorAvatar: Value(reply.authorAvatar),
            content: reply.content,
            resonance: Value(reply.resonance),
            createdAt: reply.createdAt,
          ),
        );
  }

  @override
  Future<void> pinThread(String threadId, bool pinned) async {
    await (_db.update(_db.collectiveThreads)
          ..where((t) => t.id.equals(threadId)))
        .write(db.CollectiveThreadsCompanion(isPinned: Value(pinned)));
  }

  @override
  Future<void> lockThread(String threadId, bool locked) async {
    await (_db.update(_db.collectiveThreads)
          ..where((t) => t.id.equals(threadId)))
        .write(db.CollectiveThreadsCompanion(isLocked: Value(locked)));
  }

  @override
  Future<List<CommunityMember>> getCommunityMembers(String communityId,
      {int limit = 50, int offset = 0}) async {
    final rows = await (_db.select(_db.communityMembers)
          ..where((t) => t.communityId.equals(communityId))
          ..limit(limit, offset: offset))
        .get();
    return rows
        .map((row) => CommunityMember(
              id: row.id,
              communityId: row.communityId,
              userId: row.userId,
              username: 'User ${row.userId}',
              role: CommunityRole.values.firstWhere((e) => e.name == row.role,
                  orElse: () => CommunityRole.member),
              joinedAt: row.joinedAt,
              isActive: true,
              lastActiveAt: DateTime.now(),
            ))
        .toList();
  }

  @override
  Future<void> updateMemberRole(
      String communityId, String memberId, String role) async {
    await (_db.update(_db.communityMembers)
          ..where(
              (t) => t.communityId.equals(communityId) & t.id.equals(memberId)))
        .write(db.CommunityMembersCompanion(role: Value(role)));
  }

  @override
  Future<void> banMember(
      String communityId, String memberId, String reason) async {
    // Ban logic
  }

  @override
  Future<void> unbanMember(String communityId, String memberId) async {
    // Unban logic
  }

  @override
  Future<List<Subscription>> getUserSubscriptions() async {
    return [];
  }

  @override
  Future<void> createSubscription(String creatorId, String tier) async {}

  @override
  Future<void> cancelSubscription(String subscriptionId) async {}

  @override
  Future<void> updateSubscriptionTier(
      String subscriptionId, String tier) async {}

  @override
  Future<CommunityAnalytics?> getCommunityAnalytics(
      String communityId, String period) async {
    return null;
  }
}
