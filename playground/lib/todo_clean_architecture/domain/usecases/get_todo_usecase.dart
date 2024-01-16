import '../contracts/todo_data_contract.dart';
import '../entities/todo.dart';

class GetTodosUseCase {
  GetTodosUseCase({
    required this.todoRepository,
  });

  final TodoRepository todoRepository;

  Future<List<Todo>> call() async {
    return todoRepository.fetchTodos();
  }
}
