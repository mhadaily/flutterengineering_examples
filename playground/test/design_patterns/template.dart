import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/template.dart';
// Import your BaseWidget and ConcreteWidget classes

void main() {
  testWidgets(
    'ConcreteWidget should display the correct AppBar title and body content',
    (WidgetTester tester) async {
      // Build the ConcreteWidget
      await tester.pumpWidget(const MaterialApp(home: ConcreteWidget()));

      // Verify that the AppBar title is correct as per ConcreteWidget's implementation
      expect(find.text('Concrete Widget'), findsOneWidget);

      // Verify that the body content is correct as per ConcreteWidget's implementation
      expect(
        find.text('Concrete implementation of buildBody.'),
        findsOneWidget,
      );
    },
  );
}
