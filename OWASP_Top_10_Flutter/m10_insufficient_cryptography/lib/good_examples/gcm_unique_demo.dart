/// ✅ SECURE: Demonstrate that AES-GCM produces different ciphertext for the
/// same plaintext (unique nonce each time) — the secure counterpart to ECB.
library;

import 'dart:convert';
import 'package:cryptography/cryptography.dart';

/// Show that identical plaintext encrypted twice with GCM yields different
/// ciphertexts (unlike ECB).
Future<void> demonstrateGcmUniqueCiphertexts() async {
  final algorithm = AesGcm.with256bits();
  final secretKey = await algorithm.newSecretKey();

  final plaintext = utf8.encode('AAAAAAAAAAAAAAAA');

  final box1 = await algorithm.encrypt(plaintext, secretKey: secretKey);
  final box2 = await algorithm.encrypt(plaintext, secretKey: secretKey);

  print('GCM cipher 1: ${base64Encode(box1.cipherText)}');
  print('GCM cipher 2: ${base64Encode(box2.cipherText)}');
  print('Different?    ${base64Encode(box1.cipherText) != base64Encode(box2.cipherText)}');
  print('✅ Same plaintext, different ciphertext each time. Patterns hidden.');
}
