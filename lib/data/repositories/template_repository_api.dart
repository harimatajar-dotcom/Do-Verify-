import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../services/auth_service.dart';

/// Repository for template operations via API
class TemplateRepositoryApi {
  final ApiClient _apiClient;
  final AuthService _authService;

  TemplateRepositoryApi({
    ApiClient? apiClient,
    AuthService? authService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _authService = authService ?? AuthService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getToken();
    if (token != null) {
      return {'Authorization': 'Bearer $token'};
    }
    return {};
  }

  /// Get all templates
  Future<List<TemplateEntity>> getAllTemplates() async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.get(
      ApiEndpoints.templates,
      headers: headers,
    );

    final List<dynamic> data = response['templates'] ?? response ?? [];
    return data.map((json) => TemplateEntity.fromJson(json)).toList();
  }

  /// Get featured templates
  Future<List<TemplateEntity>> getFeaturedTemplates() async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.get(
      ApiEndpoints.featuredTemplates,
      headers: headers,
    );

    final List<dynamic> data = response['templates'] ?? response ?? [];
    return data.map((json) => TemplateEntity.fromJson(json)).toList();
  }

  /// Get template by ID
  Future<TemplateEntity?> getTemplateById(String id) async {
    final headers = await _getAuthHeaders();
    try {
      final response = await _apiClient.get(
        ApiEndpoints.templateById(id),
        headers: headers,
      );
      return TemplateEntity.fromJson(response);
    } catch (_) {
      return null;
    }
  }

  /// Get templates by category
  Future<List<TemplateEntity>> getTemplatesByCategory(Category category) async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.get(
      ApiEndpoints.templatesByCategory(category.name),
      headers: headers,
    );

    final List<dynamic> data = response['templates'] ?? response ?? [];
    return data.map((json) => TemplateEntity.fromJson(json)).toList();
  }

  /// Search templates
  Future<List<TemplateEntity>> searchTemplates(String query) async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.get(
      ApiEndpoints.searchTemplates(query),
      headers: headers,
    );

    final List<dynamic> data = response['templates'] ?? response ?? [];
    return data.map((json) => TemplateEntity.fromJson(json)).toList();
  }

  /// Create checklist from template
  Future<void> useTemplate(String templateId) async {
    final headers = await _getAuthHeaders();
    await _apiClient.post(
      '${ApiEndpoints.templateById(templateId)}/use',
      headers: headers,
    );
  }
}
