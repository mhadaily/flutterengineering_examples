import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/decorator.dart';

void main() {
  testWidgets('BorderText adds a border', (WidgetTester tester) async {
    TextComponent text = SimpleText('Test');
    TextComponent borderedText = BorderText(text);

    // Wrap the component in a MaterialApp and Scaffold to provide context
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (BuildContext context) {
              return borderedText.build(context);
            },
          ),
        ),
      ),
    ));

    final borderedTextFinder = find.byType(Container);
    expect(borderedTextFinder, findsOneWidget);

    final Container container = tester.firstWidget(borderedTextFinder);
    expect(container.decoration, isA<BoxDecoration>());

    BoxDecoration decoration = container.decoration as BoxDecoration;
    expect(decoration.border, isNotNull);
  });

  // ... other test cases ...
}
