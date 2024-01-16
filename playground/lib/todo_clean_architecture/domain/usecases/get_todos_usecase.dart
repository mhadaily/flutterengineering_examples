import '../contracts/todo_data_contract.dart';
import '../entities/todo.dart';

class GetTodoUseCase {
  GetTodoUseCase(this.repository);

  final TodoRepository repository;

  Future<Todo> call(String id) async {
    final todos = await repository.fetchTodos();
    return todos.where((todo) => todo.id == id).first;
  }
}
