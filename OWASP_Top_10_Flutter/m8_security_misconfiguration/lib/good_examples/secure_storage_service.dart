/// GOOD EXAMPLE — Secure Keychain / Keystore storage.
///
/// From the article section "Insecure Keychain Configuration".
/// Configures `flutter_secure_storage` with the strongest platform-specific
/// options: `encryptedSharedPreferences` on Android and
/// `first_unlock_this_device` accessibility on iOS.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      // Not synced to iCloud, available after first unlock
    ),
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Saves an auth token securely.
  ///
  /// Output:
  /// ```
  /// [SecureStorage] ✅ Auth token written (encrypted, first_unlock_this_device).
  /// ```
  Future<void> saveAuthToken(String token) async {
    await _storage.write(
      key: 'auth_token',
      value: token,
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
    print(
      '[SecureStorage] ✅ Auth token written '
      '(encrypted, first_unlock_this_device).',
    );
  }

  /// Reads the auth token back from secure storage.
  ///
  /// Output:
  /// ```
  /// [SecureStorage] ✅ Auth token read (length: 36).
  /// ```
  Future<String?> getAuthToken() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      print('[SecureStorage] ✅ Auth token read (length: ${token.length}).');
    } else {
      print('[SecureStorage] ⚠️  No auth token found.');
    }
    return token;
  }

  /// Deletes the auth token from secure storage.
  ///
  /// Output:
  /// ```
  /// [SecureStorage] ✅ Auth token deleted.
  /// ```
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: 'auth_token');
    print('[SecureStorage] ✅ Auth token deleted.');
  }
}
