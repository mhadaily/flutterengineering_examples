/// GOOD EXAMPLE — Prevent screenshots of sensitive screens.
///
/// Android: Uses FLAG_SECURE window flag.
/// iOS: Shows a blur overlay when app goes to background.
///
/// Requires platform channel — see the article for native implementations.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScreenshotProtection {
  static const _channel = MethodChannel('com.example.app/security');

  /// Enable screenshot protection.
  static Future<void> enable() async {
    try {
      await _channel.invokeMethod('enableScreenshotProtection');
      print('[Screenshot] ✅ Screenshot protection enabled.');
    } on PlatformException catch (e) {
      debugPrint('[Screenshot] ⚠️  Failed to enable protection: $e');
    } on MissingPluginException {
      print('[Screenshot] ⚠️  Platform channel not available (test/desktop).');
    }
  }

  /// Disable screenshot protection.
  static Future<void> disable() async {
    try {
      await _channel.invokeMethod('disableScreenshotProtection');
      print('[Screenshot] ✅ Screenshot protection disabled.');
    } on PlatformException catch (e) {
      debugPrint('[Screenshot] ⚠️  Failed to disable protection: $e');
    } on MissingPluginException {
      print('[Screenshot] ⚠️  Platform channel not available (test/desktop).');
    }
  }
}
