# OWASP M8: Security Misconfiguration — Flutter Examples

This Flutter project contains every runnable code example from the **OWASP M8:
Security Misconfiguration** blog article. Run it on an Android or iOS device to
see each misconfiguration and its secure fix side by side.

---

## Project Structure

```
lib/
  main.dart                              ← Demo app UI (runs all 10 checks)
  bad_examples/
    insecure_http_client.dart            ← Accepts ALL certificates (BAD)
    insecure_storage.dart                ← Auth token in SharedPreferences (BAD)
    insecure_logger.dart                 ← Logs email + password (BAD)
  good_examples/
    app_config.dart                      ← Debug / release mode detection
    deep_link_handler.dart               ← Deep-link validation & routing
    permission_service.dart              ← Runtime permission with explanation
    secure_storage_service.dart          ← Keychain / EncryptedSharedPrefs
    secure_http_client.dart              ← Certificate pinning
    storage_service.dart                 ← Right tool for right data type
    secure_logger.dart                   ← PII-masked logging
    security_config_validator.dart       ← Runtime configuration audit

android/
  app/
    build.gradle                         ← minifyEnabled, shrinkResources, debuggable false
    proguard-rules.pro                   ← R8 / ProGuard keep rules
    src/main/
      AndroidManifest.xml                ← Hardened manifest (backup, cleartext, exported)
      res/xml/
        network_security_config.xml      ← HTTPS-only + cert pinning + debug overrides
        data_extraction_rules.xml        ← Android 12+ backup exclusions
        backup_rules.xml                 ← Pre-Android 12 backup exclusions

ios/
  Runner/
    Info.plist                           ← ATS enforced, privacy descriptions present
    Runner.entitlements                  ← Universal Links (no custom URL schemes)
  apple-app-site-association.json        ← AASA file example for Universal Links
```

---

## Quick Start

```bash
cd OWASP_Top_10_Flutter/m8_security_misconfiguration
flutter pub get
flutter run          # debug — watch the console for output
```

Tap the **▶** FAB to run all demos. Output is printed to the debug console.

---

## Demo Output (debug build)

```
═══════════════════════════════════════════════════════
 OWASP M8 — Security Misconfiguration Demo
═══════════════════════════════════════════════════════

── 1. Debug Mode Detection ──────────────────────────────
[AppConfig] Build mode     : debug
[AppConfig] API URL        : https://dev-api.yourapp.com
[AppConfig] Detailed logs  : true

── 2. Insecure HTTP Client (BAD) ────────────────────────
[BAD] Insecure HTTP client created — ALL certificates accepted!
[BAD] An attacker on the same network can intercept every request.

── 3. Secure HTTP Client (GOOD) ─────────────────────────
[SecureHTTP] ✅ Secure HTTP client created.
[SecureHTTP]    Pinned host : api.yourapp.com
[SecureHTTP]    Expected FP : AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99

── 4. Insecure Storage (BAD) ────────────────────────────
[BAD] Auth token saved to SharedPreferences (NOT encrypted!).
[BAD] Token visible at: /data/data/<pkg>/shared_prefs/FlutterSharedPreferences.xml

── 5. Secure Storage (GOOD) ─────────────────────────────
[SecureStorage] ✅ Auth token written (encrypted, first_unlock_this_device).
[SecureStorage] ✅ Auth token read (length: 36).
[SecureStorage] ✅ Auth token deleted.

── 6. Storage Service — right tool for right job ────────
[Storage] ✅ Token saved to FlutterSecureStorage (encrypted).
[Storage] Theme preference saved: dark=true
[Storage] Locale preference saved: en_US

── 7. Insecure Logger (BAD) ─────────────────────────────
[BAD] Login attempt: user@example.com / s3cretP@ss!
[BAD] Using API key: sk-live-abc123xyz789

── 8. Secure Logger (GOOD) ──────────────────────────────
[log] Login attempt: ma***@example.com
[log] User tapped checkout button

── 9. Deep Link Validation ──────────────────────────────
[DeepLink] ✅ Accepted: https://yourapp.com/product?id=abc-123
[DeepLink]    → navigating to product abc-123
[DeepLink] ❌ Rejected: https://yourapp.com/../etc/passwd
[DeepLink] ❌ Rejected: https://evil.com/product?id=1
[DeepLink] ❌ Rejected: https://yourapp.com/search?q=<script>alert(1)</script>

── 10. Runtime Configuration Validation ─────────────────
[SecurityValidator] Running configuration checks…
[SecurityValidator] ⚠️  Debug mode detected (expected for dev builds).
[SecurityValidator] Package: com.example.m8_security_misconfiguration (non-production ✅)
[SecurityValidator] Platform: android
[SecurityValidator] Validation complete — 0 critical issues.

═══════════════════════════════════════════════════════
 All demos complete — see cards above for summary.
═══════════════════════════════════════════════════════
```

---

## Article Coverage

| #   | Article Section                    | Bad Example                 | Good Example                     | Config File(s)                                                         |
| --- | ---------------------------------- | --------------------------- | -------------------------------- | ---------------------------------------------------------------------- |
| 1   | Debug Mode in Production           | —                           | `app_config.dart`                | `build.gradle`                                                         |
| 2   | Backup Configuration Leaks         | —                           | —                                | `AndroidManifest.xml`, `data_extraction_rules.xml`, `backup_rules.xml` |
| 3   | Cleartext Traffic (HTTP)           | —                           | —                                | `network_security_config.xml`, `AndroidManifest.xml`                   |
| 4   | Certificate Pinning                | —                           | `secure_http_client.dart`        | `network_security_config.xml`                                          |
| 5   | Exported Components                | —                           | `deep_link_handler.dart`         | `AndroidManifest.xml`                                                  |
| 6   | Excessive Permissions              | —                           | `permission_service.dart`        | `AndroidManifest.xml`                                                  |
| 7   | App Transport Security (iOS)       | —                           | —                                | `Info.plist`                                                           |
| 8   | Missing Privacy Usage Descriptions | —                           | —                                | `Info.plist`                                                           |
| 9   | Insecure Keychain Configuration    | —                           | `secure_storage_service.dart`    | —                                                                      |
| 10  | URL Scheme Hijacking               | —                           | —                                | `Runner.entitlements`, `AASA`                                          |
| 11  | Debug Mode Detection Bypass        | —                           | `app_config.dart`                | —                                                                      |
| 12  | Insecure HTTP Client Configuration | `insecure_http_client.dart` | `secure_http_client.dart`        | —                                                                      |
| 13  | Insecure SharedPreferences Usage   | `insecure_storage.dart`     | `storage_service.dart`           | —                                                                      |
| 14  | Logging Sensitive Information      | `insecure_logger.dart`      | `secure_logger.dart`             | —                                                                      |
| 15  | Runtime Configuration Validation   | —                           | `security_config_validator.dart` | —                                                                      |

---

## CI/CD Security Scan

A sample GitHub Actions workflow is included in the article. Copy
`.github/workflows/security-scan.yml` from the article to automate manifest /
plist / hardcoded-secret scanning on every push.
