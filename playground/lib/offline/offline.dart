import 'data/local/todo_local.dart';
import 'data/model/todo.dart';
import 'data/network/todo_network.dart';

class OfflineTodoRepository {
  OfflineTodoRepository(
    this.todoLocalDataSource,
    this.todoNetworkDataSource,
  );

  final TodoLocalDataSource todoLocalDataSource;
  final TodoNetworkDataSource todoNetworkDataSource;

  Stream<List<Todo>> getTodos() async* {
    // Fetching todos from the local database
    final List<Todo> todos = await todoLocalDataSource.getAll();

    // Emitting todos to the UI
    yield todos;
  }

  Future<void> write(Todo todo) async {
    // Writing todo to the local database
    await todoLocalDataSource.save(todo);
  }
}
