// OWASP M7 Binary Protection — widget smoke test.
//
// Verifies that the demo app renders and exposes the "Run All Checks" FAB.

import 'package:flutter_test/flutter_test.dart';

import 'package:m7_binary_protection/main.dart';

void main() {
  testWidgets('M7DemoApp renders and shows Run All Checks button',
      (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const M7DemoApp());

    // The app bar title should be present.
    expect(find.text('OWASP M7 - Binary Protection'), findsOneWidget);
    // The FAB label should be visible before any checks are run.
    expect(find.text('Run All Checks'), findsOneWidget);
  });
}
