import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LifecycleWidget extends StatefulWidget {
  const LifecycleWidget({Key? key}) : super(key: key);

  @override
  LifecycleState createState() => LifecycleState();
}

class LifecycleState extends State<LifecycleWidget> {
  int _counter = 0;

  LifecycleState() {
    if (mounted) {}
    print('Constructor, mounted: $mounted');
  }

  @override
  void initState() {
    super.initState();
    print('initState, mounted: $mounted');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies, mounted: $mounted');
  }

  @override
  Widget build(BuildContext context) {
    print('Build method');
    return Column(
      children: [
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text('Increment'),
        ),
      ],
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      print('setState, new counter value: $_counter');
    });
  }

  @override
  void didUpdateWidget(covariant LifecycleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget, mounted: $mounted');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate, mounted: $mounted');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose, mounted: $mounted');
  }

  @override
  void reassemble() {
    super.reassemble();
    print('reassemble, mounted: $mounted');
  }
}

// lib
// |--common
// |    |--widgets
// |    |--themes
// |    |--settings
// |    |--utils
// |--constants
// |--localization
// |--features
// |    |--profile
// |         |--presentation
// |             |--widgets
// |             |--state
// |         |--business
// |             |--usecase
// |         |--data
// |             |--repository
// |             |--data
// |    |--setting
// |    |--cart
// |--routing

// lib
// |--common
// |    |--widgets
// |    |--themes
// |    |--settings
// |    |--utils
// |--constants
// |--localization
// |--presentation
// |  |--widgets
// |    |--profile
// |    |--setting
// |  |--state
// |    |--profile
// |    |--setting
// |--business
// |  |--usecase
// |--data
// |  |--repository
// |  |--data
// |--routing