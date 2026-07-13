import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(ThemeMode value) : super(value);

  bool get isDarkMode => value == ThemeMode.dark;

  void toggleTheme() {
    value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }
  
  void setThemeMode(ThemeMode mode) {
    value = mode;
  }
}

// Global notifier instance for simplicity and easy access
final themeNotifier = ThemeNotifier(ThemeMode.light);
