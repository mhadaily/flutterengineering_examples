import '../data/todo_repository.dart';
import 'model.dart';

abstract interface class TodoUseCases {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
}

class _TodoUseCases implements TodoUseCases {
  _TodoUseCases(this.repository);

  final TodoRepository repository;

  @override
  Future<List<Todo>> getTodos() async {
    final todos = await repository.fetchTodos();
    return todos.map((todo) => Todo.fromDataModel(todo)).toList();
  }

  @override
  Future<void> addTodo(Todo todo) {
    final todoDataModel = todo.toDataModel();
    return repository.addTodo(todoDataModel);
  }
}

// typically this would be a singleton
// or you must use a dependency injection framework
final todosUseCasesInstance = _TodoUseCases(todoRepositoryInstance);
