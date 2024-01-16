// ui/todo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'events.dart';
import 'state.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoading) {
            return const CircularProgressIndicator();
          } else if (state is TodosLoaded) {
            return ListView(
              children: state.todos.map((todo) => Text(todo.title)).toList(),
            );
          } else {
            return Column(
              children: [
                const Text('Something went wrong!'),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<TodoBloc>(context).add(LoadTodos());
                  },
                  child: const Text('Retry'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
