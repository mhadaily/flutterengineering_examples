import Flutter
import UIKit
import Darwin // sysctl

/// IntegrityPlugin — iOS counterpart of IntegrityPlugin.kt
///
/// Channel: com.example.m7/integrity
/// Methods:
///   isDebuggerAttached  → Bool
///   verifySignature     → Bool  (always true on iOS — enforced by the OS)
///   getSignatureHash    → nil   (not applicable on iOS)
///   getLibappHash       → nil   (not applicable on iOS)
///
/// On iOS, binary integrity is guaranteed by Apple's mandatory code-signing and
/// the App Store review process. We therefore:
///   • Implement a real debugger / Frida detection check.
///   • Return sensible no-op values for the Android-only signature/hash methods
///     so the shared Dart code works transparently on both platforms.
class IntegrityPlugin: NSObject, FlutterPlugin {

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.example.m7/integrity",
            binaryMessenger: registrar.messenger()
        )
        let instance = IntegrityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isDebuggerAttached":
            result(isDebuggerOrDylibInjected())
        case "verifySignature":
            // iOS enforces code-signing at the OS level — always valid if the
            // app is running from the App Store or a trusted enterprise profile.
            result(true)
        case "getSignatureHash":
            // Not meaningful on iOS; Dart caller already guards with Platform.isAndroid.
            result(nil)
        case "getLibappHash":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // -------------------------------------------------------------------------
    // Debugger & Frida detection
    // -------------------------------------------------------------------------

    private func isDebuggerOrDylibInjected() -> Bool {
        return isTracerPidNonZero() || isFridaLibraryLoaded()
    }

    /// Checks /proc equivalent: uses sysctl kinfo_proc P_TRACED flag.
    private func isTracerPidNonZero() -> Bool {
        var info = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.size
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        let result = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        guard result == 0 else { return false }
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }

    /// Scans loaded dynamic libraries for known Frida gadget/agent names.
    private func isFridaLibraryLoaded() -> Bool {
        let count = _dyld_image_count()
        for i in 0..<count {
            if let name = _dyld_get_image_name(i) {
                let imageName = String(cString: name).lowercased()
                if imageName.contains("frida") || imageName.contains("gadget") {
                    return true
                }
            }
        }
        return false
    }
}
