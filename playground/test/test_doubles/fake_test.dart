import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:playground/test_doubles.dart';

// 1.
class FakeDatabase extends Fake implements Database {
  final map = HashMap();

  @override
  Future<UserProfile> read(String userId) async {
    return map[userId]!;
  }

  @override
  Future<void> write(UserProfile user) async {
    map[user.userId] = user;
  }
}

void main() {
  test('should write user profile correctly', () async {
    // Arrange
    //2.
    final fakeDb = FakeDatabase();
    //3.
    final repository = UserRepository(fakeDb);

    // Act
    //4.
    await fakeDb.write(
      UserProfile(
        userId: '123',
        name: 'John Doe',
        email: 'jon@doe.dev',
      ),
    );
    final profile = await repository.loadUserProfile('123');

    // Assert
    //5.
    expect(profile.userId, equals('123'));
    expect(profile.name, equals('John Doe'));
    expect(profile.email, equals('jon@doe.dev'));
  });
}
