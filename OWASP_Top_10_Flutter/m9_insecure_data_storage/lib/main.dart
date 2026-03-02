/// M9 Insecure Data Storage — interactive demo runner.
///
/// Runs all bad and good examples side-by-side so you can see the
/// console output from each pattern.
library;

import 'package:flutter/material.dart';

import 'bad_examples/insecure_storage.dart';
import 'bad_examples/insecure_file_storage.dart';
import 'bad_examples/insecure_database.dart';
import 'bad_examples/insecure_logger.dart';

import 'good_examples/secure_database.dart';
import 'good_examples/secure_file_storage.dart';
import 'good_examples/secure_logger.dart';
import 'good_examples/secure_memory.dart';
import 'good_examples/security_service.dart';

void main() => runApp(const M9DemoApp());

class M9DemoApp extends StatelessWidget {
  const M9DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M9 Insecure Data Storage',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class _DemoItem {
  final String title;
  final String subtitle;
  final bool isBad;
  final VoidCallback action;

  const _DemoItem({
    required this.title,
    required this.subtitle,
    required this.isBad,
    required this.action,
  });
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  late final List<_DemoItem> _demos;

  @override
  void initState() {
    super.initState();
    _demos = [
      // --- BAD examples ---
      _DemoItem(
        title: '1. BAD — SharedPreferences',
        subtitle: 'Credentials stored in plain text',
        isBad: true,
        action: demonstrateInsecureStorage,
      ),
      _DemoItem(
        title: '2. BAD — Plain JSON files',
        subtitle: 'PII & medical data unencrypted',
        isBad: true,
        action: () => InsecureFileStorage().demonstrateInsecureFileStorage(),
      ),
      _DemoItem(
        title: '3. BAD — Unencrypted SQLite',
        subtitle: 'Database readable with any viewer',
        isBad: true,
        action: () => InsecureDatabase().demonstrateInsecureDatabase(),
      ),
      _DemoItem(
        title: '4. BAD — Logging credentials',
        subtitle: 'Passwords & tokens in console',
        isBad: true,
        action: () {
          InsecureLogger.logLoginBad('user@example.com', 's3cretP@ss!');
          InsecureLogger.logTokenBad('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkw.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U');
          InsecureLogger.logApiKeyBad('sk-live-abc123xyz789');
          InsecureLogger.logUserDataBad({
            'email': 'user@example.com',
            'ssn': '123-45-6789',
            'password': 'secret123',
          });
        },
      ),

      // --- GOOD examples ---
      _DemoItem(
        title: '5. GOOD — Encrypted database',
        subtitle: 'SQLCipher with Keystore-backed key',
        isBad: false,
        action: () => SecureDatabase().demonstrateSecureDatabase(),
      ),
      _DemoItem(
        title: '6. GOOD — AES-GCM file encryption',
        subtitle: 'Encrypted files + secure delete',
        isBad: false,
        action: () {
          final fs = SecureFileStorage();
          fs.demonstrateEncryptedFileStorage();
          print('');
          fs.demonstrateSecureDelete();
        },
      ),
      _DemoItem(
        title: '7. GOOD — Secure logger',
        subtitle: 'Auto-redacts JWTs, cards, SSNs',
        isBad: false,
        action: () {
          print('[SecureLogger] Input with sensitive data:');
          const input =
              'User login: email=user@example.com, '
              'password=secret123, '
              'token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkw.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U, '
              'card=4111-1111-1111-1111, '
              'ssn=123-45-6789';
          print('[SecureLogger]   Raw : $input');
          final sanitized = SecureLogger.sanitize(input);
          print('[SecureLogger]   Safe: $sanitized');
          print('');
          print('[SecureLogger] Map sanitization:');
          final data = {
            'email': 'user@example.com',
            'password': 'secret123',
            'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkw.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U',
          };
          final sanitizedData = SecureLogger.sanitizeObject(data);
          print('[SecureLogger]   Raw : $data');
          print('[SecureLogger]   Safe: $sanitizedData');
        },
      ),
      _DemoItem(
        title: '8. GOOD — Secure memory',
        subtitle: 'SecureString zeroed after use',
        isBad: false,
        action: demonstrateSecureMemory,
      ),
      _DemoItem(
        title: '9. GOOD — Security checks',
        subtitle: 'Root/jailbreak detection + response',
        isBad: false,
        action: () => SecurityService().demonstrateSecurityChecks(),
      ),
    ];
  }

  void _runAll() {
    print('');
    print('═══════════════════════════════════════════════════════');
    print(' M9 Insecure Data Storage — Full Demo Run');
    print('═══════════════════════════════════════════════════════');
    for (final demo in _demos) {
      print('');
      print('── ${demo.title} ${'─' * (50 - demo.title.length)}');
      demo.action();
    }
    print('');
    print('═══════════════════════════════════════════════════════');
    print(' Demo complete.');
    print('═══════════════════════════════════════════════════════');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('M9 — Insecure Data Storage')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _demos.length,
        itemBuilder: (context, index) {
          final demo = _demos[index];
          return Card(
            color: demo.isBad
                ? Colors.red.shade50
                : Colors.green.shade50,
            child: ListTile(
              leading: Icon(
                demo.isBad ? Icons.warning_amber : Icons.check_circle,
                color: demo.isBad ? Colors.red : Colors.green,
              ),
              title: Text(demo.title),
              subtitle: Text(demo.subtitle),
              onTap: () {
                print('');
                print('── ${demo.title} ${'─' * (50 - demo.title.length)}');
                demo.action();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _runAll,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Run All'),
      ),
    );
  }
}
