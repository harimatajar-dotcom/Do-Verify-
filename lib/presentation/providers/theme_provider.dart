import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app theme state
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if dark mode is enabled
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Check if light mode is enabled
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Check if system mode is enabled
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Check if provider is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize theme from stored preference
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedTheme = prefs.getString(_themeKey);

      if (storedTheme != null) {
        _themeMode = _themeModeFromString(storedTheme);
      }
    } catch (_) {
      // Use default theme on error
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _themeModeToString(mode));
    } catch (_) {
      // Ignore storage errors
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Set light mode
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark mode
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system mode
  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Convert ThemeMode to string for storage
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
