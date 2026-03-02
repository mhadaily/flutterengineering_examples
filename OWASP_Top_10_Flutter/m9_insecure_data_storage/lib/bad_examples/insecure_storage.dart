/// BAD EXAMPLE — Storing sensitive data in SharedPreferences.
///
/// SharedPreferences stores data in plain XML (Android) or plist (iOS).
/// On a rooted/jailbroken device, or via backup extraction, all data is
/// readable in clear text.
library;

import 'package:shared_preferences/shared_preferences.dart';

class InsecureStorage {
  /// Demonstrates the vulnerability: credentials stored unencrypted.
  Future<void> storeCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // DANGER: Plain text storage!
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setString('auth_token', 'eyJhbGciOiJIUzI1...');
    await prefs.setString('credit_card', '4111-1111-1111-1111');

    print('[BAD] Stored credentials in SharedPreferences (NOT encrypted!):');
    print('[BAD]   username  : $username');
    print('[BAD]   password  : $password');
    print('[BAD]   auth_token: eyJhbGciOiJIUzI1...');
    print('[BAD]   credit_card: 4111-1111-1111-1111');
  }
}

/// Standalone demo that doesn't require platform channels.
void demonstrateInsecureStorage() {
  print('[BAD] SharedPreferences stores data in PLAIN TEXT:');
  print('[BAD]   Android → /data/data/<pkg>/shared_prefs/FlutterSharedPreferences.xml');
  print('[BAD]   iOS    → /var/mobile/Containers/Data/Application/<UUID>/Library/Preferences/<pkg>.plist');
  print('[BAD]');
  print('[BAD] Example XML content an attacker would see:');
  print('[BAD]   <string name="flutter.username">john_doe</string>');
  print('[BAD]   <string name="flutter.password">MySecretPassword123!</string>');
  print('[BAD]   <string name="flutter.auth_token">eyJhbGciOiJIUzI1...</string>');
  print('[BAD]   <string name="flutter.credit_card">4111-1111-1111-1111</string>');
}
