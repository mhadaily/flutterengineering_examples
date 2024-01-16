import 'package:flutter/foundation.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/get_todo_usecase.dart';

class TodoState extends ChangeNotifier {
  TodoState({
    required this.getTodosUseCase,
  });

  GetTodosUseCase getTodosUseCase;

  List<Todo> _todos = [];

  @override
  List<Todo> get todos => _todos;

  @override
  Future<void> getTodos() async {
    _todos = await getTodosUseCase.call();
    notifyListeners();
  }
}
