/// GOOD EXAMPLE — Sanitised logging that never leaks PII.
///
/// From the article section "Logging Sensitive Information".
/// In debug mode we log a *masked* version of the email; in release mode
/// we skip the log entirely (or forward to a crash-reporting service without PII).
library;

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class SecureLogger {
  /// General-purpose log that only emits in debug mode.
  static void log(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(message, error: error, stackTrace: stackTrace);
    }
    // In release: forward to crash-reporting without PII.
  }

  /// Logs a login attempt with the email *masked*.
  ///
  /// Output (debug):
  /// ```
  /// [log] Login attempt: ma***@example.com
  /// ```
  static void logLoginGood(String email) {
    if (kDebugMode) {
      final masked = maskEmail(email);
      developer.log('Login attempt: $masked');
    }
  }

  /// Masks an email address, keeping only the first two characters of the
  /// local part. Visible for testing.
  ///
  /// Examples:
  /// ```
  /// maskEmail('majid@example.com')  → 'ma***@example.com'
  /// maskEmail('ab@x.co')            → 'ab***@x.co'
  /// maskEmail('a@x.co')             → '***@x.co'
  /// ```
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return '***';

    final local = parts[0];
    final domain = parts[1];

    if (local.length <= 2) return '***@$domain';
    return '${local.substring(0, 2)}***@$domain';
  }

  /// This method solely documents values that should **never** be logged.
  /// Calling it throws immediately.
  static void neverLog({
    String? password,
    String? token,
    String? creditCard,
    String? ssn,
    String? apiKey,
  }) {
    throw UnsupportedError('This method should never be called');
  }
}
