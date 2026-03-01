import 'package:flutter_test/flutter_test.dart';
import 'package:m8_security_misconfiguration/main.dart';

void main() {
  testWidgets('App renders demo home', (tester) async {
    await tester.pumpWidget(const M8DemoApp());
    expect(find.text('M8: Security Misconfiguration'), findsOneWidget);
  });
}
