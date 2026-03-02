/// GOOD EXAMPLE — Three-tier secure storage service.
///
/// Supports three sensitivity levels:
///   • standard  — EncryptedSharedPreferences / Keychain (first_unlock)
///   • biometric — requires biometric auth before read/write
///   • critical  — biometric + device-only + no iCloud sync
///
/// Your UI/repo layers never touch encryption or platform APIs directly.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum StorageSensitivity {
  /// Standard encryption, no biometrics.
  standard,

  /// Requires biometric authentication.
  biometric,

  /// Highest security: biometrics + device-only storage.
  critical,
}

class ComprehensiveStorageService {
  final FlutterSecureStorage _standardStorage;
  final FlutterSecureStorage _biometricStorage;
  final FlutterSecureStorage _criticalStorage;

  ComprehensiveStorageService()
      : _standardStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        ),
        _biometricStorage = FlutterSecureStorage(
          aOptions: AndroidOptions.biometric(
            enforceBiometrics: true,
            biometricPromptTitle: 'Verify your identity',
          ),
          iOptions: const IOSOptions(
            accessibility: KeychainAccessibility.unlocked,
          ),
        ),
        _criticalStorage = FlutterSecureStorage(
          aOptions: AndroidOptions.biometric(
            enforceBiometrics: true,
            biometricPromptTitle: 'High security verification required',
          ),
          iOptions: const IOSOptions(
            accessibility: KeychainAccessibility.passcode,
            synchronizable: false,
          ),
        );

  FlutterSecureStorage _getStorage(StorageSensitivity sensitivity) {
    switch (sensitivity) {
      case StorageSensitivity.standard:
        return _standardStorage;
      case StorageSensitivity.biometric:
        return _biometricStorage;
      case StorageSensitivity.critical:
        return _criticalStorage;
    }
  }

  /// Store a string value securely.
  Future<void> write({
    required String key,
    required String value,
    StorageSensitivity sensitivity = StorageSensitivity.standard,
  }) async {
    final storage = _getStorage(sensitivity);
    await storage.write(key: key, value: value);
    print('[Storage] ✅ "$key" written (${sensitivity.name}).');
  }

  /// Read a string value.
  Future<String?> read({
    required String key,
    StorageSensitivity sensitivity = StorageSensitivity.standard,
  }) async {
    final storage = _getStorage(sensitivity);
    return await storage.read(key: key);
  }

  /// Store a complex object as JSON.
  Future<void> writeObject<T>({
    required String key,
    required T value,
    required Map<String, dynamic> Function(T) toJson,
    StorageSensitivity sensitivity = StorageSensitivity.standard,
  }) async {
    final jsonString = jsonEncode(toJson(value));
    await write(key: key, value: jsonString, sensitivity: sensitivity);
  }

  /// Read a complex object from JSON.
  Future<T?> readObject<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    StorageSensitivity sensitivity = StorageSensitivity.standard,
  }) async {
    final jsonString = await read(key: key, sensitivity: sensitivity);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (e) {
      debugPrint('Failed to parse stored object: $e');
      return null;
    }
  }

  /// Delete a specific key.
  Future<void> delete({
    required String key,
    StorageSensitivity sensitivity = StorageSensitivity.standard,
  }) async {
    final storage = _getStorage(sensitivity);
    await storage.delete(key: key);
  }

  /// Clear all secure storage tiers.
  Future<void> clearAll() async {
    await Future.wait([
      _standardStorage.deleteAll(),
      _biometricStorage.deleteAll(),
      _criticalStorage.deleteAll(),
    ]);
    print('[Storage] ✅ All tiers cleared.');
  }
}
