// lib/main.dart
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'FFIgen/hello_world_bindings.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  MyApp({super.key});

  final nativeLibrary = NativeLibrary(
    DynamicLibrary.open(
      Platform.isMacOS ? 'libhello_world.dylib' : '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final helloWorld = nativeLibrary.hello_world();
    // Convert the Pointer<Char> to a Dart String
    final String stringHelloWorld =
        helloWorld.cast<Utf8>().toDartString();

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child:
              Text('lib.hello_world(): $stringHelloWorld'),
        ),
      ),
    );
  }
}
