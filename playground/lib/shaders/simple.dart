import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

main() {
  runApp(const MaterialApp(
    home: ShaderAdvancedPage(),
  ));
}

class ShaderAdvancedPage extends StatefulWidget {
  const ShaderAdvancedPage({super.key});

  @override
  State<ShaderAdvancedPage> createState() => _SnowPageState();
}

class _SnowPageState extends State<ShaderAdvancedPage> {
  int count = 0;

  double time = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time += 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/structure.glsl',
      (context, shader, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ShaderPainter(time, shader: shader),
        );
      },
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter(this.time, {required this.shader});

  final FragmentShader shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}
