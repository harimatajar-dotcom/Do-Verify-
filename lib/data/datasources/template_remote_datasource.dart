import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/template_model.dart';

/// Remote data source for templates
/// Handles API calls for template data
class TemplateRemoteDataSource {
  final ApiClient _apiClient;

  TemplateRemoteDataSource(this._apiClient);

  /// Get all templates from API
  Future<List<TemplateModel>> getAllTemplates() async {
    final response = await _apiClient.get(ApiEndpoints.templates);
    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => TemplateModel.fromJson(json)).toList();
  }

  /// Get featured templates from API
  Future<List<TemplateModel>> getFeaturedTemplates() async {
    final response = await _apiClient.get(ApiEndpoints.featuredTemplates);
    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => TemplateModel.fromJson(json)).toList();
  }

  /// Get template by ID from API
  Future<TemplateModel?> getTemplateById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.templateById(id));
      if (response['data'] != null) {
        return TemplateModel.fromJson(response['data']);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get templates by category from API
  Future<List<TemplateModel>> getTemplatesByCategory(String category) async {
    final response = await _apiClient.get(
      ApiEndpoints.templatesByCategory(category),
    );
    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => TemplateModel.fromJson(json)).toList();
  }

  /// Search templates from API
  Future<List<TemplateModel>> searchTemplates(String query) async {
    final response = await _apiClient.get(
      ApiEndpoints.searchTemplates(query),
    );
    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => TemplateModel.fromJson(json)).toList();
  }
}
