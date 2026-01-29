import 'package:flutter/foundation.dart' hide Category;
import '../../domain/entities/template_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_all_templates_usecase.dart';
import '../../domain/usecases/get_featured_templates_usecase.dart';
import '../../domain/usecases/get_template_by_id_usecase.dart';
import '../../domain/usecases/search_templates_usecase.dart';
import '../../domain/usecases/filter_templates_by_category_usecase.dart';

/// Provider state enum
enum TemplateState {
  initial,
  loading,
  loaded,
  error,
}

/// Provider for managing template state
class TemplateProvider extends ChangeNotifier {
  final GetAllTemplatesUseCase _getAllTemplatesUseCase;
  final GetFeaturedTemplatesUseCase _getFeaturedTemplatesUseCase;
  final GetTemplateByIdUseCase _getTemplateByIdUseCase;
  final SearchTemplatesUseCase _searchTemplatesUseCase;
  final FilterTemplatesByCategoryUseCase _filterTemplatesByCategoryUseCase;

  TemplateProvider({
    required GetAllTemplatesUseCase getAllTemplatesUseCase,
    required GetFeaturedTemplatesUseCase getFeaturedTemplatesUseCase,
    required GetTemplateByIdUseCase getTemplateByIdUseCase,
    required SearchTemplatesUseCase searchTemplatesUseCase,
    required FilterTemplatesByCategoryUseCase filterTemplatesByCategoryUseCase,
  })  : _getAllTemplatesUseCase = getAllTemplatesUseCase,
        _getFeaturedTemplatesUseCase = getFeaturedTemplatesUseCase,
        _getTemplateByIdUseCase = getTemplateByIdUseCase,
        _searchTemplatesUseCase = searchTemplatesUseCase,
        _filterTemplatesByCategoryUseCase = filterTemplatesByCategoryUseCase;

  // State
  TemplateState _state = TemplateState.initial;
  String? _errorMessage;

  // Data
  List<TemplateEntity> _allTemplates = [];
  List<TemplateEntity> _featuredTemplates = [];
  List<TemplateEntity> _filteredTemplates = [];
  TemplateEntity? _selectedTemplate;

  // Filters
  Category _selectedCategory = Category.all;
  String _searchQuery = '';

  // Getters
  TemplateState get state => _state;
  String? get errorMessage => _errorMessage;
  List<TemplateEntity> get allTemplates => _allTemplates;
  List<TemplateEntity> get featuredTemplates => _featuredTemplates;
  List<TemplateEntity> get filteredTemplates => _filteredTemplates;
  TemplateEntity? get selectedTemplate => _selectedTemplate;
  Category get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  bool get isLoading => _state == TemplateState.loading;
  bool get hasError => _state == TemplateState.error;
  bool get isLoaded => _state == TemplateState.loaded;

  // Alias for errorMessage used in screens
  String? get error => _errorMessage;

  int get filteredCount => _filteredTemplates.length;
  int get totalCount => _allTemplates.length;

  bool get showFeatured =>
      _selectedCategory == Category.all && _searchQuery.isEmpty;

  /// Initialize and load all data
  Future<void> initialize() async {
    await loadAllTemplates();
    await loadFeaturedTemplates();
  }

  /// Load all templates
  Future<void> loadAllTemplates() async {
    _state = TemplateState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _allTemplates = await _getAllTemplatesUseCase();
      _filteredTemplates = _allTemplates;
      _state = TemplateState.loaded;
    } catch (e) {
      _state = TemplateState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Load featured templates
  Future<void> loadFeaturedTemplates() async {
    try {
      _featuredTemplates = await _getFeaturedTemplatesUseCase();
      notifyListeners();
    } catch (_) {
      // Keep existing featured templates on error
    }
  }

  /// Get template by ID
  Future<TemplateEntity?> getTemplateById(String id) async {
    try {
      _selectedTemplate = await _getTemplateByIdUseCase(id);
      notifyListeners();
      return _selectedTemplate;
    } catch (_) {
      return null;
    }
  }

  /// Set selected template
  void setSelectedTemplate(TemplateEntity? template) {
    _selectedTemplate = template;
    notifyListeners();
  }

  /// Clear selected template
  void clearSelectedTemplate() {
    _selectedTemplate = null;
    notifyListeners();
  }

  /// Set category filter
  Future<void> setCategory(Category category) async {
    if (_selectedCategory == category) return;

    _selectedCategory = category;
    await _applyFilters();
  }

  /// Set search query
  Future<void> setSearchQuery(String query) async {
    if (_searchQuery == query) return;

    _searchQuery = query;
    await _applyFilters();
  }

  /// Clear search query
  Future<void> clearSearch() async {
    if (_searchQuery.isEmpty) return;

    _searchQuery = '';
    await _applyFilters();
  }

  /// Reset all filters
  Future<void> resetFilters() async {
    _selectedCategory = Category.all;
    _searchQuery = '';
    _filteredTemplates = _allTemplates;
    notifyListeners();
  }

  /// Apply current filters
  Future<void> _applyFilters() async {
    _state = TemplateState.loading;
    notifyListeners();

    try {
      List<TemplateEntity> results;

      // Apply search if query exists
      if (_searchQuery.isNotEmpty) {
        results = await _searchTemplatesUseCase(_searchQuery);
      } else {
        results = _allTemplates;
      }

      // Apply category filter
      if (_selectedCategory != Category.all) {
        results = results
            .where((t) => t.category == _selectedCategory)
            .toList();
      }

      _filteredTemplates = results;
      _state = TemplateState.loaded;
    } catch (e) {
      _state = TemplateState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Get category title based on current filter
  String getCategoryTitle() {
    return _selectedCategory.fullName;
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadAllTemplates();
    await loadFeaturedTemplates();
    await _applyFilters();
  }

  // Convenience methods for screen usage

  /// Alias for initialize - loads all templates and featured
  Future<void> loadTemplates() => initialize();

  /// Alias for setSearchQuery - search templates by query
  Future<void> searchTemplates(String query) => setSearchQuery(query);

  /// Alias for setCategory - filter templates by category
  Future<void> filterByCategory(Category category) => setCategory(category);
}
