/// BAD EXAMPLE — Insecure HTTP client that accepts every certificate.
///
/// From the article section "Insecure HTTP Client Configuration".
/// Disabling certificate validation defeats TLS entirely and should NEVER
/// appear in production code.
library;

import 'dart:io';

/// Creates an [HttpClient] that blindly trusts every certificate.
///
/// An attacker performing a man-in-the-middle attack can present any
/// certificate and this client will happily accept it, giving the attacker
/// full visibility into (and control over) all network traffic.
HttpClient createInsecureClient() {
  final client = HttpClient();
  // DANGER: Accepts ALL certificates — defeats the purpose of TLS!
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return client;
}

/// Demonstrates the insecure client.
///
/// Output:
/// ```
/// [BAD] Insecure HTTP client created — ALL certificates accepted!
/// [BAD] An attacker on the same network can intercept every request.
/// ```
void demonstrateInsecureClient() {
  final client = createInsecureClient();
  print('[BAD] Insecure HTTP client created — ALL certificates accepted!');
  print(
    '[BAD] An attacker on the same network can intercept every request.',
  );
  client.close();
}
