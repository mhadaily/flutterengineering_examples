// ✅ GOOD EXAMPLE — Hash-based binary integrity check
//
// Detects whether libapp.so has been tampered with by comparing its
// SHA-256 hash against an expected value baked in at build time.
//
// ⚠️  Chicken-and-egg caveat:
//   The expected hash lives inside the binary you are hashing. A purely
//   client-side self-check will always have this limitation. The recommended
//   workaround is to either:
//     a) hash a *different* file (e.g. libflutter.so or a known asset), or
//     b) send the computed hash to your backend and validate it there.
//
// The native side resolves the correct nativeLibraryDir path; that is why
// the hash computation is delegated via MethodChannel rather than computed
// in Dart. See IntegrityPlugin.kt for the native implementation.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BinaryIntegrityChecker {
  static const _channel = MethodChannel('com.example.m7/integrity');

  // Generate this value during your CI release build:
  //   sha256sum extracted/lib/arm64-v8a/libapp.so
  // Then replace the placeholder below with the real hash.
  static const String _expectedLibappHash =
      'REPLACE_WITH_SHA256_OF_YOUR_RELEASE_LIBAPP_SO';

  /// Returns true when libapp.so has not been modified since the release build.
  /// Always returns true on iOS (iOS integrity is enforced by the OS).
  static Future<bool> verifyBinaryIntegrity() async {
    if (!Platform.isAndroid) return true;

    try {
      // Native code uses context.applicationInfo.nativeLibraryDir to locate
      // libapp.so and compute its SHA-256 hash.
      final hash = await _channel.invokeMethod<String>('getLibappHash');
      if (hash == null) return false;

      final match = hash == _expectedLibappHash;
      if (!match) {
        debugPrint(
          'BinaryIntegrityChecker: hash mismatch!\n'
          '  expected: $_expectedLibappHash\n'
          '  actual  : $hash',
        );
      }
      return match;
    } catch (e) {
      debugPrint('BinaryIntegrityChecker: check failed — $e');
      return false;
    }
  }
}
