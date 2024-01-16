import 'package:flutter_test/flutter_test.dart';
import 'package:playground/design_patterns/singelton.dart';

void main() {
  // This setup runs before each test to reset the singleton
  setUp(() {
    AppConfig.reset();
  });

  test('Singleton instance should be the same', () {
    var instance1 = AppConfig.instance;
    var instance2 = AppConfig.instance;

    // Test whether both instances are the same instance
    expect(identical(instance1, instance2), isTrue);
  });

  test('Singleton should retain its state', () {
    var instance = AppConfig.instance;
    instance.appName = 'Test App';

    // Create another reference to the singleton
    var instance2 = AppConfig.instance;

    // Test whether the second reference sees the updated state
    expect(instance2.appName, 'Test App');
  });

  // Add more tests as needed for different aspects of the singleton
}
