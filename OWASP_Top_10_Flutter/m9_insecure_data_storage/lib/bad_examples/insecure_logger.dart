/// BAD EXAMPLE — Logging sensitive data.
///
/// print() and debugPrint() output persists in release builds and
/// is visible via ADB, device logs, or crash reports.
library;

class InsecureLogger {
  /// Demonstrates the vulnerability: credentials in logs.
  static void logLoginBad(String email, String password) {
    print('[BAD] Login attempt: email=$email, password=$password');
  }

  /// Demonstrates the vulnerability: API token in logs.
  static void logTokenBad(String token) {
    print('[BAD] Got token: $token');
  }

  /// Demonstrates the vulnerability: API key in logs.
  static void logApiKeyBad(String apiKey) {
    print('[BAD] API Key: $apiKey');
  }

  /// Demonstrates the vulnerability: full user object in logs.
  static void logUserDataBad(Map<String, dynamic> userData) {
    print('[BAD] User data: $userData');
  }
}
