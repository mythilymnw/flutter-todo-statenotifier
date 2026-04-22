import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/todo_service.dart';
import '../model/todo_model.dart';
import '../model/serializers.dart';

class TodoServiceImpl implements TodoService {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<Todo>> getTodos(String userId) {
    return _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = {
          ...doc.data(),
          'id': doc.id, // important for built_value
        };

        return serializers.deserializeWith(
          Todo.serializer,
          data,
        )!;
      }).toList();
    });
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final json = serializers.serializeWith(
      Todo.serializer,
      todo,
    );

    await _db.collection('tasks').add(json as Map<String, dynamic>);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final json = serializers.serializeWith(
      Todo.serializer,
      todo,
    );

    await _db
        .collection('tasks')
        .doc(todo.id)
        .update(json as Map<String, dynamic>);
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