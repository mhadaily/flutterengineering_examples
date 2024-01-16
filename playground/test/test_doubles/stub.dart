import 'package:playground/test_doubles.dart';

class UserProfileServiceStub implements UserProfileService {
  @override
  Future<UserProfile> getUserProfile(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Return a hardcoded user profile
    return UserProfile(
      userId: userId,
      name: 'John Doe',
      email: 'john@example.com',
    );
  }
}
