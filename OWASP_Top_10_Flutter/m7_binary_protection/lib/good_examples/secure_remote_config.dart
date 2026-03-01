// ✅ GOOD EXAMPLE — Fetch secrets at runtime from a secure remote source
//
// Best practice: never ship secrets with the app at all.
// Firebase Remote Config delivers config values server-side.
// flutter_secure_storage caches them encrypted on-device so the
// app still works offline after the first successful fetch.
//
// Requires:
//   firebase_remote_config: ^5.0.0
//   flutter_secure_storage: ^9.0.0
//   firebase_core: ^3.0.0
//   (add to pubspec.yaml and configure google-services.json/GoogleService-Info.plist)

import 'package:flutter/foundation.dart';

// ---------------------------------------------------------------------------
// Mock interfaces so this file compiles without the real Firebase packages.
// Replace with the actual imports in your real project:
//   import 'package:firebase_remote_config/firebase_remote_config.dart';
//   import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ---------------------------------------------------------------------------

abstract class RemoteConfigAdapter {
  Future<void> setConfigSettings(ConfigSettings settings);
  Future<bool> fetchAndActivate();
  String getString(String key);
}

class ConfigSettings {
  final Duration fetchTimeout;
  final Duration minimumFetchInterval;
  ConfigSettings({
    required this.fetchTimeout,
    required this.minimumFetchInterval,
  });
}

abstract class SecureStorageAdapter {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
}

// ---------------------------------------------------------------------------
// Production implementation
// ---------------------------------------------------------------------------

class SecureConfigService {
  // In a real project these would come from firebase_remote_config and
  // flutter_secure_storage. The adapter types above make the demo compile.
  final RemoteConfigAdapter _remoteConfig;
  final SecureStorageAdapter _secureStorage;

  SecureConfigService({
    required RemoteConfigAdapter remoteConfig,
    required SecureStorageAdapter secureStorage,
  }) : _remoteConfig = remoteConfig,
       _secureStorage = secureStorage;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      ConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  /// Returns the API key.
  /// 1. Checks on-device encrypted cache first.
  /// 2. Falls back to Remote Config fetch.
  /// 3. Caches the fetched value securely.
  Future<String> getApiKey() async {
    // 1. Try secure cache
    final cached = await _secureStorage.read(key: 'api_key');
    if (cached != null && cached.isNotEmpty) {
      debugPrint('SecureConfigService: Using cached API key');
      return cached;
    }

    // 2. Fetch from Remote Config
    final key = _remoteConfig.getString('api_key');
    if (key.isEmpty) {
      throw StateError('api_key is not configured in Firebase Remote Config.');
    }

    // 3. Cache it securely for offline use
    await _secureStorage.write(key: 'api_key', value: key);
    debugPrint('SecureConfigService: API key fetched and cached');

    return key;
  }
}
