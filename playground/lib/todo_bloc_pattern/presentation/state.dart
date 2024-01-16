import '../domain/model.dart';

abstract class TodoState {}

class TodosLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;
  TodosLoaded(this.todos);
}

class TodoError extends TodoState {}
