// ✅ GOOD EXAMPLE — Root and jailbreak detection
//
// A rooted Android device or jailbroken iOS device gives attackers
// elevated access that bypasses the normal security sandbox.
//
// This checks multiple indicators because tools like Magisk actively
// try to hide themselves. No single check is reliable alone.
//
// Native implementation:
//   android/app/src/main/kotlin/com/example/m7_binary_protection/RootDetectionPlugin.kt

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RootDetector {
  static const _channel = MethodChannel('com.example.m7/root_detection');

  /// Returns true if the device shows any root or jailbreak indicators.
  static Future<bool> isDeviceCompromised() async {
    if (Platform.isAndroid) {
      return _checkAndroidRoot();
    } else if (Platform.isIOS) {
      return _checkIOSJailbreak();
    }
    return false;
  }

  static Future<bool> _checkAndroidRoot() async {
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'checkRoot',
      );
      if (result == null) return false;

      final checks = <String, bool>{
        'suBinaryExists': (result['suBinaryExists'] as bool?) ?? false,
        'superuserApkExists': (result['superuserApkExists'] as bool?) ?? false,
        'rootCloakingApps': (result['rootCloakingApps'] as bool?) ?? false,
        'testKeysBuild': (result['testKeysBuild'] as bool?) ?? false,
        'dangerousProps': (result['dangerousProps'] as bool?) ?? false,
        'rwSystem': (result['rwSystem'] as bool?) ?? false,
        'magiskDetected': (result['magiskDetected'] as bool?) ?? false,
      };

      checks.forEach((check, triggered) {
        if (triggered) debugPrint('RootDetector: $check triggered');
      });

      return checks.values.any((v) => v);
    } catch (e) {
      debugPrint('RootDetector._checkAndroidRoot failed: $e');
      return false;
    }
  }

  static Future<bool> _checkIOSJailbreak() async {
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'checkJailbreak',
      );
      if (result == null) return false;

      final checks = <String, bool>{
        'cydiaInstalled': (result['cydiaInstalled'] as bool?) ?? false,
        'suspiciousFiles': (result['suspiciousFiles'] as bool?) ?? false,
        'canWriteOutsideSandbox':
            (result['canWriteOutsideSandbox'] as bool?) ?? false,
        'symbolicLinks': (result['symbolicLinks'] as bool?) ?? false,
        'suspiciousLibraries':
            (result['suspiciousLibraries'] as bool?) ?? false,
      };

      checks.forEach((check, triggered) {
        if (triggered) debugPrint('RootDetector: iOS $check triggered');
      });

      return checks.values.any((v) => v);
    } catch (e) {
      debugPrint('RootDetector._checkIOSJailbreak failed: $e');
      return false;
    }
  }
}
