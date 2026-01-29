import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

/// Empty state widget for when no results found
class EmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.action,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightCream,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.search_off,
                size: AppDimensions.iconXxl,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingXxl),

            // Title
            Text(
              title ?? AppStrings.noTemplatesFound,
              style: TextStyle(
                fontSize: AppDimensions.fontXl,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spacingSm),

            // Message
            Text(
              message ?? AppStrings.noTemplatesMessage,
              style: TextStyle(
                fontSize: AppDimensions.fontMd,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (action != null) ...[
              const SizedBox(height: AppDimensions.spacingXxl),
              action!,
            ] else if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.spacingXxl),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
