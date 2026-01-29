import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../widgets/common/bottom_nav_bar.dart';
import '../providers/checklist_provider.dart';

class CreateScreen extends StatefulWidget {
  final bool showBottomNav;
  
  const CreateScreen({super.key, this.showBottomNav = true});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int _currentStep = 1;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _aiPromptController = TextEditingController();
  List<TextEditingController> _taskControllers = [];
  String _selectedColor = 'primary';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _taskControllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _aiPromptController.dispose();
    for (var c in _taskControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectMethod(String method) {
    if (method == 'blank') {
      _clearForm();
      setState(() => _currentStep = 4);
    } else if (method == 'template') {
      setState(() => _currentStep = 2);
    } else if (method == 'ai') {
      setState(() => _currentStep = 3);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    for (var c in _taskControllers) {
      c.clear();
    }
  }

  void _useTemplate(String templateId, Map<String, dynamic> template) {
    _nameController.text = template['name'] as String;
    _descController.text = template['desc'] as String;
    final tasks = template['tasks'] as List<String>;

    // Clear existing controllers
    for (var c in _taskControllers) {
      c.dispose();
    }

    // Create new controllers with template tasks
    _taskControllers = tasks.map((t) => TextEditingController(text: t)).toList();

    setState(() => _currentStep = 4);
  }

  void _generateFromAI() async {
    if (_aiPromptController.text.trim().isEmpty) {
      _showToast('Please describe what you want to accomplish');
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    final tasks = [
      'Research and gather requirements',
      'Create initial plan and timeline',
      'Prepare necessary materials',
      'Set up workspace or environment',
      'Execute main activities',
      'Review and quality check',
      'Finalize and document results',
    ];

    _nameController.text = _aiPromptController.text.substring(0, _aiPromptController.text.length > 50 ? 50 : _aiPromptController.text.length);
    _descController.text = 'AI-generated checklist for: ${_aiPromptController.text}';

    for (var c in _taskControllers) {
      c.dispose();
    }
    _taskControllers = tasks.map((t) => TextEditingController(text: t)).toList();

    setState(() {
      _isLoading = false;
      _currentStep = 4;
    });

    _showToast('Checklist generated! Customize it as needed.');
  }

  void _addTaskInput() {
    setState(() {
      _taskControllers.add(TextEditingController());
    });
  }

  void _removeTaskInput(int index) {
    if (_taskControllers.length <= 1) {
      _showToast('At least one task is required');
      return;
    }
    setState(() {
      _taskControllers[index].dispose();
      _taskControllers.removeAt(index);
    });
  }

  void _createChecklist() async {
    if (_nameController.text.trim().isEmpty) {
      _showToast('Please enter a checklist name');
      return;
    }

    final hasTasks = _taskControllers.any((c) => c.text.trim().isNotEmpty);
    if (!hasTasks) {
      _showToast('Please add at least one task');
      return;
    }

    setState(() => _isLoading = true);

    // Get tasks
    final tasks = _taskControllers
        .where((c) => c.text.trim().isNotEmpty)
        .map((c) => c.text.trim())
        .toList();

    // Create via API
    final provider = context.read<ChecklistProvider>();
    final success = await provider.createChecklist(
      name: _nameController.text.trim(),
      description: _descController.text.trim().isNotEmpty 
          ? _descController.text.trim() 
          : null,
      tasks: tasks,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showToast('Checklist created successfully!');
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/main');
        }
      });
    } else {
      _showToast(provider.error ?? 'Failed to create checklist');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(isDark),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                    child: _buildCurrentStep(isDark),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Generating your checklist...',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavBar(
              currentIndex: 2,
              onTap: (index) {
                if (index != 2) {
                  Navigator.of(context).pushReplacementNamed(_getRouteForIndex(index));
                }
              },
            )
          : null,
    );
  }

  String _getRouteForIndex(int index) {
    switch (index) {
      case 0: return '/home';
      case 1: return '/templates';
      case 3: return '/shared';
      case 4: return '/profile';
      default: return '/home';
    }
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: 12,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_currentStep > 1) {
                setState(() => _currentStep = 1);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'New Checklist',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(bool isDark) {
    switch (_currentStep) {
      case 1:
        return _buildStep1(isDark);
      case 2:
        return _buildStep2(isDark);
      case 3:
        return _buildStep3(isDark);
      case 4:
        return _buildStep4(isDark);
      default:
        return _buildStep1(isDark);
    }
  }

  Widget _buildStep1(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Create Checklist',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'How would you like to start?',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 24),
        _buildCreateOption(
          icon: Icons.description_outlined,
          title: 'Start from Scratch',
          subtitle: 'Create a blank checklist and add your own tasks',
          color: AppColors.primary,
          isDark: isDark,
          onTap: () => _selectMethod('blank'),
        ),
        const SizedBox(height: 12),
        _buildCreateOption(
          icon: Icons.grid_view,
          title: 'Use a Template',
          subtitle: 'Start with a pre-built template and customize it',
          color: AppColors.olive,
          isDark: isDark,
          onTap: () => _selectMethod('template'),
        ),
        const SizedBox(height: 12),
        _buildCreateOption(
          icon: Icons.auto_awesome,
          title: 'AI Generate',
          subtitle: 'Describe your task and let AI create a checklist',
          color: AppColors.terracotta,
          isDark: isDark,
          onTap: () => _selectMethod('ai'),
          badge: 'NEW',
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Quick Start', 'View All', isDark, () => Navigator.of(context).pushNamed('/templates')),
        const SizedBox(height: 16),
        _buildQuickTemplates(isDark),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCreateOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurSm,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionLabel, bool isDark, VoidCallback onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTemplates(bool isDark) {
    final templates = [
      {'id': 'project-launch', 'icon': Icons.check_circle_outline, 'label': 'Project Launch', 'color': AppColors.primary},
      {'id': 'meeting-prep', 'icon': Icons.people_outline, 'label': 'Meeting Prep', 'color': AppColors.primary},
      {'id': 'travel-packing', 'icon': Icons.luggage_outlined, 'label': 'Travel Packing', 'color': AppColors.terracotta},
      {'id': 'code-review', 'icon': Icons.code, 'label': 'Code Review', 'color': AppColors.olive},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: templates.map((t) {
        return GestureDetector(
          onTap: () => _useQuickTemplate(t['id'] as String),
          child: Container(
            width: (MediaQuery.of(context).size.width - 44) / 2,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                  blurRadius: AppDimensions.shadowBlurSm,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (t['color'] as Color).withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(t['icon'] as IconData, color: t['color'] as Color, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  t['label'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _useQuickTemplate(String templateId) {
    final templates = {
      'project-launch': {'name': 'Project Launch', 'desc': 'Launch a new project successfully', 'tasks': ['Define project scope', 'Identify stakeholders', 'Create timeline', 'Allocate resources', 'Set up communication', 'Schedule kick-off']},
      'meeting-prep': {'name': 'Meeting Preparation', 'desc': 'Prepare for a productive meeting', 'tasks': ['Define objective', 'Create agenda', 'Prepare materials', 'Test tech setup', 'Send invites']},
      'travel-packing': {'name': 'Travel Packing', 'desc': 'Pack essentials for your trip', 'tasks': ['Check passport', 'Book accommodation', 'Pack clothes', 'Prepare toiletries', 'Charge devices', 'Download maps', 'Notify bank']},
      'code-review': {'name': 'Code Review', 'desc': 'Thorough code review checklist', 'tasks': ['Check code style', 'Review logic', 'Security check', 'Error handling', 'Test coverage', 'Documentation', 'Test locally']},
    };

    final template = templates[templateId];
    if (template != null) {
      _useTemplate(templateId, template);
    }
  }

  Widget _buildStep2(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Choose Template',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select a template to get started',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 24),
        _buildQuickTemplates(isDark),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _currentStep = 1),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildStep3(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'AI Generate',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Describe what you need and AI will create a checklist',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'What do you want to accomplish?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _aiPromptController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'e.g., Plan a birthday party for 20 people, or Prepare for a job interview...',
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : AppColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSuggestionChip('Plan a camping trip', isDark),
            _buildSuggestionChip('Job interview prep', isDark),
            _buildSuggestionChip('Product launch', isDark),
            _buildSuggestionChip('Team building', isDark),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _generateFromAI,
            icon: const Icon(Icons.auto_awesome, size: 20),
            label: const Text('Generate Checklist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => setState(() => _currentStep = 1),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Back'),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSuggestionChip(String text, bool isDark) {
    return GestureDetector(
      onTap: () => _aiPromptController.text = text,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.gray100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildStep4(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Checklist Details',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Customize your checklist',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 24),
        _buildFormField('Checklist Name *', _nameController, 'Enter checklist name...', isDark),
        const SizedBox(height: 16),
        _buildFormField('Description', _descController, 'Add a description (optional)...', isDark, maxLines: 2),
        const SizedBox(height: 16),
        _buildColorPicker(isDark),
        const SizedBox(height: 24),
        _buildTasksSection(isDark),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _createChecklist,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Create Checklist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => setState(() => _currentStep = 1),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, String hint, bool isDark, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : AppColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker(bool isDark) {
    final colors = [
      {'key': 'primary', 'color': AppColors.primary},
      {'key': 'terracotta', 'color': AppColors.terracotta},
      {'key': 'olive', 'color': AppColors.olive},
      {'key': 'secondary', 'color': AppColors.secondary},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: colors.map((c) {
            final isSelected = _selectedColor == c['key'];
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = c['key'] as String),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: c['color'] as Color,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: (c['color'] as Color).withAlpha(128), blurRadius: 8)]
                      : null,
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTasksSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tasks',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: _addTaskInput,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(_taskControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.drag_handle, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _taskControllers[index],
                    decoration: InputDecoration(
                      hintText: 'Task ${index + 1}',
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurface : AppColors.gray100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removeTaskInput(index),
                  child: Icon(Icons.close, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, size: 20),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
