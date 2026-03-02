# OWASP M10 — Insufficient Cryptography (Flutter Examples)

Companion code for the article  
**[OWASP Top 10 For Flutter – M10: Insufficient Cryptography](https://github.com/mhadaily/flutterengineering_examples/tree/main/OWASP_Top_10_Flutter/m10_insufficient_cryptography)**

## What's inside

| Category | File                                           | Description                                                        |
| -------- | ---------------------------------------------- | ------------------------------------------------------------------ |
| ❌ Bad   | `bad_examples/insecure_crypto.dart`            | Hardcoded key, ECB, static IV, CBC without HMAC, SHA-256 passwords |
| ❌ Bad   | `bad_examples/ecb_mode_demo.dart`              | ECB pattern-leak demonstration                                     |
| ❌ Bad   | `bad_examples/insecure_random.dart`            | `Random()` vs `Random.secure()`                                    |
| ❌ Bad   | `bad_examples/weak_password_hashing.dart`      | SHA-256 for password hashing                                       |
| ✅ Good  | `good_examples/secure_encryption_service.dart` | AES-256-GCM with tamper detection                                  |
| ✅ Good  | `good_examples/chacha_encryption_service.dart` | ChaCha20-Poly1305 AEAD                                             |
| ✅ Good  | `good_examples/secure_password_hasher.dart`    | Argon2id password hashing                                          |
| ✅ Good  | `good_examples/pbkdf2_password_hasher.dart`    | PBKDF2-SHA256 (310k iterations)                                    |
| ✅ Good  | `good_examples/secure_key_generator.dart`      | AES, Ed25519, HKDF sub-keys                                        |
| ✅ Good  | `good_examples/key_management_service.dart`    | Key lifecycle: create, rotate, expire, delete                      |
| ✅ Good  | `good_examples/signature_service.dart`         | Ed25519 digital signatures                                         |
| ✅ Good  | `good_examples/secure_random_generator.dart`   | `Random.secure()` for keys, nonces, salts                          |
| ✅ Good  | `good_examples/constant_time_comparison.dart`  | Timing-attack resistant equality                                   |
| ✅ Good  | `good_examples/gcm_unique_demo.dart`           | Same plaintext → different ciphertext                              |

## Quick start

```bash
flutter pub get
flutter test                               # all 15 tests (14 output + 1 widget)
flutter test test/output_capture_test.dart  # just the output-capture suite
```

## Packages used

| Package                  | Purpose                                            |
| ------------------------ | -------------------------------------------------- |
| `cryptography`           | AES-GCM, ChaCha20, Argon2id, PBKDF2, Ed25519, HKDF |
| `encrypt`                | ECB/CBC demos (bad examples)                       |
| `crypto`                 | SHA-256 demos (bad examples)                       |
| `flutter_secure_storage` | Platform key storage (Keychain / Keystore)         |

## Running on device

Tests exercise all pure-Dart examples. Platform-dependent examples
(`SecureEncryptionService`, `KeyManagementService`) require a real device or
emulator — run the app with `flutter run` to test those interactively.

## License

Same as the parent repository.
