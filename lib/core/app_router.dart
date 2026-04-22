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
        final authState = ref.read(authProvider);

        final isLoggedIn = authState.maybeWhen(
          data: (user) => user != null,
          orElse: () => false,
        );

        final path = state.matchedLocation;

        // not logged in → only allow login/register
        if (!isLoggedIn && path != '/register') {
          return '/login';
        }

        // logged in → block login/register
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

        // ADD TODO
        GoRoute(
          path: '/add',
          builder: (context, state) {
            final userId = state.extra as String?;
            if (userId == null) {
              return const HomeScreen();
            }
            return AddEditScreen(userId: userId);
          },
        ),

        // EDIT TODO
        GoRoute(
          path: '/edit',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>?;

            if (data == null) {
              return const HomeScreen();
            }

            return AddEditScreen(
              userId: data['userId'] ?? '',
              todo: data['todo'] as Todo?,
            );
          },
        ),
      ],
    );
  }
}