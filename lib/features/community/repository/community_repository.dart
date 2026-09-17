import '../domain/models/community_model.dart';

abstract class ICommunityRepository {
  Future<List<Community>> getCommunities({int limit = 20, int offset = 0});
  Future<Community?> getCommunity(String communityId);
  Future<void> createCommunity(Community community);
  Future<void> joinCommunity(String communityId);
  Future<void> leaveCommunity(String communityId);
  Future<void> updateCommunitySettings(String communityId, CommunitySettings settings);
  Future<void> updateCommunityGuidelines(String communityId, List<CommunityGuideline> guidelines);

  Future<List<CommunityEvent>> getCommunityEvents(String communityId, {int limit = 10, int offset = 0});
  Future<List<CommunityEvent>> getUpcomingEvents({int limit = 10, int offset = 0});
  Future<void> createEvent(CommunityEvent event);
  Future<void> rsvpEvent(String eventId, String status);
  Future<void> cancelEvent(String eventId);

  Future<List<Collective>> getCollectives({int limit = 20, int offset = 0});
  Future<void> createCollective(Collective collective);
  Future<void> joinCollective(String collectiveId);

  Future<List<CollectiveThread>> getThreads(String collectiveId, {int limit = 20, int offset = 0});
  Future<void> createThread(CollectiveThread thread);
  Future<void> resonateThread(String threadId, int delta);
  Future<void> createThreadReply(ThreadReply reply);
  Future<void> pinThread(String threadId, bool pinned);
  Future<void> lockThread(String threadId, bool locked);

  Future<List<CommunityMember>> getCommunityMembers(String communityId, {int limit = 50, int offset = 0});
  Future<void> updateMemberRole(String communityId, String memberId, String role);
  Future<void> banMember(String communityId, String memberId, String reason);
  Future<void> unbanMember(String communityId, String memberId);

  Future<List<Subscription>> getUserSubscriptions();
  Future<void> createSubscription(String creatorId, String tier);
  Future<void> cancelSubscription(String subscriptionId);
  Future<void> updateSubscriptionTier(String subscriptionId, String tier);

  Future<CommunityAnalytics?> getCommunityAnalytics(String communityId, String period);
}
