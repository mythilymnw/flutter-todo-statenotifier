import '../model/todo_model.dart';

abstract class AbstractTodoService {
  Future<List<TodoModel>> fetchTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}