import 'data_model.dart';
import 'todo_repository.dart';

class RemoteTodoDataSource implements TodoRepository {
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
    throw UnimplementedError();
  }

  @override
  Future<void> updateTodo(TodoDataModel todo) {
    throw UnimplementedError();
  }
}
