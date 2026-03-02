/// ✅ SECURE: PBKDF2-SHA256 password hashing (when Argon2id is not available).
///
/// OWASP 2023 recommends ≥310 000 iterations for PBKDF2-SHA256.
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class Pbkdf2PasswordHasher {
  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 310000,
    bits: 256,
  );

  /// Hash a password with PBKDF2-SHA256.
  Future<String> hashPassword(String password) async {
    final salt = SecretKeyData.random(length: 16);
    final saltBytes = await salt.extractBytes();

    final secretKey = await _pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: saltBytes,
    );
    final hashBytes = await secretKey.extractBytes();

    final result = {
      'algorithm': 'pbkdf2-sha256',
      'iterations': _pbkdf2.iterations,
      'salt': base64Encode(saltBytes),
      'hash': base64Encode(hashBytes),
    };

    return jsonEncode(result);
  }

  /// Verify a password against a stored hash.
  Future<bool> verifyPassword(String password, String storedHash) async {
    try {
      final data = jsonDecode(storedHash) as Map<String, dynamic>;
      final salt = base64Decode(data['salt'] as String);
      final expectedHash = base64Decode(data['hash'] as String);
      final iterations = data['iterations'] as int;

      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: iterations,
        bits: expectedHash.length * 8,
      );

      final secretKey = await pbkdf2.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );
      final computedHash = await secretKey.extractBytes();

      return _constantTimeEquals(
        Uint8List.fromList(computedHash),
        Uint8List.fromList(expectedHash),
      );
    } catch (e) {
      return false;
    }
  }

  bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}

/// Pure-Dart demo: hash and verify with PBKDF2.
Future<void> demonstratePbkdf2() async {
  final hasher = Pbkdf2PasswordHasher();

  print('Hashing password with PBKDF2-SHA256 (310 000 iterations)…');
  final stored = await hasher.hashPassword('myS3cureP@ss!');
  final parsed = jsonDecode(stored) as Map<String, dynamic>;
  print('Algorithm:  ${parsed['algorithm']}');
  print('Iterations: ${parsed['iterations']}');
  print('Salt:       ${parsed['salt']}');
  print('Hash:       ${parsed['hash']}');
  print('');

  final correctMatch = await hasher.verifyPassword('myS3cureP@ss!', stored);
  final wrongMatch = await hasher.verifyPassword('wrongPassword', stored);
  print('Verify correct password: $correctMatch');
  print('Verify wrong password:   $wrongMatch');
}
