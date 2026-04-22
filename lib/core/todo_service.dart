import '../model/todo_model.dart';
abstract class TodoService {
  Stream<List<Todo>> getTodos(String userId);
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<void> updateStatus(String id, String status);
}