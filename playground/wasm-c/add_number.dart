import 'package:web/web.dart';

// add_number.dart
int addNumbers(int a, int b) {
  return a + b;
}

void main() {
  final now = DateTime.now();
  final element =
      document.querySelector('#output') as HTMLDivElement;
  element.text = 'The time is ${now.hour}:${now.minute} '
      'and your Dart web app is running using Wasm GC!';
}
