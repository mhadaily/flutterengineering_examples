/// Standalone test that exercises every pure-Dart example and prints output.
///
/// Run with:  flutter test test/output_capture_test.dart
///
/// Platform-channel examples (FlutterSecureStorage) cannot run in test —
/// those are verified by code inspection.
library;

import 'package:flutter_test/flutter_test.dart';

// Bad examples
import 'package:m10_insufficient_cryptography/bad_examples/insecure_crypto.dart';
import 'package:m10_insufficient_cryptography/bad_examples/ecb_mode_demo.dart';
import 'package:m10_insufficient_cryptography/bad_examples/insecure_random.dart';
import 'package:m10_insufficient_cryptography/bad_examples/weak_password_hashing.dart';

// Good examples
import 'package:m10_insufficient_cryptography/good_examples/secure_encryption_service.dart';
import 'package:m10_insufficient_cryptography/good_examples/chacha_encryption_service.dart';
import 'package:m10_insufficient_cryptography/good_examples/secure_password_hasher.dart';
import 'package:m10_insufficient_cryptography/good_examples/pbkdf2_password_hasher.dart';
import 'package:m10_insufficient_cryptography/good_examples/secure_key_generator.dart';
import 'package:m10_insufficient_cryptography/good_examples/key_management_service.dart';
import 'package:m10_insufficient_cryptography/good_examples/signature_service.dart';
import 'package:m10_insufficient_cryptography/good_examples/secure_random_generator.dart';
import 'package:m10_insufficient_cryptography/good_examples/constant_time_comparison.dart';
import 'package:m10_insufficient_cryptography/good_examples/gcm_unique_demo.dart';

void main() {
  // ── Bad examples ───────────────────────────────────────────

  test('1. BAD — Common crypto mistakes', () {
    print('');
    print('── 1. BAD — Common crypto mistakes ─────────────────────');
    demonstrateInsecureCrypto();
  });

  test('2. BAD — ECB pattern leak', () {
    print('');
    print('── 2. BAD — ECB pattern leak ───────────────────────────');
    demonstrateECBProblem();
  });

  test('3. BAD — Insecure random', () {
    print('');
    print('── 3. BAD — Insecure random ────────────────────────────');
    demonstrateInsecureRandom();
  });

  test('4. BAD — Weak password hashing (SHA-256)', () {
    print('');
    print('── 4. BAD — Weak password hashing ──────────────────────');
    demonstrateWeakPasswordHashing();
  });

  // ── Good examples ──────────────────────────────────────────

  test('5. GOOD — AES-256-GCM encrypt/decrypt', () async {
    print('');
    print('── 5. GOOD — AES-256-GCM ──────────────────────────────');
    await demonstrateAesGcm();
  });

  test('6. GOOD — ChaCha20-Poly1305', () async {
    print('');
    print('── 6. GOOD — ChaCha20-Poly1305 ────────────────────────');
    await demonstrateChaCha20();
  });

  test('7. GOOD — Argon2id password hashing', () async {
    print('');
    print('── 7. GOOD — Argon2id ─────────────────────────────────');
    await demonstrateArgon2id();
  });

  test('8. GOOD — PBKDF2-SHA256 password hashing', () async {
    print('');
    print('── 8. GOOD — PBKDF2-SHA256 ────────────────────────────');
    await demonstratePbkdf2();
  });

  test('9. GOOD — Key generation & HKDF', () async {
    print('');
    print('── 9. GOOD — Key generation & HKDF ────────────────────');
    await demonstrateKeyGeneration();
  });

  test('10. GOOD — Key management lifecycle', () {
    print('');
    print('── 10. GOOD — Key management lifecycle ────────────────');
    demonstrateKeyManagement();
  });

  test('11. GOOD — Ed25519 signatures', () async {
    print('');
    print('── 11. GOOD — Ed25519 signatures ──────────────────────');
    await demonstrateSignatures();
  });

  test('12. GOOD — Secure random', () {
    print('');
    print('── 12. GOOD — Secure random ───────────────────────────');
    demonstrateSecureRandom();
  });

  test('13. GOOD — Constant-time comparison', () {
    print('');
    print('── 13. GOOD — Constant-time comparison ────────────────');
    demonstrateConstantTimeComparison();
  });

  test('14. GOOD — GCM unique ciphertexts', () async {
    print('');
    print('── 14. GOOD — GCM unique ciphertexts ──────────────────');
    await demonstrateGcmUniqueCiphertexts();
  });
}
