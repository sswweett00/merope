import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/content_api_service.dart';
import 'package:merope_core/data/services/social_api.dart' as social_api;
import 'package:merope_core/data/services/api_client.dart';
import 'package:merope_models/social/post_model.dart';

class TimelineState {
  final List<MeropeSignal> items;
  final bool isLoadingMore;
  final bool hasMore;

  TimelineState({
    required this.items,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  TimelineState copyWith({
    List<MeropeSignal>? items,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return TimelineState(
      items: items ?? this.items,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class TimelineNotifier extends AsyncNotifier<TimelineState> {
  @override
  FutureOr<TimelineState> build() async {
    return _fetchInitial();
  }

  Future<TimelineState> _fetchInitial() async {
    final api = ref.read(contentApiServiceProvider);
    final result = await api.getFeed(limit: 10);
    return TimelineState(
      items: result.items,
      hasMore: result.hasMore,
      isLoadingMore: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchInitial());
  }

  Future<void> fetchMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    final api = ref.read(contentApiServiceProvider);
    final cursor = current.items.isNotEmpty ? current.items.last.id : null;
    final result = await api.getFeed(limit: 10, cursor: cursor);

    state = AsyncValue.data(current.copyWith(
      items: [...current.items, ...result.items],
      isLoadingMore: false,
      hasMore: result.hasMore,
    ));
  }

  Future<void> broadcastSignal(String content,
      {List<SignalMedia> media = const [],
      String? pollQuestion,
      List<String>? pollOptions}) async {
    final api = ref.read(contentApiServiceProvider);
    final cards = pollQuestion != null && pollOptions != null
        ? [
            MeropeAppCard(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              type: AppCardType.poll,
              data: {
                'question': pollQuestion,
                'options': pollOptions,
              },
            ),
          ]
        : null;

    final result = await api.createPost(
      content: content,
      mediaUrls: media.map((item) => item.url).toList(),
      cards: cards,
    );

    if (!result.success) {
      throw StateError(result.error ?? 'Failed to create post');
    }

    final createdId = result.post?.id ?? 'post-created';
    try {
      await ApiClient().post<void>(
        '/progression/events',
        data: {'action': 'post_created', 'source_id': createdId},
      );
    } catch (_) {}

    state = await AsyncValue.guard(() => _fetchInitial());
  }

  Future<void> resonateSignal(
      String signalId, String resonanceType, int addedAmplitude) async {
    if (addedAmplitude <= 0) return;

    final api = ref.read(contentApiServiceProvider);
    final result = await api.likePost(signalId);
    if (!result.success) {
      throw StateError(result.error ?? 'Failed to amplify signal');
    }

    try {
      await ApiClient().post<void>(
        '/progression/events',
        data: {'action': 'reaction_added', 'source_id': signalId},
      );
    } catch (_) {}

    state = await AsyncValue.guard(() => _fetchInitial());
  }
}

final nexusTimelineProvider =
    AsyncNotifierProvider<TimelineNotifier, TimelineState>(
        TimelineNotifier.new);

final userProfileProvider =
    FutureProvider.family<social_api.UserModel, String>((ref, userId) async {
  final api = ref.read(social_api.socialApiServiceProvider);

  if (userId == 'me') {
    final result = await api.getCurrentUser();
    if (result.isSuccess && result.data != null) return result.data!;
    throw StateError(result.error ?? 'Failed to load current user');
  }

  final result = await api.getProfile(userId);
  if (result.isSuccess && result.data != null) return result.data!;
  throw StateError(result.error ?? 'Failed to load profile');
});
