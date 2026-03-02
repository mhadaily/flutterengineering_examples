/// ✅ SECURE: Complete key management service with rotation, expiration, and
/// secure deletion. Platform-channel dependent (FlutterSecureStorage).
library;

import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Define clear purposes for keys.
enum KeyPurpose { encryption, signing, authentication }

class KeyInfo {
  final String id;
  final KeyPurpose purpose;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final int version;

  KeyInfo({
    required this.id,
    required this.purpose,
    required this.createdAt,
    this.expiresAt,
    this.version = 1,
  });

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  Map<String, dynamic> toJson() => {
        'id': id,
        'purpose': purpose.name,
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'version': version,
      };

  factory KeyInfo.fromJson(Map<String, dynamic> json) => KeyInfo(
        id: json['id'] as String,
        purpose: KeyPurpose.values.byName(json['purpose'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
        version: json['version'] as int? ?? 1,
      );
}

class KeyManagementService {
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.passcode),
  );

  static const _keyPrefix = 'crypto_key_';
  static const _keyInfoPrefix = 'crypto_key_info_';

  /// Generate and store a new AES-256 key.
  Future<KeyInfo> generateEncryptionKey({
    String? customId,
    Duration? validFor,
  }) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKey();
    final keyId = customId ?? _generateKeyId();
    final keyInfo = KeyInfo(
      id: keyId,
      purpose: KeyPurpose.encryption,
      createdAt: DateTime.now(),
      expiresAt: validFor != null ? DateTime.now().add(validFor) : null,
    );

    final keyBytes = await secretKey.extractBytes();
    await _secureStorage.write(
      key: '$_keyPrefix$keyId',
      value: base64Encode(keyBytes),
    );
    await _secureStorage.write(
      key: '$_keyInfoPrefix$keyId',
      value: jsonEncode(keyInfo.toJson()),
    );

    return keyInfo;
  }

  Future<SecretKey?> getKey(String keyId) async {
    final keyInfo = await getKeyInfo(keyId);
    if (keyInfo == null || keyInfo.isExpired) return null;

    final keyBase64 = await _secureStorage.read(key: '$_keyPrefix$keyId');
    if (keyBase64 == null) return null;
    return SecretKey(base64Decode(keyBase64));
  }

  Future<KeyInfo?> getKeyInfo(String keyId) async {
    final infoJson = await _secureStorage.read(key: '$_keyInfoPrefix$keyId');
    if (infoJson == null) return null;
    return KeyInfo.fromJson(jsonDecode(infoJson) as Map<String, dynamic>);
  }

  /// Rotate a key — create new version, archive old.
  Future<KeyInfo> rotateKey(String keyId) async {
    final oldKeyInfo = await getKeyInfo(keyId);
    if (oldKeyInfo == null) throw StateError('Key not found: $keyId');

    final algorithm = AesGcm.with256bits();
    final newSecretKey = await algorithm.newSecretKey();

    final newKeyInfo = KeyInfo(
      id: keyId,
      purpose: oldKeyInfo.purpose,
      createdAt: DateTime.now(),
      expiresAt: oldKeyInfo.expiresAt,
      version: oldKeyInfo.version + 1,
    );

    final oldKeyBase64 = await _secureStorage.read(key: '$_keyPrefix$keyId');
    if (oldKeyBase64 != null) {
      await _secureStorage.write(
        key: '${_keyPrefix}${keyId}_v${oldKeyInfo.version}',
        value: oldKeyBase64,
      );
    }

    final keyBytes = await newSecretKey.extractBytes();
    await _secureStorage.write(
      key: '$_keyPrefix$keyId',
      value: base64Encode(keyBytes),
    );
    await _secureStorage.write(
      key: '$_keyInfoPrefix$keyId',
      value: jsonEncode(newKeyInfo.toJson()),
    );

    return newKeyInfo;
  }

  /// Delete a key and all archived versions.
  Future<void> deleteKey(String keyId) async {
    await _secureStorage.delete(key: '$_keyPrefix$keyId');
    await _secureStorage.delete(key: '$_keyInfoPrefix$keyId');

    for (var v = 1; v < 100; v++) {
      final versionKey = '${_keyPrefix}${keyId}_v$v';
      if (await _secureStorage.containsKey(key: versionKey)) {
        await _secureStorage.delete(key: versionKey);
      } else {
        break;
      }
    }
  }

  Future<List<KeyInfo>> listKeys() async {
    final allKeys = await _secureStorage.readAll();
    final keyInfos = <KeyInfo>[];

    for (final entry in allKeys.entries) {
      if (entry.key.startsWith(_keyInfoPrefix)) {
        try {
          keyInfos.add(
            KeyInfo.fromJson(jsonDecode(entry.value) as Map<String, dynamic>),
          );
        } catch (_) {}
      }
    }
    return keyInfos;
  }

  String _generateKeyId() {
    final random = Random.secure();
    final bytes = List.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}

/// Pure-Dart demo: simulate key lifecycle (without platform storage).
void demonstrateKeyManagement() {
  // We can't call FlutterSecureStorage in tests. Show the lifecycle logic.
  final now = DateTime.now();

  final keyInfo = KeyInfo(
    id: 'demo-key-001',
    purpose: KeyPurpose.encryption,
    createdAt: now,
    expiresAt: now.add(const Duration(days: 90)),
    version: 1,
  );

  print('Key ID:      ${keyInfo.id}');
  print('Purpose:     ${keyInfo.purpose.name}');
  print('Created:     ${keyInfo.createdAt.toIso8601String()}');
  print('Expires:     ${keyInfo.expiresAt?.toIso8601String()}');
  print('Version:     ${keyInfo.version}');
  print('Is expired:  ${keyInfo.isExpired}');

  // Simulate rotation
  final rotated = KeyInfo(
    id: keyInfo.id,
    purpose: keyInfo.purpose,
    createdAt: DateTime.now(),
    expiresAt: keyInfo.expiresAt,
    version: keyInfo.version + 1,
  );

  print('');
  print('After rotation:');
  print('Version:     ${rotated.version}');
  print('Is expired:  ${rotated.isExpired}');

  // Simulate expired key
  final expired = KeyInfo(
    id: 'old-key',
    purpose: KeyPurpose.encryption,
    createdAt: now.subtract(const Duration(days: 365)),
    expiresAt: now.subtract(const Duration(days: 1)),
    version: 1,
  );
  print('');
  print('Expired key "${expired.id}" → isExpired: ${expired.isExpired}');
}
