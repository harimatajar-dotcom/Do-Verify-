import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/template_entity.dart';
import 'category_icon.dart';

/// Bottom sheet modal for template preview
class TemplatePreviewModal extends StatelessWidget {
  final TemplateEntity template;
  final VoidCallback? onUseTemplate;
  final VoidCallback? onCancel;

  const TemplatePreviewModal({
    super.key,
    required this.template,
    this.onUseTemplate,
    this.onCancel,
  });

  /// Show the modal
  static Future<void> show(
    BuildContext context, {
    required TemplateEntity template,
    VoidCallback? onUseTemplate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplatePreviewModal(
        template: template,
        onUseTemplate: onUseTemplate,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * AppDimensions.modalMaxHeight,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.modalBorderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          _buildHandle(isDark),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.screenPaddingH,
                0,
                AppDimensions.screenPaddingH,
                bottomPadding + AppDimensions.spacingLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(isDark),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // Description
                  Text(
                    template.description,
                    style: TextStyle(
                      fontSize: AppDimensions.fontMd,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingXxl),

                  // Tasks section
                  _buildTasksSection(isDark),

                  const SizedBox(height: AppDimensions.spacingXxl),

                  // Actions
                  _buildActions(context, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
      child: Container(
        width: AppDimensions.modalHandleWidth,
        height: AppDimensions.modalHandleHeight,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        // Icon
        Container(
          width: AppDimensions.templateIconSize,
          height: AppDimensions.templateIconSize,
          decoration: BoxDecoration(
            color: CategoryIcon.getBackgroundColor(template.category, isDark),
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

        const SizedBox(width: AppDimensions.spacingMd),

        // Title and task count
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                template.name,
                style: TextStyle(
                  fontSize: AppDimensions.fontXl,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXxs),
              Text(
                AppStrings.taskCount(template.taskCount),
                style: TextStyle(
                  fontSize: AppDimensions.fontMd,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTasksSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          AppStrings.tasksIncluded,
          style: TextStyle(
            fontSize: AppDimensions.fontLg,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Task list
        ...template.tasks.map((task) => _TaskItem(task: task, isDark: isDark)),
      ],
    );
  }

  Widget _buildActions(BuildContext context, bool isDark) {
    return Column(
      children: [
        // Use template button
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onUseTemplate?.call();
            },
            child: const Text(AppStrings.useThisTemplate),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingSm),

        // Cancel button
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          child: TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskItem extends StatelessWidget {
  final String task;
  final bool isDark;

  const _TaskItem({
    required this.task,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: AppDimensions.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),

          // Task text
          Expanded(
            child: Text(
              task,
              style: TextStyle(
                fontSize: AppDimensions.fontMd,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
