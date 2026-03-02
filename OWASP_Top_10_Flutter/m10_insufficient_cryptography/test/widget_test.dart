import 'package:flutter_test/flutter_test.dart';
import 'package:m10_insufficient_cryptography/main.dart';

void main() {
  testWidgets('M10DemoApp renders title', (tester) async {
    await tester.pumpWidget(const M10DemoApp());
    expect(find.text('M10 — Insufficient Cryptography'), findsOneWidget);
  });
}
