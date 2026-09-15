import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ViewMode { list, grid, compact, masonry, carousel, focus }

class ViewPreferences {
  final ViewMode mode;
  final String activeFilter;

  const ViewPreferences({
    required this.mode,
    required this.activeFilter,
  });

  ViewPreferences copyWith({
    ViewMode? mode,
    String? activeFilter,
  }) {
    return ViewPreferences(
      mode: mode ?? this.mode,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class ViewPreferencesNotifier extends StateNotifier<Map<String, ViewPreferences>> {
  ViewPreferencesNotifier() : super({
    'feed': const ViewPreferences(mode: ViewMode.list, activeFilter: 'All'),
    'market': const ViewPreferences(mode: ViewMode.grid, activeFilter: 'All'),
    'talent': const ViewPreferences(mode: ViewMode.list, activeFilter: 'All'),
    'orbit': const ViewPreferences(mode: ViewMode.focus, activeFilter: 'All'),
  });

  void setMode(String domain, ViewMode mode) {
    final current = state[domain] ?? const ViewPreferences(mode: ViewMode.list, activeFilter: 'All');
    state = {
      ...state,
      domain: current.copyWith(mode: mode),
    };
  }

  void setFilter(String domain, String filter) {
    final current = state[domain] ?? const ViewPreferences(mode: ViewMode.list, activeFilter: 'All');
    state = {
      ...state,
      domain: current.copyWith(activeFilter: filter),
    };
  }
}

final viewPreferencesProvider = StateNotifierProvider<ViewPreferencesNotifier, Map<String, ViewPreferences>>((ref) {
  return ViewPreferencesNotifier();
});
