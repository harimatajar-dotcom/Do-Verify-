/// API endpoints for Do-Verify
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://api.do-verify.com/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User endpoints
  static const String userMe = '/users/me';
  static const String userProfile = '/users/profile';
  static String userById(String id) => '/users/$id';

  // Checklists endpoints
  static const String checklists = '/checklists';
  static String checklistById(String id) => '/checklists/$id';
  static String checklistTasks(String id) => '/checklists/$id/tasks';
  static String checklistShare(String id) => '/checklists/$id/share';
  static String checklistDuplicate(String id) => '/checklists/$id/duplicate';

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

  // Organizations
  static const String organizations = '/organizations';
  static String organizationById(String id) => '/organizations/$id';
  static String organizationMembers(String id) => '/organizations/$id/members';

  // Teams
  static const String teams = '/teams';
  static String teamById(String id) => '/teams/$id';
  static String teamMembers(String id) => '/teams/$id/members';

  // Notifications
  static const String notifications = '/notifications';
  static String notificationById(String id) => '/notifications/$id';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read';

  // Full URL builders
  static String getFullUrl(String endpoint) => '$baseUrl$endpoint';
}
