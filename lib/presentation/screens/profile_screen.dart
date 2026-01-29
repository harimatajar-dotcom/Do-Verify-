import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/theme_provider.dart';
import '../widgets/common/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 4;
  final UserEntity _user = UserEntity.defaultUser();

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    setState(() => _currentNavIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/templates');
        break;
      case 2:
        Navigator.of(context).pushNamed('/create');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/shared');
        break;
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildProfileHeader(isDark),
                    const SizedBox(height: 24),
                    _buildAchievements(isDark),
                    const SizedBox(height: 24),
                    _buildSettingsSection('Account', [
                      _SettingsItem(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        subtitle: 'Update your name and photo',
                        onTap: () => _showToast('Edit Profile coming soon!'),
                      ),
                      _SettingsItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage push notifications',
                        onTap: () => Navigator.of(context).pushNamed('/notifications'),
                      ),
                      _SettingsItem(
                        icon: Icons.lock_outline,
                        title: 'Security',
                        subtitle: 'Password and authentication',
                        onTap: () => _showToast('Security settings coming soon!'),
                      ),
                    ], isDark),
                    const SizedBox(height: 16),
                    _buildSettingsSection('Preferences', [
                      _SettingsItem(
                        icon: Icons.brightness_6_outlined,
                        title: 'Appearance',
                        subtitle: isDark ? 'Dark mode' : 'Light mode',
                        onTap: () {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) {
                            context.read<ThemeProvider>().toggleTheme();
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                      _SettingsItem(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: 'English',
                        onTap: () => _showToast('Language settings coming soon!'),
                      ),
                      _SettingsItem(
                        icon: Icons.storage_outlined,
                        title: 'Data & Storage',
                        subtitle: 'Manage your data',
                        onTap: () => _showToast('Data settings coming soon!'),
                      ),
                    ], isDark),
                    const SizedBox(height: 16),
                    _buildSettingsSection('Subscription', [
                      _SettingsItem(
                        icon: Icons.star_outline,
                        title: 'Pro Plan',
                        subtitle: 'Renews on Jan 15, 2025',
                        onTap: () => _showToast('Subscription management coming soon!'),
                        isPremium: true,
                        badge: 'Active',
                      ),
                    ], isDark),
                    const SizedBox(height: 16),
                    _buildSettingsSection('Support', [
                      _SettingsItem(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        onTap: () => _showToast('Help Center coming soon!'),
                      ),
                      _SettingsItem(
                        icon: Icons.chat_bubble_outline,
                        title: 'Send Feedback',
                        onTap: () => _showToast('Feedback coming soon!'),
                      ),
                      _SettingsItem(
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Version 1.0.0',
                        onTap: () => _showToast('About coming soon!'),
                      ),
                    ], isDark),
                    const SizedBox(height: 16),
                    _buildSettingsSection('', [
                      _SettingsItem(
                        icon: Icons.logout,
                        title: 'Log Out',
                        onTap: _logout,
                        isDestructive: true,
                      ),
                    ], isDark),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: 12,
      ),
      child: Row(
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showToast('Settings coming soon!'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    _user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 16,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _user.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _user.email,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          if (_user.isPro) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Pro Member',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(_user.checklistCount.toString(), 'Checklists', isDark),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStatItem(_user.completedCount.toString(), 'Completed', isDark),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStatItem(_user.tasksDone.toString(), 'Tasks Done', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(bool isDark) {
    final achievements = [
      {'icon': Icons.emoji_events_outlined, 'label': 'First List', 'unlocked': true},
      {'icon': Icons.check_circle_outline, 'label': '10 Tasks', 'unlocked': true},
      {'icon': Icons.people_outline, 'label': 'Team Player', 'unlocked': true},
      {'icon': Icons.star_outline, 'label': '100 Tasks', 'unlocked': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => _showToast('View all achievements coming soon!'),
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: achievements.map((a) {
            return _buildAchievementItem(
              icon: a['icon'] as IconData,
              label: a['label'] as String,
              unlocked: a['unlocked'] as bool,
              isDark: isDark,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAchievementItem({
    required IconData icon,
    required String label,
    required bool unlocked,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: unlocked
                ? AppColors.primary.withAlpha(26)
                : (isDark ? AppColors.darkSurface : AppColors.gray100),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 28,
            color: unlocked
                ? AppColors.primary
                : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: unlocked
                ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<_SettingsItem> items, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
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
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildSettingsItem(item, isDark),
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      indent: 56,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(_SettingsItem item, bool isDark) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.isDestructive
                    ? AppColors.error.withAlpha(26)
                    : item.isPremium
                        ? AppColors.primary.withAlpha(26)
                        : (isDark ? AppColors.darkSurface : AppColors.gray100),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: item.isDestructive
                    ? AppColors.error
                    : item.isPremium
                        ? AppColors.primary
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: item.isDestructive
                          ? AppColors.error
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                ],
              ),
            ),
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.badge!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
              )
            else if (item.trailing != null)
              item.trailing!
            else if (!item.isDestructive)
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isPremium;
  final String? badge;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
    this.isPremium = false,
    this.badge,
    this.trailing,
  });
}
