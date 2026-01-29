/// API endpoints for CheckFlow
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://api.checkflow.com/v1';

  // Templates
  static const String templates = '/templates';
  static const String featuredTemplates = '/templates/featured';
  static String templateById(String id) => '/templates/$id';
  static String templatesByCategory(String category) =>
      '/templates/category/$category';
  static String searchTemplates(String query) =>
      '/templates/search?q=$query';

  // Categories
  static const String categories = '/categories';

  // User
  static const String user = '/user';
  static const String userTemplates = '/user/templates';

  // Full URL builders
  static String getFullUrl(String endpoint) => '$baseUrl$endpoint';
}
