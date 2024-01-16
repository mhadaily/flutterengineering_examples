import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encryptPackage;

class SafeContentDisplay extends StatelessWidget {
  final String userContent;

  const SafeContentDisplay({super.key, required this.userContent});

  @override
  Widget build(BuildContext context) {
    // Encoding user content to prevent XSS
    const htmlEscape = HtmlEscape(HtmlEscapeMode.attribute);
    final safeContent = htmlEscape.convert(userContent);

    return Text(safeContent);
  }
}

Future<http.Response> fetchData(String url) async {
  // Ensure the URL uses HTTPS
  final uri = Uri.parse(url).replace(scheme: 'https');
  return await http.get(uri);
}

class EncryptionService {
  // Replace with a secure key either using secure-random or receive from the backend
  final key = encryptPackage.Key.fromUtf8(
    'dmzoGLq72Z9xj+BVdNQNjM8glbkGqNXmHCmD7CLlfcY=',
  );
  final iv = encryptPackage.IV.fromLength(16);

  String encrypt(String plainText) {
    final encrypter = encryptPackage.Encrypter(encryptPackage.AES(key));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decrypt(String encryptedText) {
    final encrypter = encryptPackage.Encrypter(encryptPackage.AES(key));
    return encrypter.decrypt64(encryptedText, iv: iv);
  }
}
