import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';

/// Use case to get a template by its ID
class GetTemplateByIdUseCase {
  final TemplateRepository _repository;

  GetTemplateByIdUseCase(this._repository);

  /// Execute the use case
  Future<TemplateEntity?> call(String id) async {
    return await _repository.getTemplateById(id);
  }
}
