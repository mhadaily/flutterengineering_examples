// ✅ GOOD EXAMPLE — Signature verification via MethodChannel
//
// Android apps are digitally signed. If an attacker re-packs and re-signs
// your APK the signature changes. This check catches that.
//
// Native implementation:
//   android/app/src/main/kotlin/com/example/m7_binary_protection/IntegrityPlugin.kt

import 'dart:io';
import 'package:flutter/services.dart';

class IntegrityChecker {
  static const _channel = MethodChannel('com.example.m7/integrity');

  /// Returns true when the app's signing certificate matches the
  /// expected release certificate.
  /// Always returns true on iOS — iOS integrity is handled by the OS.
  static Future<bool> verifySignature() async {
    if (!Platform.isAndroid) return true;

    try {
      final isValid = await _channel.invokeMethod<bool>('verifySignature');
      return isValid ?? false;
    } catch (e) {
      // If we can't verify, assume compromised.
      return false;
    }
  }

  /// Returns the SHA-256 hex fingerprint of the current signing certificate.
  /// Useful for sending to the server as part of a license verification call.
  static Future<String?> getSignatureHash() async {
    if (!Platform.isAndroid) return null;

    try {
      return await _channel.invokeMethod<String>('getSignatureHash');
    } catch (e) {
      return null;
    }
  }
}
