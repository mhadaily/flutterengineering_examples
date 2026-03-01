// ✅ GOOD EXAMPLE — Build-time environment variable injection
//
// Use --dart-define=API_KEY=xxx at build time so secrets are
// never committed to source control.
//
// Build command:
//   flutter build apk --release \
//     --dart-define=API_KEY=your_real_key \
//     --dart-define=SECRET_TOKEN=your_real_token \
//     --obfuscate --split-debug-info=./debug-info
//
// ⚠️  CAVEAT: The value is still compiled into the binary as a string.
// This keeps secrets out of your git history—but not out of libapp.so.
// For true binary protection, use NativeSecrets or SecureRemoteConfig.
//
// See:
//   native_secrets.dart       — harder-to-extract native layer option
//   secure_remote_config.dart — best: never ship secrets at all

class SecureConfig {
  // Value injected at compile time, not in source code.
  static const String apiKey = String.fromEnvironment('API_KEY');
  static const String secretToken = String.fromEnvironment('SECRET_TOKEN');

  /// Call once at startup to verify all required config is present.
  static void validateConfig() {
    if (apiKey.isEmpty) {
      throw StateError(
        'API_KEY not configured. '
        'Build with --dart-define=API_KEY=your_key_here',
      );
    }
    if (secretToken.isEmpty) {
      throw StateError(
        'SECRET_TOKEN not configured. '
        'Build with --dart-define=SECRET_TOKEN=your_token_here',
      );
    }
  }
}
