// ✅ GOOD EXAMPLE — freeRASP integration for comprehensive RASP protection
//
// Writing all native security checks by hand for both Android and iOS is
// time-consuming and easy to get wrong. freeRASP by Talsec packages them
// together and keeps them up to date.
//
// Package: https://pub.dev/packages/freerasp
// Add to pubspec.yaml:
//   freerasp: ^6.0.0
//
// This file uses a minimal mock of the freerasp API so the project compiles
// without the package installed. Replace the mock imports with the real ones
// once you add the dependency.

import 'package:flutter/foundation.dart';

// ---------------------------------------------------------------------------
// Mock types — replace with:
//   import 'package:freerasp/freerasp.dart';
// ---------------------------------------------------------------------------
class TalsecConfig {
  final AndroidConfig? androidConfig;
  final IOSConfig? iosConfig;
  final String watcherMail;
  final bool isProd;
  TalsecConfig({
    this.androidConfig,
    this.iosConfig,
    required this.watcherMail,
    required this.isProd,
  });
}

class AndroidConfig {
  final String packageName;
  final List<String> signingCertHashes;
  final List<String> supportedStores;
  AndroidConfig({
    required this.packageName,
    required this.signingCertHashes,
    required this.supportedStores,
  });
}

class IOSConfig {
  final List<String> bundleIds;
  final String teamId;
  IOSConfig({required this.bundleIds, required this.teamId});
}

class ThreatCallback {
  final void Function()? onAppIntegrity;
  final void Function()? onDebug;
  final void Function()? onHooks;
  final void Function()? onPasscode;
  final void Function()? onPrivilegedAccess;
  final void Function()? onSimulator;
  final void Function()? onUnofficialStore;
  final void Function()? onDeviceBinding;
  final void Function()? onDeviceID;
  final void Function()? onSecureHardwareNotAvailable;
  ThreatCallback({
    this.onAppIntegrity,
    this.onDebug,
    this.onHooks,
    this.onPasscode,
    this.onPrivilegedAccess,
    this.onSimulator,
    this.onUnofficialStore,
    this.onDeviceBinding,
    this.onDeviceID,
    this.onSecureHardwareNotAvailable,
  });
}

class _MockTalsec {
  static final _MockTalsec instance = _MockTalsec._();
  _MockTalsec._();
  Future<void> start(
    TalsecConfig config, {
    required ThreatCallback callback,
  }) async {
    debugPrint('freeRASP: protection started (mock)');
  }
}
// ---------------------------------------------------------------------------

/// Wraps freeRASP initialisation and maps every threat callback to a
/// unified handler that you can extend with logging, disabling features,
/// or forcing logout.
class SecurityService {
  final _talsec = _MockTalsec.instance; // swap for Talsec.instance

  Future<void> initialize() async {
    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: 'com.example.m7_binary_protection',
        signingCertHashes: [
          // Replace with your actual SHA-256 certificate hash:
          //   keytool -printcert -jarfile your-release.apk | grep SHA256
          'REPLACE_WITH_YOUR_RELEASE_CERT_SHA256_HASH',
        ],
        supportedStores: ['com.android.vending'], // Google Play only
      ),
      iosConfig: IOSConfig(
        bundleIds: ['com.example.m7BinaryProtection'],
        teamId: 'YOUR_APPLE_TEAM_ID',
      ),
      watcherMail: 'security@yourapp.com',
      isProd: kReleaseMode,
    );

    final callback = ThreatCallback(
      onAppIntegrity: () => _handleThreat('App integrity violation'),
      onDebug: () => _handleThreat('Debugger detected'),
      onDeviceBinding: () => _handleThreat('Device binding violation'),
      onDeviceID: () => _handleThreat('Device ID manipulation'),
      onHooks: () => _handleThreat('Hooking framework detected'),
      onPasscode: () => _handleThreat('No device passcode set'),
      onPrivilegedAccess: () => _handleThreat('Root / jailbreak detected'),
      onSecureHardwareNotAvailable: () => _handleThreat('No secure hardware'),
      onSimulator: () => _handleThreat('Running on simulator'),
      onUnofficialStore: () => _handleThreat('Installed from unofficial store'),
    );

    await _talsec.start(config, callback: callback);
  }

  void _handleThreat(String threat) {
    debugPrint('🚨 SECURITY THREAT: $threat');

    // Tailor the response to your app's risk tolerance:
    //   1. Log to analytics / security backend
    //   2. Disable sensitive features until app is restarted
    //   3. Wipe cached credentials
    //   4. Show a warning dialog
    //   5. Exit the app
  }
}
