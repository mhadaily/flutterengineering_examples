/// BAD EXAMPLE — Logging sensitive user data.
///
/// From the article section "Logging Sensitive Information".
/// Never log passwords, tokens, credit-card numbers, or other PII.
/// Logs can be captured via `adb logcat`, screen recordings, or CI artefacts.
library;

import 'package:flutter/foundation.dart';

class InsecureLogger {
  /// Logs the user's email AND password in clear text — NEVER do this.
  ///
  /// Output:
  /// ```
  /// [BAD] Login attempt: user@example.com / s3cretP@ss!
  /// ```
  static void logLoginBad(String email, String password) {
    debugPrint('[BAD] Login attempt: $email / $password'); // NEVER DO THIS!
  }

  /// Logs an API key — equally dangerous.
  ///
  /// Output:
  /// ```
  /// [BAD] Using API key: sk-live-abc123xyz789
  /// ```
  static void logApiKeyBad(String apiKey) {
    debugPrint('[BAD] Using API key: $apiKey');
  }
}
