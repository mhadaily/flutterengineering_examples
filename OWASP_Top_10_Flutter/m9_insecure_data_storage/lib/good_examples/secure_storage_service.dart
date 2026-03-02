/// GOOD EXAMPLE — Secure storage using flutter_secure_storage.
///
/// Uses Android Keystore / iOS Keychain for hardware-backed encryption.
/// Data is encrypted at rest and protected by the platform's secure storage.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  late final FlutterSecureStorage _storage;

  SecureStorageService() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.passcode,
        synchronizable: false,
      ),
    );
  }

  /// Store authentication token.
  Future<void> storeAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    print('[SecureStorage] ✅ Auth token stored (encrypted, hardware-backed).');
  }

  /// Retrieve authentication token.
  Future<String?> getAuthToken() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      print('[SecureStorage] ✅ Auth token retrieved (length: ${token.length}).');
    } else {
      print('[SecureStorage] ⚠️  No auth token found.');
    }
    return token;
  }

  /// Store refresh token with biometric protection.
  Future<void> storeRefreshToken(String token) async {
    final biometricStorage = FlutterSecureStorage(
      aOptions: AndroidOptions.biometric(
        enforceBiometrics: true,
        biometricPromptTitle: 'Authenticate to access credentials',
        biometricPromptSubtitle: 'Use your fingerprint or face',
      ),
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.passcode,
      ),
    );

    await biometricStorage.write(key: 'refresh_token', value: token);
    print('[SecureStorage] ✅ Refresh token stored (biometric-protected).');
  }

  /// Delete all stored data (for logout).
  Future<void> clearAll() async {
    await _storage.deleteAll();
    print('[SecureStorage] ✅ All secure storage cleared.');
  }

  /// Check if key exists.
  Future<bool> hasKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
