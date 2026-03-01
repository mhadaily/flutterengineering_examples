/// BAD EXAMPLE — Storing sensitive data in SharedPreferences.
///
/// From the article section "Insecure SharedPreferences Usage".
/// SharedPreferences is NOT encrypted — on a rooted / jailbroken device
/// any app (or a human with ADB) can read its XML files directly.
library;

import 'package:shared_preferences/shared_preferences.dart';

class InsecureStorage {
  final SharedPreferences _prefs;

  InsecureStorage(this._prefs);

  /// Saves an auth token in plain text — anyone with device access can read it.
  ///
  /// Output:
  /// ```
  /// [BAD] Auth token saved to SharedPreferences (NOT encrypted!).
  /// [BAD] Token visible at: /data/data/<pkg>/shared_prefs/FlutterSharedPreferences.xml
  /// ```
  Future<void> saveTokenInsecure(String token) async {
    await _prefs.setString('auth_token', token);
    print('[BAD] Auth token saved to SharedPreferences (NOT encrypted!).');
    print(
      '[BAD] Token visible at: '
      '/data/data/<pkg>/shared_prefs/FlutterSharedPreferences.xml',
    );
  }

  /// Reads the (unprotected) token back.
  Future<String?> readTokenInsecure() async {
    return _prefs.getString('auth_token');
  }
}
