import 'package:playground/todo_clean_architecture/data/models/todo_mapper.dart';

import '../../domain/entities/todo.dart';
import '../models/todo_model.dart';

class LocalTodoDataSource {
  Future<List<Todo>> fetchTodos() {
    return Future.delayed(
      const Duration(seconds: 5),
      () => List<Todo>.generate(
        10,
        (index) => TodoMapper.fromEntity(
          TodoModel(
            id: '$index',
            title: 'Todo $index',
            isCompleted: false,
            createdAt: DateTime.now().toLocal().toString(),
            updatedAt: DateTime.now().toLocal().toString(),
          ),
        ),
      ),
    );
  }
}
