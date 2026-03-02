/// BAD EXAMPLE — Unencrypted SQLite database.
///
/// Without SQLCipher or similar encryption, the database file at
/// `/data/data/<pkg>/databases/user_data.db` can be opened with
/// any SQLite viewer.
library;

class InsecureDatabase {
  /// Demonstrates the vulnerability: sensitive columns in plain SQLite.
  void demonstrateInsecureDatabase() {
    print('[BAD] Unencrypted SQLite database:');
    print('[BAD]   Path: /data/data/<pkg>/databases/user_data.db');
    print('[BAD]');
    print('[BAD]   CREATE TABLE users (');
    print('[BAD]     id INTEGER PRIMARY KEY,');
    print('[BAD]     username TEXT,');
    print('[BAD]     password_hash TEXT,   -- still sensitive!');
    print('[BAD]     ssn TEXT,             -- DANGER: Plaintext SSN');
    print('[BAD]     credit_score INTEGER,');
    print('[BAD]     bank_account TEXT');
    print('[BAD]   );');
    print('[BAD]');
    print('[BAD]   Example row an attacker extracts:');
    print('[BAD]   | john_doe | \$2b\$10\$Kx... | 123-45-6789 | 750 | 9876543210 |');
    print('[BAD]');
    print('[BAD] ⚠️  Database file readable with: sqlite3 user_data.db ".dump"');
  }
}
