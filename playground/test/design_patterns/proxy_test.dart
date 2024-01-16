import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/proxy.dart';

void main() {
  group(
    'AccessControlProxyWidget',
    () {
      // Test when access is granted
      testWidgets(
        ' displays content when access is granted',
        (WidgetTester tester) async {
          // Build the widget with access granted
          await tester.pumpWidget(
            MaterialApp(
              home: AccessControlProxyWidget(
                protectedWidget: RestrictedContentWidget(),
                hasAccess: true,
              ),
            ),
          );

          // Verify that the restricted content is displayed
          expect(
            find.byKey(const Key('restrictedContentKey')),
            findsOneWidget,
          );
          expect(
            find.text('Restricted Content'),
            findsOneWidget,
          );
        },
      );

      // Test when access is denied
      testWidgets(
        'displays "Access Denied" when access is denied',
        (WidgetTester tester) async {
          // Build the widget with access denied
          await tester.pumpWidget(
            MaterialApp(
              home: AccessControlProxyWidget(
                protectedWidget: RestrictedContentWidget(),
                hasAccess: false,
              ),
            ),
          );

          // Verify that the "Access Denied" message
          // is displayed instead of the restricted content
          expect(
            find.byType(RestrictedContentWidget),
            findsNothing,
          );
          expect(
              find.text('Access Denied'), findsOneWidget);
        },
      );
    },
  );
}
