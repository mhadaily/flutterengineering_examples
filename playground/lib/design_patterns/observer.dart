import 'package:flutter/material.dart';

// FLUTTER
class CounterObserver with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterConcreteObserver extends StatelessWidget {
  const CounterConcreteObserver({
    super.key,
    required this.counterNotifier,
  });

  final CounterObserver counterNotifier;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Current counter value:'),
          ListenableBuilder(
            listenable: counterNotifier,
            builder: (BuildContext context, Widget? child) {
              return Text('${counterNotifier.count}');
            },
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _counter = CounterObserver();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ListenableBuilder Example')),
        body: Column(
          children: [
            CounterConcreteObserver(counterNotifier: _counter),
            CounterConcreteObserver(counterNotifier: _counter),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _counter.increment,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// PURE DART
abstract class Observer {
  void update();
}

class Subject {
  final List<Observer> _observers = [];

  void attach(Observer observer) {
    _observers.add(observer);
  }

  void detach(Observer observer) {
    _observers.remove(observer);
  }

  void notifyObservers() {
    for (var observer in _observers) {
      observer.update();
    }
  }
}

class ConcreteObserver implements Observer {
  @override
  String update() {
    return 'Observer updated.';
  }
}

void main() {
  var subject = Subject();
  var observer = ConcreteObserver();
  var observer2 = ConcreteObserver();
  subject.attach(observer);
  subject.attach(observer2);

  subject.notifyObservers(); // Notifies the observer

  runApp(const MyApp());
}
// Observer updated.
// Observer updated.
