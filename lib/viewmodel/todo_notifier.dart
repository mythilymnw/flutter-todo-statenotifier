import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/todo_model.dart';
import '../service/todo_service_impl.dart';

final todoProvider =
    StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>(
      (ref) => TodoNotifier(),
    );

class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final _service = TodoServiceImpl();

  TodoNotifier() : super(const AsyncValue.loading());

  void listen(String userId) {
    _service.getTodos(userId).listen((data) {
      state = AsyncValue.data(data);
    });
  }

  Future<void> add(Todo t) => _service.addTodo(t);
  Future<void> update(Todo t) => _service.updateTodo(t);
  Future<void> delete(String id) => _service.deleteTodo(id);
  Future<void> status(String id, String s) => _service.updateStatus(id, s);
}
