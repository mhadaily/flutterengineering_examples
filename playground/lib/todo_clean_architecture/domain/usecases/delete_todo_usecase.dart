import '../contracts/todo_data_contract.dart';

class DeleteTodoUseCase {
  DeleteTodoUseCase(this.repository);

  final TodoRepository repository;

  Future<void> call() async {
    // call the repository to delete
  }
}
