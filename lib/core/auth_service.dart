import '../model/user_model.dart';

abstract class AuthService {
  Future<AppUser?> login(String email, String password);
  Future<AppUser?> register(String name, String email, String password);
  Future<void> logout();
  Stream<AppUser?> authState();
}
