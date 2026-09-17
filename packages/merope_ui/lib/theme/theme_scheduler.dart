import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_customizer_provider.dart';

class ThemeSchedulerNotifier extends StateNotifier<bool> {
  ThemeSchedulerNotifier() : super(false);

  void toggleAutoSchedule(bool enabled, WidgetRef ref) {
    state = enabled;
    if (enabled) {
      _evaluateTime(ref);
    }
  }

  void _evaluateTime(WidgetRef ref) {
    final hour = DateTime.now().hour;
    // If night time (19:00 - 06:00), switch to Obsidian or Cyberpunk, else Arctic or Default
    if (hour >= 19 || hour < 6) {
      ref
          .read(themeCustomizerProvider.notifier)
          .setPreset(ThemePreset.obsidian);
    } else {
      ref.read(themeCustomizerProvider.notifier).setPreset(ThemePreset.arctic);
    }
  }
}

final themeSchedulerProvider =
    StateNotifierProvider<ThemeSchedulerNotifier, bool>((ref) {
  return ThemeSchedulerNotifier();
});
