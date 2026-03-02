/// GOOD EXAMPLE — Clear sensitive data from memory after use.
///
/// Dart strings are immutable, so we work with byte arrays that
/// can be zeroed out. This reduces the window during which secrets
/// are readable in a memory dump.
library;

import 'dart:typed_data';

class SecureMemory {
  /// Securely clear a byte array by overwriting with zeros.
  static Uint8List clearBytes(Uint8List data) {
    for (var i = 0; i < data.length; i++) {
      data[i] = 0;
    }
    return data;
  }
}

class SecureString {
  late Uint8List _data;
  bool _isCleared = false;

  SecureString(String value) {
    _data = Uint8List.fromList(value.codeUnits);
  }

  String get value {
    if (_isCleared) {
      throw StateError('SecureString has been cleared');
    }
    return String.fromCharCodes(_data);
  }

  bool get isCleared => _isCleared;

  void clear() {
    if (!_isCleared) {
      SecureMemory.clearBytes(_data);
      _isCleared = true;
    }
  }

  @override
  String toString() => _isCleared ? '[CLEARED]' : '[SecureString(${_data.length} bytes)]';
}

/// Demonstrate secure memory handling.
void demonstrateSecureMemory() {
  final password = SecureString('MyS3cretP@ss!');
  print('[SecureMemory] Created SecureString: $password');
  print('[SecureMemory] Value accessible: ${password.value.length} chars');

  // Simulate using the value for login…
  print('[SecureMemory] (simulating API login call…)');

  // Clear from memory immediately after use
  password.clear();
  print('[SecureMemory] After clear(): $password');

  // Attempting to read after clear throws
  try {
    password.value;
  } on StateError catch (e) {
    print('[SecureMemory] ✅ Access denied: $e');
  }
}
