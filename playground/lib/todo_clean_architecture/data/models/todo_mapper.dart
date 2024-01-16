import '../../domain/entities/todo.dart';
import 'todo_model.dart';

class TodoMapper {
  static Todo fromEntity(TodoModel todoModel) {
    return Todo(
      id: todoModel.id,
      title: todoModel.title,
      isCompleted: todoModel.isCompleted,
      createdAt: todoModel.createdAt,
      updatedAt: todoModel.updatedAt,
    );
  }

  static TodoModel toEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
  }

  static List<Todo> transformToModelList(List<TodoModel> models) {
    return models.map((e) => fromEntity(e)).toList();
  }
}
