// ✅ GOOD EXAMPLE — Comprehensive integrity service
//
// Combines signature verification, debugger detection, emulator detection,
// and root/jailbreak detection into a single auditable service.
//
// Usage:
//   final service = AppIntegrityService();
//   await service.performFullCheck();
//   if (service.isCompromised) {
//     service.handleViolations();
//   }

import 'package:flutter/foundation.dart';
import 'anti_debug_service.dart';
import 'integrity_checker.dart';
import 'root_detector.dart';

enum IntegrityStatus {
  valid,
  signatureMismatch,
  debuggerAttached,
  emulatorDetected,
  rootDetected,
  tamperingDetected,
  unknown,
}

class AppIntegrityService {
  // Singleton
  static final AppIntegrityService _instance = AppIntegrityService._internal();
  factory AppIntegrityService() => _instance;
  AppIntegrityService._internal();

  final List<IntegrityStatus> _violations = [];

  /// Immutable snapshot of current violations.
  List<IntegrityStatus> get violations => List.unmodifiable(_violations);

  /// True when any violation was detected.
  bool get isCompromised => _violations.isNotEmpty;

  /// Run all checks. Results accumulate in [violations].
  Future<void> performFullCheck() async {
    _violations.clear();

    // 1. Signature check (Android only)
    if (!await IntegrityChecker.verifySignature()) {
      _violations.add(IntegrityStatus.signatureMismatch);
    }

    // 2. Debugger check — only meaningful in release mode
    if (kReleaseMode && await _isDebuggerAttached()) {
      _violations.add(IntegrityStatus.debuggerAttached);
    }

    // 3. Emulator check
    if (await _isRunningOnEmulator()) {
      _violations.add(IntegrityStatus.emulatorDetected);
    }

    // 4. Root / jailbreak check
    if (await _isDeviceRooted()) {
      _violations.add(IntegrityStatus.rootDetected);
    }

    debugPrint(
      'AppIntegrityService: check complete — '
      '${_violations.isEmpty ? "all clear" : _violations.join(", ")}',
    );
  }

  // ---------------------------------------------------------------------------
  // Platform check stubs — replace with your MethodChannel implementations
  // or use the freeRASP package (see security_service.dart).
  // ---------------------------------------------------------------------------

  Future<bool> _isDebuggerAttached() async {
    return AntiDebugService.isDebuggerAttached();
  }

  Future<bool> _isRunningOnEmulator() async {
    // No generic emulator check yet — extend with a native MethodChannel if needed.
    return false;
  }

  Future<bool> _isDeviceRooted() async {
    return RootDetector.isDeviceCompromised();
  }

  // ---------------------------------------------------------------------------
  // Violation response — tailor to your app's risk tolerance
  // ---------------------------------------------------------------------------

  void handleViolations() {
    if (!isCompromised) return;

    for (final violation in _violations) {
      switch (violation) {
        case IntegrityStatus.signatureMismatch:
          _handleCriticalViolation('Application signature mismatch');
          break;
        case IntegrityStatus.debuggerAttached:
          _handleHighViolation('Debugger attached in release build');
          break;
        case IntegrityStatus.rootDetected:
          _handleMediumViolation('Rooted/jailbroken device');
          break;
        case IntegrityStatus.emulatorDetected:
          _handleMediumViolation('Emulator detected');
          break;
        case IntegrityStatus.tamperingDetected:
          _handleCriticalViolation('Binary tampered');
          break;
        default:
          break;
      }
    }
  }

  void _handleCriticalViolation(String message) {
    debugPrint('🔴 CRITICAL: $message');
    // In production:
    //   • Clear all sensitive data from secure storage
    //   • Log to your security analytics backend
    //   • Show a warning dialog and exit the app
  }

  void _handleHighViolation(String message) {
    debugPrint('🟠 HIGH: $message');
    // In production: disable sensitive features, log the event
  }

  void _handleMediumViolation(String message) {
    debugPrint('🟡 MEDIUM: $message');
    // In production: show a user-facing warning, restrict risky operations
  }
}
