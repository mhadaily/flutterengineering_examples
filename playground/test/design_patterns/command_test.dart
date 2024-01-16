import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/command.dart';

void main() {
  testWidgets('MyApp should execute and undo commands correctly',
      (WidgetTester tester) async {
    // Create a CommandManager and build the MyApp widget
    CommandManager commandManager = CommandManager();
    await tester.pumpWidget(MyApp(commandManager: commandManager));

    // Find the buttons
    Finder drawButton = find.text('Tap to draw');
    Finder changeColorButton = find.text('Tap to Change Color');
    Finder undoButton = find.text('Press to undo');

    // Execute the DrawCommand
    await tester.tap(drawButton);
    await tester.pump();

    // Verify that the DrawCommand is added to the history
    expect(find.text('DrawCommand'), findsOneWidget);

    // Execute the ChangeColorCommand
    await tester.tap(changeColorButton);
    await tester.pump();

    // Verify that the ChangeColorCommand is added to the history
    expect(find.text('ChangeColorCommand'), findsOneWidget);

    // Undo the last command (ChangeColorCommand)
    await tester.tap(undoButton);
    await tester.pump();

    // Verify that the ChangeColorCommand is removed from the history
    expect(find.text('ChangeColorCommand'), findsNothing);
    // Verify that the DrawCommand is still in the history
    expect(find.text('DrawCommand'), findsOneWidget);

    // Undo the DrawCommand
    await tester.tap(undoButton);
    await tester.pump();

    // Verify that the DrawCommand is removed from the history
    expect(find.text('DrawCommand'), findsNothing);
  });
}
