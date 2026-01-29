import 'task_entity.dart';

/// Checklist status enum
enum ChecklistStatus {
  inProgress,
  completed,
  shared,
}

/// Checklist entity representing a user's checklist
class ChecklistEntity {
  final String id;
  final String title;
  final String? description;
  final List<TaskEntity> tasks;
  final ChecklistStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? ownerId;
  final String? ownerName;
  final String? ownerInitials;
  final List<String>? sharedWith;
  final String? permission; // 'edit' or 'view'
  final String? color;

  const ChecklistEntity({
    required this.id,
    required this.title,
    this.description,
    required this.tasks,
    this.status = ChecklistStatus.inProgress,
    required this.createdAt,
    this.updatedAt,
    this.ownerId,
    this.ownerName,
    this.ownerInitials,
    this.sharedWith,
    this.permission,
    this.color,
  });

  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((t) => t.isCompleted).length;

  double get progress => totalTasks > 0 ? completedTasks / totalTasks : 0.0;

  int get progressPercent => (progress * 100).round();

  bool get isCompleted => progress == 1.0;

  bool get isShared => sharedWith != null && sharedWith!.isNotEmpty;

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()} week${diff.inDays >= 14 ? 's' : ''} ago';
    } else if (diff.inDays > 0) {
      return diff.inDays == 1 ? 'yesterday' : '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

  ChecklistEntity copyWith({
    String? id,
    String? title,
    String? description,
    List<TaskEntity>? tasks,
    ChecklistStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
    String? ownerName,
    String? ownerInitials,
    List<String>? sharedWith,
    String? permission,
    String? color,
  }) {
    return ChecklistEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerInitials: ownerInitials ?? this.ownerInitials,
      sharedWith: sharedWith ?? this.sharedWith,
      permission: permission ?? this.permission,
      color: color ?? this.color,
    );
  }

  static List<ChecklistEntity> sampleData() {
    return [
      ChecklistEntity(
        id: '1',
        title: 'Project Launch',
        description: 'Launch the new marketing website with all required features',
        tasks: [
          const TaskEntity(id: '1', title: 'Finalize design mockups', isCompleted: true),
          const TaskEntity(id: '2', title: 'Complete frontend development', isCompleted: true),
          const TaskEntity(id: '3', title: 'Set up analytics'),
          const TaskEntity(id: '4', title: 'Write launch announcement'),
          const TaskEntity(id: '5', title: 'Schedule social media posts'),
        ],
        status: ChecklistStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ChecklistEntity(
        id: '2',
        title: 'Weekly Groceries',
        description: 'Shopping list for the week',
        tasks: [
          const TaskEntity(id: '1', title: 'Milk', isCompleted: true),
          const TaskEntity(id: '2', title: 'Bread', isCompleted: true),
          const TaskEntity(id: '3', title: 'Eggs', isCompleted: true),
          const TaskEntity(id: '4', title: 'Vegetables', isCompleted: true),
          const TaskEntity(id: '5', title: 'Fruits', isCompleted: true),
        ],
        status: ChecklistStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ChecklistEntity(
        id: '3',
        title: 'Morning Routine',
        description: 'Daily morning tasks',
        tasks: [
          const TaskEntity(id: '1', title: 'Wake up early', isCompleted: true),
          const TaskEntity(id: '2', title: 'Drink water'),
          const TaskEntity(id: '3', title: 'Exercise'),
          const TaskEntity(id: '4', title: 'Healthy breakfast'),
          const TaskEntity(id: '5', title: 'Review goals'),
        ],
        status: ChecklistStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ChecklistEntity(
        id: '4',
        title: 'Team Sprint Planning',
        description: 'Sprint planning tasks',
        tasks: [
          const TaskEntity(id: '1', title: 'Review backlog', isCompleted: true),
          const TaskEntity(id: '2', title: 'Estimate stories', isCompleted: true),
          const TaskEntity(id: '3', title: 'Assign tasks', isCompleted: true),
          const TaskEntity(id: '4', title: 'Set sprint goals', isCompleted: true),
          const TaskEntity(id: '5', title: 'Update board', isCompleted: true),
          const TaskEntity(id: '6', title: 'Notify team'),
          const TaskEntity(id: '7', title: 'Schedule standups'),
          const TaskEntity(id: '8', title: 'Create documentation'),
        ],
        status: ChecklistStatus.shared,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        sharedWith: ['user1', 'user2', 'user3'],
      ),
      ChecklistEntity(
        id: '5',
        title: 'Vacation Packing',
        description: 'Packing list for upcoming trip',
        tasks: [
          const TaskEntity(id: '1', title: 'Check passport', isCompleted: true),
          const TaskEntity(id: '2', title: 'Book accommodation', isCompleted: true),
          const TaskEntity(id: '3', title: 'Pack clothes', isCompleted: true),
          const TaskEntity(id: '4', title: 'Prepare toiletries', isCompleted: true),
          const TaskEntity(id: '5', title: 'Charge devices', isCompleted: true),
          const TaskEntity(id: '6', title: 'Download maps', isCompleted: true),
          const TaskEntity(id: '7', title: 'Notify bank', isCompleted: true),
          const TaskEntity(id: '8', title: 'Arrange pet care', isCompleted: true),
          const TaskEntity(id: '9', title: 'Set out-of-office', isCompleted: true),
          const TaskEntity(id: '10', title: 'Print itinerary'),
          const TaskEntity(id: '11', title: 'Pack snacks'),
          const TaskEntity(id: '12', title: 'Check weather'),
        ],
        status: ChecklistStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}
