import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';
import 'api_exceptions.dart';

/// HTTP client wrapper for API calls
class ApiClient {
  final http.Client _client;
  final Duration _timeout;

  ApiClient({
    http.Client? client,
    Duration? timeout,
  })  : _client = client ?? http.Client(),
        _timeout = timeout ?? const Duration(seconds: 30);

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      var uri = Uri.parse(ApiEndpoints.getFullUrl(endpoint));
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await _client
          .get(uri, headers: _buildHeaders(headers))
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getFullUrl(endpoint));
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getFullUrl(endpoint));
      final response = await _client
          .put(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getFullUrl(endpoint));
      final response = await _client
          .delete(uri, headers: _buildHeaders(headers))
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  /// Build headers
  Map<String, String> _buildHeaders(Map<String, String>? additionalHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Handle response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    }

    switch (statusCode) {
      case 400:
        throw BadRequestException(
          message: body?['message'] ?? 'Bad request',
          data: body,
        );
      case 401:
        throw UnauthorizedException(message: body?['message']);
      case 404:
        throw NotFoundException(message: body?['message']);
      case 500:
      case 502:
      case 503:
        throw ServerException(
          message: body?['message'],
          statusCode: statusCode,
        );
      default:
        throw ApiException(
          message: body?['message'] ?? 'Unknown error occurred',
          statusCode: statusCode,
        );
    }
  }

  /// Close the client
  void dispose() {
    _client.close();
  }
}
