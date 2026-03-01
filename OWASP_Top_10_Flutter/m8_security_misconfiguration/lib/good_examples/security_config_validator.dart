/// GOOD EXAMPLE — Runtime security-configuration validation.
///
/// From the article section "Runtime Configuration Validation".
/// Run these checks once at app startup. Any issues are logged to your crash
/// reporting service (without exposing details to the user).
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SecurityConfigValidator {
  /// Validates the current configuration and returns a list of issues.
  ///
  /// Output (debug, non-production package):
  /// ```
  /// [SecurityValidator] Running configuration checks…
  /// [SecurityValidator] ⚠️  Debug mode detected (expected for dev builds).
  /// [SecurityValidator] Package: com.yourapp.dev (non-production ✅)
  /// [SecurityValidator] Platform: android
  /// [SecurityValidator] Validation complete — 0 critical issues.
  /// ```
  ///
  /// Output (release, production package with debug flag):
  /// ```
  /// [SecurityValidator] Running configuration checks…
  /// [SecurityValidator] 🚨 CRITICAL: Debug mode detected in production environment
  /// [SecurityValidator] Package: com.yourapp.app (production)
  /// [SecurityValidator] Platform: android
  /// [SecurityValidator] Validation complete — 1 critical issues.
  /// ```
  static Future<List<String>> validateConfiguration() async {
    final issues = <String>[];
    print('[SecurityValidator] Running configuration checks…');

    // 1. Build-mode vs package-name coherence
    final isProduction = await _isProductionEnvironment();

    if (kDebugMode && isProduction) {
      const msg = 'CRITICAL: Debug mode detected in production environment';
      issues.add(msg);
      print('[SecurityValidator] 🚨 $msg');
    } else if (kDebugMode) {
      print(
        '[SecurityValidator] ⚠️  Debug mode detected (expected for dev builds).',
      );
    }

    // 2. Log package info
    final info = await PackageInfo.fromPlatform();
    print(
      '[SecurityValidator] Package: ${info.packageName} '
      '(${isProduction ? "production" : "non-production ✅"})',
    );

    // 3. Platform-specific checks
    if (Platform.isAndroid) {
      issues.addAll(await _validateAndroidConfig());
      print('[SecurityValidator] Platform: android');
    } else if (Platform.isIOS) {
      issues.addAll(await _validateIOSConfig());
      print('[SecurityValidator] Platform: ios');
    }

    print(
      '[SecurityValidator] Validation complete — '
      '${issues.length} critical issues.',
    );
    return issues;
  }

  static Future<bool> _isProductionEnvironment() async {
    final info = await PackageInfo.fromPlatform();
    return !info.packageName.contains('.dev') &&
        !info.packageName.contains('.staging');
  }

  static Future<List<String>> _validateAndroidConfig() async {
    // Runtime checks are limited on Android but can surface some signals.
    return [];
  }

  static Future<List<String>> _validateIOSConfig() async {
    return [];
  }

  /// Convenience wrapper to run at startup.
  static void assertSecureConfiguration() {
    if (kReleaseMode) {
      validateConfiguration().then((issues) {
        for (final issue in issues) {
          debugPrint('Security Issue: $issue');
        }
      });
    }
  }
}
