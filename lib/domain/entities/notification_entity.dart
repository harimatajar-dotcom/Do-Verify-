/// Notification type enum
enum NotificationType {
  reminder,
  shared,
  complete,
  mention,
  comment,
  update,
  deadline,
}

/// Notification entity
class NotificationEntity {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? checklistId;
  final String? tag;
  final bool hasActions;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.checklistId,
    this.tag,
    this.hasActions = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()} week${diff.inDays >= 14 ? 's' : ''} ago';
    } else if (diff.inDays > 0) {
      if (diff.inDays == 1) return 'Yesterday';
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  NotificationEntity copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
    String? checklistId,
    String? tag,
    bool? hasActions,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      checklistId: checklistId ?? this.checklistId,
      tag: tag ?? this.tag,
      hasActions: hasActions ?? this.hasActions,
    );
  }

  static List<NotificationEntity> sampleData() {
    return [
      NotificationEntity(
        id: '1',
        type: NotificationType.mention,
        title: 'Sarah mentioned you in a comment',
        message: '"@you Can you review the final step before we launch?"',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        tag: 'Marketing Campaign Q1',
      ),
      NotificationEntity(
        id: '2',
        type: NotificationType.shared,
        title: 'Alex Lee shared a checklist with you',
        message: 'Sprint 24 Planning - Development tasks for the upcoming sprint',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        tag: 'Can Edit',
        hasActions: true,
      ),
      NotificationEntity(
        id: '3',
        type: NotificationType.deadline,
        title: 'Deadline approaching!',
        message: 'Project Launch checklist is due tomorrow. 3 tasks remaining.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        tag: 'Due Tomorrow',
      ),
      NotificationEntity(
        id: '4',
        type: NotificationType.complete,
        title: 'Checklist completed!',
        message: 'Great job! You completed "Weekly Review" checklist.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: true,
      ),
      NotificationEntity(
        id: '5',
        type: NotificationType.comment,
        title: 'New comment on your checklist',
        message: 'Mike Kim: "I\'ve updated the budget numbers in task 3"',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        tag: 'Product Roadmap',
        isRead: true,
      ),
      NotificationEntity(
        id: '6',
        type: NotificationType.update,
        title: 'Task updated',
        message: 'Jane Wilson marked "Schedule moving company" as complete',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        isRead: true,
      ),
      NotificationEntity(
        id: '7',
        type: NotificationType.reminder,
        title: 'Reminder: Daily standup checklist',
        message: 'Don\'t forget to complete your daily standup tasks',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        isRead: true,
      ),
    ];
  }
}
