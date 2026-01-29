import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/template_entity.dart';
import 'category_icon.dart';

/// Template card widget for vertical list
class TemplateCard extends StatelessWidget {
  final TemplateEntity template;
  final VoidCallback? onTap;

  const TemplateCard({
    super.key,
    required this.template,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurSm,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: AppDimensions.templateIconSize,
              height: AppDimensions.templateIconSize,
              decoration: BoxDecoration(
                color: CategoryIcon.getBackgroundColor(
                  template.category,
                  isDark,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Center(
                child: CategoryIcon(
                  category: template.category,
                  size: AppDimensions.iconLg,
                  color: CategoryIcon.getForegroundColor(template.category),
                ),
              ),
            ),

            const SizedBox(width: AppDimensions.templateCardGap),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    template.name,
                    style: TextStyle(
                      fontSize: AppDimensions.fontLg,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingXs),

                  // Description
                  Text(
                    template.description,
                    style: TextStyle(
                      fontSize: AppDimensions.fontMd,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppDimensions.spacingSm),

                  // Meta row
                  Row(
                    children: [
                      // Category badge
                      _CategoryBadge(
                        category: template.category,
                        isDark: isDark,
                      ),

                      const SizedBox(width: AppDimensions.spacingSm),

                      // Task count
                      Text(
                        AppStrings.taskCount(template.taskCount),
                        style: TextStyle(
                          fontSize: AppDimensions.fontSm,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final dynamic category;
  final bool isDark;

  const _CategoryBadge({
    required this.category,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXxs,
      ),
      decoration: BoxDecoration(
        color: CategoryIcon.getBackgroundColor(category, isDark),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(
        category.name,
        style: TextStyle(
          fontSize: AppDimensions.fontXs,
          fontWeight: FontWeight.w500,
          color: CategoryIcon.getForegroundColor(category),
        ),
      ),
    );
  }
}
