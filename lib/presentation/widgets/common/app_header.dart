import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Custom app header widget matching HTML design
class AppHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showLogo;
  final VoidCallback? onThemeToggle;

  const AppHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showLogo = true,
    this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppDimensions.headerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      ),
      child: Row(
        children: [
          // Leading / Logo
          if (leading != null)
            leading!
          else if (showLogo)
            _buildLogo(context),

          const Spacer(),

          // Actions
          if (actions != null) ...actions!,

          // Theme toggle button
          if (onThemeToggle != null)
            HeaderActionButton(
              icon: isDark ? Icons.light_mode : Icons.dark_mode,
              onPressed: onThemeToggle!,
              tooltip: isDark ? 'Light mode' : 'Dark mode',
            ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo icon (grid pattern)
        SizedBox(
          width: 24,
          height: 24,
          child: CustomPaint(
            painter: _LogoPainter(color: color),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Text(
          title,
          style: TextStyle(
            fontSize: AppDimensions.fontXl,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the logo icon
class _LogoPainter extends CustomPainter {
  final Color color;

  _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final unit = size.width / 24;

    // Top-left square
    canvas.drawRect(
      Rect.fromLTWH(3 * unit, 3 * unit, 7 * unit, 7 * unit),
      paint,
    );

    // Top-right square
    canvas.drawRect(
      Rect.fromLTWH(14 * unit, 3 * unit, 7 * unit, 7 * unit),
      paint,
    );

    // Bottom-left square
    canvas.drawRect(
      Rect.fromLTWH(3 * unit, 14 * unit, 7 * unit, 7 * unit),
      paint,
    );

    // Bottom-right square
    canvas.drawRect(
      Rect.fromLTWH(14 * unit, 14 * unit, 7 * unit, 7 * unit),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Header action button
class HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const HeaderActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(
        icon,
        size: AppDimensions.iconLg,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
      onPressed: onPressed,
      tooltip: tooltip,
      splashRadius: 20,
    );
  }
}
