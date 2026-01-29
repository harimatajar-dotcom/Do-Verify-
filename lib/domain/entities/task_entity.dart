/// Task entity representing a single task item
class TaskEntity {
  final String id;
  final String title;
  final bool isCompleted;

  const TaskEntity({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  /// Create a copy with updated fields
  TaskEntity copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isCompleted.hashCode;

  @override
  String toString() => 'TaskEntity(id: $id, title: $title, isCompleted: $isCompleted)';

  /// Create from JSON
  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['text'] ?? json['title'] ?? '',
      isCompleted: json['completed'] ?? json['isCompleted'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': title,
      'completed': isCompleted,
    };
  }
}
