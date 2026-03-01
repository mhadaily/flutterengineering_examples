// ✅ GOOD EXAMPLE — Store secrets in native code via a MethodChannel
//
// Native code (C++/Kotlin) is harder to reverse engineer than Dart.
// Combined with XOR obfuscation in C++, this raises the bar for
// string extraction.
//
// Still a speed bump, not a wall — a determined attacker with Ghidra
// and enough time can still figure it out. Prefer SecureRemoteConfig
// when possible.
//
// To wire up the Kotlin side, see:
//   android/app/src/main/kotlin/com/example/m7_binary_protection/SecretProvider.kt

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeSecrets {
  static const _channel = MethodChannel('com.example.m7/secrets');

  /// Retrieve the API key from native code.
  /// Returns an empty string if unavailable or if the call fails.
  static Future<String> getApiKey() async {
    try {
      final key = await _channel.invokeMethod<String>('getApiKey');
      return key ?? '';
    } catch (e) {
      debugPrint('NativeSecrets.getApiKey failed: $e');
      return '';
    }
  }

  /// Retrieve the ML model decryption key from native code.
  static Future<String> getModelDecryptionKey() async {
    try {
      final key = await _channel.invokeMethod<String>('getModelDecryptionKey');
      return key ?? '';
    } catch (e) {
      debugPrint('NativeSecrets.getModelDecryptionKey failed: $e');
      return '';
    }
  }
}
