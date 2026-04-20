class TodoModel {
  final String id;
  final String title;
  final bool isCompleted;

  TodoModel({required this.id, required this.title, required this.isCompleted});

  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    return TodoModel(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'isCompleted': isCompleted};
  }
}
