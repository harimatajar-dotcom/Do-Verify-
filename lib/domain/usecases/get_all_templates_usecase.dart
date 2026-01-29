import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';

/// Use case to get all templates
class GetAllTemplatesUseCase {
  final TemplateRepository _repository;

  GetAllTemplatesUseCase(this._repository);

  /// Execute the use case
  Future<List<TemplateEntity>> call() async {
    return await _repository.getAllTemplates();
  }
}
