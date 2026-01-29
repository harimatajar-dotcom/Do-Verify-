/// App string constants for CheckFlow
/// Centralized location for all text content
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'CheckFlow';
  static const String appTagline = 'Task Management Made Simple';

  // Navigation
  static const String navHome = 'Home';
  static const String navTemplates = 'Templates';
  static const String navCreate = 'Create';
  static const String navShared = 'Shared';
  static const String navProfile = 'Profile';

  // Templates Screen
  static const String templatesTitle = 'Templates';
  static const String templatesSubtitle = '200+ professionally designed templates';
  static const String searchPlaceholder = 'Search templates...';
  static const String featuredTitle = 'Featured';
  static const String featuredSubtitle = 'Handpicked for you';
  static const String allTemplatesTitle = 'All Templates';
  static const String tasksIncluded = 'Tasks included';
  static const String useThisTemplate = 'Use This Template';
  static const String cancel = 'Cancel';

  // Categories
  static const String categoryAll = 'All';
  static const String categoryWork = 'Work';
  static const String categoryPersonal = 'Personal';
  static const String categoryDev = 'Dev';
  static const String categoryHealth = 'Health';

  // Category Full Names
  static const String categoryWorkFull = 'Work Templates';
  static const String categoryPersonalFull = 'Personal Templates';
  static const String categoryDevFull = 'Development Templates';
  static const String categoryHealthFull = 'Health & Wellness';

  // Section Titles
  static const String featuredTemplates = 'Featured';
  static const String allTemplates = 'All Templates';
  static const String searchResults = 'Search Results';

  // Empty States
  static const String noTemplatesFound = 'No templates found';
  static const String noTemplatesTitle = 'No Templates';
  static const String noTemplatesMessage = 'Try adjusting your search or filter criteria.';
  static const String noSearchResults = 'No results found for your search.';

  // Error States
  static const String errorTitle = 'Oops!';
  static const String retry = 'Retry';

  // Toast Messages
  static const String templateInfo = 'Browse and use our 200+ professional templates!';
  static const String templateAdded = 'Template added to your tasks!';
  static const String errorOccurred = 'An error occurred. Please try again.';

  // Task Counts
  static String taskCount(int count) => '$count tasks';
  static String templateCount(int count) => '$count templates';

  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'Something went wrong.';

  // Loading
  static const String loading = 'Loading...';
  static const String loadingTemplates = 'Loading templates...';
}
