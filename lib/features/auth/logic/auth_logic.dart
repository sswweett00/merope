import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_core/data/services/auth_api.dart';
import 'package:merope_core/security/session_storage.dart';
import 'package:merope_models/auth/auth_user.dart';
import 'package:merope_core/security/aether_auth_shield.dart';
import 'package:merope_core/utils/enterprise_logger.dart';

class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isInitialised = false,
    this.isLoading = false,
    this.error,
  });
  final bool isAuthenticated;
  final AuthUser? user;
  final bool isInitialised;
  final bool isLoading;
  final String? error;

  AuthState copyWith({
    bool? isAuthenticated,
    AuthUser? user,
    bool? isInitialised,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isInitialised: isInitialised ?? this.isInitialised,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState()) {
    checkAuth();
  }
  final Ref _ref;
  final SessionStorage _sessionStorage = SessionStorage();

  Future<void> checkAuth() async {
    final token = await _sessionStorage.getToken();
    final user = await _sessionStorage.getUser();

    state = AuthState(
      isAuthenticated: token != null && user != null,
      isInitialised: true,
      user: user,
    );
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final api = _ref.read(authApiServiceProvider);
    final result = await api.login(email: email, password: password);

    if (result.isSuccess && result.data != null) {
      final shield = _ref.read(aetherAuthShieldProvider.notifier);

      final biometricSuccess = await shield.authenticateBiometrically();
      if (!biometricSuccess) {
        state = state.copyWith(
            isLoading: false, error: 'Biometric authentication failed');
        return false;
      }

      await shield.getSecureDeviceSignature();
      MeropeLogger.info('Session successfully bound to the current device');

      state = state.copyWith(
        isAuthenticated: true,
        user: result.data,
        isLoading: false,
      );
      return true;
    }

    final errorMessage = result.error?.toString() ?? 'Login failed';
    state = state.copyWith(isLoading: false, error: errorMessage);
    MeropeLogger.error('Login failed: $errorMessage');
    return false;
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final api = _ref.read(authApiServiceProvider);
    final result = await api.register(
      username: username,
      email: email,
      password: password,
      displayName: displayName,
    );

    if (result.isSuccess && result.data != null) {
      state = state.copyWith(
        isAuthenticated: true,
        user: result.data,
        isLoading: false,
      );
      return true;
    }

    final errorMessage = result.error?.toString() ?? 'Registration failed';
    state = state.copyWith(isLoading: false, error: errorMessage);
    MeropeLogger.error('Registration failed: $errorMessage');
    return false;
  }

  Future<void> logout() async {
    state = const AuthState();
    await _ref.read(authApiServiceProvider).logout();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
