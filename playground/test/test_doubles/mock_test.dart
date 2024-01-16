import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:playground/test_doubles.dart';

// 1.
class MockUserProfileService extends Mock implements UserProfileService {}

void main() {
  testWidgets('Should call getProfile on service', (tester) async {
    // 2.
    final mockService = MockUserProfileService();

// 3.
    when(
      () => mockService.getUserProfile(
        any(),
      ),
    ).thenAnswer(
      (_) async => UserProfile(
        userId: '1',
        name: 'John Doe',
        email: 'john@example.com',
      ),
    );

    // Injecting the mock service into the UserProfileWidget
    await tester.pumpWidget(
      MaterialApp(
        // 4.
        home: UserProfileWidget(mockService),
      ),
    );

    // Allow time for the UserProfileWidget to rebuild with the new data
    await tester.pumpAndSettle();

    // Verify that the getUserProfile method was called on the mock
    // 5.
    verify(() => mockService.getUserProfile(any())).called(1);

    // Verify the widget displays the expected text
    // 6.
    expect(find.text('John Doe'), findsOneWidget);
  });
}
