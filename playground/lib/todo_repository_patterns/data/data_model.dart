class TodoDataModel {
  TodoDataModel({
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

  factory TodoDataModel.fromJson(Map<String, dynamic> json) {
    return TodoDataModel(
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
