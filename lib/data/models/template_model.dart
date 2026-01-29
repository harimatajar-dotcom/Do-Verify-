import '../../domain/entities/template_entity.dart';
import '../../domain/entities/category_entity.dart';

/// Template model with JSON serialization
class TemplateModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> tasks;
  final bool isFeatured;
  final String? createdAt;
  final String? updatedAt;

  const TemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tasks,
    this.isFeatured = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from JSON
  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      tasks: (json['tasks'] as List<dynamic>).map((e) => e as String).toList(),
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'tasks': tasks,
      'isFeatured': isFeatured,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Convert to entity
  TemplateEntity toEntity() {
    return TemplateEntity(
      id: id,
      name: name,
      description: description,
      category: Category.fromId(category),
      tasks: tasks,
      isFeatured: isFeatured,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }

  /// Create from entity
  factory TemplateModel.fromEntity(TemplateEntity entity) {
    return TemplateModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category.id,
      tasks: entity.tasks,
      isFeatured: entity.isFeatured,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
}
