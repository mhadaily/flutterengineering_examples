// ✅ GOOD EXAMPLE — Encrypted AI/ML model loading
//
// If your app bundles an AI or ML model, that model is intellectual property.
// An attacker who unpacks your APK can steal it.
//
// This service loads the model encrypted from assets, fetches the decryption
// key from native code (see native_secrets.dart), and decrypts it in memory.
//
// The model is never written to disk in plaintext.
//
// Encryption format:
//   [12 bytes IV] + [AES-256-GCM ciphertext + 16-byte auth tag]
//
// To encrypt your model at build time (Python example):
//   from cryptography.hazmat.primitives.ciphers.aead import AESGCM
//   import os, base64
//   key = os.urandom(32)          # 256-bit key — store in native code / key vault
//   nonce = os.urandom(12)        # 96-bit IV
//   ct = AESGCM(key).encrypt(nonce, model_bytes, None)
//   open('model.tflite.enc', 'wb').write(nonce + ct)
//
// Requires pointycastle in pubspec.yaml:
//   pointycastle: ^3.7.4

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'native_secrets.dart';

class ModelProtectionService {
  /// Loads and decrypts an encrypted model from Flutter assets.
  ///
  /// [assetPath] — path as listed in pubspec.yaml, e.g. 'assets/models/scoring.tflite.enc'
  ///
  /// Returns the raw decrypted bytes ready to pass to TensorFlow Lite or ONNX.
  Future<Uint8List> loadProtectedModel(String assetPath) async {
    // 1. Load the encrypted blob from assets
    final data = await rootBundle.load(assetPath);
    final encryptedBytes = data.buffer.asUint8List();

    // 2. Fetch the decryption key from native code (never hardcoded in Dart)
    final keyBase64 = await NativeSecrets.getModelDecryptionKey();
    if (keyBase64.isEmpty) {
      throw StateError('ModelProtectionService: decryption key unavailable');
    }

    // 3. Decrypt in memory
    final decrypted = _decryptAesGcm(encryptedBytes, keyBase64);

    debugPrint(
      'ModelProtectionService: loaded ${decrypted.lengthInBytes} bytes '
      'from $assetPath',
    );
    return decrypted;
  }

  /// AES-256-GCM decryption.
  ///
  /// The first 12 bytes of [encrypted] are the IV; the remainder is ciphertext
  /// + 16-byte authentication tag.
  ///
  /// In a real project, replace this stub with the pointycastle implementation:
  ///   final cipher = GCMBlockCipher(AESEngine())
  ///     ..init(false, AEADParameters(KeyParameter(keyBytes), 128, iv, Uint8List(0)));
  ///   return cipher.process(ciphertext);
  Uint8List _decryptAesGcm(Uint8List encrypted, String keyBase64) {
    if (encrypted.length <= 12) {
      throw ArgumentError(
        'Encrypted data too short — expected IV + ciphertext',
      );
    }

    final keyBytes = base64Decode(keyBase64);

    // Split IV and ciphertext
    // ignore: unused_local_variable
    final iv = encrypted.sublist(0, 12);
    // ignore: unused_local_variable
    final ciphertext = encrypted.sublist(12);

    // ⚠️  STUB: plug in the pointycastle GCM cipher here.
    // The lines below are placeholders so the project compiles.
    // Do NOT use XOR or any home-rolled crypto in production.
    final decrypted = Uint8List(ciphertext.length);
    for (int i = 0; i < ciphertext.length; i++) {
      decrypted[i] = ciphertext[i] ^ keyBytes[i % keyBytes.length];
    }
    return decrypted;
  }
}
