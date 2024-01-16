import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double time = 0.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        time += 0.016;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/structure.glsl',
      (context, shader, child) {
        return Builder(builder: (context) {
          return CustomPaint(
            size: MediaQuery.sizeOf(context),
            painter: ShaderPainter(time: time, shader: shader),
          );
        });
      },
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader, required this.time});
  // 3
  final FragmentShader shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);

    final paint = Paint()..shader = shader;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) => true;
}
