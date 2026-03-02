/// ✅ SECURE: Key generation using cryptographically secure RNG and vetted libs.
library;

import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';

class SecureKeyGenerator {
  /// Generate an AES-256 secret key via the `cryptography` package.
  Future<SecretKey> generateAesKey() async {
    final algorithm = AesGcm.with256bits();
    return await algorithm.newSecretKey();
  }

  /// Generate secure random bytes for salts, IVs, etc.
  List<int> generateSecureRandomBytes(int length) {
    final random = Random.secure();
    return List.generate(length, (_) => random.nextInt(256));
  }

  /// Generate a key pair for key exchange (X25519).
  Future<SimpleKeyPair> generateKeyPair() async {
    return await X25519().newKeyPair();
  }

  /// Generate a signing key pair (Ed25519).
  Future<SimpleKeyPair> generateSigningKeyPair() async {
    return await Ed25519().newKeyPair();
  }

  /// Derive an encryption key from a user password using Argon2id.
  Future<SecretKey> deriveKeyFromPassword(
    String password,
    List<int> salt,
  ) async {
    final argon2id = Argon2id(
      parallelism: 4,
      memory: 65536,
      iterations: 3,
      hashLength: 32,
    );
    return await argon2id.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
  }

  /// Derive multiple subkeys from a master key using HKDF-SHA256.
  Future<List<SecretKey>> deriveSubKeys(
    SecretKey masterKey,
    int numberOfKeys,
  ) async {
    final hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

    final keys = <SecretKey>[];
    for (var i = 0; i < numberOfKeys; i++) {
      final derivedKey = await hkdf.deriveKey(
        secretKey: masterKey,
        info: utf8.encode('subkey-$i'),
        nonce: [],
      );
      keys.add(derivedKey);
    }
    return keys;
  }
}

/// Pure-Dart demo: generate keys and derive sub-keys.
Future<void> demonstrateKeyGeneration() async {
  final gen = SecureKeyGenerator();

  // AES key
  final aesKey = await gen.generateAesKey();
  final aesBytes = await aesKey.extractBytes();
  print('AES-256 key:       ${base64Encode(aesBytes)} (${aesBytes.length} bytes)');

  // Secure random salt
  final salt = gen.generateSecureRandomBytes(16);
  print('Secure salt (16B): ${base64Encode(salt)}');

  // Ed25519 signing key pair
  final signingPair = await gen.generateSigningKeyPair();
  final pubKey = await signingPair.extractPublicKey();
  print('Ed25519 public:    ${base64Encode(pubKey.bytes)} (${pubKey.bytes.length} bytes)');

  // HKDF sub-key derivation
  final subKeys = await gen.deriveSubKeys(aesKey, 3);
  for (var i = 0; i < subKeys.length; i++) {
    final bytes = await subKeys[i].extractBytes();
    print('Sub-key $i:         ${base64Encode(bytes)}');
  }
}
