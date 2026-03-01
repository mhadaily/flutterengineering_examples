import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'bad_examples/api_config_bad.dart';
import 'bad_examples/license_checker_bad.dart';
import 'good_examples/app_integrity_service.dart';
import 'good_examples/anti_debug_service.dart';
import 'good_examples/binary_integrity_checker.dart';
import 'good_examples/integrity_checker.dart';
import 'good_examples/license_service.dart';
import 'good_examples/model_protection_service.dart';
import 'good_examples/native_secrets.dart';
import 'good_examples/root_detector.dart';
import 'good_examples/secure_config.dart';
import 'good_examples/security_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecurityService().initialize();
  runApp(const M7DemoApp());
}

class M7DemoApp extends StatelessWidget {
  const M7DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OWASP M7 - Binary Protection Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const DemoHome(),
    );
  }
}

class CheckResult {
  final String name;
  final String description;
  final bool? passed;
  final String detail;

  const CheckResult({
    required this.name,
    required this.description,
    this.passed,
    this.detail = '',
  });
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  final List<CheckResult> _results = [];
  bool _running = false;
  final _antiDebug = AntiDebugService();

  @override
  void dispose() {
    _antiDebug.stopMonitoring();
    super.dispose();
  }

  Future<void> _runAllChecks() async {
    setState(() {
      _running = true;
      _results.clear();
    });

    // 0a. BAD EXAMPLE — exposed LicenseChecker class (visible in libapp.so)
    //     The class name and method name are embedded verbatim without --obfuscate.
    //     Run: strings libapp.so | grep -i "LicenseChecker\|verifyPremium"
    //     Ghidra: Window → Defined Strings → filter 'LicenseChecker'
    final checker = LicenseChecker();
    final premiumResult = await checker.verifyPremium('demo_user');
    _add(CheckResult(
      name: '0a. ❌ LicenseChecker.verifyPremium (BAD EXAMPLE)',
      description:
          'Class & method names are plaintext strings in libapp.so when built without --obfuscate',
      passed: false,
      detail: 'verifyPremium returned: $premiumResult\n'
          'Visible in binary: strings libapp.so | grep -i LicenseChecker\n'
          'Ghidra: Window → Defined Strings → "LicenseChecker"',
    ));

    // 0b. BAD EXAMPLE — hardcoded secrets (visible in libapp.so)
    //    Run: strings libapp.so | grep -i "api\|key\|secret\|token"
    final badApiKey = ApiConfigBad.apiKey;
    final badToken = ApiConfigBad.secretToken;
    _add(CheckResult(
      name: '0b. ❌ Hardcoded secrets (BAD EXAMPLE)',
      description: 'Secrets embedded in Dart source → plaintext in libapp.so',
      passed: false,
      detail: 'apiKey="${badApiKey.substring(0, 8)}…"  '
          'secretToken="${badToken.substring(0, 8)}…"\n'
          'Extract with: strings libapp.so | grep -i "api|key|secret|token"',
    ));

    // 1. Build-time env config
    final key = SecureConfig.apiKey;
    _add(CheckResult(
      name: '1. Build-time env config',
      description: 'String.fromEnvironment("API_KEY")',
      passed: true,
      detail: key.isEmpty
          ? 'API_KEY not set. Build with --dart-define=API_KEY=xxx'
          : 'Key loaded (first 4 chars): ${key.substring(0, 4)}',
    ));

    // 2. Native secrets
    final nativeKey = await NativeSecrets.getApiKey();
    _add(CheckResult(
      name: '2. Native secrets (MethodChannel + C++ XOR)',
      description: 'Dart calls Kotlin which calls C++ XOR-decoded secret',
      passed: true,
      detail: nativeKey.isEmpty
          ? 'Empty (expected without native build - see SecretProvider.kt + secrets.cpp)'
          : 'Key received',
    ));

    // 3. Signature verification
    final sigValid = await IntegrityChecker.verifySignature();
    final sigHash = await IntegrityChecker.getSignatureHash();
    _add(CheckResult(
      name: '3. APK signature verification',
      description: 'Checks signing cert SHA-256 vs known release value',
      passed: sigValid,
      detail: sigHash ?? 'Not available (iOS or check failed)',
    ));

    // 4. Binary hash
    final binaryOk = await BinaryIntegrityChecker.verifyBinaryIntegrity();
    _add(CheckResult(
      name: '4. libapp.so hash check',
      description: 'SHA-256 of compiled Dart binary vs expected value',
      passed: binaryOk,
      detail: binaryOk
          ? 'Hash matches - binary not tampered'
          : 'Mismatch or placeholder hash still set in BinaryIntegrityChecker',
    ));

    // 5. Root / jailbreak
    final rooted = await RootDetector.isDeviceCompromised();
    _add(CheckResult(
      name: '5. Root / jailbreak detection',
      description: 'su paths, Magisk, test-keys build tag, root cloakers',
      passed: !rooted,
      detail: rooted ? 'Root/jailbreak indicators found!' : 'Clean device',
    ));

    // 6. Debugger / Frida
    final debugged = await AntiDebugService.isDebuggerAttached();
    _add(CheckResult(
      name: '6. Debugger / Frida detection',
      description: 'android.os.Debug + Frida port 27042 + /proc/self/maps',
      passed: !debugged,
      detail: debugged ? 'Debugger or Frida detected!' : 'No debugger/Frida found',
    ));

    // 7. AppIntegrityService
    final svc = AppIntegrityService();
    await svc.performFullCheck();
    _add(CheckResult(
      name: '7. AppIntegrityService (combined)',
      description: 'Signature + debugger + emulator + root in one service',
      passed: !svc.isCompromised,
      detail: svc.isCompromised
          ? 'Violations: ${svc.violations.map((v) => v.name).join(', ')}'
          : 'All sub-checks passed',
    ));

    // 8. Server-side license
    final licensed = await LicenseService().checkPremiumAccess();
    _add(CheckResult(
      name: '8. Server-side license check',
      description: 'License + device ID + app signature sent to backend',
      passed: true,
      detail: licensed
          ? 'License valid (mock server accepted)'
          : 'No license in storage (expected on first run)',
    ));

    // 9. Anti-debug monitor
    _antiDebug.startMonitoring(
      onDebuggerDetected: () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debugger attached - stopping sensitive ops'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
    _add(const CheckResult(
      name: '9. Anti-debug monitor (background)',
      description: 'Periodic check every 5s - SnackBar fires if triggered',
      passed: true,
      detail: 'Monitoring active. Attach Frida to see the alert.',
    ));

    // 10. Encrypted model loading
    try {
      await ModelProtectionService().loadProtectedModel(
        'assets/models/scoring.tflite.enc',
      );
      _add(const CheckResult(
        name: '10. Encrypted model loading',
        description: 'AES-256-GCM model decryption from assets',
        passed: true,
        detail: 'Model decrypted into memory successfully',
      ));
    } catch (e) {
      _add(CheckResult(
        name: '10. \u2139\uFE0F Encrypted model loading',
        description: 'AES-256-GCM model decryption from assets',
        // null = informational; no asset present in demo, not a real failure
        detail: 'No asset bundled (expected in demo).\n'
            'Add assets/models/scoring.tflite.enc to pubspec + assets/ to test.',
      ));
    }

    setState(() => _running = false);
  }

  void _add(CheckResult r) => setState(() => _results.add(r));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OWASP M7 - Binary Protection'),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: cs.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Binary Protection Examples',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kReleaseMode
                      ? 'All examples from the OWASP M7 blog article. Mode: RELEASE'
                      : 'All examples from the OWASP M7 blog article. Mode: DEBUG',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _results.isEmpty && !_running
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield_outlined, size: 56,
                            color: cs.primary.withValues(alpha: 0.35)),
                        const SizedBox(height: 12),
                        const Text('Tap the button to run all checks'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: _results.length + (_running ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (i == _results.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return ResultCard(result: _results[i]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _running ? null : _runAllChecks,
        icon: _running
            ? const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.security),
        label: Text(_running ? 'Running...' : 'Run All Checks'),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final CheckResult result;
  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final ok = result.passed;
    final color = ok == null
        ? Colors.grey
        : ok ? Colors.green[700]! : Colors.red[700]!;
    final icon = ok == null
        ? Icons.help_outline
        : ok ? Icons.check_circle_outline : Icons.cancel_outlined;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(result.description,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  if (result.detail.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(result.detail,
                        style: TextStyle(fontSize: 11, color: color)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
