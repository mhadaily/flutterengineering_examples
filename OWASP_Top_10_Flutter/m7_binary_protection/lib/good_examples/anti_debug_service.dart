// ✅ GOOD EXAMPLE — Anti-debugging protection
//
// In a production app there is no legitimate reason for a debugger to be
// attached. Detecting it — especially Frida, which attackers use to hook
// your app at runtime — is an important layer of defense.
//
// This runs a periodic check so that a debugger attached *after* launch
// is still caught.
//
// Frida detection is implemented on the native side (Kotlin):
//   android/app/src/main/kotlin/com/example/m7_binary_protection/IntegrityPlugin.kt

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AntiDebugService {
  static const _channel = MethodChannel('com.example.m7/integrity');

  Timer? _monitor;

  /// Returns true if a debugger is currently attached.
  static Future<bool> isDebuggerAttached() async {
    try {
      final attached = await _channel.invokeMethod<bool>('isDebuggerAttached');
      return attached ?? false;
    } catch (e) {
      // A failure to check may itself indicate tampering.
      debugPrint('AntiDebugService.isDebuggerAttached failed: $e');
      return false;
    }
  }

  /// Starts a periodic check (every [interval]) and calls [onDebuggerDetected]
  /// once if a debugger is found. Stops the timer afterwards.
  void startMonitoring({
    Duration interval = const Duration(seconds: 5),
    required void Function() onDebuggerDetected,
  }) {
    _monitor?.cancel();
    _monitor = Timer.periodic(interval, (timer) async {
      if (await AntiDebugService.isDebuggerAttached()) {
        timer.cancel();
        debugPrint('AntiDebugService: debugger detected!');
        onDebuggerDetected();
      }
    });
  }

  /// Stop monitoring. Call this when the widget/service is disposed.
  void stopMonitoring() {
    _monitor?.cancel();
    _monitor = null;
  }
}
