import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/composite.dart';

void main() {
  testWidgets('Submenu should display its title and child items',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Submenu(
          title: 'Test Submenu',
          children: [
            SimpleMenuItem(title: 'Child Item', action: () {}),
          ],
        ),
      ),
    ));

    // Verify the submenu title is displayed
    expect(find.text('Test Submenu'), findsOneWidget);

    // Expand the submenu to see child items
    await tester.tap(find.text('Test Submenu'));
    await tester.pumpAndSettle();

    // Verify the child item is displayed
    expect(find.text('Child Item'), findsOneWidget);
  });

  // Additional tests for Submenu and other components
}
