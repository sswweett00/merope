import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/content_api_service.dart';
import 'package:merope_core/data/services/social_api.dart' as social_api;
import 'package:merope_models/social/post_model.dart';
import './veritas_integrity_engine.dart';
import '../data/repository/social_repository.dart';

final socialRepositoryProvider = Provider<ISocialRepository>((ref) {
  return DriftSocialRepository();
});

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
    final lastItem = current.items.last;
    final result = await api.getFeed(limit: 10, cursor: lastItem.id);

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
    final veritas = ref.read(veritasIntegrityProvider.notifier);

    // Sign the post payload via Veritas
    veritas.signPost(
      userId: 'current_user',
      content: content,
      mediaIds: media.map((m) => m.url).toList(),
    );

    List<MeropeAppCard>? cards;
    if (pollQuestion != null && pollOptions != null) {
      cards = [
        MeropeAppCard(
          id: DateTime.now().toString(),
          type: AppCardType.poll,
          data: {
            'question': pollQuestion,
            'options': pollOptions,
          },
        ),
      ];
    }

    final newSignal = MeropeSignal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      author: const MeropeAuthor(
        id: 'current_user',
        username: 'merope_user',
        displayName: 'Merope Explorer',
        isVerified: true,
        influenceScore: 4.8,
      ),
      content: content,
      media: media,
      cards: cards ?? [],
      createdAt: DateTime.now().millisecondsSinceEpoch,
      resonances: [
        const SignalResonance(type: '❤️', amplitude: 0),
        const SignalResonance(type: '🔄', amplitude: 0),
        const SignalResonance(type: '🔥', amplitude: 0),
      ],
    );

    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(
          previousState.copyWith(items: [newSignal, ...previousState.items]));
    }
  }

  Future<void> resonateSignal(
      String signalId, String resonanceType, int addedAmplitude) async {
    final previousState = state.value;
    if (previousState == null) return;

    final updatedItems = previousState.items.map((signal) {
      if (signal.id == signalId) {
        final updatedResonances = signal.resonances.map((r) {
          if (r.type == resonanceType) {
            return r.copyWith(
              amplitude: r.amplitude + addedAmplitude,
              isResonated: true,
            );
          }
          return r;
        }).toList();
        return signal.copyWith(resonances: updatedResonances);
      }
      return signal;
    }).toList();

    state = AsyncValue.data(previousState.copyWith(items: updatedItems));
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
    return result.data!;
  }

  final result = await api.getProfile(userId);
  if (result.isSuccess) {
    return result.data!;
  }

  // Minimal fallback for missing users
  return social_api.UserModel(
    id: userId,
    username: 'explorer',
    displayName: 'Nexus Explorer',
    createdAt: 0,
  );
});
