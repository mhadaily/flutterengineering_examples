/// GOOD EXAMPLE — Safe logging that auto-redacts sensitive patterns.
///
/// Completely disables logging in release mode.
/// In debug mode, automatically redacts JWTs, credit cards, SSNs,
/// passwords, and any key in a map that looks sensitive.
library;

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class SecureLogger {
  static final Set<String> _sensitiveKeys = {
    'password',
    'token',
    'secret',
    'key',
    'authorization',
    'credit_card',
    'ssn',
    'pin',
    'cvv',
  };

  /// Log safely, redacting sensitive information.
  static void log(String message, {Object? data}) {
    if (kReleaseMode) return;

    final sanitizedMessage = sanitize(message);
    final sanitizedData = data != null ? sanitizeObject(data) : null;

    developer.log(
      sanitizedMessage,
      name: 'APP',
      error: sanitizedData,
    );
  }

  /// Public sanitize so tests can verify output.
  static String sanitize(String input) {
    String result = input;

    // JWT tokens
    result = result.replaceAll(
      RegExp(r'eyJ[A-Za-z0-9_-]*\.eyJ[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*'),
      '[REDACTED_JWT]',
    );

    // Credit card numbers
    result = result.replaceAll(
      RegExp(r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b'),
      '[REDACTED_CARD]',
    );

    // SSN patterns
    result = result.replaceAll(
      RegExp(r'\b\d{3}[-\s]?\d{2}[-\s]?\d{4}\b'),
      '[REDACTED_SSN]',
    );

    // Password in key=value context
    result = result.replaceAll(
      RegExp(r'password["\s:=]+[^\s,}"]+', caseSensitive: false),
      'password=[REDACTED]',
    );

    return result;
  }

  /// Public sanitizeObject so tests can verify output.
  static Object? sanitizeObject(Object obj) {
    if (obj is Map) {
      return obj.map((key, value) {
        final keyLower = key.toString().toLowerCase();
        if (_sensitiveKeys.any((k) => keyLower.contains(k))) {
          return MapEntry(key, '[REDACTED]');
        }
        return MapEntry(key, sanitizeObject(value));
      });
    } else if (obj is List) {
      return obj.map((e) => sanitizeObject(e as Object)).toList();
    } else if (obj is String) {
      return sanitize(obj);
    }
    return obj;
  }
}
