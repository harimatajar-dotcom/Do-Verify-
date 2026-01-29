import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for managing authentication tokens securely
class AuthService {
  static const _tokenKey = 'jwt_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  
  final FlutterSecureStorage _storage;
  
  AuthService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save JWT token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Get JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all auth data (logout)
  Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }
}
