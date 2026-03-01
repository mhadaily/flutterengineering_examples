/// OWASP M8: Security Misconfiguration — Flutter Demo App
///
/// Run on a device/emulator to see each misconfiguration and its fix in action.
/// The app runs a series of checks and prints output to the console.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bad_examples/insecure_http_client.dart';
import 'bad_examples/insecure_logger.dart';
import 'bad_examples/insecure_storage.dart';
import 'good_examples/app_config.dart';
import 'good_examples/deep_link_handler.dart';
import 'good_examples/permission_service.dart';
import 'good_examples/secure_http_client.dart';
import 'good_examples/secure_logger.dart';
import 'good_examples/secure_storage_service.dart';
import 'good_examples/security_config_validator.dart';
import 'good_examples/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run runtime configuration validation on startup.
  SecurityConfigValidator.assertSecureConfiguration();

  runApp(const M8DemoApp());
}

class M8DemoApp extends StatelessWidget {
  const M8DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OWASP M8 – Security Misconfiguration Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD32F2F)),
        useMaterial3: true,
      ),
      home: const DemoHome(),
    );
  }
}

// ---------------------------------------------------------------------------
// A single result row shown in the UI
// ---------------------------------------------------------------------------
class CheckResult {
  final String name;
  final String description;
  final bool isBad;
  final String detail;

  const CheckResult({
    required this.name,
    required this.description,
    this.isBad = false,
    this.detail = '',
  });
}

// ---------------------------------------------------------------------------
// Home screen — list of demo cards
// ---------------------------------------------------------------------------
class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  final List<CheckResult> _results = [];
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M8: Security Misconfiguration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _results.isEmpty
          ? Center(
              child: _running
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Tap ▶ to run all demos.\n'
                      'Watch the debug console for full output.',
                      textAlign: TextAlign.center,
                    ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _results.length,
              itemBuilder: (_, i) => _buildCard(_results[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _running ? null : _runAllDemos,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildCard(CheckResult r) {
    return Card(
      color: r.isBad ? Colors.red.shade50 : Colors.green.shade50,
      child: ListTile(
        leading: Icon(
          r.isBad ? Icons.warning_amber_rounded : Icons.check_circle,
          color: r.isBad ? Colors.red : Colors.green,
        ),
        title: Text(r.name),
        subtitle: Text(r.description),
        trailing: r.detail.isNotEmpty
            ? Tooltip(
                message: r.detail,
                child: const Icon(Icons.info_outline),
              )
            : null,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Run every demo and collect results
  // -------------------------------------------------------------------------
  Future<void> _runAllDemos() async {
    setState(() {
      _running = true;
      _results.clear();
    });

    print('');
    print('═══════════════════════════════════════════════════════');
    print(' OWASP M8 — Security Misconfiguration Demo');
    print('═══════════════════════════════════════════════════════');
    print('');

    // 1. AppConfig — debug mode detection
    _section('1. Debug Mode Detection');
    AppConfig.validateReleaseConfiguration();
    _results.add(CheckResult(
      name: '1. Debug Mode Detection',
      description: kReleaseMode
          ? 'Release mode ✅'
          : 'Debug mode detected (expected in dev)',
      isBad: false,
      detail: 'API URL: ${AppConfig.apiBaseUrl}',
    ));

    // 2. BAD — insecure HTTP client
    _section('2. Insecure HTTP Client (BAD)');
    demonstrateInsecureClient();
    _results.add(const CheckResult(
      name: '2. Insecure HTTP Client (BAD)',
      description: 'Accepts ALL certificates — defeats TLS!',
      isBad: true,
    ));

    // 3. GOOD — secure HTTP client
    _section('3. Secure HTTP Client (GOOD)');
    final secureClient = SecureHttpClient.createSecureClient();
    secureClient.close();
    _results.add(const CheckResult(
      name: '3. Secure HTTP Client (GOOD)',
      description: 'Certificate pinning enabled.',
      isBad: false,
    ));

    // 4. BAD — insecure SharedPreferences storage
    _section('4. Insecure Storage (BAD)');
    final prefs = await SharedPreferences.getInstance();
    final insecureStore = InsecureStorage(prefs);
    await insecureStore.saveTokenInsecure('eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9');
    _results.add(const CheckResult(
      name: '4. SharedPreferences Token (BAD)',
      description: 'Auth token stored without encryption!',
      isBad: true,
    ));

    // 5. GOOD — secure storage
    _section('5. Secure Storage (GOOD)');
    final secureStorageSvc = SecureStorageService();
    await secureStorageSvc.saveAuthToken('eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9');
    await secureStorageSvc.getAuthToken();
    await secureStorageSvc.deleteAuthToken();
    _results.add(const CheckResult(
      name: '5. Secure Storage (GOOD)',
      description: 'Encrypted Keychain / EncryptedSharedPrefs.',
      isBad: false,
    ));

    // 6. GOOD — storage service (right tool for right job)
    _section('6. Storage Service — right tool for right job');
    const secureFS = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final storageSvc = StorageService(prefs, secureFS);
    await storageSvc.saveTokenSecure('refresh_token_xyz');
    await storageSvc.saveThemePreference(true);
    await storageSvc.saveLanguagePreference('en_US');
    _results.add(const CheckResult(
      name: '6. Storage Service (GOOD)',
      description: 'Secrets → secure, prefs → SharedPreferences.',
      isBad: false,
    ));

    // 7. BAD — insecure logging
    _section('7. Insecure Logger (BAD)');
    InsecureLogger.logLoginBad('user@example.com', 's3cretP@ss!');
    InsecureLogger.logApiKeyBad('sk-live-abc123xyz789');
    _results.add(const CheckResult(
      name: '7. Insecure Logger (BAD)',
      description: 'Logs email + password in plain text!',
      isBad: true,
    ));

    // 8. GOOD — secure logging
    _section('8. Secure Logger (GOOD)');
    SecureLogger.logLoginGood('majid@example.com');
    SecureLogger.log('User tapped checkout button');
    _results.add(const CheckResult(
      name: '8. Secure Logger (GOOD)',
      description: 'PII masked, only in debug mode.',
      isBad: false,
    ));

    // 9. Deep-link validation
    _section('9. Deep Link Validation');
    final dlHandler = DeepLinkHandler();
    dlHandler.handleDeepLink(
      Uri.parse('https://yourapp.com/product?id=abc-123'),
    );
    const traversalRaw = 'https://yourapp.com/../etc/passwd';
    dlHandler.handleDeepLink(
      Uri.parse(traversalRaw),
      rawLink: traversalRaw,
    );
    dlHandler.handleDeepLink(
      Uri.parse('https://evil.com/product?id=1'),
    );
    const xssRaw = 'https://yourapp.com/search?q=<script>alert(1)</script>';
    dlHandler.handleDeepLink(
      Uri.parse(xssRaw),
      rawLink: xssRaw,
    );
    _results.add(const CheckResult(
      name: '9. Deep Link Validation',
      description: 'Valid links accepted, malicious links rejected.',
      isBad: false,
    ));

    // 10. Runtime configuration validation
    _section('10. Runtime Configuration Validation');
    final issues = await SecurityConfigValidator.validateConfiguration();
    _results.add(CheckResult(
      name: '10. Runtime Config Validation',
      description: issues.isEmpty
          ? 'No critical issues found ✅'
          : '${issues.length} issue(s) found!',
      isBad: issues.isNotEmpty,
      detail: issues.join('; '),
    ));

    print('');
    print('═══════════════════════════════════════════════════════');
    print(' All demos complete — see cards above for summary.');
    print('═══════════════════════════════════════════════════════');

    setState(() => _running = false);
  }

  void _section(String title) {
    print('');
    print('── $title ${"─" * (55 - title.length)}');
  }
}
