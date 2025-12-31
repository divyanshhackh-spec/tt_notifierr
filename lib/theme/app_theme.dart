import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = Color(0xFF1E40AF); // Indigo 700 as school color

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme([ThemeMode? mode]) {
    if (mode != null) {
      _themeMode = mode;
    } else {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }
}
