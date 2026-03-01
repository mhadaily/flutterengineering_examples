// ✅ GOOD EXAMPLE — Server-side license verification
//
// The golden rule: never trust the client.
// Every client-side check can be bypassed with a binary patch or a Frida hook.
// The only check that cannot be bypassed client-side is one that runs on *your* server.
//
// This service:
//   1. Caches the license key in flutter_secure_storage (offline grace).
//   2. Sends the key + device ID + app signature to the server on every session.
//   3. Trusts the server's answer — if the server says "invalid", the local cache
//      is cleared immediately.
//
// Server-side implementation (Node.js/Express example):
//   backend/server.js

import 'package:flutter/foundation.dart';
import 'integrity_checker.dart';

// ---------------------------------------------------------------------------
// Mock types — in a real project, use flutter_secure_storage + http/dio
// ---------------------------------------------------------------------------
class _SecureStorage {
  final Map<String, String> _store = {};
  Future<String?> read({required String key}) async => _store[key];
  Future<void> write({required String key, required String value}) async =>
      _store[key] = value;
  Future<void> delete({required String key}) async => _store.remove(key);
}

class _LicenseResponse {
  final bool isValid;
  final List<String> features;
  _LicenseResponse({required this.isValid, required this.features});
}

class _ApiClient {
  Future<_LicenseResponse> verifyLicense({
    required String licenseKey,
    required String deviceId,
    required String? appSignature,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate network
    return _LicenseResponse(isValid: true, features: ['trading', 'analytics']);
  }
}
// ---------------------------------------------------------------------------

class LicenseService {
  final _secureStorage = _SecureStorage();
  final _api = _ApiClient();

  /// Returns true when the current session has a valid, server-confirmed license.
  Future<bool> checkPremiumAccess() async {
    // Step 1: Check local cache — avoids network call if we have nothing stored
    final localLicense = await _secureStorage.read(key: 'license');
    if (localLicense == null) {
      debugPrint('LicenseService: no license found');
      return false;
    }

    // Step 2: Always verify with the server — this is the check that cannot
    //         be bypassed by patching the client binary.
    try {
      final signature = await IntegrityChecker.getSignatureHash();
      final response = await _api.verifyLicense(
        licenseKey: localLicense,
        deviceId: await _getDeviceId(),
        appSignature: signature,
      );

      if (!response.isValid) {
        // Trust the server: clear the locally cached license
        await _secureStorage.delete(key: 'license');
        debugPrint('LicenseService: server rejected license — cache cleared');
        return false;
      }

      debugPrint(
        'LicenseService: license valid, features=${response.features}',
      );
      return true;
    } catch (e) {
      // Network error — you can implement a grace period here instead of
      // immediately blocking, but be conservative with sensitive operations.
      debugPrint('LicenseService: network error — $e');
      return false;
    }
  }

  Future<String> _getDeviceId() async {
    // Use package:device_info_plus or package:flutter_device_id
    return 'device_placeholder_id';
  }
}
