import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with RestorationMixin {
  final _themePreference = RestorableBool(false);

  @override
  String? get restorationId => 'app_root';

  @override
  void restoreState(
    RestorationBucket? oldBucket,
    bool initialRestore,
  ) {
    registerForRestoration(
      _themePreference,
      'theme_preference',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themePreference.value
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const MyHomePage(),
    );
  }

  @override
  void dispose() {
    _themePreference.dispose();
    super.dispose();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Preference Demo'),
      ),
      body: const Center(
        child: Text(
          'Toggle theme from the system settings.',
        ),
      ),
    );
  }
}

class UserThemePreference extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    if (value != _isDarkTheme) {
      _isDarkTheme = value;
      notifyListeners();
    }
  }

  Map<String, dynamic> toJson() => {
        'isDarkTheme': _isDarkTheme,
      };

  void loadFromJson(Map<String, dynamic> json) {
    _isDarkTheme = json['isDarkTheme'] as bool? ?? false;
  }
}

class RestorableUserThemePreference
    extends RestorableListenable<UserThemePreference> {
  @override
  UserThemePreference createDefaultValue() {
    return UserThemePreference();
  }

  @override
  UserThemePreference fromPrimitives(Object? data) {
    final Map<String, dynamic> savedData =
        Map<String, dynamic>.from(
      data as Map<Object?, Object?>,
    );
    final UserThemePreference preference =
        UserThemePreference();
    preference.loadFromJson(savedData);
    return preference;
  }

  @override
  Object? toPrimitives() {
    // Serialize the UserThemePreference
    return value.toJson();
  }

  @override
  void initWithValue(UserThemePreference value) {
    // Don't forget to call super
    super.initWithValue(value);
    // Additional initialization actions go here
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}
