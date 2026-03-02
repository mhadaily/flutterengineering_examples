/// GOOD EXAMPLE — Auto-clear clipboard for sensitive data.
///
/// When users copy account numbers or recovery codes, the clipboard
/// is automatically cleared after 30 seconds.
library;

import 'dart:async';

import 'package:flutter/services.dart';

class SecureClipboard {
  static Timer? _clearTimer;

  /// Copy sensitive data with auto-clear.
  static Future<void> copySecure(
    String data, {
    Duration clearAfter = const Duration(seconds: 30),
  }) async {
    await Clipboard.setData(ClipboardData(text: data));
    print('[Clipboard] ✅ Sensitive data copied.');
    print('[Clipboard]    Auto-clear in ${clearAfter.inSeconds}s.');

    _clearTimer?.cancel();
    _clearTimer = Timer(clearAfter, () async {
      await Clipboard.setData(const ClipboardData(text: ''));
      print('[Clipboard] 🗑️  Clipboard cleared.');
    });
  }

  /// Immediately clear clipboard.
  static Future<void> clear() async {
    _clearTimer?.cancel();
    await Clipboard.setData(const ClipboardData(text: ''));
    print('[Clipboard] 🗑️  Clipboard cleared immediately.');
  }
}
