import 'category_entity.dart';

/// Template entity representing a checklist template
class TemplateEntity {
  final String id;
  final String name;
  final String description;
  final Category category;
  final List<String> tasks;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TemplateEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tasks,
    this.isFeatured = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Get task count
  int get taskCount => tasks.length;

  /// Create a copy with updated fields
  TemplateEntity copyWith({
    String? id,
    String? name,
    String? description,
    Category? category,
    List<String>? tasks,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TemplateEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      tasks: tasks ?? this.tasks,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TemplateEntity(id: $id, name: $name, category: ${category.name})';
}
