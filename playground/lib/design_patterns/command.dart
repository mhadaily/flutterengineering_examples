import 'dart:collection';
import 'package:flutter/material.dart';

// Command Interface
abstract class Command {
  String get name;
  void execute();
  void undo();
}

// Concrete Command for Drawing
class DrawCommand implements Command {
  DrawCommand();

  @override
  String get name => 'DrawCommand';

  @override
  void execute() {}

  @override
  void undo() {}
}

// Concrete Command for ChangeColor
class ChangeColorCommand implements Command {
  ChangeColorCommand();

  @override
  String get name => 'ChangeColorCommand';

  @override
  void execute() {}

  @override
  void undo() {}
}

// Command Manager to handle execution and undoing
class CommandManager {
  final _commandList = ListQueue<Command>();

  bool get hasHistory => commandHistoryList.isNotEmpty;

  List<String> get commandHistoryList =>
      _commandList.map((c) => c.name).toList();

  void executeCommand(Command command) => _commandList.add(command);

  void undo() {
    if (_commandList.isEmpty) return;
    _commandList.removeLast().undo();
  }
}

class MyApp extends StatefulWidget {
  final CommandManager commandManager;

  const MyApp({
    super.key,
    required this.commandManager,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Command Pattern Example'),
        ),
        body: Column(
          key: const Key('drawButtonKey'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                widget.commandManager.executeCommand(
                  DrawCommand(),
                );
                setState(() {});
              },
              child: const Text('Tap to draw'),
            ),
            TextButton(
              onPressed: () {
                widget.commandManager.executeCommand(
                  ChangeColorCommand(),
                );
                setState(() {});
              },
              child: const Text('Tap to Change Color'),
            ),
            if (widget.commandManager.hasHistory)
              TextButton(
                onPressed: () {
                  widget.commandManager.undo();
                  setState(() {});
                },
                child: const Text('Press to undo'),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.commandManager.commandHistoryList.length,
                itemBuilder: (context, index) {
                  return Text(widget.commandManager.commandHistoryList[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Usage in the app
void main() {
  final CommandManager commandManager = CommandManager();

  runApp(
    MyApp(
      commandManager: commandManager,
    ),
  );
}
