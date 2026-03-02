/// GOOD EXAMPLE — Authentication repository using three-tier storage.
///
/// Access token  → standard   (short-lived)
/// Refresh token → biometric  (long-lived)
/// Banking creds → critical   (highest security)
library;

import 'comprehensive_storage_service.dart';

class AuthenticationRepository {
  final ComprehensiveStorageService _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _bankingCredentialsKey = 'banking_credentials';

  AuthenticationRepository(this._storage);

  /// Store tokens after successful login.
  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(
      key: _accessTokenKey,
      value: accessToken,
      sensitivity: StorageSensitivity.standard,
    );
    await _storage.write(
      key: _refreshTokenKey,
      value: refreshToken,
      sensitivity: StorageSensitivity.biometric,
    );
  }

  /// Get access token (for API calls).
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get refresh token (requires biometric).
  Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: _refreshTokenKey,
      sensitivity: StorageSensitivity.biometric,
    );
  }

  /// Store banking credentials (highest security).
  Future<void> storeBankingCredentials(BankingCredentials credentials) async {
    await _storage.writeObject(
      key: _bankingCredentialsKey,
      value: credentials,
      toJson: (c) => c.toJson(),
      sensitivity: StorageSensitivity.critical,
    );
  }

  /// Get banking credentials (requires biometrics).
  Future<BankingCredentials?> getBankingCredentials() async {
    return await _storage.readObject(
      key: _bankingCredentialsKey,
      fromJson: BankingCredentials.fromJson,
      sensitivity: StorageSensitivity.critical,
    );
  }

  /// Clear all on logout.
  Future<void> logout() async {
    await _storage.clearAll();
  }
}

class BankingCredentials {
  final String accountNumber;
  final String routingNumber;
  final DateTime lastAccessed;

  BankingCredentials({
    required this.accountNumber,
    required this.routingNumber,
    required this.lastAccessed,
  });

  Map<String, dynamic> toJson() => {
        'accountNumber': accountNumber,
        'routingNumber': routingNumber,
        'lastAccessed': lastAccessed.toIso8601String(),
      };

  factory BankingCredentials.fromJson(Map<String, dynamic> json) {
    return BankingCredentials(
      accountNumber: json['accountNumber'] as String,
      routingNumber: json['routingNumber'] as String,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
    );
  }
}
