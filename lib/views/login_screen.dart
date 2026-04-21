import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/auth_notifier.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = TextEditingController();
    final pass = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          TextField(controller: email),
          TextField(controller: pass),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(authProvider.notifier)
                  .login(email.text, pass.text);
              context.go('/');
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () => context.go('/register'),
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
