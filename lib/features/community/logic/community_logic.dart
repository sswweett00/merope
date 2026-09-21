import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/community_model.dart';
import '../repository/community_repository.dart';
import '../data/repositories/community_remote_repository.dart';
import 'package:merope_core/data/services/api_client.dart';

final communityRepositoryProvider = Provider<ICommunityRepository>((ref) {
  return ApiCommunityRepository();
});

// Community List Controller
class CommunityController extends AsyncNotifier<List<Community>> {
  String? _query;

  @override
  FutureOr<List<Community>> build() async {
    final repo = ref.watch(communityRepositoryProvider);
    final all = await repo.getCommunities();
    if (_query == null || _query!.isEmpty) return all;
    return all
        .where((c) =>
            c.name.toLowerCase().contains(_query!.toLowerCase()) ||
            c.description.toLowerCase().contains(_query!.toLowerCase()))
        .toList();
  }

  void search(String query) {
    _query = query;
    ref.invalidateSelf();
  }

  Future<void> join(String communityId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.joinCommunity(communityId);
    try {
      await ApiClient().post<void>(
        '/progression/events',
        data: {'action': 'community_joined', 'source_id': communityId},
      );
    } catch (_) {}
    ref.invalidateSelf();
  }

  Future<void> leave(String communityId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.leaveCommunity(communityId);
    ref.invalidateSelf();
  }

  Future<void> createCommunity(Community community) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.createCommunity(community);
    ref.invalidateSelf();
  }
}

final communityControllerProvider =
    AsyncNotifierProvider<CommunityController, List<Community>>(
        CommunityController.new);

// Community Detail Controller
class CommunityDetailController extends AsyncNotifier<Community?> {
  String? _communityId;

  @override
  FutureOr<Community?> build() async {
    if (_communityId == null) return null;
    final repo = ref.watch(communityRepositoryProvider);
    return await repo.getCommunity(_communityId!);
  }

  void setCommunityId(String id) {
    _communityId = id;
    ref.invalidateSelf();
  }

  Future<void> updateSettings(CommunitySettings settings) async {
    if (_communityId == null) return;
    final repo = ref.read(communityRepositoryProvider);
    await repo.updateCommunitySettings(_communityId!, settings);
    ref.invalidateSelf();
  }

  Future<void> updateGuidelines(List<CommunityGuideline> guidelines) async {
    if (_communityId == null) return;
    final repo = ref.read(communityRepositoryProvider);
    await repo.updateCommunityGuidelines(_communityId!, guidelines);
    ref.invalidateSelf();
  }
}

final communityDetailControllerProvider =
    AsyncNotifierProvider<CommunityDetailController, Community?>(
        CommunityDetailController.new);

// Event Controller
class EventController extends AsyncNotifier<List<CommunityEvent>> {
  String? _communityId;

  @override
  FutureOr<List<CommunityEvent>> build() async {
    final repo = ref.watch(communityRepositoryProvider);
    if (_communityId != null) {
      return await repo.getCommunityEvents(_communityId!);
    }
    return await repo.getUpcomingEvents();
  }

  void setCommunityId(String? id) {
    _communityId = id;
    ref.invalidateSelf();
  }

  Future<void> createEvent(CommunityEvent event) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.createEvent(event);
    ref.invalidateSelf();
  }

  Future<void> rsvp(String eventId, String status) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.rsvpEvent(eventId, status);
    if (status == 'attending') {
      try {
        await ApiClient().post<void>(
          '/progression/events',
          data: {'action': 'community_event_rsvp', 'source_id': eventId},
        );
      } catch (_) {}
    }
    ref.invalidateSelf();
  }

  Future<void> cancelEvent(String eventId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.cancelEvent(eventId);
    ref.invalidateSelf();
  }
}

final eventControllerProvider =
    AsyncNotifierProvider<EventController, List<CommunityEvent>>(
        EventController.new);

// Collective Controller
class CollectiveController extends AsyncNotifier<List<Collective>> {
  @override
  FutureOr<List<Collective>> build() async {
    final repo = ref.watch(communityRepositoryProvider);
    return await repo.getCollectives();
  }

  Future<void> createCollective(Collective collective) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.createCollective(collective);
    ref.invalidateSelf();
  }

  Future<void> joinCollective(String collectiveId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.joinCollective(collectiveId);
    ref.invalidateSelf();
  }
}

final collectiveControllerProvider =
    AsyncNotifierProvider<CollectiveController, List<Collective>>(
        CollectiveController.new);

// Thread Controller
class ThreadController extends AsyncNotifier<List<CollectiveThread>> {
  String? _collectiveId;

  @override
  FutureOr<List<CollectiveThread>> build() async {
    if (_collectiveId == null) return [];
    final repo = ref.watch(communityRepositoryProvider);
    return await repo.getThreads(_collectiveId!);
  }

  void setCollectiveId(String id) {
    _collectiveId = id;
    ref.invalidateSelf();
  }

  Future<void> createThread(CollectiveThread thread) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.createThread(thread);
    ref.invalidateSelf();
  }

  Future<void> resonate(String threadId, bool isPositive) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.resonateThread(threadId, isPositive ? 1 : -1);
    ref.invalidateSelf();
  }

  Future<void> replyToThread(ThreadReply reply) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.createThreadReply(reply);
    ref.invalidateSelf();
  }

  Future<void> pinThread(String threadId, bool pinned) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.pinThread(threadId, pinned);
    ref.invalidateSelf();
  }

  Future<void> lockThread(String threadId, bool locked) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.lockThread(threadId, locked);
    ref.invalidateSelf();
  }
}

final threadControllerProvider =
    AsyncNotifierProvider<ThreadController, List<CollectiveThread>>(
        ThreadController.new);

// Member Controller
class MemberController extends AsyncNotifier<List<CommunityMember>> {
  String? _communityId;

  @override
  FutureOr<List<CommunityMember>> build() async {
    if (_communityId == null) return [];
    final repo = ref.watch(communityRepositoryProvider);
    return await repo.getCommunityMembers(_communityId!);
  }

  void setCommunityId(String id) {
    _communityId = id;
    ref.invalidateSelf();
  }

  Future<void> promoteMember(String memberId, String role) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.updateMemberRole(_communityId!, memberId, role);
    ref.invalidateSelf();
  }

  Future<void> banMember(String memberId, String reason) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.banMember(_communityId!, memberId, reason);
    ref.invalidateSelf();
  }

  Future<void> unbanMember(String memberId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.unbanMember(_communityId!, memberId);
    ref.invalidateSelf();
  }
}

final memberControllerProvider =
    AsyncNotifierProvider<MemberController, List<CommunityMember>>(
        MemberController.new);

// Subscription Controller
class SubscriptionController extends AsyncNotifier<List<Subscription>> {
  @override
  FutureOr<List<Subscription>> build() async {
    final repo = ref.watch(communityRepositoryProvider);
    return await repo.getUserSubscriptions();
  }

  Future<void> subscribe(String creatorId, String tier) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.createSubscription(creatorId, tier);
    ref.invalidateSelf();
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.cancelSubscription(subscriptionId);
    ref.invalidateSelf();
  }

  Future<void> updateTier(String subscriptionId, String tier) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.updateSubscriptionTier(subscriptionId, tier);
    ref.invalidateSelf();
  }
}

final subscriptionControllerProvider =
    AsyncNotifierProvider<SubscriptionController, List<Subscription>>(
        SubscriptionController.new);

// Analytics Controller
class AnalyticsController extends AsyncNotifier<CommunityAnalytics?> {
  String? _communityId;

  @override
  FutureOr<CommunityAnalytics?> build() async {
    if (_communityId == null) return null;
    final repo = ref.watch(communityRepositoryProvider);
    return await repo.getCommunityAnalytics(_communityId!, 'monthly');
  }

  void setCommunityId(String id) {
    _communityId = id;
    ref.invalidateSelf();
  }
}

final analyticsControllerProvider =
    AsyncNotifierProvider<AnalyticsController, CommunityAnalytics?>(
        AnalyticsController.new);
