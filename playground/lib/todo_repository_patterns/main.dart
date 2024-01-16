import 'package:flutter/material.dart';

import 'presentation/state.dart';
import 'presentation/ui.dart';

main() {
  runApp(
    MaterialApp(
      home: TodoListScreen(
        todoState: todoStateInstance,
      ),
    ),
  );
}
