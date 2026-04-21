import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/todo_model.dart';
import '../viewmodel/todo_notifier.dart';

class TodoTile extends ConsumerWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        // ✅ Checkbox (status toggle)
        leading: Checkbox(
          value: todo.status == 'completed',
          onChanged: (value) {
            ref
                .read(todoProvider.notifier)
                .status(todo.id, value! ? 'completed' : 'pending');
          },
        ),

        // ✅ Title
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.status == 'completed'
                ? TextDecoration.lineThrough
                : null,
          ),
        ),

        // ✅ Description
        subtitle: Text(todo.description),

        // ✅ Edit navigation
        onTap: () {
          context.push('/edit', extra: {'userId': todo.userId, 'todo': todo});
        },

        // ✅ Delete
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            ref.read(todoProvider.notifier).delete(todo.id);
          },
        ),
      ),
    );
  }
}
