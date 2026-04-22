import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../viewmodel/auth_notifier.dart';
import '../viewmodel/todo_notifier.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String filter = 'all';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final user = ref.read(authProvider).value;

      if (user != null) {
        ref.read(todoProvider.notifier).listen(user.uid);
      }

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final todoState = ref.watch(todoProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("Not logged in")),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Welcome ${user.name}"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/login');
                },
              ),
            ],
          ),

          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _filterBtn('all'),
                  _filterBtn('pending'),
                  _filterBtn('completed'),
                ],
              ),

              const Divider(),

              Expanded(
                child: todoState.when(
                  data: (list) {
                    final filtered = filter == 'all'
                        ? list
                        : list.where((t) => t.status == filter).toList();

                    if (filtered.isEmpty) {
                      return const Center(child: Text("No tasks"));
                    }

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => TodoTile(todo: filtered[i]),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(e.toString())),
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.push('/add', extra: user.uid);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text(e.toString()))),
    );
  }

  Widget _filterBtn(String value) {
    return TextButton(
      onPressed: () {
        setState(() => filter = value);
      },
      child: Text(
        value.toUpperCase(),
        style: TextStyle(
          fontWeight: filter == value ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}