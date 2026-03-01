/// GOOD EXAMPLE — Environment-aware configuration.
///
/// From the article section "Debug Mode Detection Bypass".
/// Uses Flutter's compile-time constants to ensure debug features never
/// leak into production builds.
library;

import 'package:flutter/foundation.dart';

class AppConfig {
  /// `true` only in `flutter build --release` (or `flutter run --release`).
  static bool get isProduction => kReleaseMode;

  /// Returns the correct API base URL for the current build mode.
  ///
  /// Output (debug):
  /// ```
  /// API base URL: https://dev-api.yourapp.com
  /// ```
  ///
  /// Output (release):
  /// ```
  /// API base URL: https://api.yourapp.com
  /// ```
  static String get apiBaseUrl {
    if (kDebugMode) {
      return 'https://dev-api.yourapp.com';
    }
    return 'https://api.yourapp.com';
  }

  /// Detailed logging is only enabled during development.
  static bool get enableDetailedLogging => kDebugMode;

  /// Call once at startup to sanity-check the release build.
  ///
  /// In a true release build the `assert` block is stripped by the compiler,
  /// so this method is a no-op. If you see the warning, you are NOT running
  /// in release mode.
  ///
  /// Output (debug):
  /// ```
  /// [AppConfig] Build mode     : debug
  /// [AppConfig] API URL        : https://dev-api.yourapp.com
  /// [AppConfig] Detailed logs  : true
  /// ```
  ///
  /// Output (release):
  /// ```
  /// [AppConfig] Build mode     : release
  /// [AppConfig] API URL        : https://api.yourapp.com
  /// [AppConfig] Detailed logs  : false
  /// ```
  static void validateReleaseConfiguration() {
    final mode = kReleaseMode
        ? 'release'
        : kProfileMode
            ? 'profile'
            : 'debug';

    print('[AppConfig] Build mode     : $mode');
    print('[AppConfig] API URL        : $apiBaseUrl');
    print('[AppConfig] Detailed logs  : $enableDetailedLogging');

    if (kReleaseMode) {
      assert(() {
        debugPrint(
          'WARNING: Assert statements are executing — this is NOT a release build!',
        );
        return true;
      }());
    }
  }
}
