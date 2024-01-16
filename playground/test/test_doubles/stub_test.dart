import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/test_doubles.dart';

import 'stub.dart';

main() {
  testWidgets('User Profile Widget Test', (WidgetTester tester) async {
    final userProfileService = UserProfileServiceStub();

    // Inject the stub into the widget
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfileWidget(
          userProfileService,
        ),
      ),
    );

    // Wait 1 second for the FutureBuilder to complete
    await tester.pumpAndSettle(
      const Duration(seconds: 1),
    );

    // Perform your test logic here
    // Example: Verify if the widget displays "John Doe"
    expect(
      find.text('John Doe'),
      findsOneWidget,
    );
  });
}
