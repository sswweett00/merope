import 'package:flutter_riverpod/flutter_riverpod.dart';

class HUDAction {
  final String id;
  final String label;
  final String description;
  final String? category;
  final Function() onExecute;

  HUDAction({
    required this.id,
    required this.label,
    required this.description,
    this.category,
    required this.onExecute,
  });
}

class HUDController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void hide() => state = false;
  void show() => state = true;
}

final hUDControllerProvider =
    NotifierProvider<HUDController, bool>(HUDController.new);

class HUDSearch extends Notifier<String> {
  @override
  String build() => "";

  void update(String query) => state = query;
}

final hUDSearchProvider = NotifierProvider<HUDSearch, String>(HUDSearch.new);

final hudActionsProvider = Provider<List<HUDAction>>((ref) {
  return [
    HUDAction(
      id: 'go_home',
      label: 'Home',
      description: 'Go to your feed',
      category: 'Navigation',
      onExecute: () {},
    ),
    HUDAction(
      id: 'go_vault',
      label: 'Vault',
      description: 'Access secure storage',
      category: 'Navigation',
      onExecute: () {},
    ),
    HUDAction(
      id: 'toggle_ghost',
      label: 'Ghost Mode',
      description: 'Hide your online status',
      category: 'Privacy',
      onExecute: () {},
    ),
    HUDAction(
      id: 'sync_now',
      label: 'Sync Now',
      description: 'Force immediate data synchronization',
      category: 'System',
      onExecute: () {},
    ),
  ];
});

final filteredHUDActionsProvider = Provider<List<HUDAction>>((ref) {
  final query = ref.watch(hUDSearchProvider).toLowerCase();
  final actions = ref.watch(hudActionsProvider);

  if (query.isEmpty) return actions;

  return actions.where((action) {
    return action.label.toLowerCase().contains(query) ||
        action.description.toLowerCase().contains(query) ||
        (action.category?.toLowerCase().contains(query) ?? false);
  }).toList();
});
