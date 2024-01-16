import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/strategy.dart';

void main() {
  List<int> testData = [3, 1, 4, 5, 9];

  testWidgets('SortingWidget displays data sorted by AscendingSort',
      (WidgetTester tester) async {
    ContextStrategy sortingContext = ContextStrategy(AscendingSort());

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SortingWidget(
          dataset: testData,
          contextStrategy: sortingContext,
        ),
      ),
    ));

    List<int> expectedSortedData = sortingContext.executeStrategy(testData);
    for (int i = 0; i < expectedSortedData.length; i++) {
      expect(
        find.widgetWithText(
          ListTile,
          expectedSortedData[i].toString(),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('SortingWidget displays data sorted by DescendingSort',
      (WidgetTester tester) async {
    ContextStrategy sortingContext = ContextStrategy(DescendingSort());

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SortingWidget(
          dataset: testData,
          contextStrategy: sortingContext,
        ),
      ),
    ));

    List<int> expectedSortedData = sortingContext.executeStrategy(testData);
    for (int i = 0; i < expectedSortedData.length; i++) {
      expect(
        find.widgetWithText(
          ListTile,
          expectedSortedData[i].toString(),
        ),
        findsOneWidget,
      );
    }
  });
}
