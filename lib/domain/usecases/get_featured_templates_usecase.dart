import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';

/// Use case to get featured templates
class GetFeaturedTemplatesUseCase {
  final TemplateRepository _repository;

  GetFeaturedTemplatesUseCase(this._repository);

  /// Execute the use case
  Future<List<TemplateEntity>> call() async {
    return await _repository.getFeaturedTemplates();
  }
}
