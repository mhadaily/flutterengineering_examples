import 'model.dart';

class RemoteTodoDataSource implements DataSource {
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
    throw UnimplementedError();
  }

  @override
  Future<void> updateTodo(Todo todo) {
    throw UnimplementedError();
  }
}
