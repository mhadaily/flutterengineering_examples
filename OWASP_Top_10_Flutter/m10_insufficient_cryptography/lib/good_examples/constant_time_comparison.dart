/// ✅ SECURE: Constant-time comparison to prevent timing attacks.
///
/// Regular == stops at the first mismatch, leaking positional information.
/// This implementation always compares every byte.
library;

import 'dart:convert';

/// Constant-time comparison of two byte lists.
bool constantTimeEquals(List<int> a, List<int> b) {
  if (a.length != b.length) {
    // Still do a dummy comparison to avoid length-timing leak.
    _alwaysCompare(a, a);
    return false;
  }
  return _alwaysCompare(a, b);
}

bool _alwaysCompare(List<int> a, List<int> b) {
  var result = 0;
  for (var i = 0; i < a.length; i++) {
    result |= a[i] ^ b[i];
  }
  return result == 0;
}

/// Timing-safe password verification wrapper.
bool verifyPasswordSafe(String provided, String stored) {
  final providedBytes = utf8.encode(provided);
  final storedBytes = utf8.encode(stored);

  if (providedBytes.length != storedBytes.length) {
    _alwaysCompare(providedBytes, providedBytes);
    return false;
  }
  return _alwaysCompare(providedBytes, storedBytes);
}

/// Pure-Dart demo: constant-time comparison results.
void demonstrateConstantTimeComparison() {
  final a = utf8.encode('correctPassword123');
  final b = utf8.encode('correctPassword123');
  final c = utf8.encode('wrongPassword12345');
  final d = utf8.encode('short');

  print('--- Constant-time comparison ---');
  print('Same value:       ${constantTimeEquals(a, b)}');
  print('Different value:  ${constantTimeEquals(a, c)}');
  print('Different length: ${constantTimeEquals(a, utf8.encode('short'))}');
  print('');

  print('--- verifyPasswordSafe ---');
  print('Correct: ${verifyPasswordSafe("secret", "secret")}');
  print('Wrong:   ${verifyPasswordSafe("secret", "SECRET")}');
  print('Length:  ${verifyPasswordSafe("short", "a-much-longer-password")}');
}
