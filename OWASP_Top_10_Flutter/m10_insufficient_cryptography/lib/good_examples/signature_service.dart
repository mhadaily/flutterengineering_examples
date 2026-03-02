/// ✅ SECURE: Ed25519 digital signatures — sign and verify messages.
library;

import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class SignatureService {
  final _algorithm = Ed25519();

  Future<SimpleKeyPair> generateKeyPair() async {
    return await _algorithm.newKeyPair();
  }

  Future<Signature> sign(
    List<int> data,
    SimpleKeyPair keyPair,
  ) async {
    return await _algorithm.sign(data, keyPair: keyPair);
  }

  Future<bool> verify(
    List<int> data,
    Signature signature,
  ) async {
    return await _algorithm.verify(data, signature: signature);
  }

  Future<String> signMessage(
    String message,
    SimpleKeyPair keyPair,
  ) async {
    final messageBytes = utf8.encode(message);
    final signature = await sign(messageBytes, keyPair);
    return base64Encode(signature.bytes);
  }

  Future<bool> verifyMessage(
    String message,
    String signatureBase64,
    SimplePublicKey publicKey,
  ) async {
    try {
      final messageBytes = utf8.encode(message);
      final signatureBytes = base64Decode(signatureBase64);
      final signature = Signature(signatureBytes, publicKey: publicKey);
      return await verify(messageBytes, signature);
    } catch (e) {
      return false;
    }
  }
}

/// Pure-Dart demo: sign, verify, and tamper-detect with Ed25519.
Future<void> demonstrateSignatures() async {
  final service = SignatureService();
  final keyPair = await service.generateKeyPair();
  final publicKey = await keyPair.extractPublicKey();

  final message = 'Transfer \$500 to account 12345';
  final sigB64 = await service.signMessage(message, keyPair);
  print('Message:    $message');
  print('Signature:  ${sigB64.substring(0, 40)}… (${base64Decode(sigB64).length} bytes)');
  print('Public key: ${base64Encode(publicKey.bytes)} (${publicKey.bytes.length} bytes)');
  print('');

  final valid = await service.verifyMessage(message, sigB64, publicKey);
  print('Verify original: $valid');

  final tampered = await service.verifyMessage(
    'Transfer \$5000 to account 12345', // changed amount
    sigB64,
    publicKey,
  );
  print('Verify tampered: $tampered');
}
