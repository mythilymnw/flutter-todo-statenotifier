import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/todo_service.dart';
import '../model/todo_model.dart';

class TodoServiceImpl implements TodoService {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<Todo>> getTodos(String userId) {
    return _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((s) => s.docs.map((d) => Todo.fromMap(d.id, d.data())).toList());
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await _db.collection('tasks').add(todo.toMap());
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await _db.collection('tasks').doc(todo.id).update(todo.toMap());
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _db.collection('tasks').doc(id).delete();
  }

  @override
  Future<void> updateStatus(String id, String status) async {
    await _db.collection('tasks').doc(id).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}
