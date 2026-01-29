import '../../domain/entities/task_entity.dart';

/// Task model with JSON serialization
class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  /// Create from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  /// Convert to entity
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      isCompleted: isCompleted,
    );
  }

  /// Create from entity
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      isCompleted: entity.isCompleted,
    );
  }

  /// Create from simple string (for template tasks)
  factory TaskModel.fromString(String title, int index) {
    return TaskModel(
      id: 'task_$index',
      title: title,
      isCompleted: false,
    );
  }
}
