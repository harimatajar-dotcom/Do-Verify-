import 'package:flutter/foundation.dart';
import '../../data/repositories/checklist_repository.dart';
import '../../domain/entities/checklist_entity.dart';

/// Provider for checklist state management
class ChecklistProvider extends ChangeNotifier {
  final ChecklistRepository _repository;

  List<ChecklistEntity> _checklists = [];
  bool _isLoading = false;
  String? _error;

  ChecklistProvider({ChecklistRepository? repository})
      : _repository = repository ?? ChecklistRepository();

  List<ChecklistEntity> get checklists => _checklists;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Filter checklists by status
  List<ChecklistEntity> getByStatus(String status) {
    switch (status) {
      case 'in-progress':
        return _checklists.where((c) => c.status == ChecklistStatus.inProgress).toList();
      case 'completed':
        return _checklists.where((c) => c.status == ChecklistStatus.completed).toList();
      case 'shared':
        return _checklists.where((c) => c.status == ChecklistStatus.shared).toList();
      default:
        return _checklists;
    }
  }

  /// Load all checklists
  Future<void> loadChecklists() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _checklists = await _repository.getChecklists();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create new checklist
  Future<bool> createChecklist({
    required String name,
    String? description,
    List<String>? tasks,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final checklist = await _repository.createChecklist(
        name: name,
        description: description,
        tasks: tasks,
      );
      _checklists.insert(0, checklist);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete checklist
  Future<bool> deleteChecklist(String id) async {
    try {
      await _repository.deleteChecklist(id);
      _checklists.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Toggle task completion
  Future<void> toggleTask(String checklistId, String taskId) async {
    try {
      final updated = await _repository.toggleTask(checklistId, taskId);
      final index = _checklists.indexWhere((c) => c.id == checklistId);
      if (index != -1) {
        _checklists[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Add task to checklist
  Future<void> addTask(String checklistId, String taskText) async {
    try {
      final updated = await _repository.addTask(checklistId, taskText);
      final index = _checklists.indexWhere((c) => c.id == checklistId);
      if (index != -1) {
        _checklists[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Share checklist
  Future<String?> shareChecklist(String id) async {
    try {
      return await _repository.shareChecklist(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
