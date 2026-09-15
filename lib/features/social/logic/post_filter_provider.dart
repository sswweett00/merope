import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_models/social/post_model.dart';
import 'package:merope_ui/logic/view_preferences_provider.dart';
import 'timeline_provider.dart';

enum PostFilter { all, media, interactive, stories }

final postFilterProvider = StateProvider<PostFilter>((ref) => PostFilter.all);

final filteredTimelineProvider = Provider<AsyncValue<List<MeropeSignal>>>((ref) {
  final prefs = ref.watch(viewPreferencesProvider)['feed'] ??
      const ViewPreferences(mode: ViewMode.list, activeFilter: 'All');

  final timelineAsync = ref.watch(nexusTimelineProvider);

  return timelineAsync.whenData((state) {
    final signals = state.items;
    if (prefs.activeFilter == 'All') return signals;

    return signals.where((s) {
      if (prefs.activeFilter == 'Media') return s.media.isNotEmpty;
      if (prefs.activeFilter == 'Interactive') return s.cards.isNotEmpty;
      if (prefs.activeFilter == 'Stories') return s.layers.isNotEmpty;
      return true;
    }).toList();
  });
});

final filteredProfilePostsProvider = Provider.family<AsyncValue<List<MeropeSignal>>, String>((ref, userId) {
  final prefs = ref.watch(viewPreferencesProvider)['profile'] ??
      const ViewPreferences(mode: ViewMode.list, activeFilter: 'All');

  final timelineAsync = ref.watch(nexusTimelineProvider);

  return timelineAsync.whenData((state) {
    final userSignals = state.items.where((s) => s.author.id == userId || userId == 'me').toList();
    if (prefs.activeFilter == 'All') return userSignals;

    return userSignals.where((s) {
      if (prefs.activeFilter == 'Media') return s.media.isNotEmpty;
      if (prefs.activeFilter == 'Interactive') return s.cards.isNotEmpty;
      if (prefs.activeFilter == 'Stories') return s.layers.isNotEmpty;
      return true;
    }).toList();
  });
});
