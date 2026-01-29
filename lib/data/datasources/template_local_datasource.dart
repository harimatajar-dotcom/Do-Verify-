import '../models/template_model.dart';

/// Local data source for templates
/// Contains hardcoded template data matching the HTML reference
class TemplateLocalDataSource {
  /// Get all templates from local storage
  Future<List<TemplateModel>> getAllTemplates() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _templates;
  }

  /// Get featured templates
  Future<List<TemplateModel>> getFeaturedTemplates() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _templates.where((t) => t.isFeatured).toList();
  }

  /// Get template by ID
  Future<TemplateModel?> getTemplateById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _templates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get templates by category
  Future<List<TemplateModel>> getTemplatesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _templates.where((t) => t.category == category).toList();
  }

  /// Search templates
  Future<List<TemplateModel>> searchTemplates(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final lowerQuery = query.toLowerCase();
    return _templates.where((t) {
      return t.name.toLowerCase().contains(lowerQuery) ||
          t.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Template data matching the HTML file
  static final List<TemplateModel> _templates = [
    // Work Templates
    const TemplateModel(
      id: 'project-launch',
      name: 'Project Launch',
      description: 'Complete checklist for launching a new project successfully',
      category: 'work',
      isFeatured: true,
      tasks: [
        'Define project scope and objectives',
        'Identify key stakeholders',
        'Create project timeline',
        'Allocate resources and budget',
        'Set up communication channels',
        'Kick-off meeting scheduled',
      ],
    ),
    const TemplateModel(
      id: 'meeting-prep',
      name: 'Meeting Preparation',
      description: 'Ensure productive meetings with proper preparation',
      category: 'work',
      isFeatured: false,
      tasks: [
        'Define meeting objective',
        'Create and share agenda',
        'Prepare presentation materials',
        'Test technical setup',
        'Send calendar invites',
      ],
    ),
    const TemplateModel(
      id: 'employee-onboarding',
      name: 'Employee Onboarding',
      description: 'Comprehensive onboarding checklist for new team members',
      category: 'work',
      isFeatured: false,
      tasks: [
        'Prepare workstation and equipment',
        'Set up email and accounts',
        'Introduce to team members',
        'Review company policies',
        'Assign first week tasks',
        'Schedule 30-day check-in',
      ],
    ),

    // Personal Templates
    const TemplateModel(
      id: 'travel-packing',
      name: 'Travel Packing',
      description: 'Never forget essentials with this travel packing list',
      category: 'personal',
      isFeatured: true,
      tasks: [
        'Check passport/ID validity',
        'Book accommodation',
        'Pack clothing for weather',
        'Prepare toiletries bag',
        'Charge all devices',
        'Download offline maps',
        'Notify bank of travel',
      ],
    ),
    const TemplateModel(
      id: 'moving-house',
      name: 'Moving House',
      description: 'Complete moving checklist to ensure a smooth transition',
      category: 'personal',
      isFeatured: false,
      tasks: [
        'Sort and declutter belongings',
        'Gather packing supplies',
        'Notify utilities of move',
        'Update address with services',
        'Book moving company',
        'Pack room by room',
        'Clean old residence',
      ],
    ),
    const TemplateModel(
      id: 'event-planning',
      name: 'Event Planning',
      description: 'Plan and execute memorable events',
      category: 'personal',
      isFeatured: false,
      tasks: [
        'Set event date and time',
        'Create guest list',
        'Book venue',
        'Arrange catering',
        'Send invitations',
        'Plan entertainment',
      ],
    ),

    // Dev Templates
    const TemplateModel(
      id: 'code-review',
      name: 'Code Review',
      description: 'Thorough code review checklist for quality assurance',
      category: 'dev',
      isFeatured: true,
      tasks: [
        'Check code style consistency',
        'Review business logic',
        'Look for security issues',
        'Verify error handling',
        'Check test coverage',
        'Review documentation',
        'Test locally',
      ],
    ),
    const TemplateModel(
      id: 'deployment',
      name: 'Deployment Checklist',
      description: 'Safe deployment process for production releases',
      category: 'dev',
      isFeatured: true,
      tasks: [
        'Run all tests',
        'Review changelog',
        'Backup database',
        'Check environment variables',
        'Deploy to staging first',
        'Monitor error rates',
        'Notify team of deployment',
      ],
    ),
    const TemplateModel(
      id: 'bug-fix',
      name: 'Bug Fix Process',
      description: 'Systematic approach to fixing and preventing bugs',
      category: 'dev',
      isFeatured: false,
      tasks: [
        'Reproduce the bug',
        'Identify root cause',
        'Write failing test',
        'Implement fix',
        'Verify fix works',
        'Check for regressions',
        'Update documentation',
      ],
    ),

    // Health Templates
    const TemplateModel(
      id: 'morning-routine',
      name: 'Morning Routine',
      description: 'Start your day right with a healthy morning routine',
      category: 'health',
      isFeatured: true,
      tasks: [
        'Wake up at consistent time',
        'Drink water',
        'Morning stretch or yoga',
        'Healthy breakfast',
        'Review daily goals',
        'Mindfulness practice',
      ],
    ),
    const TemplateModel(
      id: 'weekly-meal-prep',
      name: 'Weekly Meal Prep',
      description: 'Save time and eat healthy with meal preparation',
      category: 'health',
      isFeatured: false,
      tasks: [
        'Plan weekly menu',
        'Create shopping list',
        'Go grocery shopping',
        'Prep vegetables',
        'Cook proteins',
        'Portion into containers',
        'Label with dates',
      ],
    ),
    const TemplateModel(
      id: 'workout-routine',
      name: 'Workout Routine',
      description: 'Complete workout session checklist',
      category: 'health',
      isFeatured: false,
      tasks: [
        'Warm up (5-10 min)',
        'Main workout',
        'Cool down',
        'Stretch muscles',
        'Rehydrate',
        'Log workout',
      ],
    ),
  ];
}
