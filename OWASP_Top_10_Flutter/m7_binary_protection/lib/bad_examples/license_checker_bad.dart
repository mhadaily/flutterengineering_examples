// ⚠️ BAD EXAMPLE — DO NOT USE IN PRODUCTION
//
// This is the canonical example from the OWASP M7 article.
// The class name "LicenseChecker" and method name "verifyPremium" are embedded
// verbatim in libapp.so when built WITHOUT --obfuscate.
//
// Try it yourself after a release build:
//   strings libapp.so | grep -i "LicenseChecker\|verifyPremium"
//
// In Ghidra: Window → Defined Strings → filter "LicenseChecker"
// The attacker now knows exactly which function to Frida-hook or binary-patch.
//
// See: good_examples/license_service.dart for the correct approach
//      (server-side verification + code obfuscation)

/// ❌ BAD: Pure client-side premium gate.
///
/// Problems:
///   1. The class name and method name are visible in the compiled binary.
///   2. The entire check runs in the client's address space — it can be hooked.
///   3. A one-byte branch patch makes [verifyPremium] always return true.
class LicenseChecker {
  // ❌ Hard-coded "grace period" means the app works offline without ever
  //    validating against a real server — an attacker only has to block
  //    the network call once to get permanent access.
  static const _gracePeriodDays = 7;

  bool _isPremium = false;
  DateTime? _lastVerified;

  /// ❌ Returns whether the user has premium access.
  ///
  /// The method name "verifyPremium" is embedded as a string in libapp.so.
  /// In Ghidra's Symbol Tree you will see it under the Dart snapshot strings.
  /// A Frida hook is trivial:
  ///
  /// ```js
  /// // frida -U -n com.example.app -e "..."
  /// Interceptor.attach(ptr('0x<offset>'), {
  ///   onLeave: retval => retval.replace(1)   // always premium
  /// });
  /// ```
  Future<bool> verifyPremium(String userId) async {
    // Simulate a server round-trip (in reality this should be server-side)
    await Future.delayed(const Duration(milliseconds: 150));

    // ❌ The "server" result is trusted unconditionally on the client
    _isPremium = await _fetchLicenseFromServer(userId);
    _lastVerified = DateTime.now();
    return _isPremium;
  }

  /// ❌ Returns cached value — no expiry, no signature, fully patchable.
  bool get isPremium => _isPremium;

  /// ❌ Grace period logic is entirely client-side.
  bool isWithinGracePeriod() {
    if (_lastVerified == null) return true; // ❌ defaults to "allowed"
    final elapsed = DateTime.now().difference(_lastVerified!);
    return elapsed.inDays < _gracePeriodDays;
  }

  // Simulated network call — replace with a real HTTP call in a bad real app
  Future<bool> _fetchLicenseFromServer(String userId) async {
    // In a real bad example this would be an unauthenticated GET that the
    // attacker can simply intercept and replay with a 200 OK {"valid":true}.
    return true;
  }
}

/// ❌ BAD: Premium feature gate that trusts [LicenseChecker] client-side.
class PremiumFeatureGate {
  final LicenseChecker _checker;

  PremiumFeatureGate(this._checker);

  /// ❌ The entire gate is bypassed by patching [LicenseChecker.verifyPremium].
  Future<bool> canAccessAdvancedAlgorithms(String userId) async {
    final ok = await _checker.verifyPremium(userId);
    return ok || _checker.isWithinGracePeriod();
  }
}
