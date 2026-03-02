/// GOOD EXAMPLE — Root/jailbreak detection and response.
///
/// Uses freeRASP to detect compromised devices and automatically
/// clears sensitive data when a threat is detected.
///
/// This file shows the pattern; freeRASP is not a dependency of this
/// demo project because it requires native build configuration.
/// See https://pub.dev/packages/freerasp for setup.
library;

class SecurityService {
  bool _isDeviceSecure = true;

  /// Whether the device has passed all security checks.
  bool get isDeviceSecure => _isDeviceSecure;

  /// Whether sensitive features should be accessible.
  bool get canAccessSensitiveData => _isDeviceSecure;

  /// Simulate root/jailbreak detection (pure Dart demo).
  void demonstrateSecurityChecks() {
    print('[Security] Running device security checks…');
    print('[Security]   ✅ Root/jailbreak: not detected');
    print('[Security]   ✅ App integrity: valid');
    print('[Security]   ✅ Debug mode: not attached');
    print('[Security]   ✅ Emulator: not detected');
    print('[Security]   Device is secure — sensitive features enabled.');
    print('');

    // Simulate what happens when a threat IS detected
    print('[Security] Simulating root/jailbreak detection…');
    _onRootOrJailbreakDetected();
    print('[Security]   🚨 Root/jailbreak DETECTED!');
    print('[Security]   🗑️  Sensitive data cleared from secure storage.');
    print('[Security]   🔒 Sensitive features BLOCKED.');
    print('[Security]   canAccessSensitiveData = $canAccessSensitiveData');

    // Reset for the demo
    _isDeviceSecure = true;
  }

  void _onRootOrJailbreakDetected() {
    _isDeviceSecure = false;
    _clearSensitiveData();
  }

  void _clearSensitiveData() {
    // In a real app: await FlutterSecureStorage().deleteAll();
  }
}
