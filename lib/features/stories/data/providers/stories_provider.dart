import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/stories_api.dart';
import 'package:merope_core/data/services/exceptions.dart';
import 'package:merope_models/stories/story_model.dart' as model;
import '../../repository/story_repository.dart';

class StoryFeed extends AsyncNotifier<List<model.StoryUser>> {
  int _page = 0;
  static const int _pageSize = 20;

  @override
  FutureOr<List<model.StoryUser>> build() async {
    return _fetchFeed();
  }

  Future<List<model.StoryUser>> _fetchFeed() async {
    final api = ref.read(storiesApiServiceProvider);
    final repo = ref.read(storyRepositoryProvider);

    try {
      final result = await api.getFeed(
          limit: _pageSize, cursor: _page > 0 ? 'cursor_$_page' : null);
      if (result.error != null) throw result.error!;

      final stories = result.data ?? [];
      for (final story in stories) {
        await repo.markStoryViewed(story.id);
      }

      final users = <String, model.Story>{};
      for (final story in stories) {
        users[story.userId] = story;
      }

      final userList = <model.StoryUser>[];
      for (final entry in users.entries) {
        final story = entry.value;
        final hasUnviewed = !story.isViewed;
        userList.add(model.StoryUser(
          id: story.userId,
          username: story.userId,
          displayName: story.userId,
          isViewed: !hasUnviewed,
          unreadStoryIds: hasUnviewed ? [story.id] : const [],
          streak: (story.id.hashCode % 90) + 1,
        ));
      }

      _page++;
      return userList;
    } on MeropeAPIException catch (_) {
      final localStories = await repo.getStoryFeed();
      final users = <String, model.Story>{};
      for (final story in localStories) {
        users[story.userId] = story;
      }
      return users.entries.map((e) {
        final story = e.value;
        return model.StoryUser(
          id: story.userId,
          username: story.userId,
          displayName: story.userId,
          isViewed: story.isViewed,
          unreadStoryIds: story.isViewed ? const [] : [story.id],
          streak: (story.id.hashCode % 90) + 1,
        );
      }).toList();
    }
  }

  Future<void> refresh() async {
    _page = 0;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFeed());
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || state.isLoading) return;

    state = AsyncValue.data(current);
    final api = ref.read(storiesApiServiceProvider);
    final result = await api.getFeed(limit: _pageSize, cursor: 'cursor_$_page');
    if (result.error != null || result.data == null) return;

    final newStories = result.data!;
    final existing = state.valueOrNull ?? [];
    final seen = <String>{for (final u in existing) u.id};
    final newUsers = <model.StoryUser>[];
    for (final story in newStories) {
      if (!seen.contains(story.userId)) {
        newUsers.add(model.StoryUser(
          id: story.userId,
          username: story.userId,
          displayName: story.userId,
          isViewed: story.isViewed,
          unreadStoryIds: story.isViewed ? const [] : [story.id],
          streak: (story.id.hashCode % 90) + 1,
        ));
      }
    }
    _page++;
    state = AsyncValue.data([...existing, ...newUsers]);
  }
}

final storyFeedProvider =
    AsyncNotifierProvider<StoryFeed, List<model.StoryUser>>(StoryFeed.new);

class StoryProvider extends FamilyAsyncNotifier<model.Story, String> {
  @override
  FutureOr<model.Story> build(String arg) async {
    final api = ref.read(storiesApiServiceProvider);
    final repo = ref.read(storyRepositoryProvider);

    final remoteResult = await api.getStory(arg);
    if (remoteResult.error == null && remoteResult.data != null) {
      return remoteResult.data!;
    }

    final localStory = await repo.getStory(arg);
    if (localStory != null) return localStory;

    throw Exception('Story not found for user: $arg');
  }
}

final storyProvider =
    AsyncNotifierProviderFamily<StoryProvider, model.Story, String>(
        StoryProvider.new);

class StoryViewersProvider
    extends FamilyAsyncNotifier<List<model.StoryUser>, String> {
  @override
  FutureOr<List<model.StoryUser>> build(String arg) async {
    final api = ref.read(storiesApiServiceProvider);
    final repo = ref.read(storyRepositoryProvider);

    final remoteResult = await api.getStoryViewers(arg);
    if (remoteResult.error == null && remoteResult.data != null) {
      return remoteResult.data!;
    }

    return repo.getStoryViewers(arg);
  }
}

final storyViewersProvider = AsyncNotifierProviderFamily<StoryViewersProvider,
    List<model.StoryUser>, String>(StoryViewersProvider.new);
