import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_core/data/services/exceptions.dart';
import 'package:merope_core/security/session_storage.dart';

import '../../domain/models/community_model.dart';
import '../../repository/community_repository.dart';

class ApiCommunityRepository implements ICommunityRepository {
  ApiCommunityRepository({ApiClient? apiClient, SessionStorage? sessionStorage})
      : _apiClient = apiClient ?? ApiClient(),
        _sessionStorage = sessionStorage ?? SessionStorage();

  final ApiClient _apiClient;
  final SessionStorage _sessionStorage;

  Future<String> _userId() async {
    final user = await _sessionStorage.getUser();
    if (user == null || user.id.trim().isEmpty) {
      throw StateError('An authenticated user is required for community operations');
    }
    return user.id;
  }

  Map<String, dynamic> _map(dynamic value) =>
      Map<String, dynamic>.from(value as Map);

  List<dynamic> _list(dynamic value, [String? key]) {
    if (value is List) return value;
    if (value is Map && key != null && value[key] is List) return value[key] as List<dynamic>;
    return const <dynamic>[];
  }

  Never _throw(dynamic error) =>
      throw MeropeAPIException.fromDioError(error);

  @override
  Future<List<Community>> getCommunities({int limit = 20, int offset = 0}) async {
    final result = await _apiClient.get<dynamic>('/community/communities', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return result.fold(
      (data) => _list(data, 'communities')
          .map((e) => Community.fromJson(_map(e)))
          .toList(growable: false),
      _throw,
    );
  }

  @override
  Future<Community?> getCommunity(String communityId) async {
    final result = await _apiClient.get<dynamic>('/community/communities/$communityId');
    return result.fold(
      (data) => data == null ? null : Community.fromJson(_map(data)),
      _throw,
    );
  }

  @override
  Future<void> createCommunity(Community community) async {
    final result = await _apiClient.post<dynamic>('/community/communities', data: community.toJson());
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> joinCommunity(String communityId) async {
    final result = await _apiClient.post<dynamic>('/community/communities/$communityId/join');
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> leaveCommunity(String communityId) async {
    final result = await _apiClient.post<dynamic>('/community/communities/$communityId/leave');
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> updateCommunitySettings(String communityId, CommunitySettings settings) async {
    final result = await _apiClient.patch<dynamic>('/community/communities/$communityId/settings', data: settings.toJson());
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> updateCommunityGuidelines(String communityId, List<CommunityGuideline> guidelines) async {
    final result = await _apiClient.put<dynamic>('/community/communities/$communityId/guidelines', data: {
      'guidelines': guidelines.map((e) => e.toJson()).toList(),
    });
    result.fold((_) {}, _throw);
  }

  @override
  Future<List<CommunityEvent>> getCommunityEvents(String communityId, {int limit = 10, int offset = 0}) async {
    final result = await _apiClient.get<dynamic>('/community/events', queryParameters: {
      'community_id': communityId,
      'limit': limit,
      'offset': offset,
    });
    return result.fold(
      (data) => _list(data, 'events').map((e) => CommunityEvent.fromJson(_map(e))).toList(growable: false),
      _throw,
    );
  }

  @override
  Future<List<CommunityEvent>> getUpcomingEvents({int limit = 10, int offset = 0}) async {
    final result = await _apiClient.get<dynamic>('/community/events/upcoming', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return result.fold(
      (data) => _list(data, 'events').map((e) => CommunityEvent.fromJson(_map(e))).toList(growable: false),
      _throw,
    );
  }

  @override
  Future<void> createEvent(CommunityEvent event) async {
    final result = await _apiClient.post<dynamic>('/community/events', data: event.toJson());
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> rsvpEvent(String eventId, String status) async {
    final result = await _apiClient.post<dynamic>('/community/events/$eventId/rsvp', data: {'status': status});
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> cancelEvent(String eventId) async {
    final result = await _apiClient.delete<dynamic>('/community/events/$eventId');
    result.fold((_) {}, _throw);
  }

  @override
  Future<List<Collective>> getCollectives({int limit = 20, int offset = 0}) async {
    final result = await _apiClient.get<dynamic>('/community/collectives', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return result.fold(
      (data) => _list(data, 'collectives').map((e) => Collective.fromJson(_map(e))).toList(growable: false),
      _throw,
    );
  }

  @override
  Future<void> createCollective(Collective collective) async {
    final result = await _apiClient.post<dynamic>('/community/collectives', data: collective.toJson());
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> joinCollective(String collectiveId) async {
    final result = await _apiClient.post<dynamic>('/community/collectives/$collectiveId/join');
    result.fold((_) {}, _throw);
  }

  @override
  Future<List<CollectiveThread>> getThreads(String collectiveId, {int limit = 20, int offset = 0}) async {
    final result = await _apiClient.get<dynamic>('/community/collectives/$collectiveId/threads', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return result.fold(
      (data) => _list(data, 'threads').map((e) => CollectiveThread.fromJson(_map(e))).toList(growable: false),
      _throw,
    );
  }

  @override
  Future<void> createThread(CollectiveThread thread) async {
    final result = await _apiClient.post<dynamic>('/community/collectives/${thread.collectiveId}/threads', data: thread.toJson());
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> resonateThread(String threadId, int delta) async {
    final result = await _apiClient.post<dynamic>('/community/threads/$threadId/resonate', data: {'delta': delta});
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> createThreadReply(ThreadReply reply) async {
    final result = await _apiClient.post<dynamic>('/community/threads/${reply.threadId}/replies', data: reply.toJson());
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> pinThread(String threadId, bool pinned) async {
    final result = await _apiClient.post<dynamic>('/community/threads/$threadId/pin', data: {'pinned': pinned});
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> lockThread(String threadId, bool locked) async {
    final result = await _apiClient.post<dynamic>('/community/threads/$threadId/lock', data: {'locked': locked});
    result.fold((_) {}, _throw);
  }

  @override
  Future<List<CommunityMember>> getCommunityMembers(String communityId, {int limit = 50, int offset = 0}) async {
    final result = await _apiClient.get<dynamic>('/community/communities/$communityId/members', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return result.fold(
      (data) => _list(data, 'members').map((e) => CommunityMember.fromJson(_map(e))).toList(growable: false),
      _throw,
    );
  }

  @override
  Future<void> updateMemberRole(String communityId, String memberId, String role) async {
    final result = await _apiClient.patch<dynamic>('/community/communities/$communityId/members/$memberId', data: {'role': role});
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> banMember(String communityId, String memberId, String reason) async {
    final result = await _apiClient.post<dynamic>('/community/communities/$communityId/members/$memberId/ban', data: {'reason': reason});
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> unbanMember(String communityId, String memberId) async {
    final result = await _apiClient.post<dynamic>('/community/communities/$communityId/members/$memberId/unban');
    result.fold((_) {}, _throw);
  }

  @override
  Future<List<Subscription>> getUserSubscriptions() async {
    final userId = await _userId();
    final result = await _apiClient.get<dynamic>('/community/subscriptions', queryParameters: {'user_id': userId});
    return result.fold(
      (data) => _list(data, 'subscriptions').map((e) => Subscription.fromJson(_map(e))).toList(growable: false),
      _throw,
    );
  }

  @override
  Future<void> createSubscription(String creatorId, String tier) async {
    final result = await _apiClient.post<dynamic>('/community/subscriptions', data: {'creator_id': creatorId, 'tier': tier});
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> cancelSubscription(String subscriptionId) async {
    final result = await _apiClient.delete<dynamic>('/community/subscriptions/$subscriptionId');
    result.fold((_) {}, _throw);
  }

  @override
  Future<void> updateSubscriptionTier(String subscriptionId, String tier) async {
    final result = await _apiClient.patch<dynamic>('/community/subscriptions/$subscriptionId', data: {'tier': tier});
    result.fold((_) {}, _throw);
  }

  @override
  Future<CommunityAnalytics?> getCommunityAnalytics(String communityId, String period) async {
    final result = await _apiClient.get<dynamic>('/community/communities/$communityId/analytics', queryParameters: {'period': period});
    return result.fold(
      (data) => data == null ? null : CommunityAnalytics.fromJson(_map(data)),
      _throw,
    );
  }
}
