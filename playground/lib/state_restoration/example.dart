import 'package:flutter/material.dart';

void main() {
  runApp(
    const RootRestorationScope(
      restorationId: 'root',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      restorationScopeId: 'app',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with RestorationMixin {
  final RestorableInt _counter = RestorableInt(0);

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(
    RestorationBucket? oldBucket,
    bool initialRestore,
  ) {
    registerForRestoration(_counter, 'counter');
  }

  void _incrementCounter() {
    setState(() {
      _counter.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'State Restoration Demo',
        ),
      ),
      body: Center(
        child: Text(
          'Button tapped ${_counter.value} time(s)',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
