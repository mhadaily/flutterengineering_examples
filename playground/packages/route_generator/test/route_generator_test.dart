import 'package:route_generator/route_generator.dart';
import 'package:route_generator/src/route_config_generator.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = RouteConfigGenerator();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome, isA<RouteConfigGenerator>());
    });
  });
}
