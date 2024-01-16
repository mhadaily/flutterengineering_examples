// main.dart
import 'package:flutter/material.dart';
import 'package:playground/EDA/logic.dart';

void main() {
  final appConfig = {'loadProfile': true, 'loadSettings': true};
  final analyticsService = AnalyticsService(AnyAnalyticsService());

  if (appConfig['loadProfile']!) {
    final profilePlugin = ProfilePlugin();
    profilePlugin.setAnalyticsService(analyticsService);
    profilePlugin.register();
  }
  if (appConfig['loadSettings']!) {
    SettingsPlugin().register();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plugin Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      onGenerateRoute: RouterRegistry.generateRoute,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin Demo Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/profile',
              ),
              child: const Text('Go to Profile'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/settings',
              ),
              child: const Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class RouterRegistry {
  static final Map<String, WidgetBuilder> _routes = {};

  static void registerRoute(String routeName, WidgetBuilder builder) {
    _routes[routeName] = builder;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (_routes.containsKey(settings.name)) {
      return MaterialPageRoute(
        builder: _routes[settings.name]!,
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
    }
  }
}

abstract class PluginContract {
  late final AnalyticsService analyticsService;

  void register();

  void setAnalyticsService(AnalyticsService service) {
    analyticsService = service;
  }
  // Other common methods can be added here
}

class ProfilePlugin implements PluginContract {
  @override
  late final AnalyticsService analyticsService;

  @override
  void register() {
    RouterRegistry.registerRoute(
      '/profile',
      (context) => const ProfilePage(),
    );
    analyticsService.trackEvent('ProfilePluginLoaded', {});
  }

  @override
  void setAnalyticsService(AnalyticsService service) {
    analyticsService = service;
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('This is the profile page!'),
      ),
    );
  }
}

class SettingsPlugin implements PluginContract {
  @override
  late final AnalyticsService analyticsService;

  @override
  void register() {
    RouterRegistry.registerRoute(
      '/settings',
      (context) => const SettingsPage(),
    );
    analyticsService.trackEvent('SettingsPluginLoaded', {});
  }

  @override
  void setAnalyticsService(AnalyticsService service) {
    analyticsService = service;
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('This is the settings page!'),
      ),
    );
  }
}
