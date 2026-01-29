import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';

/// Use case to search templates
class SearchTemplatesUseCase {
  final TemplateRepository _repository;

  SearchTemplatesUseCase(this._repository);

  /// Execute the use case
  Future<List<TemplateEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return await _repository.getAllTemplates();
    }
    return await _repository.searchTemplates(query);
  }
}
