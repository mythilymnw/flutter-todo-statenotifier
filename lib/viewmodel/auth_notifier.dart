import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../service/auth_service_impl.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AppUser?>>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final _service = AuthServiceImpl();
  late final Stream<AppUser?> _authStream;

  AuthNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    await _service.init();

    _authStream = _service.authState();

    _authStream.listen((user) {
      state = AsyncValue.data(user);
    });
  }

  Future<void> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();

      final user = await _service.login(email, password);

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      state = const AsyncValue.loading();

      final user = await _service.register(name, email, password);

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AsyncValue.data(null);
  }
}