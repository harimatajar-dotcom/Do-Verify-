import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/template_entity.dart';
import 'category_icon.dart';

/// Featured template card widget for horizontal scroll
class FeaturedCard extends StatelessWidget {
  final TemplateEntity template;
  final VoidCallback? onTap;

  const FeaturedCard({
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
        width: AppDimensions.featuredCardWidth,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurMd,
              offset: const Offset(0, AppDimensions.shadowOffsetY),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon
            Container(
              height: AppDimensions.featuredCardHeaderHeight,
              decoration: BoxDecoration(
                color: CategoryIcon.getBackgroundColor(
                  template.category,
                  isDark,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusLg),
                ),
              ),
              child: Center(
                child: CategoryIcon(
                  category: template.category,
                  size: AppDimensions.featuredCardIconSize,
                  color: CategoryIcon.getForegroundColor(template.category),
                ),
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              child: Column(
                children: [
                  // Title
                  Text(
                    template.name,
                    style: TextStyle(
                      fontSize: AppDimensions.fontMd,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppDimensions.spacingXs),

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
            ),
          ],
        ),
      ),
    );
  }
}
