import Flutter
import UIKit

/// SecretProvider — iOS counterpart of SecretProvider.kt / secrets.cpp
///
/// Channel: com.example.m7/secrets
/// Methods:
///   getApiKey              → String  (XOR-decoded from obfuscated bytes)
///   getModelDecryptionKey  → String  (XOR-decoded from obfuscated bytes)
///
/// The XOR encoding matches the C++ implementation in android/app/src/main/cpp/secrets.cpp.
/// To update the secret, re-encode with the same mask:
///
///   python3 -c "
///   mask = 0x5A
///   secret = b'your-real-secret-here'
///   print(', '.join(f'0x{b ^ mask:02X}' for b in secret))
///   "
///
/// ⚠️  This is a speed bump, not a wall. A determined attacker with a binary analysis
/// tool can still find the secret. Prefer fetching secrets from your server at runtime
/// (see SecureConfigService on the Dart side) whenever possible.
class SecretProvider: NSObject, FlutterPlugin {

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.example.m7/secrets",
            binaryMessenger: registrar.messenger()
        )
        let instance = SecretProvider()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getApiKey":
            result(xorDecode(encodedApiKey))
        case "getModelDecryptionKey":
            result(xorDecode(encodedModelKey))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // -------------------------------------------------------------------------
    // XOR-encoded secrets (mask = 0x5A)
    // These match the values in android/app/src/main/cpp/secrets.cpp
    // -------------------------------------------------------------------------

    // Encodes "sk-prod"
    private let encodedApiKey: [UInt8] = [
        0x29, 0x31, 0x77, 0x2A, 0x28, 0x35, 0x3E
    ]

    // Encodes "DEMOKEY"
    private let encodedModelKey: [UInt8] = [
        0x1E, 0x3E, 0x28, 0x33, 0x29, 0x35, 0x27
    ]

    private let kMask: UInt8 = 0x5A

    private func xorDecode(_ encoded: [UInt8]) -> String {
        let bytes = encoded.map { $0 ^ kMask }
        return String(bytes: bytes, encoding: .utf8) ?? ""
    }
}
