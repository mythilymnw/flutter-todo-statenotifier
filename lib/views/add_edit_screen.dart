import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/todo_model.dart';
import '../viewmodel/todo_notifier.dart';

class AddEditScreen extends ConsumerStatefulWidget {
  final String userId;
  final Todo? todo;

  const AddEditScreen({super.key, required this.userId, this.todo});

  @override
  ConsumerState<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends ConsumerState<AddEditScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descController.text = widget.todo!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.todo != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Task" : "Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) return;

                if (isEdit) {
                  final updated = widget.todo!.copyWith(
                    title: titleController.text,
                    description: descController.text,
                  );

                  ref.read(todoProvider.notifier).update(updated);
                } else {
                  final todo = Todo(
                    id: '',
                    title: titleController.text,
                    description: descController.text,
                    userId: widget.userId,
                    status: 'pending',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  ref.read(todoProvider.notifier).add(todo);
                }

                context.pop();
              },
              child: Text(isEdit ? "Update" : "Add"),
            ),
          ],
        ),
      ),
    );
  }
}
