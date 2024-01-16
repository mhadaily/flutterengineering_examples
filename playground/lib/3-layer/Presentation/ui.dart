import 'package:flutter/material.dart';
import 'state.dart';

void main() {
  runApp(const ListenableBuilderExample());
}

class ListenableBuilderExample extends StatefulWidget {
  const ListenableBuilderExample({super.key});

  @override
  State<ListenableBuilderExample> createState() =>
      _ListenableBuilderExampleState();
}

class _ListenableBuilderExampleState extends State<ListenableBuilderExample> {
  final UiStateManager _counter = UiStateManager();

  @override
  void initState() {
    _counter.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('3-Layer Demo Home')),
        body: UiWidget(stateManager: _counter),
      ),
    );
  }
}

class UiWidget extends StatelessWidget {
  const UiWidget({
    super.key,
    required this.stateManager,
  });

  final UiStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListenableBuilder(
            listenable: stateManager,
            builder: (BuildContext context, Widget? child) {
              return Column(
                children: [
                  for (var user in stateManager.value)
                    Text(
                      user.data,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
