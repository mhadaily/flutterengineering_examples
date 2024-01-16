class TodoModel {
  TodoModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final String? createdAt;
  final String? updatedAt;

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
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
