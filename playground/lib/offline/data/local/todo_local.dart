import '../../interface.dart';
import 'db/local_db.dart';
import '../model/todo.dart';

class TodoLocalDataSource implements TodoService {
  TodoLocalDataSource(this.db);

  final TodoDatabase db;

  @override
  Future<Todo?> get(String id) async {
    // Fetching todos from the local database
    final Todo? todo = await db.get(id);

    // Returning todos to the repository
    return todo;
  }

  @override
  Future<List<Todo>> getAll() async {
    // Fetching todos from the local database
    final List<Todo> todos = await db.getAll();

    // Returning todos to the repository
    return todos;
  }

  @override
  Future<List<Todo>> refresh(List<Todo> listTodos) async {
    // Converting todos to the local model
    return listTodos;
  }

  @override
  Future<void> save(Todo todo) async {
    return db.write(todo);
  }
}
