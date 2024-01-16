abstract class DataSource {
  Future<List<Todo>> fetchTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}

class Todo {
  Todo({
    required this.id,
    required this.title,
    this.createdAt,
    this.updatedAt,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final String? createdAt;
  final String? updatedAt;

  String get slug => title.toLowerCase().replaceAll(' ', '-');

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
