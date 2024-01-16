// ui/todo_list_screen.dart
import 'package:flutter/material.dart';

import '../view_model/todo_view_model.dart';

class TodoListScreen extends StatelessWidget {
  TodoListScreen({
    super.key,
    required this.todoViewModel,
  }) {
    todoViewModel.fetchTodosCommand.execute();
  }

  final TodoViewModel todoViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ListenableBuilder(
        listenable: todoViewModel.fetchTodosCommand,
        builder: (BuildContext context, Widget? child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: todoViewModel.todos.length,
                  itemBuilder: (context, index) {
                    return Text(todoViewModel.todos[index].title);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!todoViewModel.fetchTodosCommand.isExecuting) {
                    todoViewModel.fetchTodosCommand.execute();
                  }
                },
                child: todoViewModel.fetchTodosCommand.isExecuting
                    ? const Text('Loading...')
                    : const Text('Refresh'),
              ),
            ],
          );
        },
      ),
    );
  }
}
