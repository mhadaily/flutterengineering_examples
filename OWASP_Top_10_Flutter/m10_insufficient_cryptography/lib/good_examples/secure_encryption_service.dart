/// ✅ SECURE: AES-256-GCM encryption with proper key management.
///
/// Uses `cryptography` package for AES-GCM and `flutter_secure_storage` for
/// key persistence. Platform-channel dependent — verified by code inspection.
library;

import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureEncryptionService {
  final _secureStorage = const FlutterSecureStorage();
  static const _keyAlias = 'encryption_master_key';

  final _algorithm = AesGcm.with256bits();

  /// Generate and securely store a new encryption key.
  Future<void> generateAndStoreKey() async {
    final secretKey = await _algorithm.newSecretKey();
    final keyBytes = await secretKey.extractBytes();

    await _secureStorage.write(
      key: _keyAlias,
      value: base64Encode(keyBytes),
    );
  }

  /// Retrieve the stored encryption key.
  Future<SecretKey?> _getSecretKey() async {
    final keyBase64 = await _secureStorage.read(key: _keyAlias);
    if (keyBase64 == null) return null;

    final keyBytes = base64Decode(keyBase64);
    return SecretKey(keyBytes);
  }

  /// Encrypt data with AES-256-GCM.
  Future<String?> encrypt(String plaintext) async {
    final secretKey = await _getSecretKey();
    if (secretKey == null) {
      throw StateError(
        'Encryption key not found. Call generateAndStoreKey() first.',
      );
    }

    final plaintextBytes = utf8.encode(plaintext);

    final secretBox = await _algorithm.encrypt(
      plaintextBytes,
      secretKey: secretKey,
    );

    final combined = secretBox.concatenation();
    return base64Encode(combined);
  }

  /// Decrypt data with AES-256-GCM.
  Future<String?> decrypt(String ciphertext) async {
    final secretKey = await _getSecretKey();
    if (secretKey == null) {
      throw StateError('Encryption key not found.');
    }

    try {
      final combined = base64Decode(ciphertext);

      final secretBox = SecretBox.fromConcatenation(
        combined,
        nonceLength: 12,
        macLength: 16,
      );

      final plaintextBytes = await _algorithm.decrypt(
        secretBox,
        secretKey: secretKey,
      );

      return utf8.decode(plaintextBytes);
    } on SecretBoxAuthenticationError {
      throw SecurityException(
        'Data integrity check failed - possible tampering',
      );
    } catch (e) {
      throw SecurityException('Decryption failed: $e');
    }
  }

  /// Securely delete the encryption key.
  Future<void> deleteKey() async {
    await _secureStorage.delete(key: _keyAlias);
  }
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}

/// Pure-Dart demonstration that can run without platform channels.
/// Exercises AES-256-GCM encrypt → decrypt round-trip and tamper detection.
Future<void> demonstrateAesGcm() async {
  final algorithm = AesGcm.with256bits();
  final secretKey = await algorithm.newSecretKey();

  // Encrypt
  final plaintext = 'Hello, Flutter!';
  final box = await algorithm.encrypt(
    utf8.encode(plaintext),
    secretKey: secretKey,
  );

  final combined = box.concatenation();
  final cipherB64 = base64Encode(combined);
  print('Plaintext:  $plaintext');
  print('Encrypted:  ${cipherB64.substring(0, 40)}… (${combined.length} bytes: nonce+cipher+tag)');

  // Decrypt
  final parsed = SecretBox.fromConcatenation(
    base64Decode(cipherB64),
    nonceLength: 12,
    macLength: 16,
  );
  final decrypted = await algorithm.decrypt(parsed, secretKey: secretKey);
  print('Decrypted:  ${utf8.decode(decrypted)}');

  // Tamper detection
  final tampered = List<int>.from(combined);
  tampered[20] ^= 0xFF; // flip a byte
  final tamperedBox = SecretBox.fromConcatenation(
    tampered,
    nonceLength: 12,
    macLength: 16,
  );
  try {
    await algorithm.decrypt(tamperedBox, secretKey: secretKey);
    print('Tampered:   (should not reach here)');
  } on SecretBoxAuthenticationError {
    print('Tampered:   ✅ SecretBoxAuthenticationError — tampering detected');
  }
}
