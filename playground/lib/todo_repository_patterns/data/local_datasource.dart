import 'data_model.dart';
import 'todo_repository.dart';

class LocalTodoDataSource implements TodoRepository {
  @override
  Future<void> addTodo(TodoDataModel todo) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodo(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<TodoDataModel>> fetchTodos() {
    return Future.delayed(
      const Duration(seconds: 5),
      () => List<TodoDataModel>.generate(
        10,
        (index) => TodoDataModel(
          id: '$index',
          title: 'Todo $index',
          isCompleted: false,
          createdAt: DateTime.now().toLocal().toString(),
          updatedAt: DateTime.now().toLocal().toString(),
        ),
      ),
    );
  }

  @override
  Future<void> updateTodo(TodoDataModel todo) {
    throw UnimplementedError();
  }
}
