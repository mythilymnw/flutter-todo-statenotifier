import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/todo_provider.dart';
import 'widgets/todo_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TodoProvider>(context, listen: false).loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Todo App")),
      body: ListView.builder(
        itemCount: provider.todos.length,
        itemBuilder: (context, index) {
          final todo = provider.todos[index];

          return TodoItem(
            todo: todo,
            onToggle: () => provider.toggleTodo(todo),
            onDelete: () => provider.deleteTodo(todo.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.addTodo("New Task"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
