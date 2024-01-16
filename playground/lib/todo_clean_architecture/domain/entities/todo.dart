// Entity only business logic
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

  get slug => title.toLowerCase().replaceAll(' ', '-');
}
