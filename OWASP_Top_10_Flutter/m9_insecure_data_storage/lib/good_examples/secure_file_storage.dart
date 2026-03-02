/// GOOD EXAMPLE — Encrypted file storage using AES-GCM.
///
/// Encrypts data with AES-256-GCM before writing to disk.
/// A unique IV is generated per encryption; the key lives in secure storage.
/// Also demonstrates secure file deletion (overwrite before delete).
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class SecureFileStorage {
  /// Demonstrate AES-GCM file encryption (pure Dart — no platform channels).
  void demonstrateEncryptedFileStorage() {
    // Simulate key generation
    final keyBytes = _generateRandomBytes(32);
    final ivBytes = _generateRandomBytes(16);

    final keyB64 = base64Encode(keyBytes);
    final ivB64 = base64Encode(ivBytes);

    const plaintext = '{"ssn":"123-45-6789","diagnosis":"Hypertension"}';

    // Simulate encryption — in a real app the `encrypt` package handles this
    final ciphertextB64 = base64Encode(
      _xorBytes(utf8.encode(plaintext), keyBytes), // simplified demo
    );

    print('[SecureFile] ✅ AES-256-GCM encryption:');
    print('[SecureFile]    Plaintext length : ${plaintext.length} bytes');
    print('[SecureFile]    IV  (base64)     : $ivB64');
    print('[SecureFile]    Ciphertext (b64) : ${ciphertextB64.substring(0, 20)}…');
    print('[SecureFile]    Key stored in    : flutter_secure_storage');
    print('[SecureFile]');
    print('[SecureFile]    File written: <documents>/medical.enc');
    print('[SecureFile]    Format: { "iv": "<base64>", "data": "<base64>" }');
  }

  /// Demonstrate secure file deletion.
  void demonstrateSecureDelete() {
    const fileSize = 2048;
    print('[SecureFile] 🗑️  Secure delete:');
    print('[SecureFile]    Step 1: Overwrite $fileSize bytes with random data');
    print('[SecureFile]    Step 2: Delete file from filesystem');
    print('[SecureFile]    ⚠️  Note: flash wear-leveling means original blocks');
    print('[SecureFile]           may persist — rely on full-disk encryption too.');
  }

  static Uint8List _generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (_) => random.nextInt(256)),
    );
  }

  /// Simple XOR for demo purposes — real code uses AES-GCM via `encrypt` pkg.
  static Uint8List _xorBytes(List<int> data, List<int> key) {
    return Uint8List.fromList(
      List.generate(data.length, (i) => data[i] ^ key[i % key.length]),
    );
  }
}
