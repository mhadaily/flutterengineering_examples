/// GOOD EXAMPLE — Choosing the right storage for each data type.
///
/// From the article section "Insecure SharedPreferences Usage".
/// Sensitive data → `flutter_secure_storage`; non-sensitive preferences →
/// `shared_preferences`. Simple rule.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  StorageService(this._prefs, this._secureStorage);

  // ---------------------------------------------------------------------------
  // SENSITIVE data → secure storage
  // ---------------------------------------------------------------------------

  /// Saves an auth token securely.
  ///
  /// Output:
  /// ```
  /// [Storage] ✅ Token saved to FlutterSecureStorage (encrypted).
  /// ```
  Future<void> saveTokenSecure(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
    print('[Storage] ✅ Token saved to FlutterSecureStorage (encrypted).');
  }

  // ---------------------------------------------------------------------------
  // NON-SENSITIVE preferences → SharedPreferences (OK — not secret)
  // ---------------------------------------------------------------------------

  /// Saves the theme preference.
  ///
  /// Output:
  /// ```
  /// [Storage] Theme preference saved: dark=true
  /// ```
  Future<void> saveThemePreference(bool isDark) async {
    await _prefs.setBool('dark_theme', isDark);
    print('[Storage] Theme preference saved: dark=$isDark');
  }

  /// Saves the locale preference.
  ///
  /// Output:
  /// ```
  /// [Storage] Locale preference saved: en_US
  /// ```
  Future<void> saveLanguagePreference(String locale) async {
    await _prefs.setString('locale', locale);
    print('[Storage] Locale preference saved: $locale');
  }
}
