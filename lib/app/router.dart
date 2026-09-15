import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/logic/auth_logic.dart';
import 'routes/app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      if (!auth.isInitialised) return null;

      final isLoggedIn = auth.isAuthenticated;
      final isAuthPath = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isAuthPath) {
        return '/onboarding';
      }
      if (isLoggedIn && isAuthPath) {
        return '/';
      }
      return null;
    },
    routes: appRoutes,
    refreshListenable: _AuthRefreshListenable(ref),
  );
});

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
}
