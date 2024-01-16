// ui/todo_list_screen.dart
import 'package:flutter/material.dart';

import 'state.dart';

class TodoListScreen extends StatelessWidget {
  TodoListScreen({
    super.key,
    required this.todoState,
  }) {
    todoState.getTodos();
  }

  final TodoState todoState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ListenableBuilder(
        listenable: todoState,
        builder: (BuildContext context, Widget? child) {
          return ListView.builder(
            itemCount: todoState.todos.length,
            itemBuilder: (context, index) {
              return Text(todoState.todos[index].title);
            },
          );
        },
      ),
    );
  }
}
