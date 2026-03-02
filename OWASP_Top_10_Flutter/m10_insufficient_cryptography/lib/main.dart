import 'package:flutter/material.dart';

// Bad examples (synchronous demos)
import 'bad_examples/insecure_crypto.dart';
import 'bad_examples/ecb_mode_demo.dart';
import 'bad_examples/insecure_random.dart';
import 'bad_examples/weak_password_hashing.dart';

// Good examples (some async)
import 'good_examples/secure_encryption_service.dart';
import 'good_examples/chacha_encryption_service.dart';
import 'good_examples/secure_password_hasher.dart';
import 'good_examples/pbkdf2_password_hasher.dart';
import 'good_examples/secure_key_generator.dart';
import 'good_examples/key_management_service.dart';
import 'good_examples/signature_service.dart';
import 'good_examples/secure_random_generator.dart';
import 'good_examples/constant_time_comparison.dart';
import 'good_examples/gcm_unique_demo.dart';

void main() => runApp(const M10DemoApp());

class M10DemoApp extends StatelessWidget {
  const M10DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OWASP M10 — Insufficient Cryptography',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const _DemoListPage(),
    );
  }
}

typedef _DemoFn = Future<void> Function();

class _DemoItem {
  final String title;
  final String subtitle;
  final bool isBad;
  final _DemoFn run;

  const _DemoItem({
    required this.title,
    required this.subtitle,
    required this.isBad,
    required this.run,
  });
}

class _DemoListPage extends StatelessWidget {
  const _DemoListPage();

  static final _demos = <_DemoItem>[
    // ── Bad examples ─────────────────────────────────────────
    _DemoItem(
      title: 'Common Crypto Mistakes',
      subtitle: 'Hardcoded key, ECB, static IV, SHA-256 password…',
      isBad: true,
      run: () async => demonstrateInsecureCrypto(),
    ),
    _DemoItem(
      title: 'ECB Pattern Leak',
      subtitle: 'Identical blocks → identical ciphertext',
      isBad: true,
      run: () async => demonstrateECBProblem(),
    ),
    _DemoItem(
      title: 'Insecure Random',
      subtitle: 'Random() is predictable',
      isBad: true,
      run: () async => demonstrateInsecureRandom(),
    ),
    _DemoItem(
      title: 'Weak Password Hashing',
      subtitle: 'SHA-256 for passwords — too fast',
      isBad: true,
      run: () async => demonstrateWeakPasswordHashing(),
    ),

    // ── Good examples ────────────────────────────────────────
    _DemoItem(
      title: 'AES-256-GCM Encrypt/Decrypt',
      subtitle: 'Authenticated encryption with tamper detection',
      isBad: false,
      run: () => demonstrateAesGcm(),
    ),
    _DemoItem(
      title: 'ChaCha20-Poly1305',
      subtitle: 'Fast AEAD alternative to AES-GCM',
      isBad: false,
      run: () => demonstrateChaCha20(),
    ),
    _DemoItem(
      title: 'Argon2id Password Hashing',
      subtitle: 'Memory-hard password KDF',
      isBad: false,
      run: () => demonstrateArgon2id(),
    ),
    _DemoItem(
      title: 'PBKDF2-SHA256 Hashing',
      subtitle: '310 000 iterations',
      isBad: false,
      run: () => demonstratePbkdf2(),
    ),
    _DemoItem(
      title: 'Key Generation & HKDF',
      subtitle: 'AES key, Ed25519, HKDF sub-keys',
      isBad: false,
      run: () => demonstrateKeyGeneration(),
    ),
    _DemoItem(
      title: 'Key Management Lifecycle',
      subtitle: 'Create, rotate, expire, delete',
      isBad: false,
      run: () async => demonstrateKeyManagement(),
    ),
    _DemoItem(
      title: 'Ed25519 Signatures',
      subtitle: 'Sign & verify messages',
      isBad: false,
      run: () => demonstrateSignatures(),
    ),
    _DemoItem(
      title: 'Secure Random',
      subtitle: 'Random.secure() for keys, nonces, salts',
      isBad: false,
      run: () async => demonstrateSecureRandom(),
    ),
    _DemoItem(
      title: 'Constant-Time Comparison',
      subtitle: 'Timing-attack resistant equality',
      isBad: false,
      run: () async => demonstrateConstantTimeComparison(),
    ),
    _DemoItem(
      title: 'GCM Unique Ciphertexts',
      subtitle: 'Same plaintext → different ciphertext',
      isBad: false,
      run: () => demonstrateGcmUniqueCiphertexts(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('M10 — Insufficient Cryptography')),
      body: ListView.separated(
        itemCount: _demos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final d = _demos[i];
          return ListTile(
            leading: Icon(
              d.isBad ? Icons.warning_amber_rounded : Icons.verified_rounded,
              color: d.isBad ? Colors.red : Colors.green,
            ),
            title: Text(d.title),
            subtitle: Text(d.subtitle),
            onTap: () async {
              print('\n════════════════════════════════════════');
              print('  ${d.isBad ? "❌ BAD" : "✅ GOOD"}: ${d.title}');
              print('════════════════════════════════════════');
              await d.run();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Run All'),
        icon: const Icon(Icons.play_arrow),
        onPressed: () async {
          for (final d in _demos) {
            print('\n════════════════════════════════════════');
            print('  ${d.isBad ? "❌ BAD" : "✅ GOOD"}: ${d.title}');
            print('════════════════════════════════════════');
            await d.run();
          }
        },
      ),
    );
  }
}
