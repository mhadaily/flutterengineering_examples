import 'package:flutter/material.dart';

import 'presentation/presentation.dart';
import 'domain/domain.dart';
import 'data/data.dart';

main() {
  runApp(
    MaterialApp(
      // Need to use a proper dependency injection library
      home: TodoListScreen(
        todoState: TodoState(
          getTodosUseCase: GetTodosUseCase(
            todoRepository: TodoRepositoryImpl(
              localDataSource: LocalTodoDataSource(),
              remoteDataSource: RemoteTodoDataSource(),
            ),
          ),
        ),
      ),
    ),
  );
}
