import 'package:flutter/material.dart';

//  final m = Flex();

class DrawingPage extends StatelessWidget {
  final pointsListenable = ValueNotifier<List<Offset>>([]);

  DrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DrawingPage'),
      ),
      body: GestureDetector(
        onPanStart: (details) => pointsListenable.value = [
          ...pointsListenable.value,
          details.localPosition
        ],
        onPanUpdate: (DragUpdateDetails details) {
          pointsListenable.value = [
            ...pointsListenable.value,
            details.localPosition
          ];
        },
        onPanEnd: (DragEndDetails details) {
          pointsListenable.value = [
            ...pointsListenable.value,
            Offset.infinite
          ];
        },
        child: RepaintBoundary(
          child: CustomPaint(
            painter: DrawingPainter(pointsListenable),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  ValueNotifier<List<Offset>> points;

  DrawingPainter(this.points) : super(repaint: points);

  final pencil = Paint()
    ..color = Colors.black
    ..strokeWidth = 4
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.value.length - 1; i++) {
      canvas.drawLine(
          points.value[i], points.value[i + 1], pencil);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) =>
      oldDelegate.points != points;

  @override
  bool shouldRebuildSemantics(DrawingPainter oldDelegate) =>
      false;

  @override
  bool? hitTest(Offset position) {
    return super.hitTest(position);
  }
}
