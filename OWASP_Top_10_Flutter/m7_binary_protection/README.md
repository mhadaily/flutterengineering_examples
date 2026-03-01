# OWASP M7: Insufficient Binary Protection - Flutter Examples

This Flutter project contains every runnable code example from the OWASP M7:
Insufficient Binary Protection blog article. Run it on an Android or iOS device
to see each protection technique in action.

---

## Project Structure

```
lib/
  main.dart                        <- Demo app UI (runs all 9 checks)
  bad_examples/
    api_config_bad.dart            <- Hardcoded API keys (BAD)
    trading_features_bad.dart      <- Client-side-only license check (BAD)
  good_examples/
    secure_config.dart             <- Build-time env vars (--dart-define)
    native_secrets.dart            <- Secrets via MethodChannel to native C++
    secure_remote_config.dart      <- Secrets fetched at runtime (best practice)
    integrity_checker.dart         <- APK signature verification
    binary_integrity_checker.dart  <- libapp.so SHA-256 hash check
    app_integrity_service.dart     <- Combined integrity service
    root_detector.dart             <- Root / jailbreak detection
    anti_debug_service.dart        <- Debugger + Frida detection
    security_service.dart          <- freeRASP integration
    license_service.dart           <- Server-side license validation

android/
  app/
    proguard-rules.pro
    src/main/
      kotlin/com/example/m7_binary_protection/
        MainActivity.kt
        SecretProvider.kt
        IntegrityPlugin.kt
        RootDetectionPlugin.kt
      cpp/
        secrets.cpp
        CMakeLists.txt

backend/
  server.js                        <- Node.js/Express license validation
  package.json
```

## Running the Demo App

```bash
cd examples/m7_binary_protection
flutter pub get
flutter run
```

Tap "Run All Checks" to execute all 9 protection examples.

### Release Build (recommended for realistic results)

```bash
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=./debug-info \
  --dart-define=API_KEY=your_real_api_key
```

## What Each Example Demonstrates

| #   | File                                                  | Topic                                |
| --- | ----------------------------------------------------- | ------------------------------------ |
| 1   | secure_config.dart                                    | --dart-define env vars at build time |
| 2   | native_secrets.dart + SecretProvider.kt + secrets.cpp | Secrets in native C++                |
| 3   | integrity_checker.dart + IntegrityPlugin.kt           | APK signature verification           |
| 4   | binary_integrity_checker.dart                         | libapp.so SHA-256 tamper detection   |
| 5   | root_detector.dart + RootDetectionPlugin.kt           | Root/jailbreak detection             |
| 6   | anti_debug_service.dart + IntegrityPlugin.kt          | Debugger + Frida detection           |
| 7   | app_integrity_service.dart                            | Combined integrity service           |
| 8   | security_service.dart                                 | freeRASP RASP integration            |
| 9   | license_service.dart + backend/server.js              | Server-side license validation       |

---

## One-time Setup for Native Checks

### Replace the signing cert hash (check 3)

```bash
keytool -printcert -jarfile your-release.apk | grep SHA256
```

Replace REPLACE_WITH_YOUR_RELEASE_CERT_SHA256_COLON_HEX in IntegrityPlugin.kt.

### Update libapp.so expected hash (check 4)

```bash
unzip -p your-release.apk lib/arm64-v8a/libapp.so | sha256sum
```

Replace REPLACE_WITH_SHA256_OF_YOUR_RELEASE_LIBAPP_SO in
binary_integrity_checker.dart.

### Encode your real API key (check 2)

```python
mask = 0x5A
secret = b'your-real-api-key-here'
print(', '.join(f'0x{b ^ mask:02X}' for b in secret))
```

Replace kEncodedApiKey[] in secrets.cpp with the output.

### Run the backend server (check 9)

```bash
cd backend && npm install && node server.js
```

## Optional pubspec.yaml dependencies

```yaml
firebase_core: ^3.0.0
firebase_remote_config: ^5.0.0
flutter_secure_storage: ^9.0.0
freerasp: ^6.0.0
pointycastle: ^3.7.4
```

## Build Commands Reference

```bash
# Release with obfuscation
flutter build apk --release --obfuscate --split-debug-info=./debug-info

# App Bundle for Play Store
flutter build appbundle --release --obfuscate --split-debug-info=./debug-info

# Upload debug symbols to Firebase Crashlytics
firebase crashlytics:symbols:upload --app=YOUR_APP_ID ./debug-info
```
