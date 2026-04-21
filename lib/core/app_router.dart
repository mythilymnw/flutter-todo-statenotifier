import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/auth_notifier.dart';
import '../views/login_screen.dart';
import '../views/register_screen.dart';
import '../views/home_screen.dart';
import '../views/add_edit_screen.dart';
import '../model/todo_model.dart';

class AppRouter {
 static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/',

      redirect: (context, state) {
        final auth = ref.read(authProvider);
        final isLoggedIn = auth.value != null;

        final path = state.uri.toString();

        if (!isLoggedIn && path != '/register') {
          return '/login';
        }

        if (isLoggedIn &&
            (path == '/login' || path == '/register')) {
          return '/';
        }

        return null;
      },

      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) {
            final userId = state.extra as String;
            return AddEditScreen(userId: userId);
          },
        ),
        GoRoute(
          path: '/edit',
          builder: (context, state) {
            final data = state.extra as Map;
            return AddEditScreen(
              userId: data['userId'],
              todo: data['todo'] as Todo,
            );
          },
        ),
      ],
    );
  }
}