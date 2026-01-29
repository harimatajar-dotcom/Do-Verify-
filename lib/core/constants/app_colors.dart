import 'package:flutter/material.dart';

/// App color constants for CheckFlow
/// Supports both light and dark themes
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF00D9C0);
  static const Color primaryLight = Color(0xFF00B8A3);
  static const Color primaryDark = Color(0xFF00A896);

  // Secondary Colors
  static const Color secondary = Color(0xFFC4A484);
  static const Color secondaryLight = Color(0xFFD4B494);
  static const Color secondaryDark = Color(0xFFA48464);

  // Accent Colors
  static const Color terracotta = Color(0xFFE07B4C);
  static const Color terracottaLight = Color(0xFFF08B5C);
  static const Color terracottaDark = Color(0xFFC46B3C);

  static const Color olive = Color(0xFF8B9A6D);
  static const Color oliveLight = Color(0xFF9BAA7D);
  static const Color oliveDark = Color(0xFF6B7A4D);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFBF5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCream = Color(0xFFFFF8F0);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCard = Color(0xFF363636);
  static const Color darkCream = Color(0xFF2A2A2A);

  // Text Colors - Light
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextMuted = Color(0xFF9CA3AF);

  // Text Colors - Dark
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextMuted = Color(0xFF808080);

  // Gray Scale
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Category Colors
  static const Color categoryWork = primary;
  static const Color categoryPersonal = terracotta;
  static const Color categoryDev = olive;
  static const Color categoryHealth = secondary;

  // Category Background Colors (Light)
  static Color categoryWorkBgLight = primary.withOpacity(0.15);
  static Color categoryPersonalBgLight = terracotta.withOpacity(0.15);
  static Color categoryDevBgLight = olive.withOpacity(0.15);
  static Color categoryHealthBgLight = secondary.withOpacity(0.15);

  // Category Background Colors (Dark)
  static Color categoryWorkBgDark = primary.withOpacity(0.25);
  static Color categoryPersonalBgDark = terracotta.withOpacity(0.25);
  static Color categoryDevBgDark = olive.withOpacity(0.25);
  static Color categoryHealthBgDark = secondary.withOpacity(0.25);

  // Category Foreground Colors
  static const Color workForeground = primary;
  static const Color personalForeground = terracotta;
  static const Color devForeground = olive;
  static const Color healthForeground = secondary;

  // Alias colors for simpler access
  static Color get workBgLight => categoryWorkBgLight;
  static Color get workBgDark => categoryWorkBgDark;
  static Color get personalBgLight => categoryPersonalBgLight;
  static Color get personalBgDark => categoryPersonalBgDark;
  static Color get devBgLight => categoryDevBgLight;
  static Color get devBgDark => categoryDevBgDark;
  static Color get healthBgLight => categoryHealthBgLight;
  static Color get healthBgDark => categoryHealthBgDark;

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.08);
  static Color shadowDark = Colors.black.withOpacity(0.3);

  // Border Colors
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color darkBorder = Color(0xFF404040);
}
