import '../../domain/entities/category_entity.dart';

/// Category model with JSON serialization
class CategoryModel {
  final String id;
  final String name;
  final String fullName;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.fullName,
  });

  /// Create from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String? ?? json['name'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
    };
  }

  /// Convert to entity
  Category toEntity() {
    return Category.fromId(id);
  }

  /// Create from entity
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      fullName: category.fullName,
    );
  }
}
