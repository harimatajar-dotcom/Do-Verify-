import 'package:flutter/material.dart';

/// Responsive utility class for scaling UI elements based on screen size.
/// Design baseline: 375 x 812 (iPhone X/11 Pro)
class Responsive {
  static const double _baseWidth = 375.0;
  static const double _baseHeight = 812.0;

  final BuildContext context;
  late final double screenWidth;
  late final double screenHeight;
  late final double scaleWidth;
  late final double scaleHeight;
  late final double scaleText;

  Responsive(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    scaleWidth = screenWidth / _baseWidth;
    scaleHeight = screenHeight / _baseHeight;
    // Use width for text scaling with a max limit to prevent overly large text
    scaleText = scaleWidth.clamp(0.8, 1.3);
  }

  /// Scale width based on screen width
  double w(double size) => size * scaleWidth;

  /// Scale height based on screen height
  double h(double size) => size * scaleHeight;

  /// Scale font size (clamped for readability)
  double sp(double size) => size * scaleText;

  /// Scale radius (uses average of width/height scale)
  double r(double size) => size * ((scaleWidth + scaleHeight) / 2);

  /// Get responsive horizontal padding
  double get horizontalPadding => w(16);

  /// Get responsive vertical padding
  double get verticalPadding => h(16);

  /// Check if device is a small phone (width < 360)
  bool get isSmallPhone => screenWidth < 360;

  /// Check if device is a large phone (width >= 414)
  bool get isLargePhone => screenWidth >= 414;

  /// Check if device is a tablet (width >= 600)
  bool get isTablet => screenWidth >= 600;

  /// Get appropriate grid columns based on screen width
  int get gridColumns {
    if (screenWidth >= 900) return 4;
    if (screenWidth >= 600) return 3;
    return 2;
  }

  /// Get stat card aspect ratio based on screen size
  double get statCardAspectRatio {
    if (isSmallPhone) return 1.4;
    if (isTablet) return 1.8;
    return 1.6;
  }
}

/// Extension for easy access to Responsive from BuildContext
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}
