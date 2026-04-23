import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/todo_service.dart';
import '../model/todo_model.dart';

class TodoServiceImpl implements TodoService {
  static const String key = "todos";

  final StreamController<List<Todo>> _controller =
      StreamController<List<Todo>>.broadcast();

  List<Todo> _todos = [];

  TodoServiceImpl() {
    _init();
  }

  // SAFE INIT
  Future<void> _init() async {
    await _loadTodos();
  }

  // LOAD
  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data != null) {
      try {
        final List decoded = jsonDecode(data);

        _todos = decoded
            .map((e) => Todo.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        _todos = [];
      }
    }

    _controller.add(_todos);
  }

  // SAVE
  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      _todos.map((e) => e.toJson()).toList(),
    );

    await prefs.setString(key, encoded);

    _controller.add(_todos);
  }

  // STREAM
  @override
  Stream<List<Todo>> getTodos(String userId) {
    return _controller.stream.map(
      (todos) => todos.where((t) => t.userId == userId).toList(),
    );
  }

  // ADD
  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    await _saveTodos();
  }

  // UPDATE
  @override
  Future<void> updateTodo(Todo updatedTodo) async {
    final index = _todos.indexWhere((t) => t.id == updatedTodo.id);

    if (index != -1) {
      _todos[index] = updatedTodo;
      await _saveTodos();
    }
  }

  // DELETE
  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    await _saveTodos();
  }

  // STATUS UPDATE
  @override
  Future<void> updateStatus(String id, String status) async {
    final index = _todos.indexWhere((t) => t.id == id);

    if (index != -1) {
      final todo = _todos[index];

      _todos[index] = todo.rebuild((b) => b
        ..status = status
        ..updatedAt = DateTime.now().toIso8601String());

      await _saveTodos();
    }
  }


  void dispose() {
    _controller.close();
  }
}