import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/todo_model.dart';
import '../service/todo_service_impl.dart';

final todoProvider =
    StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>(
  (ref) => TodoNotifier(),
);

class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final TodoServiceImpl _service;

  StreamSubscription<List<Todo>>? _subscription;
  String? _currentUserId;

  TodoNotifier() : _service = TodoServiceImpl(),
        super(const AsyncValue.loading());

  // SAFE LISTEN
  void listen(String userId) {
    if (_currentUserId == userId && _subscription != null) {
      return; // prevent duplicate listen
    }

    _currentUserId = userId;

    _subscription?.cancel();

    state = const AsyncValue.loading();

    _subscription = _service.getTodos(userId).listen(
      (data) {
        state = AsyncValue.data(data);
      },
      onError: (e, st) {
        state = AsyncValue.error(e, st);
      },
    );
  }

  // ADD
  Future<void> add(Todo t) async {
    await _service.addTodo(t);
  }

  // UPDATE
  Future<void> update(Todo t) async {
    await _service.updateTodo(t);
  }

  // DELETE
  Future<void> delete(String id) async {
    await _service.deleteTodo(id);
  }

  // STATUS
  Future<void> status(String id, String s) async {
    await _service.updateStatus(id, s);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}