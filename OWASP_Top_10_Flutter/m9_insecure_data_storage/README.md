# OWASP M9 — Insecure Data Storage (Flutter Examples)

Companion code for the article **OWASP Top 10 For Flutter – M9: Insecure Data
Storage in Flutter & Dart**.

## Project Structure

```
lib/
├── main.dart                              # Interactive demo runner
├── bad_examples/
│   ├── insecure_storage.dart              # SharedPreferences for credentials
│   ├── insecure_file_storage.dart         # Plain JSON files with PII
│   ├── insecure_database.dart             # Unencrypted SQLite
│   └── insecure_logger.dart               # Logging passwords & tokens
└── good_examples/
    ├── secure_storage_service.dart         # flutter_secure_storage (basic)
    ├── secure_database.dart               # SQLCipher with Keystore-backed key
    ├── secure_file_storage.dart           # AES-GCM file encryption
    ├── comprehensive_storage_service.dart # Three-tier sensitivity model
    ├── auth_repository.dart               # Auth using three-tier storage
    ├── secure_logger.dart                 # Auto-redaction of sensitive patterns
    ├── secure_clipboard.dart              # Auto-clear clipboard
    ├── screenshot_protection.dart         # FLAG_SECURE / iOS blur overlay
    ├── secure_memory.dart                 # SecureString — zeroed after use
    └── security_service.dart              # Root/jailbreak detection & response
test/
├── output_capture_test.dart               # Pure-Dart tests (real output)
└── widget_test.dart                       # App smoke test
```

## Quick Start

```bash
cd OWASP_Top_10_Flutter/m9_insecure_data_storage
flutter pub get
flutter run          # interactive demo on a device/emulator
flutter test         # verify outputs in CI
```

## What's Covered

| #   | Topic                    | Bad Example             | Good Example                    |
| --- | ------------------------ | ----------------------- | ------------------------------- |
| 1   | SharedPreferences misuse | `insecure_storage`      | `secure_storage_service`        |
| 2   | Plain JSON files         | `insecure_file_storage` | `secure_file_storage`           |
| 3   | Unencrypted SQLite       | `insecure_database`     | `secure_database`               |
| 4   | Logging credentials      | `insecure_logger`       | `secure_logger`                 |
| 5   | Three-tier storage       | —                       | `comprehensive_storage_service` |
| 6   | Auth token handling      | —                       | `auth_repository`               |
| 7   | Clipboard security       | —                       | `secure_clipboard`              |
| 8   | Screenshot protection    | —                       | `screenshot_protection`         |
| 9   | Secure memory handling   | —                       | `secure_memory`                 |
| 10  | Root/jailbreak detection | —                       | `security_service`              |

## Notes

- **Pure-Dart examples** (1–4, 5–7, 9–10) produce verifiable console output and
  are exercised in `test/output_capture_test.dart`.
- **Platform-channel examples** (SecureStorageService, SecureClipboard,
  ScreenshotProtection) require a real device or emulator.
- The `encrypt` package is included for AES-GCM; the demo uses a simplified XOR
  for CI-testability — real apps should use the full AES-GCM API.
