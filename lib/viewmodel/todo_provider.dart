import 'package:flutter/material.dart';
import '../core/abstract_todo_service.dart';
import '../model/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  final AbstractTodoService service;

  TodoProvider(this.service);

  List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await service.fetchTodos();
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    final todo = TodoModel(id: '', title: title, isCompleted: false);

    await service.addTodo(todo);
    await loadTodos();
  }

  Future<void> toggleTodo(TodoModel todo) async {
    final updated = TodoModel(
      id: todo.id,
      title: todo.title,
      isCompleted: !todo.isCompleted,
    );

    await service.updateTodo(updated);
    await loadTodos();
  }

  Future<void> deleteTodo(String id) async {
    await service.deleteTodo(id);
    await loadTodos();
  }
}
