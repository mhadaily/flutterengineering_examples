import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureDataService {
  final flutterSecureStorage = const FlutterSecureStorage();

  // 1. Derive a key from a password
  Future<encrypt.Key> deriveKey(
    String password,
    List<int> salt,
  ) async {
    // Argon2id is a password hashing algorithm
    // that is resistant to side-channel attacks
    final algorithm = Argon2id(
      parallelism: 4,
      memory: 10000, // 10 MB
      iterations: 3,
      hashLength: 32,
    );

    // Derive a key from the password
    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      // use salt a random bytes to make the key unique
      nonce: salt,
    );

    final secretKeyBytes = await secretKey.extractBytes();
    // get the key as a list of bytes
    return encrypt.Key(
      Uint8List.fromList(secretKeyBytes),
    );
  }

  // 2. Store the key in a secure storage for later use
  Future<void> storeSecretKey(encrypt.Key key, String keyName) async {
    await flutterSecureStorage.write(
      key: keyName,
      value: base64Encode(key.bytes),
    );
  }

  // 3. Retrieve the key from the secure storage when needed
  Future<encrypt.Key?> getSecretKey(String keyName) async {
    final keyString = await flutterSecureStorage.read(key: keyName);
    if (keyString == null) return null;
    return encrypt.Key(
      base64Decode(keyString),
    );
  }

  // 4. Generate a random salt
  List<int> generateSalt() {
    return encrypt.SecureRandom(16).bytes;
  }

  //5. Encrypt and decrypt data using the key you derived
  Future<String> encryptData(String data, encrypt.Key key) async {
    // IV Represents an Initialization Vector.
    final iv = encrypt.IV.fromLength(16);
    // Encrypter wraps an encrypt.Algorithm in a unique Container.
    // AES is a symmetric encryption algorithm
    // that uses the same key for both encryption and decryption
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key),
    );

    // Encrypt data using AES with the given key and IV
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  // 6. Decrypt data using the key you derived
  Future<String> decryptData(String encryptedData, encrypt.Key key) async {
    final iv = encrypt.IV.fromLength(16);
    // Encrypter wraps an encrypt.Algorithm in a unique Container.
    final encrypter = encrypt.Encrypter(
      // Same algorithm and key used for encryption
      encrypt.AES(key),
    );

    // Decrypt data using AES with the given key and IV
    return encrypter.decrypt64(encryptedData, iv: iv);
  }
}

void main() async {
  // ----------------------------------------
  final secureDataService = SecureDataService();
  // Imagine Password is provided by the user
  const password = 'userPassword';
  // Implement this to generate a random salt
  final salt = secureDataService.generateSalt();

  // Derive and store the key
  final key = await secureDataService.deriveKey(password, salt);
  await secureDataService.storeSecretKey(key, 'myEncryptionKey');
  // ----------------------------------------

  // ----------------------------------------
  // Encrypt data
  final encryptedData =
      await secureDataService.encryptData('Sensitive data', key);

  // Decrypt data
  final decryptedData = await secureDataService.decryptData(encryptedData, key);

  print('Encrypted Data: $encryptedData');
  print('Decrypted Data: $decryptedData');
  // ----------------------------------------
}
