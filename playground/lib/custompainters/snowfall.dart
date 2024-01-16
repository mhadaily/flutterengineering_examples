import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        home: Scaffold(
          body: SnowFlakePage(),
        ),
      ),
    );

class SnowFlakePage extends StatefulWidget {
  const SnowFlakePage({super.key});

  @override
  SnowFlakePageState createState() => SnowFlakePageState();
}

class SnowFlakePageState extends State<SnowFlakePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool withVerticesRaw = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snowfall'),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  withVerticesRaw = !withVerticesRaw;
                });
              },
              child: Text(
                withVerticesRaw
                    ? 'Disable Vertices Raw'
                    : 'Enable Vertices Raw',
              )),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
      body: !withVerticesRaw
          ? RepaintBoundary(
              child: CustomPaint(
                isComplex: true,
                willChange: true,
                painter: SnowFlakePainterStandard(
                  _controller,
                  MediaQuery.sizeOf(context),
                ),
                child: const SizedBox.expand(),
              ),
            )
          : RepaintBoundary(
              child: CustomPaint(
                isComplex: true,
                willChange: true,
                painter: SnowFlakePainter(
                  _controller,
                  MediaQuery.sizeOf(context),
                ),
                child: const SizedBox.expand(),
              ),
            ),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1
      ..isAntiAlias = true;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      50,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SnowFlakePainter extends CustomPainter {
  final Animation<double> animation;
  final Size _size;
  final List<Offset> _snowflakes = [];
  final List<double> _radii = [];
  final List<double> _velocities = [];
  final Random _random = Random();

  final Paint pencil = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 1
    ..isAntiAlias = true;

  SnowFlakePainter(this.animation, this._size) : super(repaint: animation) {
    _initializeSnowflakes();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // ChartPainter().paint(canvas, size);
    _updateSnowflakes();
    for (int i = 0; i < _snowflakes.length; i++) {
      _drawSnowflake(canvas, _snowflakes[i], _radii[i], size);
    }
  }

  void _initializeSnowflakes() {
    for (int i = 0; i < 10000; i++) {
      _snowflakes.add(
        Offset(
          _random.nextDouble() * _size.width,
          _random.nextDouble() * _size.height,
        ),
      );
      _radii.add(_random.nextDouble() * 2 + 2);
      _velocities.add(_random.nextDouble() * 5 + 2);
    }
  }

  void _updateSnowflakes() {
    for (int i = 0; i < _snowflakes.length; i++) {
      final y = _snowflakes[i].dy + _velocities[i];
      final x = _snowflakes[i].dx;
      if (y > _size.height + _radii[i]) {
        _snowflakes[i] = Offset(_random.nextDouble() * _size.width, -_radii[i]);
      } else {
        _snowflakes[i] = Offset(x, y);
      }
    }
  }

  void _drawSnowflake(Canvas canvas, Offset center, double radius, Size size) {
    List<Offset> points = [];
    for (int i = 0; i < 6; i++) {
      final double angle = pi / 3 * i;
      final endX = center.dx + radius * cos(angle);
      final endY = center.dy + radius * sin(angle);
      final end = Offset(endX, endY);

      points.add(center);
      points.add(end);

      points.addAll(_getBranchPoints(center, end, radius / 3));
    }

    Float32List verticesList = Float32List(points.length * 2);
    for (int i = 0; i < points.length; i++) {
      verticesList[i * 2] = points[i].dx;
      verticesList[i * 2 + 1] = points[i].dy;
    }

    Vertices vertices = Vertices.raw(VertexMode.triangleFan, verticesList);
    canvas.drawVertices(vertices, BlendMode.srcOver, pencil);
  }

  List<Offset> _getBranchPoints(Offset start, Offset end, double length) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final angle = atan2(dy, dx);

    final leftBranchEnd = Offset(
      end.dx - length * cos(angle + pi / 4),
      end.dy - length * sin(angle + pi / 4),
    );
    final rightBranchEnd = Offset(
      end.dx - length * cos(angle - pi / 4),
      end.dy - length * sin(angle - pi / 4),
    );

    return [end, leftBranchEnd, end, rightBranchEnd];
  }

  @override
  bool shouldRepaint(SnowFlakePainter oldDelegate) =>
      oldDelegate.animation != animation;
}

class SnowFlakePainterStandard extends CustomPainter {
  final Animation<double> animation;
  final Size _size;
  final List<Offset> _snowflakes = [];
  final List<double> _radii = [];
  final List<double> _velocities = [];
  final Random _random = Random();

  final Paint _pencil = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 1
    ..isAntiAlias = true;

  SnowFlakePainterStandard(
    this.animation,
    this._size,
  ) : super(repaint: animation) {
    _initializeSnowflakes();
  }

  void _initializeSnowflakes() {
    for (int i = 0; i < 10000; i++) {
      _snowflakes.add(
        Offset(
          _random.nextDouble() * _size.width,
          _random.nextDouble() * _size.height,
        ),
      );
      _radii.add(_random.nextDouble() * 2 + 2);
      _velocities.add(_random.nextDouble() * 5 + 2);
    }
  }

  void _updateSnowflakes() {
    for (int i = 0; i < _snowflakes.length; i++) {
      final y = _snowflakes[i].dy + _velocities[i];
      final x = _snowflakes[i].dx;
      if (y > _size.height + _radii[i]) {
        _snowflakes[i] = Offset(_random.nextDouble() * _size.width, -_radii[i]);
      } else {
        _snowflakes[i] = Offset(x, y);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _updateSnowflakes();
    for (int i = 0; i < _snowflakes.length; i++) {
      _drawSnowflake(canvas, _snowflakes[i], _radii[i]);
    }
  }

  void _drawSnowflake(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 6; i++) {
      final double angle = pi / 3 * i;
      final endX = center.dx + radius * cos(angle);
      final endY = center.dy + radius * sin(angle);
      final end = Offset(endX, endY);

      // Draw the main line of each snowflake arm
      canvas.drawLine(center, end, _pencil);

      // Add small branches to each arm for a detailed snowflake
      _drawBranches(canvas, center, end, radius / 3);
    }
  }

  void _drawBranches(Canvas canvas, Offset start, Offset end, double length) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final angle = atan2(dy, dx);

    // Calculate positions for two branches
    final leftBranchEnd = Offset(
      end.dx - length * cos(angle + pi / 6),
      end.dy - length * sin(angle + pi / 6),
    );
    final rightBranchEnd = Offset(
      end.dx - length * cos(angle - pi / 6),
      end.dy - length * sin(angle - pi / 6),
    );

    // Draw branches
    canvas.drawLine(end, leftBranchEnd, _pencil);
    canvas.drawLine(end, rightBranchEnd, _pencil);
  }

  @override
  bool shouldRepaint(SnowFlakePainterStandard oldDelegate) =>
      oldDelegate.animation != animation;

  @override
  bool shouldRebuildSemantics(SnowFlakePainterStandard oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
