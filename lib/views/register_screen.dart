import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/auth_notifier.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = TextEditingController();
    final email = TextEditingController();
    final pass = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          TextField(controller: name),
          TextField(controller: email),
          TextField(controller: pass),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(authProvider.notifier)
                  .register(name.text, email.text, pass.text);
              context.go('/');
            },
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
