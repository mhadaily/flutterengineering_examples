import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/bloc.dart';
import 'presentation/events.dart';
import 'presentation/ui.dart';

void main() {
  runApp(MaterialApp(
    home: BlocProvider(
      create: (context) => todoBlocInstance..add(LoadTodos()),
      child: const TodoListScreen(),
    ),
  ));
}
