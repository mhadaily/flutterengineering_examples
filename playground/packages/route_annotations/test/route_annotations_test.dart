import 'package:route_annotations/route_annotations.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = RouteConfig(
      name: 'awesome',
      path: '/awesome',
    );

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.name, 'awesome');
    });
  });
}
