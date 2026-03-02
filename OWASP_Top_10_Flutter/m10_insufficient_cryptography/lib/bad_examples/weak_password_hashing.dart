/// ❌ INSECURE: Using SHA-256 for password hashing.
///
/// SHA-256 is a fast digest — modern GPUs compute billions of hashes per second,
/// making brute-force attacks trivial. Use Argon2id, bcrypt, or scrypt instead.
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Hash a password with plain SHA-256 (INSECURE).
String hashPasswordWeak(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

/// Hash with salt but still SHA-256 (INSECURE — still too fast).
String hashPasswordWeakWithSalt(String password, String salt) {
  return sha256.convert(utf8.encode(salt + password)).toString();
}

/// Run the weak-hashing demo and print output.
void demonstrateWeakPasswordHashing() {
  print('--- SHA-256 (no salt) ---');
  final h1 = hashPasswordWeak('myP@ssword!');
  final h2 = hashPasswordWeak('myP@ssword!');
  print('Hash 1: $h1');
  print('Hash 2: $h2');
  print('Same input → same hash (no salt)');
  print('');

  print('--- SHA-256 (with salt) ---');
  final salted1 = hashPasswordWeakWithSalt('myP@ssword!', 'randomsalt');
  final salted2 = hashPasswordWeakWithSalt('myP@ssword!', 'differentsalt');
  print('Salt "randomsalt":    $salted1');
  print('Salt "differentsalt": $salted2');
  print('Different salts → different hashes, but still too fast to be secure');
}
