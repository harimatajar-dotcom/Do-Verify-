import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Light theme configuration
class LightTheme {
  LightTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.lightBackground,
        fontFamily: 'Figtree',

        // Color Scheme
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.lightSurface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.lightTextPrimary,
          onError: Colors.white,
        ),

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.lightTextPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Figtree',
            fontSize: AppDimensions.fontXl,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
        ),

        // Card Theme
        cardTheme: CardThemeData(
          color: AppColors.lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
            vertical: AppDimensions.spacingMd,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: const TextStyle(
            color: AppColors.lightTextMuted,
            fontSize: AppDimensions.fontMd,
          ),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingXxl,
              vertical: AppDimensions.spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Figtree',
              fontSize: AppDimensions.fontLg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontFamily: 'Figtree',
              fontSize: AppDimensions.fontMd,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedColor: AppColors.primary,
          disabledColor: AppColors.gray200,
          labelStyle: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: AppDimensions.fontSm,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
            vertical: AppDimensions.spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.lightTextMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Figtree',
            fontSize: AppDimensions.fontXs,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Figtree',
            fontSize: AppDimensions.fontXs,
            fontWeight: FontWeight.w500,
          ),
        ),

        // Bottom Sheet Theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.modalBorderRadius),
            ),
          ),
        ),

        // Divider Theme
        dividerTheme: const DividerThemeData(
          color: AppColors.lightBorder,
          thickness: 1,
        ),

        // Text Theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: AppDimensions.fontHeading,
            fontWeight: FontWeight.w700,
            color: AppColors.lightTextPrimary,
          ),
          displayMedium: TextStyle(
            fontSize: AppDimensions.fontDisplay,
            fontWeight: FontWeight.w700,
            color: AppColors.lightTextPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: AppDimensions.fontXxl,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: AppDimensions.fontXl,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: AppDimensions.fontLg,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: AppDimensions.fontLg,
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: AppDimensions.fontMd,
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: AppDimensions.fontSm,
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextMuted,
          ),
          labelLarge: TextStyle(
            fontSize: AppDimensions.fontMd,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
          labelMedium: TextStyle(
            fontSize: AppDimensions.fontSm,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextSecondary,
          ),
          labelSmall: TextStyle(
            fontSize: AppDimensions.fontXs,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextMuted,
          ),
        ),
      );
}
