import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

/// Main theme configuration for CheckFlow
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => LightTheme.theme;
  static ThemeData get darkTheme => DarkTheme.theme;

  /// Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}
