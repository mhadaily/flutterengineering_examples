/// Standalone test that exercises every pure-Dart example and prints output.
///
/// Run with:  flutter test test/output_capture_test.dart
///
/// Platform-channel examples (SharedPreferences, FlutterSecureStorage,
/// path_provider) cannot run in test — those are verified by code inspection.
library;

import 'package:flutter_test/flutter_test.dart';

// Bad examples
import 'package:m9_insecure_data_storage/bad_examples/insecure_storage.dart';
import 'package:m9_insecure_data_storage/bad_examples/insecure_file_storage.dart';
import 'package:m9_insecure_data_storage/bad_examples/insecure_database.dart';
import 'package:m9_insecure_data_storage/bad_examples/insecure_logger.dart';

// Good examples
import 'package:m9_insecure_data_storage/good_examples/secure_database.dart';
import 'package:m9_insecure_data_storage/good_examples/secure_file_storage.dart';
import 'package:m9_insecure_data_storage/good_examples/secure_logger.dart';
import 'package:m9_insecure_data_storage/good_examples/secure_memory.dart';
import 'package:m9_insecure_data_storage/good_examples/security_service.dart';

void main() {
  test('1. BAD — SharedPreferences plain-text demo', () {
    print('');
    print('── 1. BAD — SharedPreferences ──────────────────────────');
    demonstrateInsecureStorage();
  });

  test('2. BAD — Plain JSON file storage', () {
    print('');
    print('── 2. BAD — Plain JSON files ───────────────────────────');
    InsecureFileStorage().demonstrateInsecureFileStorage();
  });

  test('3. BAD — Unencrypted SQLite database', () {
    print('');
    print('── 3. BAD — Unencrypted SQLite ─────────────────────────');
    InsecureDatabase().demonstrateInsecureDatabase();
  });

  test('4. BAD — Logging credentials', () {
    print('');
    print('── 4. BAD — Logging credentials ────────────────────────');
    InsecureLogger.logLoginBad('user@example.com', 's3cretP@ss!');
    InsecureLogger.logTokenBad(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJzdWIiOiIxMjM0NTY3ODkw'
      '.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U',
    );
    InsecureLogger.logApiKeyBad('sk-live-abc123xyz789');
    InsecureLogger.logUserDataBad({
      'email': 'user@example.com',
      'ssn': '123-45-6789',
      'password': 'secret123',
    });
  });

  test('5. GOOD — Encrypted database (SQLCipher)', () {
    print('');
    print('── 5. GOOD — Encrypted database ────────────────────────');
    SecureDatabase().demonstrateSecureDatabase();
  });

  test('6. GOOD — AES-GCM file encryption + secure delete', () {
    print('');
    print('── 6. GOOD — AES-GCM file encryption ──────────────────');
    final fs = SecureFileStorage();
    fs.demonstrateEncryptedFileStorage();
    print('');
    fs.demonstrateSecureDelete();
  });

  test('7. GOOD — Secure logger (auto-redaction)', () {
    print('');
    print('── 7. GOOD — Secure logger ─────────────────────────────');

    // String sanitization
    const input =
        'User login: email=user@example.com, '
        'password=secret123, '
        'token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkw.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U, '
        'card=4111-1111-1111-1111, '
        'ssn=123-45-6789';
    print('[SecureLogger] Input with sensitive data:');
    print('[SecureLogger]   Raw : $input');
    final sanitized = SecureLogger.sanitize(input);
    print('[SecureLogger]   Safe: $sanitized');
    print('');

    // Map sanitization
    print('[SecureLogger] Map sanitization:');
    final data = <String, dynamic>{
      'email': 'user@example.com',
      'password': 'secret123',
      'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkw.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U',
    };
    final sanitizedData = SecureLogger.sanitizeObject(data);
    print('[SecureLogger]   Raw : $data');
    print('[SecureLogger]   Safe: $sanitizedData');
  });

  test('8. GOOD — Secure memory (SecureString)', () {
    print('');
    print('── 8. GOOD — Secure memory ─────────────────────────────');
    demonstrateSecureMemory();
  });

  test('9. GOOD — Security checks (root/jailbreak)', () {
    print('');
    print('── 9. GOOD — Security checks ───────────────────────────');
    SecurityService().demonstrateSecurityChecks();
  });
}
