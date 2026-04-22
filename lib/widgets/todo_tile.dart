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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: todo.status == 'completed',
          onChanged: (value) {
            ref.read(todoProvider.notifier).status(
              todo.id,
              value == true ? 'completed' : 'pending',
            );
          },
        ),

        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.status == 'completed'
                ? TextDecoration.lineThrough
                : null,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.description),
            const SizedBox(height: 4),
            Text(
              todo.status.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: todo.status == 'completed'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
          ],
        ),

        onTap: () {
          context.push('/edit', extra: {
            'userId': todo.userId,
            'todo': todo,
          });
        },

        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Delete Task"),
                content: const Text("Are you sure you want to delete this task?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete"),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              try {
                await ref.read(todoProvider.notifier).delete(todo.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task deleted")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            }
          },
        ),
      ),
    );
  }
}