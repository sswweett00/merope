import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_core/utils/view_preferences_provider.dart';
import '../utils/merope_haptics.dart';

class UniversalViewControls extends ConsumerWidget {
  final String domain;
  final List<String> filters;

  const UniversalViewControls({
    super.key,
    required this.domain,
    required this.filters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(viewPreferencesProvider)[domain] ??
        const ViewPreferences(mode: ViewMode.list, activeFilter: 'All');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isActive = prefs.activeFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isActive,
                    onSelected: (_) {
                      MeropeHaptics.trigger(MeropeTokens.hapticSoft);
                      ref
                          .read(viewPreferencesProvider.notifier)
                          .setFilter(domain, filter);
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor:
                        const Color(0xFF5865F2).withValues(alpha: 0.2),
                    checkmarkColor: const Color(0xFF5865F2),
                    labelStyle: TextStyle(
                      color: isActive ? const Color(0xFF5865F2) : Colors.grey,
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(MeropeTokens.radiusFull),
                      side: BorderSide(
                        color: isActive
                            ? const Color(0xFF5865F2)
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // View Mode Icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ViewModeButton(
                  mode: ViewMode.list,
                  icon: Icons.view_headline,
                  isActive: prefs.mode == ViewMode.list,
                  onTap: () => ref
                      .read(viewPreferencesProvider.notifier)
                      .setMode(domain, ViewMode.list),
                ),
                _ViewModeButton(
                  mode: ViewMode.grid,
                  icon: Icons.grid_view_rounded,
                  isActive: prefs.mode == ViewMode.grid,
                  onTap: () => ref
                      .read(viewPreferencesProvider.notifier)
                      .setMode(domain, ViewMode.grid),
                ),
                _ViewModeButton(
                  mode: ViewMode.compact,
                  icon: Icons.view_compact_rounded,
                  isActive: prefs.mode == ViewMode.compact,
                  onTap: () => ref
                      .read(viewPreferencesProvider.notifier)
                      .setMode(domain, ViewMode.compact),
                ),
                _ViewModeButton(
                  mode: ViewMode.masonry,
                  icon: Icons.dashboard_customize_rounded,
                  isActive: prefs.mode == ViewMode.masonry,
                  onTap: () => ref
                      .read(viewPreferencesProvider.notifier)
                      .setMode(domain, ViewMode.masonry),
                ),
                _ViewModeButton(
                  mode: ViewMode.carousel,
                  icon: Icons.view_carousel_rounded,
                  isActive: prefs.mode == ViewMode.carousel,
                  onTap: () => ref
                      .read(viewPreferencesProvider.notifier)
                      .setMode(domain, ViewMode.carousel),
                ),
                _ViewModeButton(
                  mode: ViewMode.focus,
                  icon: Icons.fullscreen_rounded,
                  isActive: prefs.mode == ViewMode.focus,
                  onTap: () => ref
                      .read(viewPreferencesProvider.notifier)
                      .setMode(domain, ViewMode.focus),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  final ViewMode mode;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ViewModeButton({
    required this.mode,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: 20,
        color: isActive
            ? const Color(0xFF5865F2)
            : Colors.grey.withValues(alpha: 0.5),
      ),
      onPressed: () {
        MeropeHaptics.trigger(MeropeTokens.hapticSoft);
        onTap();
      },
      tooltip: mode.name.toUpperCase(),
    );
  }
}
