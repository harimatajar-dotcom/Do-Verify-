import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../domain/entities/checklist_entity.dart';
import '../services/auth_service.dart';

/// Repository for checklist operations
class ChecklistRepository {
  final ApiClient _apiClient;
  final AuthService _authService;

  ChecklistRepository({
    ApiClient? apiClient,
    AuthService? authService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _authService = authService ?? AuthService();

  /// Get auth headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getToken();
    return {
      'Authorization': 'Bearer $token',
    };
  }

  /// Get all checklists
  Future<List<ChecklistEntity>> getChecklists() async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.get(
      ApiEndpoints.checklists,
      headers: headers,
    );

    final List<dynamic> data = response['checklists'] ?? response ?? [];
    return data.map((json) => ChecklistEntity.fromJson(json)).toList();
  }

  /// Get single checklist by ID
  Future<ChecklistEntity> getChecklistById(String id) async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.get(
      ApiEndpoints.checklistById(id),
      headers: headers,
    );

    return ChecklistEntity.fromJson(response);
  }

  /// Create new checklist
  Future<ChecklistEntity> createChecklist({
    required String name,
    String? description,
    List<String>? tasks,
  }) async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.post(
      ApiEndpoints.checklists,
      headers: headers,
      body: {
        'name': name,
        if (description != null) 'description': description,
        if (tasks != null) 'tasks': tasks.map((t) => {'text': t}).toList(),
      },
    );

    return ChecklistEntity.fromJson(response);
  }

  /// Update checklist
  Future<ChecklistEntity> updateChecklist(String id, {
    String? name,
    String? description,
  }) async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.put(
      ApiEndpoints.checklistById(id),
      headers: headers,
      body: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
      },
    );

    return ChecklistEntity.fromJson(response);
  }

  /// Delete checklist
  Future<void> deleteChecklist(String id) async {
    final headers = await _getAuthHeaders();
    await _apiClient.delete(
      ApiEndpoints.checklistById(id),
      headers: headers,
    );
  }

  /// Toggle task completion
  Future<ChecklistEntity> toggleTask(String checklistId, String taskId) async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.put(
      '${ApiEndpoints.checklistById(checklistId)}/tasks/$taskId/toggle',
      headers: headers,
    );

    return ChecklistEntity.fromJson(response);
  }

  /// Add task to checklist
  Future<ChecklistEntity> addTask(String checklistId, String taskText) async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.post(
      ApiEndpoints.checklistTasks(checklistId),
      headers: headers,
      body: {'text': taskText},
    );

    return ChecklistEntity.fromJson(response);
  }

  /// Share checklist
  Future<String> shareChecklist(String id) async {
    final headers = await _getAuthHeaders();
    final response = await _apiClient.post(
      ApiEndpoints.checklistShare(id),
      headers: headers,
    );

    return response['shareId'] ?? '';
  }
}
