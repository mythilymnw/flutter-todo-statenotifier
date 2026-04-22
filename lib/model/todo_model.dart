library todo_model;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
part 'todo_model.g.dart';
abstract class Todo implements Built<Todo, TodoBuilder> {
  String get id;
  String get title;
  String get description;
  String get userId;
  String get status;
  String get createdAt;
 Todo._();
factory Todo([void Function(TodoBuilder) updates]) = _$Todo;
static Serializer<Todo> get serializer => _$todoSerializer;
}