import 'package:merope_models/auth/auth_user.dart';

abstract class IAuthRepository {
  Future<AuthUser?> login({required String email, required String password});
  Future<AuthUser?> register({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<AuthUser?> getCurrentUser();
  Future<bool> isAuthenticated();
}
