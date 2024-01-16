import 'package:flutter/foundation.dart';
import '../domain/todo_usecase.dart';
import '../domain/model.dart';

abstract class TodoState extends ChangeNotifier {
  List<Todo> get todos;
  Future<void> getTodos();
}

class _TodoState extends TodoState {
  _TodoState(this.todoUseCases);

  TodoUseCases todoUseCases;

  List<Todo> _todos = [];

  @override
  List<Todo> get todos => _todos;

  @override
  Future<void> getTodos() async {
    _todos = await todoUseCases.getTodos();
    notifyListeners();
  }
}

// typically this would be a singleton
// or you must use a dependency injection framework
final TodoState todoStateInstance = _TodoState(todosUseCasesInstance);
