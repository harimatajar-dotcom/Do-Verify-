import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Dark theme configuration
class DarkTheme {
  DarkTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        fontFamily: 'Figtree',

        // Color Scheme
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.darkSurface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.darkTextPrimary,
          onError: Colors.white,
        ),

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Figtree',
            fontSize: AppDimensions.fontXl,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
        ),

        // Card Theme
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
            vertical: AppDimensions.spacingMd,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: const TextStyle(
            color: AppColors.darkTextMuted,
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
          backgroundColor: AppColors.darkSurface,
          selectedColor: AppColors.primary,
          disabledColor: AppColors.gray700,
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
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.darkTextMuted,
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
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.modalBorderRadius),
            ),
          ),
        ),

        // Divider Theme
        dividerTheme: const DividerThemeData(
          color: AppColors.darkBorder,
          thickness: 1,
        ),

        // Text Theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: AppDimensions.fontHeading,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
          ),
          displayMedium: TextStyle(
            fontSize: AppDimensions.fontDisplay,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: AppDimensions.fontXxl,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: AppDimensions.fontXl,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: AppDimensions.fontLg,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: AppDimensions.fontLg,
            fontWeight: FontWeight.w400,
            color: AppColors.darkTextPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: AppDimensions.fontMd,
            fontWeight: FontWeight.w400,
            color: AppColors.darkTextSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: AppDimensions.fontSm,
            fontWeight: FontWeight.w400,
            color: AppColors.darkTextMuted,
          ),
          labelLarge: TextStyle(
            fontSize: AppDimensions.fontMd,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
          labelMedium: TextStyle(
            fontSize: AppDimensions.fontSm,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextSecondary,
          ),
          labelSmall: TextStyle(
            fontSize: AppDimensions.fontXs,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextMuted,
          ),
        ),
      );
}
