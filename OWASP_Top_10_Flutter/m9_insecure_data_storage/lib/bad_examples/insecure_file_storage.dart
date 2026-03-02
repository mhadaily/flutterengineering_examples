/// BAD EXAMPLE — Storing sensitive files without encryption.
///
/// Writing plain JSON with PII, medical records, or financial data
/// to the documents directory is trivially readable on compromised devices.
library;

import 'dart:convert';

class InsecureFileStorage {
  /// Demonstrates the vulnerability: sensitive data written as plain JSON.
  void demonstrateInsecureFileStorage() {
    final profile = {
      'name': 'John Doe',
      'ssn': '123-45-6789',
      'dob': '1990-01-15',
      'address': '123 Main St, Springfield',
    };

    final medicalRecords = [
      {'diagnosis': 'Type 2 Diabetes', 'medication': 'Metformin 500mg'},
      {'diagnosis': 'Hypertension', 'medication': 'Lisinopril 10mg'},
    ];

    print('[BAD] Writing user profile as PLAIN JSON (no encryption):');
    print('[BAD]   File: <documents>/user_profile.json');
    print('[BAD]   Content:');
    const encoder = JsonEncoder.withIndent('  ');
    for (final line in encoder.convert(profile).split('\n')) {
      print('[BAD]     $line');
    }

    print('[BAD]');
    print('[BAD] Writing medical records as PLAIN JSON (no encryption):');
    print('[BAD]   File: <documents>/medical_records.json');
    print('[BAD]   Content:');
    for (final line in encoder.convert(medicalRecords).split('\n')) {
      print('[BAD]     $line');
    }
    print('[BAD]');
    print('[BAD] ⚠️  Anyone with device access can read this data!');
  }
}
