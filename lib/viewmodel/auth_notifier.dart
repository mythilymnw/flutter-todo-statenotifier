import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../service/auth_service_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AppUser?>>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final _service = AuthServiceImpl();

  AuthNotifier() : super(const AsyncValue.loading()) {
    _service.authState().listen((user) {
      state = AsyncValue.data(user);
    });
  }

  Future<void> login(String e, String p) async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _service.login(e, p));
  }

  Future<void> register(String n, String e, String p) async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _service.register(n, e, p));
  }

  Future<void> logout() async => _service.logout();
}
