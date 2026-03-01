/// Standalone test that exercises every pure-Dart example and prints output.
///
/// Run with:  flutter test test/output_capture_test.dart
///
/// Platform-channel examples (SharedPreferences, FlutterSecureStorage,
/// PackageInfo) are tested separately with mocks.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';

// Bad examples
import 'package:m8_security_misconfiguration/bad_examples/insecure_http_client.dart';
import 'package:m8_security_misconfiguration/bad_examples/insecure_logger.dart';

// Good examples
import 'package:m8_security_misconfiguration/good_examples/app_config.dart';
import 'package:m8_security_misconfiguration/good_examples/deep_link_handler.dart';
import 'package:m8_security_misconfiguration/good_examples/secure_http_client.dart';
import 'package:m8_security_misconfiguration/good_examples/secure_logger.dart';

void main() {
  test('1. AppConfig — debug mode detection', () {
    print('');
    print('── 1. Debug Mode Detection ──────────────────────────────');
    AppConfig.validateReleaseConfiguration();
  });

  test('2. Insecure HTTP client (BAD)', () {
    print('');
    print('── 2. Insecure HTTP Client (BAD) ────────────────────────');
    demonstrateInsecureClient();
  });

  test('3. Secure HTTP client (GOOD)', () {
    print('');
    print('── 3. Secure HTTP Client (GOOD) ─────────────────────────');
    final client = SecureHttpClient.createSecureClient();
    client.close();
  });

  test('7. Insecure Logger (BAD)', () {
    print('');
    print('── 7. Insecure Logger (BAD) ─────────────────────────────');
    InsecureLogger.logLoginBad('user@example.com', 's3cretP@ss!');
    InsecureLogger.logApiKeyBad('sk-live-abc123xyz789');
  });

  test('8. Secure Logger (GOOD)', () {
    print('');
    print('── 8. Secure Logger (GOOD) ──────────────────────────────');
    // developer.log output appears as "[log] ..." in the Flutter debug console
    // but not in flutter test stdout. We call the masking directly to show it:
    SecureLogger.logLoginGood('majid@example.com');
    SecureLogger.log('User tapped checkout button');
    // Print what the debug console would show:
    print('[log] Login attempt: ${SecureLogger.maskEmail('majid@example.com')}');
    print('[log] User tapped checkout button');
  });

  test('9. Deep Link Validation', () {
    print('');
    print('── 9. Deep Link Validation ──────────────────────────────');
    final handler = DeepLinkHandler();

    handler.handleDeepLink(
      Uri.parse('https://yourapp.com/product?id=abc-123'),
    );
    // Pass the raw string so the traversal check fires before URI normalisation
    const traversalRaw = 'https://yourapp.com/../etc/passwd';
    handler.handleDeepLink(
      Uri.parse(traversalRaw),
      rawLink: traversalRaw,
    );
    handler.handleDeepLink(
      Uri.parse('https://evil.com/product?id=1'),
    );
    // Uri.parse URL-encodes < and >, so pass the raw string too
    const xssRaw = 'https://yourapp.com/search?q=<script>alert(1)</script>';
    handler.handleDeepLink(
      Uri.parse(xssRaw),
      rawLink: xssRaw,
    );
  });
}
