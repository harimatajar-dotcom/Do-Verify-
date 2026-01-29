/// Custom exceptions for API calls
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Network connection exception
class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'Network connection failed. Please check your internet.',
          statusCode: null,
        );
}

/// Server exception (5xx errors)
class ServerException extends ApiException {
  ServerException({String? message, int? statusCode})
      : super(
          message: message ?? 'Server error. Please try again later.',
          statusCode: statusCode,
        );
}

/// Not found exception (404)
class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'Resource not found.',
          statusCode: 404,
        );
}

/// Unauthorized exception (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'Unauthorized. Please login again.',
          statusCode: 401,
        );
}

/// Bad request exception (400)
class BadRequestException extends ApiException {
  BadRequestException({String? message, dynamic data})
      : super(
          message: message ?? 'Invalid request.',
          statusCode: 400,
          data: data,
        );
}

/// Timeout exception
class TimeoutException extends ApiException {
  TimeoutException({String? message})
      : super(
          message: message ?? 'Request timed out. Please try again.',
          statusCode: null,
        );
}

/// Cache exception
class CacheException extends ApiException {
  CacheException({String? message})
      : super(
          message: message ?? 'Failed to load cached data.',
          statusCode: null,
        );
}
