import '../../domain/entities/template_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_local_datasource.dart';
import '../datasources/template_remote_datasource.dart';

/// Implementation of TemplateRepository
/// Uses local data source with fallback to remote
class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateLocalDataSource _localDataSource;
  final TemplateRemoteDataSource? _remoteDataSource;
  final bool _useRemote;

  TemplateRepositoryImpl({
    required TemplateLocalDataSource localDataSource,
    TemplateRemoteDataSource? remoteDataSource,
    bool useRemote = false,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _useRemote = useRemote;

  @override
  Future<List<TemplateEntity>> getAllTemplates() async {
    try {
      if (_useRemote && _remoteDataSource != null) {
        final models = await _remoteDataSource!.getAllTemplates();
        return models.map((m) => m.toEntity()).toList();
      }
    } catch (_) {
      // Fallback to local on error
    }

    final models = await _localDataSource.getAllTemplates();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<TemplateEntity>> getFeaturedTemplates() async {
    try {
      if (_useRemote && _remoteDataSource != null) {
        final models = await _remoteDataSource!.getFeaturedTemplates();
        return models.map((m) => m.toEntity()).toList();
      }
    } catch (_) {
      // Fallback to local on error
    }

    final models = await _localDataSource.getFeaturedTemplates();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TemplateEntity?> getTemplateById(String id) async {
    try {
      if (_useRemote && _remoteDataSource != null) {
        final model = await _remoteDataSource!.getTemplateById(id);
        return model?.toEntity();
      }
    } catch (_) {
      // Fallback to local on error
    }

    final model = await _localDataSource.getTemplateById(id);
    return model?.toEntity();
  }

  @override
  Future<List<TemplateEntity>> getTemplatesByCategory(Category category) async {
    try {
      if (_useRemote && _remoteDataSource != null) {
        final models = await _remoteDataSource!.getTemplatesByCategory(category.id);
        return models.map((m) => m.toEntity()).toList();
      }
    } catch (_) {
      // Fallback to local on error
    }

    final models = await _localDataSource.getTemplatesByCategory(category.id);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<TemplateEntity>> searchTemplates(String query) async {
    try {
      if (_useRemote && _remoteDataSource != null) {
        final models = await _remoteDataSource!.searchTemplates(query);
        return models.map((m) => m.toEntity()).toList();
      }
    } catch (_) {
      // Fallback to local on error
    }

    final models = await _localDataSource.searchTemplates(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<int> getTemplateCount() async {
    final templates = await getAllTemplates();
    return templates.length;
  }

  @override
  Future<int> getTemplateCountByCategory(Category category) async {
    if (category == Category.all) {
      return getTemplateCount();
    }
    final templates = await getTemplatesByCategory(category);
    return templates.length;
  }
}
