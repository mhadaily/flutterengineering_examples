import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/observer.dart';

void main() {
  testWidgets(
    'Counter value should update on increment',
    (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Verify initial state of counter
      expect(find.text('Current counter value:'), findsNWidgets(2));
      expect(find.text('0'), findsNWidgets(2));

      // Find and tap the FloatingActionButton
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that the counter has incremented
      expect(find.text('1'), findsNWidgets(2));
    },
  );
}
