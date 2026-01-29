import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'all';
  List<NotificationEntity> _notifications = NotificationEntity.sampleData();

  List<NotificationEntity> get _filteredNotifications {
    if (_selectedFilter == 'all') return _notifications;
    if (_selectedFilter == 'unread') return _notifications.where((n) => !n.isRead).toList();
    if (_selectedFilter == 'mentions') return _notifications.where((n) => n.type == NotificationType.mention).toList();
    if (_selectedFilter == 'shared') return _notifications.where((n) => n.type == NotificationType.shared).toList();
    if (_selectedFilter == 'reminders') return _notifications.where((n) => n.type == NotificationType.reminder || n.type == NotificationType.deadline).toList();
    return _notifications;
  }

  void _markAllRead() {
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
    _showToast('All notifications marked as read');
  }

  void _markAsRead(int index) {
    setState(() {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    });
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
                    _buildFilterChips(isDark),
                    const SizedBox(height: 24),
                    _buildNotificationsList(isDark),
                    const SizedBox(height: 24),
                    _buildSettingsLink(isDark),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              'Mark all read',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = [
      {'key': 'all', 'label': 'All'},
      {'key': 'unread', 'label': 'Unread'},
      {'key': 'mentions', 'label': 'Mentions'},
      {'key': 'shared', 'label': 'Shared'},
      {'key': 'reminders', 'label': 'Reminders'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter['key']!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                ),
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationsList(bool isDark) {
    final grouped = _groupNotificationsByDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(entry.key, isDark),
            const SizedBox(height: 8),
            ...entry.value.map((notification) {
              final index = _notifications.indexOf(notification);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildNotificationCard(notification, index, isDark),
              );
            }),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Map<String, List<NotificationEntity>> _groupNotificationsByDate() {
    final grouped = <String, List<NotificationEntity>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final notification in _filteredNotifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      String key;
      if (notificationDate == today) {
        key = 'Today';
      } else if (notificationDate == yesterday) {
        key = 'Yesterday';
      } else {
        key = 'Earlier This Week';
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(notification);
    }

    return grouped;
  }

  Widget _buildDateHeader(String date, bool isDark) {
    return Text(
      date.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildNotificationCard(NotificationEntity notification, int index, bool isDark) {
    return GestureDetector(
      onTap: () {
        _markAsRead(index);
        Navigator.of(context).pushNamed('/checklist');
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: notification.isRead
              ? null
              : Border(
                  left: BorderSide(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurSm,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationIcon(notification.type, isDark),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              notification.timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.gray400,
                              ),
                            ),
                            if (notification.tag != null) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.gray100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  notification.tag!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.gray600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
            if (notification.hasActions)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _showToast('Invitation declined');
                          setState(() {
                            _notifications.removeAt(index);
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _markAsRead(index);
                          _showToast('Checklist added to your shared items');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Accept'),
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

  Widget _buildNotificationIcon(NotificationType type, bool isDark) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.reminder:
        icon = Icons.notifications_outlined;
        color = AppColors.primary;
        break;
      case NotificationType.shared:
        icon = Icons.share_outlined;
        color = AppColors.olive;
        break;
      case NotificationType.complete:
        icon = Icons.check_circle_outline;
        color = AppColors.success;
        break;
      case NotificationType.mention:
        icon = Icons.alternate_email;
        color = AppColors.terracotta;
        break;
      case NotificationType.comment:
        icon = Icons.chat_bubble_outline;
        color = AppColors.secondary;
        break;
      case NotificationType.update:
        icon = Icons.edit_outlined;
        color = AppColors.info;
        break;
      case NotificationType.deadline:
        icon = Icons.access_time;
        color = AppColors.error;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildSettingsLink(bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/profile'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurSm,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_outlined,
              size: 18,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
