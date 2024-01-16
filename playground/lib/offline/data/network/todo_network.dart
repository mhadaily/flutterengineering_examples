import '../../interface.dart';
import '../model/todo.dart';

class HttpClientFake {
  Future<dynamic> get(String path) async {
    return [];
  }

  Future<List<Todo>> post(String path) async {
    return [];
  }
}

class TodoNetworkDataSource implements TodoService {
  TodoNetworkDataSource(this.httpClient);

  final HttpClientFake httpClient;

  @override
  Future<Todo?> get(String id) async {
    // Fetching todos from the network
    final Todo? todo = await httpClient.get('/todos/$id');

    // Returning todos to the repository
    return todo;
  }

  @override
  Future<List<Todo>> getAll() async {
    // Fetching todos from the network
    final List<Todo> todos = await httpClient.get('/todos');

    // Returning todos to the repository
    return todos;
  }

  @override
  Future<void> save(Todo listTodos) async {
    httpClient.post('/save-todos');
    return;
  }

  @override
  Future<void> refresh(List<Todo> listTodos) async {
    return;
  }
}
