import 'package:flutter_test/flutter_test.dart';
import 'package:m9_insecure_data_storage/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const M9DemoApp());
    expect(find.text('M9 — Insecure Data Storage'), findsOneWidget);
    expect(find.text('Run All'), findsOneWidget);
  });
}
