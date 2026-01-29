import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../domain/entities/user_entity.dart';
import '../services/auth_service.dart';

/// Repository for authentication operations
class AuthRepository {
  final ApiClient _apiClient;
  final AuthService _authService;

  AuthRepository({
    ApiClient? apiClient,
    AuthService? authService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _authService = authService ?? AuthService();

  /// Login with email and password
  Future<UserEntity> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    // Save tokens
    if (response['token'] != null) {
      await _authService.saveToken(response['token']);
    }
    if (response['refreshToken'] != null) {
      await _authService.saveRefreshToken(response['refreshToken']);
    }
    if (response['user']?['_id'] != null) {
      await _authService.saveUserId(response['user']['_id']);
    }

    return UserEntity.fromJson(response['user']);
  }

  /// Register new user
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    // Save tokens
    if (response['token'] != null) {
      await _authService.saveToken(response['token']);
    }
    if (response['refreshToken'] != null) {
      await _authService.saveRefreshToken(response['refreshToken']);
    }
    if (response['user']?['_id'] != null) {
      await _authService.saveUserId(response['user']['_id']);
    }

    return UserEntity.fromJson(response['user']);
  }

  /// Logout
  Future<void> logout() async {
    try {
      final token = await _authService.getToken();
      if (token != null) {
        await _apiClient.post(
          ApiEndpoints.logout,
          headers: {'Authorization': 'Bearer $token'},
        );
      }
    } catch (_) {
      // Ignore errors, clear local data anyway
    }
    await _authService.clearAll();
  }

  /// Get current user
  Future<UserEntity?> getCurrentUser() async {
    final token = await _authService.getToken();
    if (token == null) return null;

    try {
      final response = await _apiClient.get(
        ApiEndpoints.userMe,
        headers: {'Authorization': 'Bearer $token'},
      );
      return UserEntity.fromJson(response);
    } catch (_) {
      return null;
    }
  }

  /// Check if logged in
  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  /// Get auth token for API calls
  Future<String?> getToken() async {
    return await _authService.getToken();
  }
}
