import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/abstract_todo_service.dart';
import '../model/todo_model.dart';

class TodoServiceImpl implements AbstractTodoService {
  final FirebaseFirestore firestore;

  TodoServiceImpl(this.firestore);

  @override
  Future<List<TodoModel>> fetchTodos() async {
    final snapshot = await firestore.collection('todos').get();

    return snapshot.docs
        .map((doc) => TodoModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await firestore.collection('todos').add(todo.toMap());
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await firestore.collection('todos').doc(todo.id).update(todo.toMap());
  }

  @override
  Future<void> deleteTodo(String id) async {
    await firestore.collection('todos').doc(id).delete();
  }
}