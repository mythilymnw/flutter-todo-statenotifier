import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/todo_model.dart';
import '../viewmodel/todo_notifier.dart';

class AddEditScreen extends ConsumerStatefulWidget {
  final String userId;
  final Todo? todo;

  const AddEditScreen({
    super.key,
    required this.userId,
    this.todo,
  });

  @override
  ConsumerState<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends ConsumerState<AddEditScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descController.text = widget.todo!.description;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title cannot be empty")),
      );
      return;
    }

    setState(() => isLoading = true);

    final notifier = ref.read(todoProvider.notifier);

    if (widget.todo != null) {
      // UPDATE
      final updated = widget.todo!.rebuild((b) => b
        ..title = titleController.text.trim()
        ..description = descController.text.trim()
        ..updatedAt = DateTime.now().toIso8601String());

      await notifier.update(updated);
    } else {
      // ADD
      final todo = Todo((b) => b
        ..id = DateTime.now().millisecondsSinceEpoch.toString()
        ..title = titleController.text.trim()
        ..description = descController.text.trim()
        ..userId = widget.userId
        ..status = 'pending'
        ..createdAt = DateTime.now().toIso8601String()
        ..updatedAt = DateTime.now().toIso8601String());

      await notifier.add(todo);
    }

    setState(() => isLoading = false);

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.todo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Task" : "Add Task"),
      ),
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _save,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(isEdit ? "Update" : "Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}