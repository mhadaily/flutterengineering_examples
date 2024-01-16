class AppConfig {
  static AppConfig? _instance;

  AppConfig._internal();

  static AppConfig get instance {
    _instance ??= AppConfig._internal();
    return _instance!;
  }

  // Reset the singleton, useful in tests
  static void reset() => _instance = null;

  String appName = 'My Flutter App';
  String appVersion = '1.0.0';

  // Additional configuration settings...
}
