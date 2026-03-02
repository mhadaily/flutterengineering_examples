/// ✅ SECURE: Cryptographically secure random number generation.
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class SecureRandomGenerator {
  /// Generate cryptographically secure random bytes.
  static Uint8List generateBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (_) => random.nextInt(256)),
    );
  }

  /// Generate a secure random URL-safe base64 string.
  static String generateString(int byteLength) {
    final bytes = generateBytes(byteLength);
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  /// Generate a secure random integer in [0, max).
  static int generateInt(int max) {
    return Random.secure().nextInt(max);
  }

  /// 12-byte nonce for AES-GCM.
  static Uint8List generateAesGcmNonce() => generateBytes(12);

  /// 16-byte IV for AES-CBC.
  static Uint8List generateAesCbcIv() => generateBytes(16);

  /// Salt for password hashing.
  static Uint8List generateSalt({int length = 16}) => generateBytes(length);
}

/// Pure-Dart demo: generate various secure random values.
void demonstrateSecureRandom() {
  print('--- Secure random bytes (16) ---');
  final bytes = SecureRandomGenerator.generateBytes(16);
  print('Hex:    ${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}');
  print('Base64: ${base64Encode(bytes)}');
  print('');

  print('--- Secure random token (32 bytes → base64url) ---');
  final token = SecureRandomGenerator.generateString(32);
  print('Token: $token');
  print('');

  print('--- AES-GCM nonce (12 bytes) ---');
  final nonce = SecureRandomGenerator.generateAesGcmNonce();
  print('Nonce: ${base64Encode(nonce)}');
  print('');

  print('--- Password salt (16 bytes) ---');
  final salt = SecureRandomGenerator.generateSalt();
  print('Salt: ${base64Encode(salt)}');
  print('');

  // Show that each call produces different values
  final a = SecureRandomGenerator.generateBytes(8);
  final b = SecureRandomGenerator.generateBytes(8);
  print('Two runs differ: ${base64Encode(a)} ≠ ${base64Encode(b)}');
}
