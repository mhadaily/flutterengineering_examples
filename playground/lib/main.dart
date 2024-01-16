import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:playground/labeled_divider.dart';
import 'package:playground/oop/mixin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
    print('${SchedulerBinding.instance.schedulerPhase}');
  });

  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    print('${SchedulerBinding.instance.schedulerPhase} ');
  });

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Labeled Divider Example')),
      body: const Column(
        children: [
          MyWidget(),
          LabeledDivider(
            label: 'Divider Label',
            thickness: 2.0,
            color: Colors.blue,
          ),
        ],
      ),
    ),
  ));
}

class MyWidget extends StatefulWidget with WidgetLoggerMixin {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin, ServiceLoggerMixinClass {
  final double _width = 100.0;
  final double _height = 100.0;
  late AnimationController _controller;

  @override
  void initState() {
    log('initState');
    super.initState();

    Future.delayed(
      Duration.zero,
      () => {
        print('${SchedulerBinding.instance.schedulerPhase}'),
      },
    );
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(
        () {
          print('${SchedulerBinding.instance.schedulerPhase}');
        },
      );
    // scheduleMicrotask(() async {
    //   print('1. ${SchedulerBinding.instance.schedulerPhase}');
    //   await Future.delayed(Duration.zero);
    //   print('2. ${SchedulerBinding.instance.schedulerPhase}');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SizedBox(
        width: _width,
        height: _height,
        child: Container(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
