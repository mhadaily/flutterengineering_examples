/// GOOD EXAMPLE — HTTP client with proper certificate validation.
///
/// From the article section "Insecure HTTP Client Configuration".
/// Demonstrates optional certificate pinning for high-security scenarios.
library;

import 'dart:io';

import 'package:crypto/crypto.dart';

class SecureHttpClient {
  /// Creates an [HttpClient] with default system certificate validation
  /// **plus** optional SHA-256 fingerprint pinning for a specific host.
  ///
  /// Output:
  /// ```
  /// [SecureHTTP] ✅ Secure HTTP client created.
  /// [SecureHTTP]    Pinned host : api.yourapp.com
  /// [SecureHTTP]    Expected FP : AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99
  /// ```
  static HttpClient createSecureClient({
    String pinnedHost = 'api.yourapp.com',
    String expectedFingerprint =
        'AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99',
  }) {
    final client = HttpClient();

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // Reject anything that isn't our pinned host.
      if (host != pinnedHost) return false;

      // Verify certificate fingerprint.
      final actual = _getCertificateFingerprint(cert);
      return actual == expectedFingerprint;
    };

    print('[SecureHTTP] ✅ Secure HTTP client created.');
    print('[SecureHTTP]    Pinned host : $pinnedHost');
    print('[SecureHTTP]    Expected FP : $expectedFingerprint');

    return client;
  }

  /// Calculates the SHA-256 fingerprint of the DER-encoded certificate.
  static String _getCertificateFingerprint(X509Certificate cert) {
    final bytes = cert.der;
    final digest = sha256.convert(bytes);
    return digest.bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(':');
  }
}
