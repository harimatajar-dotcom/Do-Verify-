import '../entities/template_entity.dart';
import '../entities/category_entity.dart';
import '../repositories/template_repository.dart';

/// Use case to filter templates by category
class FilterTemplatesByCategoryUseCase {
  final TemplateRepository _repository;

  FilterTemplatesByCategoryUseCase(this._repository);

  /// Execute the use case
  Future<List<TemplateEntity>> call(Category category) async {
    if (category == Category.all) {
      return await _repository.getAllTemplates();
    }
    return await _repository.getTemplatesByCategory(category);
  }
}
