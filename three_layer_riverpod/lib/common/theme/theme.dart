import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const appTextTheme = TextTheme(
  titleSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
);

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.deepPurple,
        ),
        textTheme: appTextTheme,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        useMaterial3: true,
      );

  static ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.green,
        ),
        textTheme: appTextTheme,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        useMaterial3: true,
      );
}

final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => ThemeMode.system,
);
