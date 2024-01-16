import 'package:flutter/material.dart';

import 'view/todo_list.dart';
import 'view_model/todo_view_model.dart';

main() {
  runApp(
    MaterialApp(
      home: TodoListScreen(
        todoViewModel: todoViewModelInstance,
      ),
    ),
  );
}
