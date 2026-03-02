/// ❌ INSECURE: Common cryptographic mistakes — DO NOT use in production.
///
/// Each method shows a single, specific anti-pattern so the output-capture
/// test can exercise and display them individually.
library;

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class InsecureCrypto {
  // ❌ MISTAKE 1: Hardcoded encryption key
  static const _hardcodedKey = 'MySecretKey12345MySecretKey12345';

  // ❌ MISTAKE 2: Using non-secure random
  static String generateWeakKey() {
    final random = Random(); // NOT cryptographically secure!
    return List.generate(32, (_) => random.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  // ❌ MISTAKE 3: ECB mode — reveals patterns in data
  static String encryptECB(String plaintext) {
    final key = encrypt.Key.fromUtf8(_hardcodedKey);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.ecb),
    );
    return encrypter.encrypt(plaintext).base64;
  }

  // ❌ MISTAKE 4: Reusing IV/nonce
  static final _staticIV = encrypt.IV.fromUtf8('1234567890123456');

  static String encryptWithStaticIV(String plaintext) {
    final key = encrypt.Key.fromUtf8(_hardcodedKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.encrypt(plaintext, iv: _staticIV).base64;
  }

  // ❌ MISTAKE 5: CBC without authentication (MAC)
  static String encryptCBCNoAuth(String plaintext) {
    final key = encrypt.Key.fromUtf8(_hardcodedKey);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );
    return encrypter.encrypt(plaintext, iv: iv).base64;
  }

  // ❌ MISTAKE 6: Weak password hashing
  static String hashPasswordWeak(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}

/// Run all insecure demos and print output.
void demonstrateInsecureCrypto() {
  print('--- Mistake 1: Hardcoded key ---');
  print('Key used: "${InsecureCrypto._hardcodedKey}" (visible in source!)');
  print('');

  print('--- Mistake 2: Non-secure Random ---');
  final weakKey1 = InsecureCrypto.generateWeakKey();
  final weakKey2 = InsecureCrypto.generateWeakKey();
  print('Weak key 1: $weakKey1');
  print('Weak key 2: $weakKey2');
  print('Both from Random() — seed-predictable');
  print('');

  print('--- Mistake 3: ECB mode (reveals patterns) ---');
  final ecb1 = InsecureCrypto.encryptECB('AAAAAAAAAAAAAAAA');
  final ecb2 = InsecureCrypto.encryptECB('AAAAAAAAAAAAAAAA');
  print('Block 1: $ecb1');
  print('Block 2: $ecb2');
  print('Identical? ${ecb1 == ecb2}');
  print('');

  print('--- Mistake 4: Static IV ---');
  final iv1 = InsecureCrypto.encryptWithStaticIV('Hello');
  final iv2 = InsecureCrypto.encryptWithStaticIV('Hello');
  print('Cipher 1: $iv1');
  print('Cipher 2: $iv2');
  print('Identical? ${iv1 == iv2}');
  print('');

  print('--- Mistake 5: CBC without HMAC ---');
  final cbc = InsecureCrypto.encryptCBCNoAuth('Sensitive data');
  print('CBC ciphertext: $cbc');
  print('No integrity check — vulnerable to padding oracle');
  print('');

  print('--- Mistake 6: SHA-256 for password hashing ---');
  final hash = InsecureCrypto.hashPasswordWeak('myP@ssword!');
  print('SHA-256 hash: $hash');
  print('Too fast — GPUs can try billions per second');
}
