import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/category_entity.dart';
import '../templates/category_icon.dart';

/// Filter chips widget for category selection
class FilterChips extends StatelessWidget {
  final List<Category>? categories;
  final Category selectedCategory;
  final ValueChanged<Category> onCategorySelected;

  const FilterChips({
    super.key,
    this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      child: Row(
        children: (categories ?? Category.values).map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
            child: _FilterChip(
              category: category,
              isSelected: selectedCategory == category,
              onTap: () => onCategorySelected(category),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    final borderColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppDimensions.animationFast),
        height: AppDimensions.chipHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show icon for non-"All" categories
            if (category != Category.all) ...[
              CategoryIcon(
                category: category,
                size: AppDimensions.iconXs,
                color: textColor,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
            ],
            Text(
              category.name,
              style: TextStyle(
                color: textColor,
                fontSize: AppDimensions.fontSm,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
