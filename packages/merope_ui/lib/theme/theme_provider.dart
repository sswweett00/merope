import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tokens/merope_tokens.dart';
import 'theme_customizer_provider.dart';

enum AppTheme { dark, light }

class ThemeState {
  final AppTheme theme;
  final MeropeColorTokens tokens;

  const ThemeState({
    required this.theme,
    required this.tokens,
  });

  MeropeColorTokens get currentTokens => tokens;
  bool get isDark => theme == AppTheme.dark;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier(ref);
});

class ThemeNotifier extends StateNotifier<ThemeState> {
  final Ref _ref;

  ThemeNotifier(this._ref)
      : super(
          ThemeState(
            theme: AppTheme.dark,
            tokens: MeropeColorTokens.darkDefault(),
          ),
        ) {
    // Sync with customizer
    _ref.listen(themeCustomizerProvider, (previous, next) {
      state = ThemeState(
        theme: state.theme,
        tokens: _ref.read(themeCustomizerProvider.notifier).tokens,
      );
    });
  }

  void toggleTheme() {
    final newIsDark = !state.isDark;
    state = ThemeState(
      theme: newIsDark ? AppTheme.dark : AppTheme.light,
      tokens: newIsDark ? MeropeColorTokens.darkDefault() : MeropeColorTokens.lightDefault(),
    );
  }
}
