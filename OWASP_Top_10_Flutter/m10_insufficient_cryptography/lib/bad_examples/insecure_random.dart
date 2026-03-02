/// ❌ INSECURE: Non-secure random number generation.
///
/// `Random()` uses a predictable PRNG. If the seed is known or guessable
/// (e.g. derived from the timestamp), attackers can reproduce the sequence.
library;

import 'dart:math';

class InsecureRandomGenerator {
  /// WRONG: Default Random — predictable PRNG.
  static List<int> generateWeakBytes(int length) {
    final random = Random();
    return List.generate(length, (_) => random.nextInt(256));
  }

  /// WRONG: Same seed → same sequence every time.
  static List<int> generatePredictableBytes(int length) {
    final random = Random(12345);
    return List.generate(length, (_) => random.nextInt(256));
  }

  /// WRONG: Timestamp seed — attacker can narrow the search space.
  static List<int> generateTimestampBytes(int length) {
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    return List.generate(length, (_) => random.nextInt(256));
  }
}

/// Run all insecure-random demos and print output.
void demonstrateInsecureRandom() {
  print('--- Random() (non-secure) ---');
  final weak = InsecureRandomGenerator.generateWeakBytes(8);
  print('Weak bytes: $weak');
  print('');

  print('--- Random(12345) (fixed seed) ---');
  final pred1 = InsecureRandomGenerator.generatePredictableBytes(8);
  final pred2 = InsecureRandomGenerator.generatePredictableBytes(8);
  print('Run 1: $pred1');
  print('Run 2: $pred2');
  print('Identical? ${_listEquals(pred1, pred2)}');
  print('');

  print('--- Random(timestamp) ---');
  final ts = InsecureRandomGenerator.generateTimestampBytes(8);
  print('Timestamp-seeded: $ts');
  print('Attacker can guess seed from approximate time');
}

bool _listEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
