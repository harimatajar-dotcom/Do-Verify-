import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/checklist_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../widgets/common/bottom_nav_bar.dart';

class ChecklistDetailScreen extends StatefulWidget {
  final ChecklistEntity? checklist;

  const ChecklistDetailScreen({super.key, this.checklist});

  @override
  State<ChecklistDetailScreen> createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  late List<TaskEntity> _tasks;
  late String _title;
  late String? _description;

  @override
  void initState() {
    super.initState();
    _title = widget.checklist?.title ?? 'Project Launch';
    _description = widget.checklist?.description ?? 'Launch the new marketing website with all required features and content.';
    _tasks = widget.checklist?.tasks ?? [
      const TaskEntity(id: '1', title: 'Finalize design mockups', isCompleted: true),
      const TaskEntity(id: '2', title: 'Complete frontend development', isCompleted: true),
      const TaskEntity(id: '3', title: 'Set up analytics', isCompleted: false),
      const TaskEntity(id: '4', title: 'Write launch announcement', isCompleted: false),
      const TaskEntity(id: '5', title: 'Schedule social media posts', isCompleted: false),
    ];
  }

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _totalCount => _tasks.length;
  double get _progress => _totalCount > 0 ? _completedCount / _totalCount : 0.0;
  int get _progressPercent => (_progress * 100).round();

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    });
    _showToast(_tasks[index].isCompleted ? 'Task completed!' : 'Task marked incomplete');
  }

  void _deleteTask(int index) {
    final task = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });
    _showToast('Task deleted');
  }

  void _addTask() {
    _showAddTaskModal();
  }

  void _showAddTaskModal() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Task Name *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : AppColors.gray100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Description (optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Add more details...',
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : AppColors.gray100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) {
                          _showToast('Please enter a task name');
                          return;
                        }
                        setState(() {
                          _tasks.add(TaskEntity(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: nameController.text.trim(),
                          ));
                        });
                        Navigator.pop(context);
                        _showToast('Task added!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Task'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareModal() {
    _showToast('Share functionality coming soon!');
  }

  void _showOptionsModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionItem(Icons.edit_outlined, 'Edit Checklist', 'Change name and description', isDark),
            _buildOptionItem(Icons.copy_outlined, 'Duplicate', 'Create a copy of this checklist', isDark),
            _buildOptionItem(Icons.upload_outlined, 'Export', 'Download as PDF or text file', isDark),
            _buildOptionItem(Icons.calendar_today_outlined, 'Set Reminder', 'Get notified about this checklist', isDark),
            _buildOptionItem(Icons.refresh, 'Reset Progress', 'Mark all tasks as incomplete', isDark),
            _buildOptionItem(Icons.delete_outline, 'Delete Checklist', 'Permanently remove this checklist', isDark, isDestructive: true),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, String subtitle, bool isDark, {bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withAlpha(26)
              : (isDark ? AppColors.darkSurface : AppColors.gray100),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? AppColors.error : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        _showToast('$title coming soon!');
      },
    );
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
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildChecklistHeader(isDark),
                    const SizedBox(height: 16),
                    _buildProgressCard(isDark),
                    const SizedBox(height: 24),
                    _buildTaskActions(isDark),
                    const SizedBox(height: 16),
                    _buildTaskList(isDark),
                    const SizedBox(height: 16),
                    _buildAddTaskButton(isDark),
                    const SizedBox(height: 24),
                    _buildCollaboratorsSection(isDark),
                    const SizedBox(height: 24),
                    _buildActivitySection(isDark),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
      ),
    );
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
            onTap: () => Navigator.of(context).pop(),
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
            'Checklist',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _showShareModal,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.share_outlined,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _showOptionsModal,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.more_horiz,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        if (_description != null) ...[
          const SizedBox(height: 8),
          Text(
            _description!,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_progressPercent%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '$_completedCount of $_totalCount tasks',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.gray200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _progress,
              child: Container(
                decoration: BoxDecoration(
                  color: _progress >= 1.0 ? AppColors.success : AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskActions(bool isDark) {
    return Row(
      children: [
        _buildActionButton(Icons.sort, 'Sort', isDark),
        const SizedBox(width: 8),
        _buildActionButton(Icons.filter_list, 'Filter', isDark),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(bool isDark) {
    return Column(
      children: List.generate(_tasks.length, (index) {
        final task = _tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildTaskItem(task, index, isDark),
        );
      }),
    );
  }

  Widget _buildTaskItem(TaskEntity task, int index, bool isDark) {
    return Container(
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
          GestureDetector(
            onTap: () => _toggleTask(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: task.isCompleted ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: task.isCompleted ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.gray300),
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: task.isCompleted
                    ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _deleteTask(index),
            child: Icon(
              Icons.delete_outline,
              size: 20,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskButton(bool isDark) {
    return GestureDetector(
      onTap: _addTask,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 20,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            const SizedBox(width: 8),
            Text(
              'Add New Task',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollaboratorsSection(bool isDark) {
    final collaborators = [
      {'initials': 'JD', 'name': 'John Doe (You)', 'role': 'Owner', 'color': AppColors.primary},
      {'initials': 'SM', 'name': 'Sarah Miller', 'role': 'Can Edit', 'color': AppColors.terracotta},
      {'initials': 'MK', 'name': 'Mike Kim', 'role': 'Can View', 'color': AppColors.olive},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Collaborators',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: _showShareModal,
              icon: const Icon(Icons.person_add_outlined, size: 18),
              label: const Text('Invite'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...collaborators.map((c) => _buildCollaboratorItem(c, isDark)),
      ],
    );
  }

  Widget _buildCollaboratorItem(Map<String, dynamic> collaborator, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [collaborator['color'] as Color, (collaborator['color'] as Color).withAlpha(200)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                collaborator['initials'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collaborator['name'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  collaborator['role'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(bool isDark) {
    final activities = [
      {'user': 'You', 'action': 'completed "Finalize design mockups"', 'time': '2 hours ago', 'isSuccess': true},
      {'user': 'Sarah', 'action': 'completed "Complete frontend development"', 'time': 'Yesterday', 'isSuccess': true},
      {'user': 'Mike', 'action': 'was added as a collaborator', 'time': '2 days ago', 'isSuccess': false},
      {'user': 'You', 'action': 'created this checklist', 'time': '3 days ago', 'isSuccess': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...activities.map((a) => _buildActivityItem(a, isDark)),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: (activity['isSuccess'] as bool) ? AppColors.success : (isDark ? AppColors.darkBorder : AppColors.gray300),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: activity['user'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      TextSpan(text: ' ${activity['action']}'),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
