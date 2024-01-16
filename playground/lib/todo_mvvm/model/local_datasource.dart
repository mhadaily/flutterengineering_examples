import 'model.dart';

class LocalTodoDataSource implements DataSource {
  @override
  Future<void> addTodo(Todo todo) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodo(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>> fetchTodos() {
    return Future.delayed(
      const Duration(seconds: 5),
      () => List<Todo>.generate(
        10,
        (index) => Todo(
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
  Future<void> updateTodo(Todo todo) {
    throw UnimplementedError();
  }
}
