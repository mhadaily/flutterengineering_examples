import 'package:flutter/material.dart';

class EnvironmentConfig {
  EnvironmentConfig({
    required this.apiUrl,
    required this.featureEnabled,
  });

  final String apiUrl;
  final bool featureEnabled;

  static EnvironmentConfig fromEnvironment() {
    return EnvironmentConfig(
      apiUrl: const String.fromEnvironment(
        'API_URL',
        defaultValue: 'https://default.example.com',
      ),
      featureEnabled: const String.fromEnvironment(
            'FEATURE_ENABLED',
            defaultValue: 'false',
          ) ==
          'true',
    );
  }
}

void main() {
  final config = EnvironmentConfig.fromEnvironment();
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final EnvironmentConfig config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // Use 'config.apiUrl' and 'config.featureEnabled' as needed in your app
      home: MyHomePage(
        config: config,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.config});

  final EnvironmentConfig config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Environment Config'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('API URL: ${config.apiUrl}'),
            Text(
              'Feature Enabled: ${config.featureEnabled ? "Yes" : "No"}',
            ),
          ],
        ),
      ),
    );
  }
}
