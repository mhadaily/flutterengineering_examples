import 'data/model/todo.dart';

abstract interface class TodoService {
  Future<Todo?> get(String id);
  Future<List<Todo>> getAll();
  Future<void> save(Todo todo);
  Future<void> refresh(List<Todo> listTodos);
}
