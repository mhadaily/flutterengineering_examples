/// Validators class contains business logic for validating inputs
///
/// this class contains a static method
/// usage:
/// ```dart
/// String? email = Validators.validateEmail('email');
/// ```
class Validators {
  // business logic for validating email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // business logic for validating password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
