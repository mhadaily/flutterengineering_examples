/// ✅ SECURE: Argon2id password hashing.
///
/// Argon2id is the winner of the Password Hashing Competition (PHC) and
/// provides memory-hard, time-hard resistance to brute-force attacks.
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class SecurePasswordHasher {
  final _argon2id = Argon2id(
    parallelism: 4,
    memory: 65536, // 64 MB
    iterations: 3,
    hashLength: 32,
  );

  /// Hash a password with Argon2id.
  Future<String> hashPassword(String password) async {
    final salt = SecretKeyData.random(length: 16);
    final saltBytes = await salt.extractBytes();

    final secretKey = await _argon2id.deriveKeyFromPassword(
      password: password,
      nonce: saltBytes,
    );
    final hashBytes = await secretKey.extractBytes();

    final result = {
      'algorithm': 'argon2id',
      'salt': base64Encode(saltBytes),
      'hash': base64Encode(hashBytes),
      'params': {
        'parallelism': _argon2id.parallelism,
        'memory': _argon2id.memory,
        'iterations': _argon2id.iterations,
      },
    };

    return jsonEncode(result);
  }

  /// Verify a password against a stored hash.
  Future<bool> verifyPassword(String password, String storedHash) async {
    try {
      final data = jsonDecode(storedHash) as Map<String, dynamic>;
      if (data['algorithm'] != 'argon2id') return false;

      final salt = base64Decode(data['salt'] as String);
      final expectedHash = base64Decode(data['hash'] as String);
      final params = data['params'] as Map<String, dynamic>;

      final argon2id = Argon2id(
        parallelism: params['parallelism'] as int,
        memory: params['memory'] as int,
        iterations: params['iterations'] as int,
        hashLength: expectedHash.length,
      );

      final secretKey = await argon2id.deriveKeyFromPassword(
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

  /// Check if stored hash params are weaker than current settings.
  bool needsRehash(String storedHash) {
    try {
      final data = jsonDecode(storedHash) as Map<String, dynamic>;
      final params = data['params'] as Map<String, dynamic>;

      return (params['memory'] as int) < _argon2id.memory ||
          (params['iterations'] as int) < _argon2id.iterations ||
          (params['parallelism'] as int) < _argon2id.parallelism;
    } catch (e) {
      return true;
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

/// Pure-Dart demo: hash, verify, and needsRehash.
Future<void> demonstrateArgon2id() async {
  final hasher = SecurePasswordHasher();

  print('Hashing password with Argon2id…');
  final stored = await hasher.hashPassword('myS3cureP@ss!');
  final parsed = jsonDecode(stored) as Map<String, dynamic>;
  print('Algorithm:  ${parsed['algorithm']}');
  print('Salt:       ${parsed['salt']}');
  print('Hash:       ${parsed['hash']}');
  print('Params:     ${jsonEncode(parsed['params'])}');
  print('');

  final correctMatch = await hasher.verifyPassword('myS3cureP@ss!', stored);
  final wrongMatch = await hasher.verifyPassword('wrongPassword', stored);
  print('Verify correct password: $correctMatch');
  print('Verify wrong password:   $wrongMatch');
  print('Needs rehash:            ${hasher.needsRehash(stored)}');
}
