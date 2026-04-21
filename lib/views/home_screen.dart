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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final todoState = ref.watch(todoProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text("Not logged in")));
        }

        // Start listening to todos
        ref.read(todoProvider.notifier).listen(user.uid);

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
              // FILTER BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _filterBtn('all'),
                  _filterBtn('pending'),
                  _filterBtn('completed'),
                ],
              ),

              const Divider(),

              //  TODO LIST
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
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
    );
  }

  Widget _filterBtn(String value) {
    return TextButton(
      onPressed: () {
        setState(() => filter = value);
      },
      child: Text(value.toUpperCase()),
    );
  }
}
