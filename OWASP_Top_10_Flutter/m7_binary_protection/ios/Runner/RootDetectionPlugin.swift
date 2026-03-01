import Flutter
import UIKit

/// RootDetectionPlugin — iOS counterpart of RootDetectionPlugin.kt
///
/// Channel: com.example.m7/root_detection
/// Methods:
///   checkJailbreak → [String: Bool]
///
/// Checks multiple indicators because jailbreak tools actively try to hide themselves.
/// No single check is reliable alone.
class RootDetectionPlugin: NSObject, FlutterPlugin {

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.example.m7/root_detection",
            binaryMessenger: registrar.messenger()
        )
        let instance = RootDetectionPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "checkJailbreak":
            result(performJailbreakChecks())
        case "checkRoot":
            // Android-only method — return empty map on iOS
            result([:])
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // -------------------------------------------------------------------------
    // Jailbreak indicators
    // -------------------------------------------------------------------------

    private func performJailbreakChecks() -> [String: Bool] {
        return [
            "cydiaInstalled":           checkCydiaInstalled(),
            "suspiciousFiles":          checkSuspiciousFiles(),
            "canWriteOutsideSandbox":   checkSandboxEscape(),
            "symbolicLinks":            checkSymbolicLinks(),
            "suspiciousLibraries":      checkSuspiciousLibraries(),
        ]
    }

    /// Cydia is the most common package manager on jailbroken devices.
    private func checkCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }

    /// Common files and directories created by jailbreak tools.
    private func checkSuspiciousFiles() -> Bool {
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/usr/bin/ssh",
            "/private/var/stash",
            "/usr/libexec/cydia",
            "/var/cache/apt",
            "/var/lib/apt",
            "/var/lib/cydia",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
        ]
        return paths.contains { FileManager.default.fileExists(atPath: $0) }
    }

    /// A jailbroken app can write outside its sandbox. A clean app cannot.
    private func checkSandboxEscape() -> Bool {
        let testPath = "/private/jailbreak_test_\(UUID().uuidString)"
        do {
            try "jailbreak_test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true // Write succeeded — sandbox has been compromised
        } catch {
            return false
        }
    }

    /// On jailbroken devices, /Applications and /Library are often symlinks.
    private func checkSymbolicLinks() -> Bool {
        let paths = ["/Applications", "/Library/Ringtones", "/Library/Wallpaper",
                     "/usr/arm-apple-darwin9", "/usr/include", "/usr/libexec", "/usr/share"]
        return paths.contains {
            (try? FileManager.default.destinationOfSymbolicLink(atPath: $0)) != nil
        }
    }

    /// Scan for known jailbreak / hooking dylibs injected into the process.
    private func checkSuspiciousLibraries() -> Bool {
        let suspicious = ["SubstrateLoader", "MobileSubstrate", "SSLKillSwitch",
                          "Cycript", "cynject", "libcycript", "frida", "gadget"]
        let count = _dyld_image_count()
        for i in 0..<count {
            if let name = _dyld_get_image_name(i) {
                let imageName = String(cString: name).lowercased()
                if suspicious.contains(where: { imageName.contains($0.lowercased()) }) {
                    return true
                }
            }
        }
        return false
    }
}
