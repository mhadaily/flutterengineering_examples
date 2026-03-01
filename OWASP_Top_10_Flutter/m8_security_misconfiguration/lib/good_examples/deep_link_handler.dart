/// GOOD EXAMPLE — Deep-link validation.
///
/// From the article section "Exported Components / Validate deep link data".
/// Every incoming URI is validated for scheme, host, path traversal, and
/// malicious patterns before the app acts on it.
library;

import 'package:flutter/widgets.dart';

class DeepLinkHandler {
  // In a real app you would use AppLinks here:
  //   final AppLinks _appLinks = AppLinks();

  /// Validates and routes a deep link.
  ///
  /// Output (valid link):
  /// ```
  /// [DeepLink] ✅ Accepted: https://yourapp.com/product?id=abc-123
  /// [DeepLink]    → navigating to product abc-123
  /// ```
  ///
  /// Output (invalid — path traversal):
  /// ```
  /// [DeepLink] ❌ Rejected: https://yourapp.com/../etc/passwd
  /// ```
  ///
  /// Output (invalid — wrong host):
  /// ```
  /// [DeepLink] ❌ Rejected: https://evil.com/product?id=1
  /// ```
  ///
  /// Output (invalid — XSS attempt):
  /// ```
  /// [DeepLink] ❌ Rejected: https://yourapp.com/search?q=<script>alert(1)</script>
  /// ```
  /// Validates and routes a deep link.
  ///
  /// [rawLink] is the original, un-parsed string as received from the OS.
  /// We validate both the raw string (to catch traversal *before* URI
  /// normalisation) and the parsed [Uri].
  void handleDeepLink(Uri uri, {String? rawLink}) {
    if (!_isValidDeepLink(uri, rawLink: rawLink)) {
      print('[DeepLink] ❌ Rejected: ${rawLink ?? uri}');
      return;
    }

    print('[DeepLink] ✅ Accepted: $uri');
    _processValidatedLink(uri);
  }

  bool _isValidDeepLink(Uri uri, {String? rawLink}) {
    // 1. Validate scheme
    if (!['https', 'myapp'].contains(uri.scheme)) return false;

    // 2. Validate host (for https only)
    final allowedHosts = ['yourapp.com', 'www.yourapp.com'];
    if (uri.scheme == 'https' && !allowedHosts.contains(uri.host)) return false;

    // 3. Reject path-traversal attempts.
    //    Uri.parse normalises ".." away, so we must also inspect the raw
    //    string the OS handed us.
    final raw = rawLink ?? uri.toString();
    if (raw.contains('..') || raw.contains('%2e%2e') || raw.contains('%2E%2E')) {
      return false;
    }

    // 4. Only allow known path prefixes (allowlist approach)
    final allowedPaths = ['/', '/product', '/profile', '/search', '/open'];
    if (!allowedPaths.contains(uri.path)) return false;

    // 5. Scan query parameters for malicious patterns
    for (final value in uri.queryParameters.values) {
      if (_containsMaliciousPatterns(value)) return false;
    }

    return true;
  }

  bool _containsMaliciousPatterns(String value) {
    final patterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'data:', caseSensitive: false),
      RegExp(r'file://', caseSensitive: false),
    ];
    return patterns.any((p) => p.hasMatch(value));
  }

  void _processValidatedLink(Uri uri) {
    switch (uri.path) {
      case '/product':
        final productId = uri.queryParameters['id'];
        if (productId != null && _isValidProductId(productId)) {
          print('[DeepLink]    → navigating to product $productId');
        }
      case '/profile':
        print('[DeepLink]    → navigating to profile');
      default:
        print('[DeepLink]    → navigating to home');
    }
  }

  bool _isValidProductId(String id) {
    return RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(id) && id.length <= 50;
  }
}
