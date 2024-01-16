import '../model/local_datasource.dart';
import '../model/model.dart';
import '../model/remote_datasource.dart';
import 'command.dart';

class TodoViewModel {
  final RemoteTodoDataSource _remoteDataSource;
  final LocalTodoDataSource _localDataSource;
  List<Todo> _todos = [];

  late final Command fetchTodosCommand;

  TodoViewModel(
    this._remoteDataSource,
    this._localDataSource,
  ) {
    fetchTodosCommand = Command(_fetchTodos);
  }

  List<Todo> get todos => _todos;

  Future<void> _fetchTodos() async {
    _todos = [];
    try {
      _todos = await _remoteDataSource.fetchTodos();
    } catch (e) {
      _todos = await _localDataSource.fetchTodos();
    }
  }

  // Add more command methods as necessary
}

// typically this would be a singleton
// or you must use a dependency injection framework
final TodoViewModel todoViewModelInstance = TodoViewModel(
  RemoteTodoDataSource(),
  LocalTodoDataSource(),
);
