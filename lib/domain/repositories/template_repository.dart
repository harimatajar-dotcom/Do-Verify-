import '../entities/template_entity.dart';
import '../entities/category_entity.dart';

/// Abstract repository interface for templates
/// This defines the contract that data layer must implement
abstract class TemplateRepository {
  /// Get all templates
  Future<List<TemplateEntity>> getAllTemplates();

  /// Get featured templates
  Future<List<TemplateEntity>> getFeaturedTemplates();

  /// Get template by ID
  Future<TemplateEntity?> getTemplateById(String id);

  /// Get templates by category
  Future<List<TemplateEntity>> getTemplatesByCategory(Category category);

  /// Search templates by query
  Future<List<TemplateEntity>> searchTemplates(String query);

  /// Get template count
  Future<int> getTemplateCount();

  /// Get template count by category
  Future<int> getTemplateCountByCategory(Category category);
}
