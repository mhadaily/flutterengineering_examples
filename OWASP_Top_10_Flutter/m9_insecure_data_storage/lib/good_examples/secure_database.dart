/// GOOD EXAMPLE — Encrypted SQLite database with SQLCipher.
///
/// The encryption key is stored in flutter_secure_storage (hardware-backed).
/// Even if the .db file is extracted, it's unreadable without the key.
library;

import 'dart:math';

class SecureDatabase {
  static const _dbKeyStorageKey = 'database_encryption_key';

  /// Generate a strong random key (pure Dart — no platform channels).
  static String generateSecureKey(int length) {
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Demonstrate what a secure database setup looks like.
  void demonstrateSecureDatabase() {
    final key = generateSecureKey(32);

    print('[SecureDB] ✅ Generated encryption key (length: ${key.length}).');
    print('[SecureDB] ✅ Key stored in flutter_secure_storage (hardware-backed).');
    print('[SecureDB] ✅ Database opened with SQLCipher encryption.');
    print('[SecureDB]    Path: <databases>/secure_user_data.db');
    print('[SecureDB]    Cipher: AES-256 (via SQLCipher)');
    print('[SecureDB]    Key storage: $_dbKeyStorageKey → Keystore/Keychain');
    print('[SecureDB]');
    print('[SecureDB]    Even if extracted, the .db file is unreadable without');
    print('[SecureDB]    the device-specific hardware-backed key.');
  }
}
