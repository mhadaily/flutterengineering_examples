/// ❌ INSECURE: ECB mode pattern-leak demonstration.
///
/// ECB encrypts each 16-byte block independently, so identical plaintext blocks
/// produce identical ciphertext blocks — patterns are preserved.
library;

import 'package:encrypt/encrypt.dart' as encrypt;

/// Demonstrate that ECB mode produces identical ciphertext for identical blocks.
void demonstrateECBProblem() {
  final key = encrypt.Key.fromUtf8('0123456789012345');
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.ecb),
  );

  final block1 = encrypter.encrypt('AAAAAAAAAAAAAAAA').base64;
  final block2 = encrypter.encrypt('AAAAAAAAAAAAAAAA').base64;

  print('ECB block 1: $block1');
  print('ECB block 2: $block2');
  print('Identical?   ${block1 == block2}');
  print('⚠️ Identical plaintext blocks → identical ciphertext. Patterns preserved.');
}
