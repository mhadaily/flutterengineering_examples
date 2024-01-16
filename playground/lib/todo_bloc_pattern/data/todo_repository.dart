import 'data_model.dart';
import 'local_datasource.dart';
import 'remote_datasource.dart';

abstract interface class TodoRepository {
  Future<List<TodoDataModel>> fetchTodos();
  Future<void> addTodo(TodoDataModel todo);
  Future<void> updateTodo(TodoDataModel todo);
  Future<void> deleteTodo(String id);
}

class _TodoRepositoryImpl implements TodoRepository {
  final LocalTodoDataSource localDataSource;
  final RemoteTodoDataSource remoteDataSource;

  const _TodoRepositoryImpl(
    this.localDataSource,
    this.remoteDataSource,
  );

  @override
  Future<List<TodoDataModel>> fetchTodos() async {
    try {
      return await remoteDataSource.fetchTodos();
    } catch (e) {
      return localDataSource.fetchTodos();
    }
  }

  @override
  Future<void> addTodo(TodoDataModel todo) async {
    // Implement logic combining local and remote data sources
  }

  @override
  Future<void> deleteTodo(String id) async {
    // Implement logic combining local and remote data sources
  }

  @override
  Future<void> updateTodo(TodoDataModel todo) async {
    // Implement logic combining local and remote data sources
  }
}

// typically this would be a singleton
// or you must use a dependency injection framework
final todoRepositoryInstance = _TodoRepositoryImpl(
  LocalTodoDataSource(),
  RemoteTodoDataSource(),
);
