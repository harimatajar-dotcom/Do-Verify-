import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

/// Navigation item data
class NavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String? route;

  const NavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.route,
  });
}

/// Bottom navigation bar widget matching HTML design
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<NavItem> items = [
    NavItem(
      label: AppStrings.navHome,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: '/home',
    ),
    NavItem(
      label: AppStrings.navTemplates,
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view,
      route: '/templates',
    ),
    NavItem(
      label: AppStrings.navCreate,
      icon: Icons.add,
      route: '/create',
    ),
    NavItem(
      label: AppStrings.navShared,
      icon: Icons.share_outlined,
      activeIcon: Icons.share,
      route: '/shared',
    ),
    NavItem(
      label: AppStrings.navProfile,
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: AppDimensions.shadowBlurLg,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = currentIndex == index;
            final isCreateButton = index == 2;

            if (isCreateButton) {
              return _CreateButton(
                onTap: () => onTap(index),
              );
            }

            return _NavItemWidget(
              item: item,
              isSelected: isSelected,
              onTap: () => onTap(index),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? (item.activeIcon ?? item.icon) : item.icon,
              size: AppDimensions.iconLg,
              color: color,
            ),
            const SizedBox(height: AppDimensions.spacingXxs),
            Text(
              item.label,
              style: TextStyle(
                fontSize: AppDimensions.fontXs,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.createButtonSize,
        height: AppDimensions.createButtonSize,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: AppDimensions.shadowBlurMd,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          size: AppDimensions.createButtonIconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
