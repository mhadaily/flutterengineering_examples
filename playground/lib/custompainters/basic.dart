import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'drawing.dart';

main() {
  debugRepaintRainbowEnabled = true;
  runApp(MaterialApp(
    title: 'CustomerPainterBasicHome',
    home: DrawingPage(),
  ));
}

class CustomerPainterBasicHome extends StatelessWidget {
  const CustomerPainterBasicHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomerPainterBasicHome'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: Sky(),
          // child: const Text('CustomerPainterBasicHome'),
        ),
      ),
    );
  }
}

class AwesomePainter extends CustomPainter {
  const AwesomePainter();

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) =>
      false;
}

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const RadialGradient gradient = RadialGradient(
      center: Alignment(0.7, -0.6),
      radius: 0.2,
      colors: <Color>[Color(0xFFFFFF00), Color(0xFF0099FF)],
      stops: <double>[0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      Rect rect = Offset.zero & size;
      final double width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9)
          .inscribe(Size(width, width), rect);
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRepaint(Sky oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}
