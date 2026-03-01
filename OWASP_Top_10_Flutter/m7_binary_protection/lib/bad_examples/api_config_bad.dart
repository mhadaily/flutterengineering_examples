// ⚠️ BAD EXAMPLE — DO NOT USE IN PRODUCTION
//
// This demonstrates the most common binary protection mistake:
// hardcoding secrets directly in Dart code.
//
// An attacker can extract these with a single command:
//   strings extracted/lib/arm64-v8a/libapp.so | grep -i "api\|key\|secret\|token"
//
// See: good_examples/secure_config.dart for the right approach.

class ApiConfigBad {
  // ❌ Hardcoded API key — visible as plaintext in libapp.so
  static const String apiKey = 'sk-prod-a1b2c3d4e5f6g7h8i9j0';

  // ❌ Hardcoded secret token — same problem
  static const String secretToken = 'super_secret_token_123';

  // ❌ String concatenation does NOT help — all parts still appear in binary
  static String getApiKey() {
    // ignore: prefer_adjacent_string_concatenation
    return 'sk-prod-' + 'a1b2c3d4' + 'e5f6g7h8i9j0';
  }

  // ❌ Even "encoding" is pointless if the decode logic is local
  static String getEncodedKey() {
    const encoded = 'c2stcHJvZC1hMWIyYzNkNGU1ZjZnN2g4aTlqMA=='; // base64
    // This is trivially reversible — attackers will find both the encoded
    // value and the decode logic.
    return String.fromCharCodes(
      encoded.codeUnits.map((c) => c), // no actual decoding here — for demo
    );
  }
}
