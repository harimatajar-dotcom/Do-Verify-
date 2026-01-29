import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/category_entity.dart';

/// Widget to display category-specific icons
class CategoryIcon extends StatelessWidget {
  final Category category;
  final double size;
  final Color? color;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIcon(),
      size: size,
      color: color ?? _getColor(),
    );
  }

  IconData _getIcon() {
    switch (category) {
      case Category.all:
        return Icons.grid_view;
      case Category.work:
        return Icons.work_outline;
      case Category.personal:
        return Icons.person_outline;
      case Category.dev:
        return Icons.code;
      case Category.health:
        return Icons.favorite_outline;
    }
  }

  Color _getColor() {
    switch (category) {
      case Category.all:
        return AppColors.gray500;
      case Category.work:
        return AppColors.categoryWork;
      case Category.personal:
        return AppColors.categoryPersonal;
      case Category.dev:
        return AppColors.categoryDev;
      case Category.health:
        return AppColors.categoryHealth;
    }
  }

  /// Get background color for category
  static Color getBackgroundColor(Category category, bool isDark) {
    switch (category) {
      case Category.all:
        return isDark ? AppColors.darkSurface : AppColors.lightCream;
      case Category.work:
        return isDark
            ? AppColors.categoryWorkBgDark
            : AppColors.categoryWorkBgLight;
      case Category.personal:
        return isDark
            ? AppColors.categoryPersonalBgDark
            : AppColors.categoryPersonalBgLight;
      case Category.dev:
        return isDark
            ? AppColors.categoryDevBgDark
            : AppColors.categoryDevBgLight;
      case Category.health:
        return isDark
            ? AppColors.categoryHealthBgDark
            : AppColors.categoryHealthBgLight;
    }
  }

  /// Get foreground color for category
  static Color getForegroundColor(Category category) {
    switch (category) {
      case Category.all:
        return AppColors.gray500;
      case Category.work:
        return AppColors.categoryWork;
      case Category.personal:
        return AppColors.categoryPersonal;
      case Category.dev:
        return AppColors.categoryDev;
      case Category.health:
        return AppColors.categoryHealth;
    }
  }
}
