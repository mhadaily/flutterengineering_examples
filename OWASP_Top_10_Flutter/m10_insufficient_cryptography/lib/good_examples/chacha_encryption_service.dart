/// ✅ SECURE: ChaCha20-Poly1305 authenticated encryption.
///
/// Excellent alternative to AES-GCM, especially on devices without hardware
/// AES acceleration. Also used in TLS 1.3 and WireGuard.
library;

import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class ChaChaEncryptionService {
  final _algorithm = Chacha20.poly1305Aead();

  Future<SecretBox> encrypt(
    List<int> plaintext,
    SecretKey secretKey, {
    List<int>? aad,
  }) async {
    return await _algorithm.encrypt(
      plaintext,
      secretKey: secretKey,
      aad: aad ?? [],
    );
  }

  Future<List<int>> decrypt(
    SecretBox secretBox,
    SecretKey secretKey, {
    List<int>? aad,
  }) async {
    return await _algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
      aad: aad ?? [],
    );
  }

  Future<SecretKey> generateKey() async {
    return await _algorithm.newSecretKey();
  }
}

/// Pure-Dart demo: encrypt → decrypt round-trip with ChaCha20-Poly1305.
Future<void> demonstrateChaCha20() async {
  final service = ChaChaEncryptionService();
  final key = await service.generateKey();

  final plaintext = 'ChaCha20-Poly1305 is fast on mobile!';
  final box = await service.encrypt(utf8.encode(plaintext), key);

  print('Plaintext:  $plaintext');
  print('Nonce:      ${base64Encode(box.nonce)} (${box.nonce.length} bytes)');
  print('Ciphertext: ${base64Encode(box.cipherText).substring(0, 30)}… (${box.cipherText.length} bytes)');
  print('MAC:        ${base64Encode(box.mac.bytes)} (${box.mac.bytes.length} bytes)');

  final decrypted = await service.decrypt(box, key);
  print('Decrypted:  ${utf8.decode(decrypted)}');
}
