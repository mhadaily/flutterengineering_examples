import 'dart:ui';
import 'package:flutter/material.dart';

void main() async {
  // 1
  final fragmentProgram = await FragmentProgram.fromAsset(
    'shaders/simple.frag',
  );
  // 2
  runApp(MyApp(shader: fragmentProgram.fragmentShader()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.shader});

  // 3
  final FragmentShader shader;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shader Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: MyHomePage(shader: shader),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.shader,
  });

  final FragmentShader shader;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Shader Demo'),
      ),
      // 4
      body: CustomPaint(
        size: MediaQuery.sizeOf(context),
        // 5
        painter: ShaderPainter(shader: shader),
      ),
    );
  }
}

// 5
class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader});
  // 6
  final FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    // 7
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    // 8
    final paint = Paint()..shader = shader;

    // 9
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
